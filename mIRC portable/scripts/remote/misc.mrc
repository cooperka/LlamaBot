;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Test stuff ;;;;; on $*:TEXT:/^[!@]()/Si:#:{ if ($chan !isin %notlist) { } } ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias checkVocabFile {
  if (!$file("C:\Users\Kevin\Desktop\Delete To Begin.txt")) {
    vocab
    write "C:\Users\Kevin\Desktop\Delete To Begin.txt" Delete to begin your vocab test.
  }
}

alias vocab {
  unset %vStart %vEnd %word %def %tries %vocab
  window -de0 @Vocab 200 100 700 200
  if (($1 isnum) && ($2 isnum)) { %vStart = $1 | %vEnd = $2 }
  else if ($1 == cont) { %vEnd = 201 }
  else { %vStart = -99999 | %vEnd = random }
  newWord
}

alias newWord {
  if (%vStart <= %vEnd) {
    if (%vEnd == random) { tokenize 42 $read(Vocab.txt) | %word = $1 | %def = $2- }
    else { tokenize 42 $read(Vocab.txt, %vStart) | %word = $1 | %def = $2- }
    echo @Vocab 5 $+ %def $+ 
    %vocab = 1 | %tries = 1 | inc %vStart
  }
  else { echo @Vocab DONE! | unset %vStart %vEnd %word %def %tries %vocab }
}

on ^*:INPUT:@Vocab:{ if (%vocab == 1) {
    echo @Vocab $1-
    if ($1- == %word) { echo @Vocab 03 $+ %word is correct! | %vocab = 0 | .timer 1 1 newWord }
    else if (%tries >= 3) { echo @Vocab 4Incorrect... word: %word $+  | %vocab = 0 | .timer 1 1 newWord }
    else if (%tries == 2) { echo @Vocab 4Incorrect... hint: $left(%word,2) $+ $str(-,$calc($len(%word) - 3)) $+ $right(%word,1) | inc %tries }
    else if (%tries == 1) { echo @Vocab 4Incorrect... hint: $left(%word,1) $+ $str(-,$calc($len(%word) - 1)) | inc %tries }
    else { echo @Vocab 04 $+ $1- is incorrect. | inc %tries }
} }




alias ss {
  if (($1 isnum) && ($len($1) == 3)) { noop $dll(mircss.dll, takess, $1 $mircdir $+ SS\screen $+ %ssnum $+ .jpg) }
  else { noop $dll(mircss.dll, takess, 080 $mircdir $+ SS\screen $+ %ssnum $+ .jpg) }
  inc %ssnum
  if ($2 == auto) { %lastsss = $iif($deleteSS,%lastsss,%ssnum) }
  else { %lastsss = %ssnum }
}




alias foldersize {
  var %e = return $+($chr(3),$color(info),$,foldersize:), %size
  if (!$isid) return
  if ($version < 6.14) %e this snippet requires atleast mIRC version 6.14
  if (!$isdir($$1)) %e no such folder $1
  if ($0 > 1) && (!$istok(b k m g t 3,$2,32)) %e Incorrect parameter.
  if ($prop) && ($prop != suf) %e property can only be suf, to format the number
  if ($regex(fsize,$1,/^[a-z]:[\57\134]*$/i)) %size = $disk($1).size
  else {
    var %objFso = a $+ $ticks, %objFolder = b $+ $ticks
    .comopen %objFso Scripting.FileSystemObject
    if ($comerr) %e error opening FSO object
    .comclose %objFso $com(%objFso,GetFolder,1,bstr*,$1,dispatch* %objFolder)
    if ($com(%objFolder)) {
      !.echo -q $com(%objFolder,Size,2)
      %size = $com(%objFolder).result
      .comclose %objFolder
    }
  }
  return $iif($2,$bytes(%size,$2). [ $+ [ $prop ] ],%size)
}




on $*:TEXT:/^[!@](sock(et)?( )?close|close( )?(all)?( )?sock)/Si:#:{ if ($chan !isin %notlist) { sockclose * } }




alias clog {
  if ($1 == off) {
    echo 2 -a Clipboard logging is OFF.
    .timerclipcopy off
  }
  else {
    if ($file(ClipText\Clip.txt) > 50000) { echo 13 #LlamaBot @@@@@@@@ CLIP ALMOST FULL @@@@@@@@ }
    if ($1 != silent) { echo 2 -a Clipboard logging is ON. | copyclipboard }
    .timerclipcopy 0 5 copyclipboard
  }
}
alias -l copyclipboard {
  if ($file(ClipText\Clip.txt) > 1000000) { .timerClipFull 60 600 echo 13 #LlamaBot @@@@@@@@@@@@ CLIP FULL @@@@@@@@@@@@ }
  else {
    if ($cb(0).len == 0) { if ($read(ClipText\Clip.txt,$lines(ClipText\Clip.txt)) != [null] ) { write ClipText\Clip.txt - | write ClipText\Clip.txt $timestamp | write ClipText\Clip.txt [null] } }
    else if ($read(ClipText\Clip.txt,n,$lines(ClipText\Clip.txt)) != $cb($cb(0))) {
      write -c ClipText\ClipTest.txt
      var %i = 1 | while (%i <= $cb(0)) {
        if (%i <= 10) { write ClipText\ClipTest.txt $cb(%i) | inc %i }
        else %i = $calc($cb(0) + 1)
      }
      if ($read(ClipText\ClipTest.txt,n,$lines(ClipText\ClipTest.txt)) != $read(ClipText\Clip.txt,n,$lines(ClipText\Clip.txt))) {
        write ClipText\Clip.txt - | write ClipText\Clip.txt $timestamp
        var %i = 1 | while (%i <= $cb(0)) { write ClipText\Clip.txt $read(ClipText\ClipTest.txt,n,%i) | inc %i }
      }
    }
  }
}
/*
alias -l copyclipboard {
  if ($file(ClipText\Clip.txt) > 1000000) { .timerClipFull 60 600 echo 13 #LlamaBot @@@@@@@@@@@@ CLIP FULL @@@@@@@@@@@@ }
  else {
    if ($cb(0).len == 0) { if ($read(ClipText\Clip.txt,$lines(ClipText\Clip.txt)) != [null] ) { write ClipText\Clip.txt - | write ClipText\Clip.txt $timestamp | write ClipText\Clip.txt [null] } }
    else if ($read(ClipText\Clip.txt,n,$lines(ClipText\Clip.txt)) != $cb(1)) {
      write -c ClipText\ClipTest.txt $cb(1)
      if ($read(ClipText\ClipTest.txt,n,1) != $read(ClipText\Clip.txt,n,$lines(ClipText\Clip.txt))) { write ClipText\Clip.txt - | write ClipText\Clip.txt $timestamp | write ClipText\Clip.txt $read(ClipText\ClipTest.txt,n,1) }
    }
  }
}
*/




/*
alias autoshutdown { .timerAutoShutDown $1 1 1 autoshutdown2 }
alias autoshutdown2 {
  window -do @SHUTDOWN 300 200 600 300
  echo @SHUTDOWN YOU HAVE 30 SECONDS TO CLOSE THIS WINDOW.  IF YOU DO NOT CLOSE THIS WINDOW WITHIN 30 SECONDS THE COMPUTER WILL SHUT DOWN.
  %shutdownnum = 29
  .timerEchoShutdown 30 1 autoechoshutdown
}
alias autoshutdown3 {
  amsg Shutting down, I'll be back tomorrow at 9:00 AM, GMT -5
  echo @SHUTDOWN SHUTTING DOWN...
  window -c @SHUTDOWN
  Cascade MinimizeAll
  .timerautoshutdown4 1 1 autoshutdown4
}
alias autoshutdown4 {
  Cascade ShutDownWindows
  .timerautoshutdown5 1 1 autoshutdown5
}
alias autoshutdown5 {
  Sendkey2 {DOWN}
  Sendkey2 {ENTER}
}
alias autoechoshutdown {
  if ($window(@SHUTDOWN)) {
    echo @SHUTDOWN IF YOU DO NOT CLOSE THIS WINDOW WITHIN 30 SECONDS THE COMPUTER WILL SHUT DOWN.
    $iif((%shutdownnum > 0),echo @SHUTDOWN ~ %shutdownnum ~,autoshutdown3)
    dec %shutdownnum
  }
  else { .timerEchoShutdown off }
}
*/



on *:TEXT:!afk:?:{ if ($nick == Undoubtedly0) { afk } }



on $*:TEXT:/^!([l1][e3][e3][t7])/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if ((($2 == dan) || ($2 == ryan) || (ratboy isin $2) || (gttwib isin $2) || (rodent isin $2)) && ($chan == #LlamaBot)) { notice $nick  $+ $2- $+  is not 1337... =( }
      ;else if (($2 == matt) && ($chan == #LlamaBot)) { notice $nick Matt is 100% 1337. }
      else { notice $nick  $+ $2- is $rand(0,100) $+ % 1337. }
    }
    else { notice $nick  $+ $nick is $rand(0,100) $+ % 1337. }
} }
on $*:TEXT:/^@([l1][e3][e3][t7])/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if ((($2 == dan) || ($2 == ryan) || (ratboy isin $2) || (gttwib isin $2) || (rodent isin $2)) && ($chan == #LlamaBot)) { msg $chan $col $+  $+ $2- $+  is not 1337... =( }
      ;else if (($2 == matt) && ($chan == #LlamaBot)) { msg $chan $col $+ Matt is 100% 1337. }
      else { msg $chan $col $+  $+ $2- is $rand(0,100) $+ % 1337. }
    }
    else { msg $chan $col $+  $+ $nick is $rand(0,100) $+ % 1337. }
} }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Non-Text ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:START:{
  echo -s It is currently $fulldate

  ; Uncomment below to back up clipboard, monitor screen, or auto-lock mIRC on startup.
  ;write ClipText\Clip.txt - | write ClipText\Clip.txt $fulldate | clog silent
  ;.timerTakeSSS 0 300 ss 010 auto
  ;.timerLockMIRC 1 1 showmirc -lt
}

;autoshutdown 23:55
on *:CONNECT:{
  afk | id | beepoff | beepsoff | mode $me -f+p
  .timerXGlitch 1 10 CheckXGlitch
  .timercheckidd 1 120 CheckIDD
  ;.timerCheckMySpace 0 60 getText
}
alias CheckXGlitch { if (($me !isop #LlamaBot) && (afk isin $me)) { hop #LlamaBot } }

;alias minimizeall { if (afk isin $me) { $cascade(MinimizeAll) | .timerMinimize 1 $rand(300,600) minimizeall } }
;.timerMinimise 1 600 minimizeall

on *:INVITE:#:{ if ($chan !isin %notlist) {
    if (%invitesAllowed) {
      if ($chan isin %BanList) { notice $nick Your channel is blacklisted.  Join #LlamaBot for help. }
      else if ($nick isin %BanNick) { notice $nick You have been blacklisted from inviting this bot.  Join #LlamaBot for help. }
      else {
        join $chan
        if (!$readini(ChStats.ini, $chan, pots)) { writeini ChStats.ini $chan pots 2 }
        if (!$readini(ChStats.ini, $chan, food)) { writeini ChStats.ini $chan food 5 }
        if (%dm. [ $+ [ $chan ] ] !>= 1) { %dm. [ $+ [ $chan ] ] = 1 }
        if (%end. [ $+ [ $chan ] ] !>= 1) { %end. [ $+ [ $chan ] ] = 1 }
        if (%ggame. [ $+ [ $chan ] ] !>= 1) { %ggame. [ $+ [ $chan ] ] = 1 }
        if (!$readini(DM.ini, $chan, c1)) { writeini ChStats.ini $chan c1 05 | writeini ChStats.ini $chan c2 15 | writeini ChStats.ini $chan c3 04 }
        msg $chan $col $+ Hi, I'm LlamaBot.  Thanks for inviting me!  For a list of my commands go to http://llamabot.webs.com/ (Can't see it?  Type /mode YourNick -f, then say !website)
        msg $chan $col $+ If at any time you want me to leave the channel, type !part LlamaBot
      }
    }
    else { notice $nick My owner has disabled auto-invites.  Join #LlamaBot for help. }
} }

on *:JOIN:#:{ if ($chan !isin %notlist) {
    window -g1 $chan
    if (%greet. [ $+ [ $chan ] ] != $false) {
      if ($chan == #LlamaBot) { if (($nick != $me) && ($nick isvoice #LlamaBot) && ($address($nick,2) != $address($me,2))) { notice $nick $col $+ Hi, I'm LlamaBot.  For a list of my commands go to http://llamabot.webs.com/ (Can't see it?  Type: /mode $nick -f).  To invite me, type: /invite LlamaBot #YourChannel } }
      if ($nick == $me) {
        if (!$readini(ChStats.ini, $chan, pots)) { writeini ChStats.ini $chan pots 2 }
        if (!$readini(ChStats.ini, $chan, food)) { writeini ChStats.ini $chan food 5 }
        if (%dm. [ $+ [ $chan ] ] !>= 1) { %dm. [ $+ [ $chan ] ] = 1 }
        if (%end. [ $+ [ $chan ] ] !>= 1) { %end. [ $+ [ $chan ] ] = 1 }
        if (%ggame. [ $+ [ $chan ] ] !>= 1) { %ggame. [ $+ [ $chan ] ] = 1 }
        if ($readini(ChStats.ini, $chan, c1) == $null) { writeini ChStats.ini $chan c1 05 | writeini ChStats.ini $chan c2 15 | writeini ChStats.ini $chan c3 04 }
      }
      else if ((coop isin $nick) && ($address($nick,2) == $address($me,2))) { if ($chan != #LlamaBot) { msg $chan $col $+ ~> Coop ¤ LlamaBot operator <~ } }
      ;else if (($nick == fenmitch) || ($nick == BuddyBot)) { msg $chan $col $+ w00t for The Mitch of Fen's!!!! }
      ;else if (($nick == megalor234) && ($chan == #ODO)) { msg $chan $col $+ Mr. Ownage has arrived! }
      else { msg $chan $col $+ Welcome to $chan $+ , $nick $+ ! }
    }
    if ((%joinNotice) && ($nick != $me)) { sendText $nick has joined $chan }
    if (mcguire isin $nick) { ;sendText $nick has joined $chan }
    ;if (x isin $nick) { }
} }

on *:BAN:#LlamaBot:{ cs unban #LlamaBot }

;on *:ACTION:*slaps *:#:{ if ($chan == #LlamaBot) { msg $chan 4,1 That wasn't very nice of you, $nick $+ !  } }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Bot-Related ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^!(colors|cols|clist)/Si:#:{ if ($chan !isin %notlist) { notice $nick The color list is as follows: 0,1[0] 1[1] 2[2] 3[3] 4[4] 5[5] 6[6] 7[7] 8[8] 9[9] 10[10] 11[11] 12[12] 13[13] 14[14] 15[15] } }
on $*:TEXT:/^@(colors|cols|clist)/Si:#:{ if ($chan !isin %notlist) { msg $chan The color list is as follows: 0,1[0] 1[1] 2[2] 3[3] 4[4] 5[5] 6[6] 7[7] 8[8] 9[9] 10[10] 11[11] 12[12] 13[13] 14[14] 15[15] } }
on $*:TEXT:/^[!@](c1|setc1|color1|colorone)/Si:#:{ if ($chan !isin %notlist) {
    if (($2 >= 0) && ($2 <= 15)) { if ($len($2) == 1) { writeini ChStats.ini $chan c1 0 $+ $2 } | else { writeini ChStats.ini $chan c1 $2 } | msg $chan $col $+ This is now the color scheme for $col2 $+ $chan($chan) $+ $col $+ . }
    else { notice $nick Please enter a number from 0 to 15. }
} }
on $*:TEXT:/^[!@](c2|setc2|color2|colortwo)/Si:#:{ if ($chan !isin %notlist) {
    if (($2 >= 0) && ($2 <= 15)) { if ($len($2) == 1) { writeini ChStats.ini $chan c2 0 $+ $2 } | else { writeini ChStats.ini $chan c2 $2 } | msg $chan $col $+ This is now the color scheme for $col2 $+ $chan($chan) $+ $col $+ . }
    else { notice $nick Please enter a number from 0 to 15. }
} }
on $*:TEXT:/^[!@](c3|setc3|color3|colorthree)/Si:#:{ if ($chan !isin %notlist) {
    if (($2 >= 0) && ($2 <= 15)) { if ($len($2) == 1) { writeini ChStats.ini $chan c3 0 $+ $2 } | else { writeini ChStats.ini $chan c3 $2 } | msg $chan $col $+ This is now the color scheme for $col2 $+ $chan($chan) $+ $col $+ . }
    else { notice $nick Please enter a number from 0 to 15. }
} }

on $*:TEXT:/^[!@](part Llama(-| )?Bot)/Si:#:{ if ($chan !isin %notlist2) { part $chan Requested by $nick } }

on $*:TEXT:/^@(commands|help|info)/Si:#:{ if ($chan !isin %notlist) { msg $chan $col $+ To see a list of my commands, go to http://llamabot.webs.com/ (Can't see the link?  Type: /mode YourNick -f) } }
on $*:TEXT:/^!(commands|help|info)/Si:#:{ if ($chan !isin %notlist) { notice $nick To see a list of my commands, go to http://llamabot.webs.com/ (Can't see the link?  Type: /mode $nick -f) } }

on $*:TEXT:/^[!@](greet(s)?off|greet(s)? off)/Si:#:{ if ($chan !isin %notlist) { %greet. [ $+ [ $chan ] ] = $false | msg $chan $col $+ The channel greet is now OFF. } }
on $*:TEXT:/^[!@](greet(s)?on|greet(s)? on)/Si:#:{ if ($chan !isin %notlist) { %greet. [ $+ [ $chan ] ] = $true | msg $chan $col $+ The channel greet is now ON. } }

on $*:TEXT:/^@(website|site)/Si:#:{ if ($chan !isin %notlist) { msg $chan $col $+ The LlamaBot website: http://llamabot.webs.com/ (Can't see it?  Type: /mode YourNick -f). } }
on $*:TEXT:/^!(website|site)/Si:#:{ if ($chan !isin %notlist) { notice $nick The LlamaBot website: http://llamabot.webs.com/ (Can't see it?  Type: /mode $nick -f). } }
;My Wikipedia page: http://en.wikipedia.org/wiki/LlamaBot

on $*:TEXT:/^[!@](error|bug|glitch|mistake)/Si:#:{ if ($chan !isin %notlist) { if ($2) { %bugs = %bugs *** $nick $+ : $2- | notice $nick Thank you for your bug report, I will try to fix it as soon as possible. } | else { notice $nick Please include your error report or comment. } } }
on $*:TEXT:/^[!@](suggest|comment)/Si:#:{ if ($chan !isin %notlist) { if ($2) { %bugs = %bugs *** $nick $+ : $2- | notice $nick Thank you for your comment, I will look at it as soon as possible. } | else { notice $nick Please include your error report or comment. } } }

;on $*:TEXT:/^[!@](amsg|global)/Si:#:{ if (($chan !isin %notlist) && ($address($nick,2) == $address($me,2))) { amsg $2- } }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Useful ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:@users:#:{ if ($chan !isin %notlist) { msg $chan $col $+ There are $nick($chan,0) users on $chan $+ . | msg $chan $col $+ There are $nick($chan,0,o) ops, $nick($chan,0,h) hops, $nick($chan,0,v) voices, and $nick($chan,0,r) non-voices. } }
on *:TEXT:!users:#:{ if ($chan !isin %notlist) { notice $nick There are $nick($chan,0) users on $chan $+ . | notice $nick There are $nick($chan,0,o) ops, $nick($chan,0,h) hops, $nick($chan,0,v) voices, and $nick($chan,0,r) non-voices. } }

on *:TEXT:@date:#:{ if ($chan !isin %notlist) { msg $chan $col $+ Today is $fulldate (GMT -5) } }
on *:TEXT:!date:#:{ if ($chan !isin %notlist) { notice $nick Today is $fulldate (GMT -5) } }

on *:TEXT:@time:#:{ if ($chan !isin %notlist) { msg $chan $col $+ It is currently $time (GMT -5) } }
on *:TEXT:!date:#:{ if ($chan !isin %notlist) { notice $nick It is currently $time (GMT -5) } }

on $*:TEXT:/^!(asc|ascii)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { var %asc = $2 | if (%asc !isnum) { notice $nick $2 is: $asc(%asc) } | else { notice $nick $2 is: $chr(%asc) } }
    else { notice $nick You need to specify a character or number to convert. }
} }
on $*:TEXT:/^@(asc|ascii)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { var %asc = $2 | if (%asc !isnum) { msg $chan $col $+ $2 is: $asc(%asc) } | else { msg $chan $col $+ $2 is: $chr(%asc) } }
    else { notice $nick You need to specify a character or number to convert. }
} }
alias asc { var %asc = $1 | if (%asc !isnum) { echo -a $asc(%asc) } | else { echo -a $chr(%asc) } }

on $*:TEXT:/^[!@](topic|settopic)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { /topic # $2- | msg $chan $col $+ I have tried to set the topic to: $2- }
    else { notice $nick You need to specify a topic to set }
} }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Entertainment ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


alias crand {
  %randCol2 = $rand(1,15) | %randCol2 = $iif($len(%randCol2) == 1,0 $+ %randCol2,%randCol2)
  if (%randCol2 isin 01 02 03 05 06 10 12 14) { %randCol1 = 00 }
  else { %randCol1 = 01 }
  return  $+ %randCol1 $+ , $+ %randCol2
}


/*
alias crand {
  %randCol1 = 1 | %randCol2 = 1
  while ($crandx(%randCol1,%randCol2)) {
    var %randCol1 = $rand(0,15)
    %randCol1 = $iif($len(%randCol1) == 1,0 $+ %randCol1,%randCol1)
    var %randCol2 = $rand(1,15)
    %randCol2 = $iif($len(%randCol2) == 1,0 $+ %randCol2,%randCol2)
  }
  return  $+ %randCol1 $+ , $+ %randCol2
}

alias crandx {
  if      ($1 == $2) { return 1 }
  else if ($2 == 14) { return 1 }
  else if (($1 isin 04 07 13) && ($2 isin 04 07 13)) { return 1 }
  else if (($1 isin 03 10 14) && ($2 isin 03 10 14)) { return 1 }
  else if (($1 isin 02 12) && ($2 isin 02 12)) { return 1 }
  else if (($1 isin 03 04 07 09) && ($2 isin 03 04 07 09)) { return 1 }
  else if (($1 isin 09 11) && ($2 isin 09 11)) { return 1 }
  else if (($1 isin 11 15) && ($2 isin 11 15)) { return 1 }
  else if (($1 isin 04 14) && ($2 isin 04 14)) { return 1 }
  else if (($1 isin 00 08 15) && ($2 isin 00 08 15)) { return 1 }
  else if (($1 isin 08 11) && ($2 isin 08 11)) { return 1 }
  else if (($1 isin 06 10) && ($2 isin 06 10)) { return 1 }
  else { return 0 }
}
*/

on $*:TEXT:/^!(total)?(llama(bot)?|lb|bot)(file)?(script(s)?)?(size|byte|char)/Si:#:{ if ($chan !isin %notlist) { notice $nick There are currently $bytes($foldersize(C:\Users\Kevin\AppData\Roaming\mIRC\scripts),b) characters making up the LlamaBot scripts. } }
on $*:TEXT:/^@(total)?(llama(bot)?|lb|bot)(file)?(script(s)?)?(size|byte|char)/Si:#:{ if ($chan !isin %notlist) { msg $chan $col $+ There are currently $bytes($foldersize(C:\Users\Kevin\AppData\Roaming\mIRC\scripts),b) characters making up the LlamaBot scripts. } }

on $*:TEXT:/^[!@](coin|flip|toss|heads|tails)/Si:#:{ if ($chan !isin %notlist) { var %side = $rand(1,2) | if (%side == 1) { %side = heads } | else { %side = tails } | msg $chan $col $+ $nick flips a coin, and it lands %side up. } }
on $*:TEXT:/^[!@](die|dice|roll)/Si:#:{ if ($chan !isin %notlist) { var %side = $rand(1,6) | msg $chan $col $+ $nick rolls a die, and it lands on %side $+ . } }

on $*:TEXT:/^[!@](rainbow)/Si:#:{ if ($chan !isin %notlist) { if ($2) { /rainbo2 $2- } | else { notice $nick Please specify a string to be made colorful. } } }

on $*:TEXT:/^@morse(code)?/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { msg $chan $col $+ Translated: $morse($2-) }
    else { notice $nick You need something to translate! }
} }
on $*:TEXT:/^!morse(code)?/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { notice $nick Translated: $morse($2-) }
    else { notice $nick You need something to translate! }
} }

on $*:TEXT:/^@(rom|roman|numeral|romnum)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 isnum) { rom $2 msg }
    else {
      if ($regex($upper($2),/^[MDCLXVI]+$/)) { rrom $upper($2) msg }
      else { notice $nick Invalid format (use only MDCLXVI). }
    }
} }
on $*:TEXT:/^@(rom|roman|numeral|romnum)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 isnum) { rom $2 }
    else {
      if ($regex($upper($2),/^[MDCLXVI]+$/)) { rrom $upper($2) }
      else { notice $nick Invalid format (use only MDCLXVI). }
    }
} }


on $*:TEXT:/^[!]((what|w)(-| )?(the|t)|sw)/Si:#,?:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ What the $read(Adjectives.txt) $read(Animals.txt) $+ ?! } }
on $*:TEXT:/^[@]((what|w)(-| )?(the|t)|sw)/Si:#:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ What the $read(Adjectives.txt) $read(Animals.txt) $+ ?! } }
on $*:TEXT:/^[!]quotes/Si:#LlamaBot,?:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ $read(Funny.txt) } }
on $*:TEXT:/^[@]quotes/Si:#LlamaBot:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ $read(Funny.txt) } }
on $*:TEXT:/^[!]quote2/Si:#LlamaBot,?:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ $read(Rec2.txt) } }
on $*:TEXT:/^[@]quote2/Si:#LlamaBot:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ $read(Rec2.txt) } }
on $*:TEXT:/^[!]quote/Si:#LlamaBot,?:{ if ($chan !isin %notlist) {
    if (([x*] iswm $right($1-,4)) && ($mid($1-,$calc($len($1-) - 1),1) isnum)) {
      var %i = 1 | while (%i < $mid($1-,$calc($len($1-) - 1),1)) {
        notice $nick  $+ $crand $+ $read(Record.txt)
        inc %i | inc %spam. [ $+ [ $chan ] ]
      }
    }
    notice $nick  $+ $crand $+ $read(Record.txt)
} }
on $*:TEXT:/^[@]quote/Si:#LlamaBot:{ if ($chan !isin %notlist) {
    if (([x*] iswm $right($1-,4)) && ($mid($1-,$calc($len($1-) - 1),1) isnum)) {
      var %quoteType = $iif($mid($1-,$calc($len($1-) - 1),1) > 3, notice $nick, msg $chan)
      var %i = 1 | while (%i < $mid($1-,$calc($len($1-) - 1),1)) {
        %quoteType  $+ $crand $+ $read(Record.txt)
        inc %i | inc %spam. [ $+ [ $chan ] ]
      }
    }
    msg $chan  $+ $crand $+ $read(Record.txt)
} }
on $*:TEXT:/^[!]quote/Si:#:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ $read(Funny.txt) } }
on $*:TEXT:/^[@]quote/Si:#:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ $read(Funny.txt) } }
on $*:TEXT:/^[!]law/Si:#,?:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ $read(Law.txt) } }
on $*:TEXT:/^[@]law/Si:#:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ $read(Law.txt) } }
on $*:TEXT:/^[!]meta/Si:#,?:{ if ($chan !isin %notlist) { notice $nick  $+ $crand $+ $read(FunnyMeta.txt) } }
on $*:TEXT:/^[@]meta/Si:#:{ if ($chan !isin %notlist) { msg $chan  $+ $crand $+ $read(FunnyMeta.txt) } }
on $*:TEXT:/^[!@](record)/Si:#LlamaBot,?:{ if ($chan !isin %notlist) {
    if ($2) {
      if (($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) { write Record.txt $2- | notice $nick I have recorded your quote. }
      else { notice $nick Only Half-Ops and above can record quotes. }
    }
    else { notice $nick You need to include the quote.  If you want me to read an already recorded quote, use !quote. }
} }

on $*:TEXT:/^[!@](kill|execute|shoot|pwn)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan sneaks up behind $2- from out of the shadows... then pulls out a machine gun and blows $2- to pieces!!!  Pwnt! } | else { describe $chan sneaks up behind $nick from out of the shadows... then pulls out a machine gun and blows $nick to pieces!!!  Pwnt! } } }
on $*:TEXT:/^[!@](snipe|headshot)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan aims carefully at $2- $+ ... silence... and then... BLAM!!  HEADSHOT!!! } | else { describe $chan aims carefully at $nick $+ ... silence... and then... BLAM!!  HEADSHOT!!! } } }
on $*:TEXT:/^[!@](rape)/Si:#:{ if ($chan !isin %notlist) { describe $chan is thoroughly disgusted by $nick $+ 's suggestion... } }
on $*:TEXT:/^[!@](cookie)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan gives $2- a big Mrs. Field's chocolate chip cookie =) } | else { describe $chan gives $nick a big Mrs. Field's chocolate chip cookie =) } } }
on $*:TEXT:/^[!@](runover|smash|crush)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan revs his engine... then runs $2- over with his SUV! } | else { describe $chan revs his engine... then runs $nick over with his SUV! } } }
on $*:TEXT:/^[!@](slap)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan slaps $2- around a bit with an enormous trout! } | else { describe $chan slaps $nick around a bit with an enormous trout! } } }
on $*:TEXT:/^[!@](punch|hit)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan punches $2- in the shoulder. } | else { describe $chan punches $nick in the shoulder. } } }
on $*:TEXT:/^[!@](hug)/Si:#:{ if ($chan !isin %notlist) { if ($2) { describe $chan huggles $2- 04<3 } | else { describe $chan huggles $nick 04<3 } } }

on $*:TEXT:/^( )*[!@i]([w]+(h)*[o0aeiu]*[o0]+[o0aeiu]*(h)*t)/Si:#LlamaBot:{
  if (($3) && ($2 == for)) { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $3-  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
  else if ($2) { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $2-  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
  else { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $nick  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
}
on $*:TEXT:/^[!@](w[o0]+[o0]+t)/Si:#:{ if ($chan !isin %notlist2) {
    if (($3) && ($2 == for)) { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $3-  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
    else if ($2) { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $2-  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
    else { msg $chan 0,9@¸3,9`@¦9,3¦@¸1,3`@¦3,1¦9,1  w00t for $nick  3,1¦1,3¦@¸9,3`@¦3,9¦@¸0,9`@ }
} }

on $*:TEXT:/^[!@]((con)?gra[td](ulation)?[zs]|gz)/Si:#:{ if ($chan !isin %notlist) {
    if ($3) {
      if ($2 isnum) {
        if ($4) {
          if (($3 == att) || ($3 == attack)) { msg $chan 3,8Congratulations on level $2 11,8Attack3,8 $+ , $4 $+ ! }
          elseif (($3 == str) || ($3 == strength)) { msg $chan 3,8Congratulations on level $2 11,8Strength3,8 $+ , $4 $+ ! }
          elseif (($3 == def) || ($3 == defence)) { msg $chan 3,8Congratulations on level $2 11,8Defence3,8 $+ , $4 $+ ! }
          elseif (($3 == hp) || ($3 == hitpoints)) { msg $chan 3,8Congratulations on level $2 11,8Hitpoints3,8 $+ , $4 $+ ! }
          elseif (($3 == hit) && ($4 == points)) {
            if ($5) { msg $chan 3,8Congratulations on level $2 11,8Hitpoints3,8 $+ , $5 $+ ! }
            else { msg $chan 3,8Congratulations on level $2 11,8Hitpoints3,8 $+ ! }
          }
          elseif (($3 == range) || ($3 == ranged)) { msg $chan 3,8Congratulations on level $2 11,8Ranged3,8 $+ , $4 $+ ! }
          elseif (($3 == mage) || ($3 == magic)) { msg $chan 3,8Congratulations on level $2 11,8Magic3,8 $+ , $4 $+ ! }
          elseif (($3 == pray) || ($3 == prayer)) { msg $chan 3,8Congratulations on level $2 11,8Prayer3,8 $+ , $4 $+ ! }
          elseif (($3 == wc) || ($3 == wcing) || ($3 == woodcutting)) { msg $chan 3,8Congratulations on level $2 11,8Woodcutting3,8 $+ , $4 $+ ! }
          elseif (($3 == wood) && ($4 == cutting)) {
            if ($5) { msg $chan 3,8Congratulations on level $2 11,8Woodcutting3,8 $+ , $5 $+ ! }
            else { msg $chan 3,8Congratulations on level $2 11,8Woodcutting3,8 $+ ! }
          }
          elseif (($3 == fm) || ($3 == fming) || ($3 == firemaking)) { msg $chan 3,8Congratulations on level $2 11,8Firemaking3,8 $+ , $4 $+ ! }
          elseif (($3 == rc) || ($3 == runecraft) || ($3 == runecrafting)) { msg $chan 3,8Congratulations on level $2 11,8Runecrafting3,8 $+ , $4 $+ ! }
          elseif (($3 == agil) || ($3 == agility)) { msg $chan 3,8Congratulations on level $2 11,8Agility3,8 $+ , $4 $+ ! }
          elseif (($3 == thief) || ($3 == thieving)) { msg $chan 3,8Congratulations on level $2 11,8Thieving3,8 $+ , $4 $+ ! }
          elseif (($3 == herb) || ($3 == herblaw) || ($3 == herblore)) { msg $chan 3,8Congratulations on level $2 11,8Herblore3,8 $+ , $4 $+ ! }
          elseif (($3 == craft) || ($3 == crafting)) { msg $chan 3,8Congratulations on level $2 11,8Crafting3,8 $+ , $4 $+ ! }
          elseif (($3 == fletch) || ($3 == fletching)) { msg $chan 3,8Congratulations on level $2 11,8Fletching3,8 $+ , $4 $+ ! }
          elseif (($3 == slay) || ($3 == slayer)) { msg $chan 3,8Congratulations on level $2 11,8Slayer3,8 $+ , $4 $+ ! }
          elseif (($3 == mine) || ($3 == mining)) { msg $chan 3,8Congratulations on level $2 11,8Mining3,8 $+ , $4 $+ ! }
          elseif (($3 == smith) || ($3 == smithing)) { msg $chan 3,8Congratulations on level $2 11,8Smithing3,8 $+ , $4 $+ ! }
          elseif (($3 == cook) || ($3 == cooking)) { msg $chan 3,8Congratulations on level $2 11,8Cooking3,8 $+ , $4 $+ ! }
          elseif (($3 == fish) || ($3 == fishing)) { msg $chan 3,8Congratulations on level $2 11,8Fishing3,8 $+ , $4 $+ ! }
          elseif (($3 == farm) || ($3 == farming)) { msg $chan 3,8Congratulations on level $2 11,8Farming3,8 $+ , $4 $+ ! }
          elseif (($3 == con) || ($3 == construction)) { msg $chan 3,8Congratulations on level $2 11,8Construction3,8 $+ , $4 $+ ! }
          elseif (($3 == hunt) || ($3 == hunting) || ($3 == hunter)) { msg $chan 3,8Congratulations on level $2 11,8Hunter3,8 $+ , $4 $+ ! }
          elseif (($3 == sum) || ($3 == summ) || ($3 == summon) || ($3 == summoning)) { msg $chan 3,8Congratulations on level $2 11,8Summoning3,8 $+ , $4 $+ ! }
          else { msg $chan 3,8Congratulations on level $2 $3 $+ , $4 $+ ! }
        }
        else {
          if (($3 == att) || ($3 == attack)) { msg $chan 3,8Congratulations on level $2 11,8Attack3,8 $+ ! }
          elseif (($3 == str) || ($3 == strength)) { msg $chan 3,8Congratulations on level $2 11,8Strength3,8 $+ ! }
          elseif (($3 == def) || ($3 == defence)) { msg $chan 3,8Congratulations on level $2 11,8Defence3,8 $+ ! }
          elseif (($3 == hp) || ($3 == hitpoints)) { msg $chan 3,8Congratulations on level $2 11,8Hitpoints3,8 $+ ! }
          elseif (($3 == range) || ($3 == ranged)) { msg $chan 3,8Congratulations on level $2 11,8Ranged3,8 $+ ! }
          elseif (($3 == mage) || ($3 == magic)) { msg $chan 3,8Congratulations on level $2 11,8Magic3,8 $+ ! }
          elseif (($3 == pray) || ($3 == prayer)) { msg $chan 3,8Congratulations on level $2 11,8Prayer3,8 $+ ! }
          elseif (($3 == wc) || ($3 == wcing) || ($3 == woodcutting)) { msg $chan 3,8Congratulations on level $2 11,8Woodcutting3,8 $+ ! }
          elseif (($3 == fm) || ($3 == fming) || ($3 == firemaking)) { msg $chan 3,8Congratulations on level $2 11,8Firemaking3,8 $+ ! }
          elseif (($3 == rc) || ($3 == runecraft) || ($3 == runecrafting)) { msg $chan 3,8Congratulations on level $2 11,8Runecrafting3,8 $+ ! }
          elseif (($3 == agil) || ($3 == agility)) { msg $chan 3,8Congratulations on level $2 11,8Agility3,8 $+ ! }
          elseif (($3 == thief) || ($3 == thieving)) { msg $chan 3,8Congratulations on level $2 11,8Thieving3,8 $+ ! }
          elseif (($3 == herb) || ($3 == herblaw) || ($3 == herblore)) { msg $chan 3,8Congratulations on level $2 11,8Herblore3,8 $+ ! }
          elseif (($3 == craft) || ($3 == crafting)) { msg $chan 3,8Congratulations on level $2 11,8Crafting3,8 $+ ! }
          elseif (($3 == fletch) || ($3 == fletching)) { msg $chan 3,8Congratulations on level $2 11,8Fletching3,8 $+ ! }
          elseif (($3 == slay) || ($3 == slayer)) { msg $chan 3,8Congratulations on level $2 11,8Slayer3,8 $+ ! }
          elseif (($3 == mine) || ($3 == mining)) { msg $chan 3,8Congratulations on level $2 11,8Mining3,8 $+ ! }
          elseif (($3 == smith) || ($3 == smithing)) { msg $chan 3,8Congratulations on level $2 11,8Smithing3,8 $+ ! }
          elseif (($3 == cook) || ($3 == cooking)) { msg $chan 3,8Congratulations on level $2 11,8Cooking3,8 $+ ! }
          elseif (($3 == fish) || ($3 == fishing)) { msg $chan 3,8Congratulations on level $2 11,8Fishing3,8 $+ ! }
          elseif (($3 == farm) || ($3 == farming)) { msg $chan 3,8Congratulations on level $2 11,8Farming3,8 $+ ! }
          elseif (($3 == con) || ($3 == construction)) { msg $chan 3,8Congratulations on level $2 11,8Construction3,8 $+ ! }
          elseif (($3 == hunt) || ($3 == hunting) || ($3 == hunter)) { msg $chan 3,8Congratulations on level $2 11,8Hunter3,8 $+ ! }
          elseif (($3 == sum) || ($3 == summ) || ($3 == summon) || ($3 == summoning)) { msg $chan 3,8Congratulations on level $2 11,8Summoning3,8 $+ ! }
          else { msg $chan 3,8Congratulations on level $2 $3 $+ ! }
        }
      }
      else { notice $nick Make sure you use this format: gratz Level Skill (Name - optional) }
    }
    else { notice $nick Make sure you use this format: gratz Level Skill (Name - optional) }
} }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Custom Scripts ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
on $*:TEXT:/^[!@](req|requirement)/Si:#ODO:{
  notice $nick ODO clan requirements...
  notice $nick Full member, tank: 90+ range or 90+ mage and 70+ defence.
  notice $nick Full member, rune pure: 70+ att and 90+ str and 45- defence.
  notice $nick Jr. member, tank: 80+ range or mage with 70+ defence.
  notice $nick Jr. member, rune pure: 60+ att and 80+ str and 45- defence.
}
on $*:TEXT:/^@(forum|clanforum|forums|clanforums)/Si:#ODO:{ msg $chan $col $+ ODO clan forums: http://z11.invisionfree.com/megalor234/index.php?&CODE=00 (Can't see it?  Type: /mode YourNick -f) }
on $*:TEXT:/^!(forum|clanforum|forums|clanforums)/Si:#ODO:{ notice $nick ODO clan forums: http://z11.invisionfree.com/megalor234/index.php?&CODE=00 (Can't see it?  Type: /mode $nick -f) }
on *:TEXT:!add:#ODO:{ if ($nick == MegaLor234) { if ($2) { %clanList = %clanList $+ , $replacex($2-, $chr(32),_) | notice $nick $replacex($2-, $chr(32),_) has been added to the clan list. } | else { notice $nick Please specify someone to add. } } | else { notice $nick Only MegaLor234 can do that. } }
on *:TEXT:@clanlist:#ODO:{ msg $chan $col $+ %clanList }
on *:TEXT:!clanlist:#ODO:{ notice $nick %clanList }
*/

on $*:TEXT:/^!(req|requirement)/Si:#TDPK:{ notice $nick Tainted Demise clan requirements: 90-120 combat with 82+ mage, and have pking skills and follow directions. }
on $*:TEXT:/^@(req|requirement)/Si:#TDPK:{ msg $chan $col $+ Tainted Demise clan requirements: 90-120 combat with 82+ mage, and have pking skills and follow directions. }

on $*:TEXT:/^!((pk)?vid|movie)/Si:#TDPK:{ notice $nick The TD PVP video can be found at http://www.youtube.com/watch?v=zYs3Y_KVSmQ }
on $*:TEXT:/^@((pk)?vid|movie)/Si:#TDPK:{ msg $chan $col $+ The TD PVP video can be found at http://www.youtube.com/watch?v=zYs3Y_KVSmQ }

on *:TEXT:!points*:#LlamaBot:{
  if (%point.U > %point.L) { msg $chan $col $+ Undoubtedly0 is in the lead with %point.U points (LlamaBot has %point.L $+ ). }
  else if (%point.U == %point.L) { msg $chan $col $+ Points are currently tied - both have %point.L points. }
  else { msg $chan $col $+ LlamaBot is in the lead with %point.L points (Undoubtedly0 has %point.U $+ ). }
}
on *:TEXT:!point*:#LlamaBot:{
  if (doubt isin $nick) {
    inc %point.L
    msg $chan 4,8LlamaBot has earned 1 point and now has %point.L points!
    woot LlamaBot
  }
  else { notice $nick You can't give points, sorry... }
}
alias point {
  inc %point.U
  msg #LlamaBot !point
  msg #LlamaBot 4,8Undoubtedly0 has earned 1 point and now has %point.U points!
  woot Undoubtedly0
}
alias points {
  if (%point.U > %point.L) { msg $chan $col $+ Undoubtedly0 is in the lead with %point.U points (LlamaBot has %point.L $+ ). }
  else if (%point.U == %point.L) { msg $chan $col $+ Points are currently tied - both have %point.L points. }
  else { msg $chan $col $+ LlamaBot is in the lead with %point.L points (Undoubtedly0 has %point.U $+ ). }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Aliases ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;if (!$readini(DM.ini, $chan, c1)) { writeini ChStats.ini $chan c1 05 | writeini ChStats.ini $chan c2 15 | writeini ChStats.ini $chan c3 04 }
alias col {
  if (($chan) || (#* iswm $left($1,1))) {
    if ($1) { return  $+ $readini(ChStats.ini, $1, c1) $+ , $+ $readini(ChStats.ini, $1, c2) }
    else { return  $+ $readini(ChStats.ini, $chan, c1) $+ , $+ $readini(ChStats.ini, $chan, c2) }
  }
  else { echo -s $timestamp ERROR: NO CHANNEL | return 05,15 }
}
alias col2 {
  if (($chan) || (#* iswm $left($1,1))) {
    if ($1) { return  $+ $readini(ChStats.ini, $1, c3) $+ , $+ $readini(ChStats.ini, $1, c2) }
    else { return  $+ $readini(ChStats.ini, $chan, c3) $+ , $+ $readini(ChStats.ini, $chan, c2) }
  }
  else { echo -s $timestamp ERROR: NO CHANNEL | return 04,15 }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias bump { echo 2 -a Bump Timer set for 10 minutes. | window -c @Bump | window -dop +L @Bump 357 958 155 66 | window @Bump 357 958 155 66 | drawrect -fr @Bump $rgb(0,220,0) 0 0 0 300 300 | .timerBump 1 600 bump2 }
alias bump2 {
  if ($window(@Bump)) {
    drawrect -fr @Bump $rgb(220,0,0) 0 0 0 300 300
    ;noop $tip(j,Double click if not Kevin,Time up - forums,10,,,/afk)
  }
}
alias bump3 { echo 2 -a Bump Timer reset for 10 minutes. | drawrect -fr @Bump $rgb(0,220,0) 0 0 0 300 300 | .timerBump 1 600 bump2 }
menu @Bump {
  rclick:{ bump }
  sclick:{ if ($getdot(@Bump,10,10) == $rgb(220,0,0)) { bump3 } }
  dclick:{ afk | window -c @Bump | showmirc -t | cascade MinimizeAll }
}
alias getBump { echo 5 -a Next bump in $timer(bump).secs seconds. }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias processes {
  var %a,%b,%c,%d,%e,%ptotal
  %a = a $+ $ticks
  %b = b $+ $ticks
  %c = c $+ $ticks
  %d = 1
  %ptotal = Current processes are
  .comopen %a wbemscripting.swbemlocator
  if (!$comerr) {
    .comclose %a $com(%a,connectserver,3,dispatch* %b)
    if ($com(%b)) {
      .comclose %b $com(%b,instancesof,3,bstr,win32_process,dispatch* %c)
      if ($com(%c)) {
        noop $com(%c,count,3)
        %e = $com(%c).result
        ;if (!$window(@processes)) {
        ;  window -ek[0] @processes
        ;}
        ;else {
        ;  clear @processes
        ;}
        while (%d <= %e) {
          ;aline @processes Process Name -> $comval(%c,%d,name)
          if ($comval(%c,%d,name) isin firefox.exe notepad.exe WINWORD.EXE EXCEL.EXE POWERPNT.EXE Safari.exe iexplore.exe iTunes.exe mspaint.exe) { %ptotal = %ptotal $+ $chr(44) $comval(%c,%d,name) }
          inc %d
        }
        .comclose %c | echo %ptotal
      }
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias MBox {
  window -dop @Hola 0 950 1 100
  drawrect -rf @Hola $rgb(0,0,0) 1 0 0 200 200
  setlayer 80 @Hola
}
menu @Hola {
  dclick:{
    window -dop @Hola2 0 0 2000 2000 | setlayer 230 @Hola2
    drawrect -rf @Hola2 $rgb(0,0,0) 1 0 0 2000 2000 | %MinAll = 0
  }
  rclick:window -c @Hola
}
menu @Hola2 {
  dclick:{
    if (%MinAll == 1) { %MinAll = 2 }
    else { window -c @Hola2 | unset %MinAll }
  }
  rclick:{
    if (%MinAll == 2) { showmirc -t | Cascade MinimizeAll | window -c @Hola2 | window -c @Hola | afk }
    else { %MinAll = 1 }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias roman {
  if ($isid) {
    if ($1 isnum) {
      if (!$2) {
        if ($1 isnum 1-900387) {
          if (!$regex($1,/^\d+\.\d+$/)) {
            var %int = $1,%x = 1,%y,%z,%r,%array = M 1000,CM 900,D 500,CD 400,C 100,XC 90,L 50,XL 40,X 10,IX 9,V 5,IV 4,I 1
            while %int {
              while ($gettok(%array,%x,44)) {
                %y = $gettok($v1,1,32) | %z = $gettok($v1,2,32) | if (%z <= %int) { %r = $+(%r,%y) | %int = $calc(%int - %z) | dec %x } | inc %x
              }
            }
            return %r
          }
          else echo $color(info) -a $!roman Invalid Parameters: $1 is a floating point number $+($!roman,$chr(40),$chr(3),04,$1,$chr(3),$chr(41)) | halt
        }
        else echo $color(info) -a $!roman Invalid Parameters: $1 > 900387 $+($!roman,$chr(40),$chr(3),04,$1,$chr(3),$chr(41)) | halt
      }
      else echo $color(info) -a $!roman Invalid Parameters: Numeric input does not take a second parameter $+($!roman,$chr(40),$1,$chr(3),04,$chr(44),$2,$chr(3),$chr(41)) | halt
    }
    else {
      if (!$regex($1,/[^MDCLXVI]/)) {
        if ($2) {
          if ($2 === r) {
            var %num = $1,%x = 1,%r,%numerals = M CM D CD C XC L XL X IX V IV I,%value = 1000 900 500 400 100 90 50 40 10 9 5 4 1
            while (%x <= $len(%num)) {
              if $istok(%numerals,$mid(%num,%x,2),32) {
                %r = $calc(%r + $gettok(%value,$findtok(%numerals,$mid(%num,%x,2),1,32),32)) | inc %x 2
              }
              elseif $istok(%numerals,$mid(%num,%x,1),32) {
                %r = $calc(%r + $gettok(%value,$findtok(%numerals,$mid(%num,%x,1),1,32),32)) | inc %x
              }
            }
            return %r | unset %num %x
          }
          else echo $color(info) -a $!roman Invalid Parameters: $2 is not valid, you must use r. $+($!roman,$chr(40),$1,$chr(3),04,$chr(44),r,$chr(3),$chr(41)) | halt
        }
        else echo $color(info) -a $!roman Invalid Parameters: You must specify the r parameter when using an alpha input $+($!roman,$chr(40),$1,$chr(3),04,$chr(44),r,$chr(3),$chr(41)) | halt
      }
      else echo $color(info) -a $!roman Invalid Parameters: Alpha input may only contain MDCLXVI (case sensitive) $+($!roman,$chr(40),$chr(3),04,$1,$chr(3),$chr(41)) | halt
    }
  }
  else echo $color(info) -a $!roman Invalid Usage: /roman $!roman(N/C[,r]) | halt
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias aniclock window -pkodCfB +l @Clock -1 -1 110 110 | drawtext @Clock 1 verdana 10 5 5 Rendering... | $iif($1, setlayer $1 @Clock, ) | aclock
alias -l aclock { if ($window(@Clock)) {
    drawfill -nr @Clock 16777215 1 0 0
    drawline -nr @Clock $rgb(255,180,180) 4 55 55 $calc(55 + 45 * $sin($calc(360 * $asctime(ss) / 60)).deg) $calc(55 - 45 * $cos($calc(360 * $asctime(ss) / 60)).deg)
    drawline -nr @Clock $rgb(255,0,0) 2 55 55 $calc(55 + 45 * $sin($calc(360 * $asctime(ss) / 60)).deg) $calc(55 - 45 * $cos($calc(360 * $asctime(ss) / 60)).deg)
    drawline -nr @Clock $rgb(180,180,180) 6 55 55 $calc(55 + 25 * $sin($calc(360 * $asctime(hh) / 12)).deg) $calc(55 - 25 * $cos($calc(360 * $asctime(hh) / 12)).deg)
    drawline -nr @Clock 0 4 55 55 $calc(55 + 25 * $sin($calc(360 * $asctime(hh) / 12)).deg) $calc(55 - 25 * $cos($calc(360 * $asctime(hh) / 12)).deg)
    drawline -nr @Clock $rgb(180,180,180) 4 55 55 $calc(55 + 45 * $sin($calc(360 * $asctime(nn) / 60)).deg) $calc(55 - 45 * $cos($calc(360 * $asctime(nn) / 60)).deg)
    drawline -nr @Clock 0 2 55 55 $calc(55 + 45 * $sin($calc(360 * $asctime(nn) / 60)).deg) $calc(55 - 45 * $cos($calc(360 * $asctime(nn) / 60)).deg)
    drawline -nr @Clock $rgb(255,255,255) 3 55 5 55 15 | drawrect -ner @Clock $rgb(0,0,0) 1 5 5 100 100 | var %n 0
    while (%n <= 12) { if (%n != 0) { drawtext -rn @Clock 0 verdana 10 $calc(51 + 43 * $sin($calc(%n * 30)).deg) $calc(49 - 43 * $cos($calc(%n * 30)).deg) %n } | inc %n }
    titlebar @Clock $asctime(h:nn:ss) $+ $asctime(tt) | drawdot @Clock | .timer -m 1 55 aclock
} }
menu @Clock {
  Transparency:$iif($input(Set Transparency 0-255, eqd, Transparency), setlayer $v1 $active, halt)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias upsidedown return $regsubex($replacex($regsubex($lower($1-),/(.)/g,$mid(\A,-\n,1)),a,C9 90,b,q,c,C9 94,d,p,e,C7 9D,f,C9 9F,g,C6 83,h,C9 A5,i,C4 B1,j,C9 BE,k,CA 9E,l,CA 83,m,C9 AF,n,u,p,d,q,b,r,C9 B9,t,CA 87,u,n,v,CA 8C,w,CA 8D,y,CA 8E,!,i, $chr(44),`,`, $chr(44),?,¿),/([A-F\d]{2}) ([A-F\d]{2})/g,$chr($base(\1,16,10)) $+ $chr($base(\2,16,10)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias benchmark {
  if ($show) {
    if ($switch($1,a)) { var %o $iif($remove($1,a) != -,$v1) | tokenize 32 $2- }
    tokenize 59 $1- | var %a 1
    while ($(,%o $ $+ %a) != %o) { scon 0 .benchmark $!v1 | inc %a }
    return
  }
  var %benchmark $iif($switch($1,i) isnum,$v1,10000)
  var %b %benchmark,%s $1
  if ($switch($1)) tokenize 32 $2-
  tokenize 32 $iif(!$switch(%s,c),noop) $1-
  var %t $ticks
  while (%benchmark) { scon 0 $1- | dec %benchmark }
  var %t2 $ticks - %t
  echo -ag %b iterations of the $iif($1 = noop,string,command) $qt($iif($1 != noop,$1) $2-) took %t2 $+ ms
  return
  :error
  echo -cag info $error
  echo -ag Could not complete benchmark test for $qt($iif($1 != noop,$1) $2-)
  reseterror
}
alias switch {
  if (-?* !iswm $1) return $false
  if (!$regex($1,/([a-zA-Z](?:".+?"|[^a-zA-Z]+)?)/g)) return $false
  if ($2 isnum && $2 > $regml(0)) return $false
  if ($2 = $null) return $true
  if ($2 isnum) {
    var %m $regml($2),%s $left(%m,1),%p $noqt($mid(%m,2))
    if ($2 = 0) return $regml(0)
    if (%m != $null) { if ($regex($prop,/^exists?$/i)) return $true | if ($regex($prop,/^contents?$/i)) return $iif(%p,%p,$false) | return %s }
    return $false
  }
  var %x 1
  while ($regml(%x)) {
    var %m $v1,%s $left($v1,1),%p $noqt($mid($v1,2))
    if ($2 === %s) { if ($prop != sname) return $iif(%p,%p,$true) | elseif ($prop = sname) return %s }
    inc %x
  }
  return $false
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias lock { showmirc -lt | %Lock = dclick | .timerLock -m 0 100 lockTim | .timerColorWind 0 3 colorWind }
alias lockTim {
  if (!$window(@APRIL_1_LOCKDOWN)) {
    window -aCdk0opx @APRIL_1_LOCKDOWN 100 100 $null $null $null C:\Program Files\McAfee\MQC\McpAdmin.exe
    setlayer 1 @APRIL_1_LOCKDOWN
    ;if ($mouse.key & 8) { %Lock = dclick }
  }
  ;else if ($active != @APRIL_1_LOCKDOWN) {
  else if (!$appactive) {
    window -c @APRIL_1_LOCKDOWN
    window -aCdk0opx @APRIL_1_LOCKDOWN 100 100 $null $null $null C:\Program Files\McAfee\MQC\McpAdmin.exe
    setlayer 1 @APRIL_1_LOCKDOWN
  }
}
menu @APRIL_1_LOCKDOWN {
  dclick:{ if (%Lock == dclick) { %Lock = rclick } | else { %Lock = dclick } }
  rclick:{ if (%Lock == rclick) { %Lock = ctrl | .timerLock2 1 1 /ctrlCheck } | else { %Lock = dclick } }
}
alias ctrlCheck { if (($mouse.key & 2) && (%Lock == ctrl)) { .timerLock off | .timerColorWind off | window -c @APRIL_1_LOCKDOWN | window -c %Lockdown | %Lock = 0 } }

alias colorWind {
  window -c @Lockdown
  window -dop @Lockdown $rand(1,2000) $rand(1,1000) $rand(100,500) $rand(50,400)
  drawrect -fr @Lockdown $rgb($rand(0,255),$rand(0,255),$rand(0,255)) 0 0 0 600 600
  drawtext -fro @Lockdown $rgb($rand(0,255),$rand(0,255),$rand(0,255)) $rand(1,20) $rand(1,20) [APRIL LOCKDOWN]
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias Logger { /window -doe0k0 @Log 1 1 400 150 | write %logFile 4---- $fulldate ---- }
on *:INPUT:@Log:{
  haltdef | write %logFile 14 $+ $timestamp $+  $1-
  if ($1 == /calcON) { %calcMode = 1 | echo @Log Calculate ON. }
  else if ($1 == /calcOFF) { %calcMode = 0 | echo @Log Calculate OFF. }
  else if (%calcMode == 1) { if ($left($1,1) isin +-*/^) { %c.Numb = x $+ $1- } | else { %c.Numb = $1- } | echo @Log $replace(%c.Numb,x,%c.LastCalc) = $calc($replace(%c.Numb,x,%c.LastCalc)) | clipboard $calc($replace(%c.Numb,x,%c.LastCalc)) | %c.LastCalc = $calc($replace(%c.Numb,x,%c.LastCalc)) }
  else if ($1 = /calc) { echo @Log $replace($2-,x,%c.LastCalc) = $calc($replace($2-,x,%c.LastCalc)) | %c.LastCalc = $calc($replace($2-,x,%c.LastCalc)) | clipboard $calc($replace($2-,x,%c.LastCalc)) }
  else { echo @Log $1- }
}
menu @Log {
  Load 10:/loadbuf 10 -ipr @Log %logFile
  Load 30:/loadbuf 30 -ipr @Log %logFile
  Load All:/loadbuf 9999 -ipr @Log %logFile
}

/*
;Calc for giving
alias Logger { window -doe0k0 @Log 1 1 400 150 }
on *:INPUT:@Log:{ if ($left($1,1) isin +-*/^) { %c.Numb = x $+ $1- } | else { %c.Numb = $1- } | echo @Log $replace(%c.Numb,x,%c.LastCalc) = $calc($replace(%c.Numb,x,%c.LastCalc)) | clipboard $calc($replace(%c.Numb,x,%c.LastCalc)) | %c.LastCalc = $calc($replace(%c.Numb,x,%c.LastCalc)) }
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias gibb { .timerGib  1 30 /gibb2 }
alias gibb2 { .timerGib 0 5 /gibb3 }
alias gibb3 {
  var %gibb1 = $rand(1,8)
  var %gibb2 = $rand(1,2)
  if (%gibb1 == 2) {
    if (%gibb2 == 1) { /sendkey2 $chr($rand(32,126)) }
    if (%gibb2 == 2) { /sendkey2 $chr($rand(32,126)) | /sendkey2 $chr($rand(32,126)) }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
