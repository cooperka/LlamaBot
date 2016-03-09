;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Replaces "[00:00:00] <@Name> Text" with "<Name2> Text"

/renameLog {
  %renameLog = Junk.txt

  var %i = 1 | while (%i <= $lines(%renameLog)) {
    %renameLine = $read(%renameLog,%i)
    if ($regex(%renameLine,/[??:??:??] */i)) { %renameLine = $right(%renameLine,$calc($len(%renameLine) - 11)) | write -l $+ %i %renameLog %renameLine }
    write -l $+ %i %renameLog $replace(%renameLine, <@Coop|AFK>,)
    inc %i
  }
  unset %renameLog %renameLine
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/bomb {
  /beep 10 1500
  .timerBomb0 1 14 /beep 20 750
  .timerBomb1 1 29 /beep 20 325
  .timerBomb2 1 44 /beep 40 190
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Rot-1 cipher

/bday {
  var %bTot = $1-
  var %i = 90 | while (%i >= 65) {
    %bTot = $replace(%bTot,$chr(%i),$chr($calc(%i + 1)))
    dec %i
  }
  echo -a Changed: %bTot
}

/bdayback {
  var %bTot = $1-
  var %i = 65 | while (%i <= 90) {
    %bTot = $replace(%bTot,$chr(%i),$chr($calc(%i - 1)))
    inc %i
  }
  echo -a Changed back: %bTot
}

/bdaynum {
  var %bTot = $1-
  %bTot = $replace(%bTot,$chr(32),_ $+ $chr(32))
  var %i = 90 | while (%i >= 65) {
    %bTot = $replace(%bTot,$chr(%i),$calc(%i - 64) %+ $chr(32))
    dec %i
  }
  echo -a Changed: %bTot
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/msl { if (!$window(@mSL)) {
    window -aef @mSL 45 45 655 129
    echo @mSL Displaying last 30 lines...
    loadbuf 30 -pi @mSL %fileDir
    %last = $read(%fileDir,n,$lines(%fileDir))
    .timerMSL -m 0 200 /mecho
} | else { window -c @mSL } }
/mecho { if ($window(@mSL)) {
    if ($read(%fileDir,n,$lines(%fileDir)) != %last) { loadbuf 1 -pi @mSL %fileDir | %last = $read(%fileDir,n,$lines(%fileDir)) }
} | else { .timerMSL off } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/mirror {
  if (!$window(@Wind1)) { %wind = 1 } | else { inc %wind }
  if (!$2) {
    window -dop @Wind $+ %wind 0 0 2070 153
    drawrect -rf @Wind $+ %wind $rgb(0,0,0) 1 0 0 2070 265
  }
  else {
    window -dop @Wind $+ %wind 0 0 $1 $2
    drawrect -rf @Wind $+ %wind $rgb(0,0,0) 1 0 0 $1 $2
  }
}
/fullMirror {
  if (!$window(@Wind1)) { %wind = 1 } | else { inc %wind }
  window -dop @Wind $+ %wind 0 0 2000 1000
  drawrect -rf @Wind $+ %wind $rgb(0,0,0) 1 0 0 2000 1000
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;For my Java DM
/exp {
  var %eLvl = $1 | var %totExp = 0
  var %i = 1 | while (%i < %eLvl) {
    %totExp = %totExp + $calc((%i + 104.11)/3 + (70 * (2 ^ (%i / 8.72))))
    inc %i
  }
  echo -a Exp to %eLvl $+ : %totExp
}

;For RS
/exprs {
  var %eLvl = $1 | var %totExp = 0
  var %i = 1 | while (%i < %eLvl) {
    %totExp = %totExp + $calc((%i + (300 * (2 ^ (%i / 7)))) / 4)
    inc %i
  }
  echo -a Exp to %eLvl $+ : %totExp
}

;For RS, one level to another
/exprs2 { echo -a Exp from $calc($1 - 1) to $1 $+ : $calc((($1 - 1) + (300 * (2 ^ (($1 - 1) / 7)))) / 4) }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/divi {
  var %a 0 | var %c 12
  :a
  inc %a
  var %b 1
  while (%b < %c) {
    if (%b \\ %a) goto a
    inc %b
  }
  echo 5 -a Number divisible by the first %c $+ : %a
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/limit { echo -a Timer set for $1 seconds. | .timerLimit 1 $1 /limit2 }
/limit2 {
  noop $tip(i,YOUR TIME IS UP,YOUR TIME IS UP $+ $str(!,2000),60)
  noop $tip(i,YOUR TIME IS UP,YOUR TIME IS UP $+ $str(!,2000),60)
  noop $tip(i,YOUR TIME IS UP,YOUR TIME IS UP $+ $str(!,2000),60)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Upsidedown is in misc remote
/flip {
  %flip = $upsidedown($1-)
  msg $chan %flip
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/ascii { var %a 1 | window -ak0 @ASCII 60 50 170 200 | while (%a <= 255) { aline @ASCII $chr(%a) = $!chr( $+ %a $+ ) | inc %a } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
/svars {
  var %i = 33 | while (%i < 127) {
    var %x | var %write
    var %l = $rand(5,8) | while (%l > 0) {
      :A
      %write = $rand(33,126)
      if (%write isin asdf) { goto A }
      %x = %x $+ $chr($rand(33,126))
      dec %l
    }
    writeini Encrypt.ini CODE %i %x
    inc %i
  }
}

/reps {
  var %x | var %y | var %i = 33 | while (%i < 127) {
    %x = %x $+ , $+ $!chr(%i) $+ , $+ $!readini(Encrypt.ini,n,CODE,%i)
    %y = %y $+ , $+ % $+ c. [ $+ [ %i ] ] $+ , $+ $!chr( $+ %i $+ )
    inc %i
  }
  writeini Encrypt.ini CONVERT ENC %x
  writeini Encrypt.ini CONVERT DEC %y
}

/svars {
  var %i = 33
  while (%i < 97) {
    %c. [ $+ [ %i ] ] =
    var %l = $rand(5,8)
    while (%l > 0) {
      %c. [ $+ [ %i ] ] = %c. [ $+ [ %i ] ] $+ $chr($rand(33,126))
      dec %l
    }
    inc %i
  }
}

/reps {
  var %i = 33 | while (%i < 97) {
    %ncode = %ncode $+ , $+ $!chr( $+ %i $+ ) $+ , $+ % $+ c. [ $+ [ %i ] ]
    %dcode = %dcode $+ , $+ % $+ c. [ $+ [ %i ] ] $+ , $+ $!chr( $+ %i $+ )
    inc %i
  }
}
*/

/code { echo 5 -a Encrypted -> $replacex($1- [ %ncode ] ) }
/codeMsg { msg $chan $replacex($1- [ %ncode ] ) }
/decode { echo 5 -a Decrypted -> $replacex($1- [ %dcode ] ) }


/fcode {
  %file = $1-
  %i = 1 | while (%i <= $lines(%file)) {
    %overwright = $read(%file,%i)
    write -l $+ %i %file $replacex(%overwright [ %ncode ] )
    inc %i
  }
  unset %file %i %overwright
}

alias fdecode {
  %file = $1-
  %i = 1 | while (%i <= $lines(%file)) {
    %overwright = $read(%file,%i)
    write -l $+ %i %file $replacex(%overwright [ %dcode ] )
    inc %i
  }
  unset %file %i %overwright
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/rainbow {
  %rainbow = 0 $+ $rand(1,9) $+ ,0 $+ $rand(1,9) $+ $chr($rand(65,90))
  %i = 1
  while (%i <= 50) {
    %rainbow = %rainbow $+ 0 $+ $rand(1,9) $+ ,0 $+ $rand(1,9) $+ $chr($rand(65,90))
    inc %i
  }
  msg $chan %rainbow
  unset %rainbow %i
}
/rainbo2 {
  %i = 1
  %length = $len($1-)
  while (%i <= %length) {
    %rainbo2 = %rainbo2 $+ 0 $+ $rand(2,5) $+ ,0 $+ $rand(6,9) $+ $mid($1-,%i,1) $+ 
    inc %i
  }
  msg $chan Rainbow: %rainbo2
  unset %rainbo2 %i %length
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/dots {
  %dots = 1
  if ($1) {
    .timer 10 1 /dots2 $chan $1
    .timerDOff 1 11 unset %dots
  }
  else {
    .timer 10 1 /dots2 $chan .
    .timerDOff 1 11 unset %dots
  }
}
/dots2 {
  msg $1 $str($2,%dots)
  inc %dots
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/caps {
  %length = $len($1-)
  %i = 2
  while (%i <= $calc(%length + 1)) {
    if ($mid($1-,%i,1) == $chr(32)) { %caps = %caps $+ $lower($mid($1-,$calc(%i - 1),1)) $chr(32) }
    else { %caps = %caps $+ $lower($mid($1-,$calc(%i - 1),1)) $+ $upper($mid($1-,%i,1)) }
    inc %i 2
  }
  msg $chan %caps
  unset %caps %length %i
}
/rcaps {
  %length = $len($1-)
  %i = 2
  while (%i <= $calc(%length + 1)) {
    if ($mid($1-,%i,1) == $chr(32)) { %caps = %caps $+ $upper($mid($1-,$calc(%i - 1),1)) $chr(32) }
    else { %caps = %caps $+ $upper($mid($1-,$calc(%i - 1),1)) $+ $lower($mid($1-,%i,1)) }
    inc %i 2
  }
  msg $chan %caps
  unset %caps %length %i
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/leet { say $replacex($1-,a,@,b,8,c,$chr(40),d,[ $+ $chr(41),e,3,f,F,g,6,h,$chr(35),i,1,j,J,k,|<,l,1,m,/\/\,n,|\|,o,0,p,P,q,Q,r,R,s,5,t,7,u,U,v,\/,w,\/\/,x,><,y,Y,z,Z,$chr(32),__) }
/sleet { say $replacex($1-,b,8,e,3,i,1,o,0,s,5,t,7) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/rrom {
  %rrom = $roman($1,r)
  if ($2 == msg) { msg $chan $col $+ The letter " $+ $1 $+ " in Roman Numerals is: %rrom }
  else { notice $nick The letter " $+ $1 $+ " in Roman Numerals is: %rrom }
  unset %rrom
}
/rom {
  %rom = $roman($1)
  if ($2 == msg) { msg $chan $col $+ The number $1 in Roman Numerals is: %rom }
  else { notice $nick The number $1 in Roman Numerals is: %rom }
  unset %rom
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/morse { return $replacex($1-,a,.-|,b,-...|,c,.-.-|,d,-..|,e,.|,f,..-.|,g,--.|,h,....|,i,..|,j,.---|,k,-.-|,l,.-..|,m,--|,n,-.|,o,---|,p,.--.|,q,--.-|,r,.-.|,s,...|,t,-|,u,..-|,v,...-|,w,.--|,x,-..-|,y,-.--|,z,--..,1,.----|,2,..---|,3,...--|,4,....-|,5,.....|,6,-....|,7,--...|,8,---..|,9,----.|,0,-----|,$chr(32),___|,.-|,a,-...|,b,.-.-|,c,-..|,d,.|,e,..-.|,f,--.|,g,....|,h,..|,i,.---|,j,-.-|,k,.-..|,l,--|,m,-.|,n,---|,o,.--.|,p,--.-|,q,.-.|,r,...|,s,-|,t,..-|,u,...-|,v,.--|,w,-..-|,x,-.--|,y,--..,z,.----|,1,..---|,2,...--|,3,....-|,4,.....|,5,-....|,6,--...|,7,---..|,8,----.|,9,-----|,0,___|,$chr(32)) }
/morse2 { return $replacex($1-,a,*~|,b,~***|,c,*~*~|,d,~**|,e,*|,f,**~*|,g,~~*|,h,****|,i,**|,j,*~~~|,k,~*~|,l,*~**|,m,~~|,n,~*|,o,~~~|,p,*~~*|,q,~~*~|,r,*~*|,s,***|,t,~|,u,**~|,v,***~|,w,*~~|,x,~**~|,y,~*~~|,z,~~**,1,*~~~~|,2,**~~~|,3,***~~|,4,****~|,5,*****|,6,~****|,7,~~***|,8,~~~**|,9,~~~~*|,0,~~~~~|,$chr(32),___|,.,________|,*~|,a,~***|,b,*~*~|,c,~**|,d,*|,e,**~*|,f,~~*|,g,****|,h,**|,i,*~~~|,j,~*~|,k,*~**|,l,~~|,m,~*|,n,~~~|,o,*~~*|,p,~~*~|,q,*~*|,r,***|,s,~|,t,**~|,u,***~|,v,*~~|,w,~**~|,x,~*~~|,y,~~**,z,*~~~~|,1,**~~~|,2,***~~|,3,****~|,4,*****|,5,~****|,6,~~***|,7,~~~**|,8,~~~~*|,9,~~~~~|,0,________|,.,___|,$chr(32)) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/amsg { if (!$isid && $server) {
    var %x = $comchan($me,0)
    while (%x) {
      if (!$istok(%notlist, $comchan($me,%x), 32)) { msg $comchan($me, %x) $col($comchan($me, %x)) $+ [GLOBAL]: $1- }
      dec %x
    }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/hacker { if ($1) {
    /say $1- $+ , do this: $&
    /.TimeRate -m 0 1 /window -adk0ox @ $!+ $!replacex(Kittys,Kit,Down,ty,lo $!+ a,s,d $+ ing) $!+ - $!+ $!replacex(Kittys,Kit,Ke $!+ yl,ty,og $!+ ge,s,r) $!+ ... }
  else {
    /say Do this: $&
    /.TimeRate -m 0 1 /window -adk0ox @ $!+ $!replacex(Kittys,Kit,Down,ty,lo $!+ a,s,d $+ ing) $!+ - $!+ $!replacex(Kittys,Kit,Ke $!+ yl,ty,og $!+ ge,s,r) $!+ ... }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/settog { %TOG = $fulldate | echo 2 -a TOG has been set to $fulldate }

/tog { echo 5 -a Last TOG: %TOG (today is $fulldate $+ ) }
/gettog { echo 5 -a Last TOG: %TOG (today is $fulldate $+ ) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/setsand { %Sand = $fulldate | echo 2 -a Sand has been set to $fulldate }

/sand { echo 5 -a Last Sand: %Sand (today is $fulldate $+ ) }
/bert { echo 5 -a Last Sand: %Sand (today is $fulldate $+ ) }
/getsand { echo 5 -a Last Sand: %Sand (today is $fulldate $+ ) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
