;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Stats, Etc. ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](cmb|combat|level|lvl)/Si:#: { if ($chan !isin %notlist) {
    set %dispp $iif($left($1,1) == @, msg $chan, notice $nick) $col
    getCmb $1-
} }

alias getCmb {
  if ($remove($2-,$chr(32)) !isnum) { %dispp $+ Oops!  You need to do: !cmb Att Str Def Hp Range Pray Mage Summon }
  else if (!$9) { %dispp $+ Oops!  You need to do: !cmb Att Str Def Hp Range Pray Mage Summon }
  else if ($10) { %dispp $+ Oops!  You need to do: !cmb Att Str Def Hp Range Pray Mage Summon }
  else {
    Var %Def $calc($4 * 100) | Var %Hits $calc($5 * 100) | Var %Pray $calc($7 * 50) | Var %summon $calc($9 * 50) | Var %hit.def.pray.summon $calc((%Def + %hits + %Pray + %summon) / 400) | Var %Att $calc($2 * 130) | Var %str $calc($3 * 130) 
    if (!$and($6,1)) { Var %range $calc((($6 - 1) + ($6 * 2)) * 65) } 
    else { var %Range $calc($6 * 195) }
    if (!$and($8,1)) { Var %mage $calc((($8 - 1) + ($8 * 2)) * 65) } 
    else { var %Mage $calc($8 * 195) }
    Var %Melee $calc((%att + %str) /400), %Ranger $calc(%range / 400), %mager $calc(%mage / 400) 
    if (%ranger > %melee) && (%ranger > %Mager) { set %return $calc(%hit.def.pray.summon + %ranger) | set %based Ranged } 
    else if (%mager > %melee) && (%mager > %ranger) { set %return $calc(%hit.def.pray.summon + %mager) | set %based Magic } 
    else if (%Melee > %mager) && (%melee > %ranger) { set %return $calc(%Hit.def.pray.summon + %melee) | set %based Melee } 
    %dispp $+ With ASDHRPMSu of $2-9 $+ , combat will be: $col2 $+ %return $col $+ ( $+ %based based).
    unset %based %return %dispp
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](setdef|defname|setname)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { 
      if ($len($2) <= 12) { notice $nick The default username for $address($nick,3) is now $2- $+  | writeini defname.ini name $address($nick,3) $2- } 
      else { notice $nick The RuneScape username can only be 12 letters long! } 
    } 
    else { notice $nick You need to enter a defname to set! } 
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](stat|skill|level)/Si:#:{ if ($chan !isin %notlist) {
    if ($len($2-) <= 12) {
      set %allName $iif(!$2,$iif($readini(defname.ini,name,$address($nick,3)),$v1,$nick),$regsubex($replace($2-,$chr(32),_),/\b(\w)/g,$upper(\1))))
      set %allMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      %allStuff = Levels for $col2 $+ %allName $+ $col $+ :
      %statsNum = 1 | %statsChan = $chan | %statsCmb = 2- | %statsCmbS = 0
      sockopen AllStats hiscore.runescape.com 80
    }
    else { notice $nick The username can only be 12 letters long. }
} }
on *:SOCKOPEN:AllStats: {
  sockwrite -nt $sockname GET /index_lite.ws?player= $+ %allName HTTP/1.1
  sockwrite -nt $sockname Host: hiscore.runescape.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:AllStats: {
  if ($sockerr) { halt }
  else {
    .timerAllClose -m 1 100 AllClose
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/Page not found/i)) { %allStuff = %allStuff No stats were found. | AllClose | .timerAllClose off }
    if ($regex(%sockreader,/(.+) $+ $chr(44) $+ (.+) $+ $chr(44) $+ (.+)/i)) {
      if (%statsNum == 1) { %allStuff = %allStuff $getStat(%statsNum) $+  $iif($regml(2) != -1,$v1 ( $+ $bytes($regml(3),b) total exp),N/A)  }
      else {
        %allStuff = %allStuff $chr(124) $getStat(%statsNum) $+  $iif($regml(2) != -1,$replace($v1,99,$col2(%statsChan) $+ 99 $+ $col(%statsChan)),N/A) $+ 
        tokenize 32 %statsCmb
        if ($1 == 5-) { if ($regml(2) == -1) { %statsCmbS = at least level } | %statsCmb = %statsCmb $replace($regml(2),-1,10) }
        else if ($1 isin 2-3-4-6-7-8-25-) { if ($regml(2) == -1) { %statsCmbS = at least level } | %statsCmb = %statsCmb $replace($regml(2),-1,1) }
      }
      inc %statsNum
      %statsCmb = $replace(%statsCmb,$1,$calc($remove($1,-) + 1) $+ -)
    }
  }
}
alias getStat {
  if     ($1 == 1) return Total
  elseif ($1 == 2) return ¬Att
  elseif ($1 == 3) return Def
  elseif ($1 == 4) return Str
  elseif ($1 == 5) return HP
  elseif ($1 == 6) return Range
  elseif ($1 == 7) return Pray
  elseif ($1 == 8) return Mage
  elseif ($1 == 9) return Cook
  elseif ($1 == 10) return WCing
  elseif ($1 == 11) return Fletch
  elseif ($1 == 12) return Fish
  elseif ($1 == 13) return FMing
  elseif ($1 == 14) return Craft
  elseif ($1 == 15) return Smith
  elseif ($1 == 16) return Mining
  elseif ($1 == 17) return ¬Herblore
  elseif ($1 == 18) return Agil
  elseif ($1 == 19) return Thief
  elseif ($1 == 20) return Slay
  elseif ($1 == 21) return Farm
  elseif ($1 == 22) return RCing
  elseif ($1 == 23) return Hunt
  elseif ($1 == 24) return Construct
  elseif ($1 == 25) return Summ
}
alias -l getCmb2 {
  if (%statsCmbS == 0) { %statsCmbS = combat level }
  Var %Def $calc($4 * 100) | Var %Hits $calc($5 * 100) | Var %Pray $calc($7 * 50) | Var %summon $calc($9 * 50) | Var %hit.def.pray.summon $calc((%Def + %hits + %Pray + %summon) / 400) | Var %Att $calc($2 * 130) | Var %str $calc($3 * 130) 
  if (!$and($6,1)) { Var %range $calc((($6 - 1) + ($6 * 2)) * 65) } 
  else { var %Range $calc($6 * 195) }
  if (!$and($8,1)) { Var %mage $calc((($8 - 1) + ($8 * 2)) * 65) } 
  else { var %Mage $calc($8 * 195) }
  Var %Melee $calc((%att + %str) /400), %Ranger $calc(%range / 400), %mager $calc(%mage / 400) 
  if (%ranger > %melee) && (%ranger > %Mager) { set %return $calc(%hit.def.pray.summon + %ranger) | set %based Ranged } 
  else if (%mager > %melee) && (%mager > %ranger) { set %return $calc(%hit.def.pray.summon + %mager) | set %based Magic } 
  else if (%Melee > %mager) && (%melee > %ranger) { set %return $calc(%Hit.def.pray.summon + %melee) | set %based Melee } 
  %allMsg $+ %allname is %statsCmbS  $+ $col2(%statsChan) $+ %return $col(%statsChan) $+ ( $+ %based based).
  unset %based %return
}
alias AllClose {
  tokenize 172 %allStuff
  if (No stats were found isin $1) { %allMsg $+ %allStuff }
  else {
    if ($len(%allStuff) < 430) { %allMsg $+ $1- | getCmb2 %statsCmb }
    else if ($len(%allStuff) < 500) { inc %spam. [ $+ [ %statsChan ] ] | %allMsg $+ $left($1,$calc($len($1) - 2)) | %allMsg $+ $2- | getCmb2 %statsCmb }
    else { inc %spam. [ $+ [ %statsChan ] ] | inc %spam. [ $+ [ %statsChan ] ] | %allMsg $+ $left($1,$calc($len($1) - 2)) | %allMsg $+ $left($2,$calc($len($2) - 2)) | %allMsg $+ $3- | getCmb2 %statsCmb }
  }
  unset %allname %allStuff %allMsg %statsChan %allStuff %getOverall %statsNum %statsCmb %statsCmbS | sockclose AllStats
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:*:#:{ if ($chan !isin %notlist) {
    if ($rsstat($1)) {
      if ($len($2-) <= 12) {
        %sChan = $chan
        var %ticks $ticks
        set $+(%,prefix.,%ticks) $iif(@* iswm $1,msg $chan,notice $nick)
        sockopen $+(skill.,%ticks) hiscore.runescape.com 80
        set $+(%,erm.,%ticks) $iif(!$2,$iif($readini(defname.ini,name,$address($nick,3)),$v1,$nick),$regsubex($replace($2-,$chr(32),_),/\b(\w)/g,$upper(\1))))
        set $+(%,stat.,%ticks) $rsstat($1)
      }
      else { notice $nick The username can only be 12 letters long. }
    }
} }
on *:SOCKOPEN:skill.*:{
  sockwrite -nt $sockname GET /index_lite.ws?player= $+ %erm. [ $+ [ $remove($sockname,skill.) ] ] HTTP/1.1
  sockwrite -nt $sockname Host: hiscore.runescape.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:skill.*:{
  if ($sockerr) { echo -a $sockerr | halt }
  else {
    var %read | sockread %read
    if (Sorry, the page you were looking for was not found. isin %read) { $($+(%,prefix.,$remove($sockname,skill.)),2) $col(%sChan) $+  $+ %erm. [ $+ [ $remove($sockname,skill.) ] ] was not found in the Runescape hiscores at all. }
    elseif (*,*,* iswm %read) { inc %stats.inc | writeini stats.ini $remove($sockname,skill.) %stats.inc %read }
  }
}
on *:SOCKCLOSE:skill.*:{
  if (%stats.inc) { $($+(%,prefix.,$remove($sockname,skill.)),2) $col(%sChan) $+ $gettok($($+(%,stat.,$remove($sockname,skill.)),2),1,32) level for $col2(%sChan) $+ $replace($($+(%,erm.,$remove($sockname,skill.)),2),_,$chr(32)) $col(%sChan) $+ $rsstat2($gettok($($+(%,stat.,$remove($sockname,skill.)),2),1,32),$remove($sockname,skill.),$sockname,$gettok($($+(%,stat.,$remove($sockname,skill.)),2),2,32)) }
  remini stats.ini $remove($sockname,skill.)
  ;unset $+(%,erm.,$remove($sockname,skill.)) | unset $+(%,prefix.,$remove($sockname,skill.)) | unset %stats.inc
  unset %sChan %stats.inc %stat.* %prefix.* %erm.*
}
alias rsstat {
  if     ($regex($1,/^[!@](Overall|Total)$/Si)) return Total 1
  elseif ($regex($1,/^[!@]Att(ack)?$/Si)) return Attack 2
  elseif ($regex($1,/^[!@]Def(en(s|c)e)?$/Si)) return Defence 3
  elseif ($regex($1,/^[!@]Str(ength)?$/Si)) return Strength 4
  elseif ($regex($1,/^[!@](HP|Hitpoints)$/Si)) return Hitpoints 5
  elseif ($regex($1,/^[!@]Rang(e|ing|ed)$/Si)) return Ranged 6
  elseif ($regex($1,/^[!@]Pray(er)?$/Si)) return Prayer 7
  elseif ($regex($1,/^[!@]Mag(e|ic)$/Si)) return Magic 8
  elseif ($regex($1,/^[!@]Cook(ing)?$/Si)) return Cooking 9
  elseif ($regex($1,/^[!@]W(ood)?c(ut(ting)?)?$/Si)) return Woodcutting 10
  elseif ($regex($1,/^[!@]Fletch(ing)?$/Si)) return Fletching 11
  elseif ($regex($1,/^[!@]Fish(ing)?$/Si)) return Fishing 12
  elseif ($regex($1,/^[!@]F(ire)?m(aking)?$/Si)) return Firemaking 13
  elseif ($regex($1,/^[!@]Craft(ing)?$/Si)) return Crafting 14
  elseif ($regex($1,/^[!@]Smith(ing)?$/Si)) return Smithing 15
  elseif ($regex($1,/^[!@]Min(e|ing)$/Si)) return Mining 16
  elseif ($regex($1,/^[!@]Herb(lore|law)?$/Si)) return Herblore 17
  elseif ($regex($1,/^[!@]Agil(ity)?$/Si)) return Agility 18
  elseif ($regex($1,/^[!@](Thief|Thiev(e|ing))$/Si)) return Thieving 19
  elseif ($regex($1,/^[!@]Slay(er|ing)?$/Si)) return Slayer 20
  elseif ($regex($1,/^[!@]Farm(er|ing)?$/Si)) return Farming 21
  elseif ($regex($1,/^[!@]R(une)?c(raft(ing)?)?$/Si)) return Runecrafting 22
  elseif ($regex($1,/^[!@]Hunt(er|ing)?$/Si)) return Hunter 23
  elseif ($regex($1,/^[!@]Con(struct(ion)?)?$/Si)) return Construction 24
  elseif ($regex($1,/^[!@]Summon(ing)?$/Si)) return Summoning 25
}
alias rsstat2 {
  if (*-1* iswm $gettok($readini(stats.ini,$2,$4),2,44)) { return - no results were found. }
  else { return $iif($gettok($($+(%,stat.,$remove($3,skill.)),2),1,32) == Level,$v1,-) $col2(%sChan) $+  $+ $gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),2,44) $col(%sChan) $+  $+ $chr(124) Rank: $bytes($gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),1,44),db)  $+ $chr(124) EXP: $bytes($gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),3,44),db) $iif($gettok($($+(%,stat.,$remove($3,skill.)),2),1,32) == Total,$null,  $+ $chr(124) EXP to Level $calc($gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),2,44) +1) $+ : $iif(*-* iswm $bytes($calc($etnl($gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),2,44)) - $gettok($readini(stats.ini,$2,$gettok($($+(%,stat.,$remove($3,skill.)),2),2,32)),3,44)),db),N/A,$v2)) }
}
alias etnl { return $gettok(0 83 174 276 388 512 650 801 969 1154 1358 1584 1833 2107 2411 2746 3115 3523 3973 4470 5018 5624 6291 7028 7842 8740 9730 10824 12031 13363 14833 16456 18247 20224 22406 24815 27473 30408 33648 37224 41171 45529 50339 55649 61512 67983 75127 83014 91721 101333 111945 123660 136594 150872 166636 184040 203254 224466 247886 273742 302288 333804 368599 407015 449428 496254 547953 605032 668051 737627 814445 899257 992895 1096278 1210421 1336443 1475581 1629200 1798808 1986068 2192818 2421087 2673114 2951373 3258594 3597792 3972294 4385776 4842295 5346332 5902831 6517253 7195629 7944614 8771558 9684577 10692629 11805606 13034431,$calc($1 +1),32) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
