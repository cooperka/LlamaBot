;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias nohtml {
  var %x, %i = $regsub($1-,/(^[^<]*>|<[^>]*>|<[^>]*$)/g,$null,%x)
  return $replace(%x,&quot;,",&nbsp;,$chr(32),&amp;,&,&lt;,<,&gt;,>,&copy;,$chr(169),&reg;,$chr(174),&deg;,$chr(176),&#183;,,&#39;,',&raquo;,»,&laquo;,«)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias sockNum { inc %DontUseVarSockNum | return %DontUseVarSockNum }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias echosite {
  if ($sock(Echo)) { echo -a Please try again in a few seconds. | halt }
  if ($1) {
    if ($1 == urban) {
      %Echo.1 = www.urbandictionary.com
      %Echo.2 = /define.php?term= $+ $replace($2-,$chr(32),+)
    }
    else if ($1 == google) {
      %Echo.1 = www.google.com
      %Echo.2 = /search?hl=en&q= $+ $replace($2-,$chr(32),+)
    }
    else if ($1 == stirk) {
      %Echo.1 = parsers.stirk.org
      %Echo.2 = /dictionary.php?word= $+ $replace($2-,$chr(32),+)
    }
    else if ($1 == define) {
      %Echo.1 = www.merriam-webster.com
      %Echo.2 = /dictionary/ $+ $replace($2-,$chr(32),+)
    }
    else {
      %Echo.1 = $left($remove($1-,http://),$calc($pos($remove($1-,http://),/,1) - 1))
      %Echo.2 = $mid($remove($1-,http://),$pos($remove($1-,http://),/,1),$len($1-))
    }
    sockopen Echo %Echo.1 80
    window @Echo
  }
  else { echo -a Must provide site... }
}
on *:SOCKOPEN:Echo:{
  sockwrite -nt $sockname GET %Echo.2 HTTP/1.1
  sockwrite -nt $sockname Host: %Echo.1
  sockwrite -nt $sockname User-Agent: mIRC
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Echo: {
  if ($sockerr) { halt }
  else {
    .timerEchoclose 1 5 Echoclose
    var %sockreader | sockread %sockreader
    if ($nohtml(%sockreader)) { echo @Echo SOCK:2 $v1 }
    if ($regex($nohtml(%sockreader),/&(.+);/i)) { if (($regml(1) !isin %htmlFix) && ($len($regml(1)) < 10)) { %htmlFix = %htmlFix & $+ $regml(1) $+ ; } }
  }
}
alias Echoclose { sockclose Echo | unset %Echo.* }


alias echohtml {
  if ($sock(Echo2)) { echo -a Please try again in a few seconds. | halt }
  if ($1) {
    %Echo2.1 = $left($remove($1-,http://),$calc($pos($remove($1-,http://),/,1) - 1))
    %Echo2.2 = $mid($remove($1-,http://),$pos($remove($1-,http://),/,1),$len($1-))
    sockopen Echo2 %Echo2.1 80
    window @Echo2
  }
  else { echo -a Must provide site... }
}
on *:SOCKOPEN:Echo2:{
  sockwrite -nt $sockname GET %Echo2.2 HTTP/1.1
  sockwrite -nt $sockname Host: %Echo2.1
  sockwrite -nt $sockname User-Agent: mIRC
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Echo2: {
  if ($sockerr) { halt }
  else {
    .timerEcho2close 1 1 Echo2close
    var %sockreader | sockread %sockreader | if (%sockreader) { echo @Echo2 SOCK:2 $v1 }
  }
}
alias Echo2close { sockclose Echo2 | unset %Echo2.* }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias sendText { }
; echo 7 -s Sent message: $1- | %textMsg = $1- | sockopen sendText $+ $sockNum www.ohdontforget.com 80 }
on *:SOCKOPEN:sendText*:{
  var %data reminder%5Bphone%5D=3136000982&reminder%5Braw_time%5D=now&reminder%5Bmsg%5D= $+ %textMsg $+ &reminder%5Bzone_offset%5D=4
  sockwrite -nt $sockname POST /create HTTP/1.1
  sockwrite -nt $sockname Host: www.ohdontforget.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname Content-Type: application/x-www-form-urlencoded
  sockwrite -nt $sockname Content-Length: $len(%data)
  sockwrite -nt $sockname $crlf $+ %data
  unset %textMsg
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Get users, weather, other sockets?, etc.

alias getText { sockopen getText $+ $sockNum www.myspace.com 80 }
on *:SOCKOPEN:getText*:{
  sockwrite -nt $sockname GET /530874371 HTTP/1.1
  sockwrite -nt $sockname Host: www.myspace.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:getText*:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    .timerCloseGetText 1 1 sockclose getText
    if ($regex(%sockreader,/<span class="status">(.+)<\/span><span class="date">/i)) {
      write -c ClipText\GetText1.txt $regml(1)
      if ($read(ClipText\GetText1.txt) != $read(ClipText\GetText2.txt)) {
        if (sendText !isin $regml(1)) { sendText Doing: $regml(1) }
        scon -at0 $regml(1) | write -c ClipText\GetText2.txt $regml(1)
        .timerCheckMySpace 0 20 getText
        .timerSlowDownText 1 180 slowDownText
      }
    }
  }
}

alias slowDownText { .timerCheckMySpace 0 60 getText }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](halo|h)3(stat|s)?/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(Halo3)) { notice $nick Please try again in a few seconds. | halt }
    set %Halo3msg $iif($left($1,1) == @, msg $chan, notice $nick) $col
    if ($2) { %Halo3chan = $chan | %Halo3player = $replace($2-,$chr(32),+) | sockopen Halo3 www.bungie.net 80 }
    else { notice $nick Please include a username. }
} }
on *:SOCKOPEN:Halo3:{
  sockwrite -nt $sockname GET /stats/Halo3/CareerStats.aspx?player= $+ %Halo3player HTTP/1.1
  sockwrite -nt $sockname Host: www.bungie.net
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Halo3:{
  if ($sockerr) { halt }
  else {
    .timerHalo3close 1 1 Halo3close
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<li><h3>(.+) - <span id=/i)) { %Halo3player = $regml(1) }
    if ($regex(%sockreader,/Ranked K\/D Ratio:<\/p><\/th><th class="statTableRight"><p class="textWrap">(.+)<\/p>/i)) { %Halo3ranked = $regml(1) }
    if ($regex(%sockreader,/Social K\/D Ratio:<\/p><\/th><th class="statTableRight"><p class="textWrap">(.+)<\/p>/i)) { %Halo3social = $regml(1) }
    if ($regex(%sockreader,/Total Games:</div><div class="rightStuff">(.+)<\/div><\/div>/i)) { %Halo3total = $regml(1) }
    if ($regex(%sockreader,/Total EXP:</div><div class="rightStuff">(.+)<\/div><\/div>/i)) { %Halo3exp = $regml(1) }
    if ($regex(%sockreader,/Highest Skill:</div><div class="rightStuff">(.+)<\/div><\/div>/i)) { %Halo3skill = $regml(1) }
    if ($regex(%sockreader,/>Tool of Destruction</i)) { .timerHalo3close off | Halo3close }
  }
}
alias Halo3close { %Halo3msg $+ Halo 3 stats for $col2(%Halo3chan) $+ %Halo3player $+ $col(%Halo3chan) - Ranked K/D: %Halo3ranked  $+ $chr(124) Social K/D: %Halo3social  $+ $chr(124) Total games: %Halo3total  $+ $chr(124) Total EXP: %Halo3exp  $+ $chr(124) Highest skill: %Halo3skill | sockclose Halo3 | unset %Halo3* }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;on *:TEXT:!chem*:#LlamaBot:{
;  if ($sock(Chem)) { notice $nick Please try again in a few seconds. | halt }
;  if $regex($nick,/(stuie|doubt|coop)/i) { chem $nick }
;}
alias Chem {
  %ChemMsg = $iif($1,notice $1,echo -a)
  sockopen Chem gpschools.schoolwires.net 80
}
on *:SOCKOPEN:Chem:{
  ;%ChemWeek = $int($calc(14 + (( $ctime - 1228712400)/86400)/7))
  %ChemWeek = $chr(32)
  sockwrite -nt $sockname GET /176820103016123480/blank/browse.asp?a=383&BMDRN=2000&BCOB=0&c=59396 $+ %ChemWeek HTTP/1.1
  sockwrite -nt $sockname Host: gpschools.schoolwires.net
  sockwrite -nt $sockname $crlf
  %ChemDay = 0
}
on *:SOCKREAD:Chem: {
  if ($sockerr) { halt }
  else {
    .timerChem 1 1 ChemClose
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/(<title>)/i)) { }
    else if ($regex(%sockreader,/0">(Monday|Tuesday|Wednesday|Thursday|Friday)/i)) { if (%ChemDay) { %ChemMsg %ChemDay } | %ChemDay = 5,15 $+  $+ $nohtml(%sockreader) $+ : }
    else if ($regex(%sockreader,/0">Webassign/i)) { %ChemMsg %ChemDay | %ChemDay = 0 }
    else if (%ChemDay) {
      if ($right(%ChemDay,1) == $chr(124)) { %ChemDay = %ChemDay $nohtml(%sockreader) }
      else { %ChemDay = %ChemDay $chr(124) $nohtml(%sockreader) }
    }
  }
}
alias ChemClose { sockclose Chem | unset %ChemDay %ChemMsg %ChemWeek }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias wikiCheck { sockopen -e wChk1 wiki.toolserver.org 443 }
on *:SOCKOPEN:wChk1:{
  var %data POSTDATA=wpName=YOURUSERNAMEHERE&wpPassword=YOURPASSWORDHERE&wpLoginattempt=Log+in
  sockwrite -nt $sockname POST /w/index.php?title=Special:UserLogin&returnto=Stable_server HTTP/1.1
  sockwrite -nt $sockname Host: wiki.toolserver.org
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname Content-Type: application/x-www-form-urlencoded
  sockwrite -nt $sockname Content-Length: $len(%data)
  sockwrite -nt $sockname $crlf $+ %data
}
on *:SOCKREAD:wChk1:{ sockclose $sockname | sockopen wChk2 stable.toolserver.org 80 }
on *:SOCKOPEN:wChk2:{
  sockwrite -nt $sockname GET /acc/acc.php HTTP/1.1
  sockwrite -nt $sockname Host: stable.toolserver.org
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:wChk2:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<h2>Open requests<\/h2>/i)) {
      if (<\/h2><i>No requests at this time<\/i> iswm %sockreader) { echo -a No requests. }
      else { echo -a Requests!!! }
      sockclose $sockname
    }
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](motivate|mqod|mqotd)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(Motivation)) { notice $nick Please try again in a few seconds. | halt }
    set %Motivation $iif($left($1,1) == @, msg $chan, notice $nick) $col
    sockopen Motivation motivateus.com 80
} }
on *:SOCKOPEN:Motivation: {
  sockwrite -nt $sockname GET /thoughts-of-the-day.htm HTTP/1.1
  sockwrite -nt $sockname Host: motivateus.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Motivation: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,(.+)&quot;<br>)) {
      %Motivation $+ Today's motivational quote is: $regml(1) $+ 
      unset %Motivation | sockclose $sockname
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](word$|wrd$|wotd|wod)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(WORd)) { notice $nick Please try again in a few seconds. | halt }
    set %WORd $iif($left($1,1) == @, msg $chan, notice $nick) $col
    sockopen WORd wordsmith.org 80
} }
on *:SOCKOPEN:WORd: {
  sockwrite -nt $sockname GET /words/today.html HTTP/1.1
  sockwrite -nt $sockname Host: wordsmith.org
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:WORd: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,A.Word.A.Day --(.+)<\/TITLE>)) {
      %WORd $+ Today's word of the day is: $regml(1) $+ 
      unset %WORd | sockclose $sockname
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
on $*:TEXT:/^[!@](fa|wikifa|wfa|wfa|featured)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(WPTfa)) { notice $nick Please try again in a few seconds. | halt }
    set %WPTfa $iif($left($1,1) == @, msg $chan, notice $nick) $col
    sockopen WPTfa en.wikipedia.org 80
} }
on *:SOCKOPEN:WPTfa:{
  sockwrite -nt $sockname GET /wiki/User:Arbitrarily0/Sandbox HTTP/1.1
  sockwrite -nt $sockname Host: en.wikipedia.org
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:WPTfa:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/ $+ $chr(40) $+ 1940\-19(.+)3 $+ $chr(41) $+ /i)) {
      ;%WPTfa $+ Today's featured article is: $replace($regml(1),_,$chr(32)) $+ 
      echo -a Frank: $regml(1)
      unset %WPTfa | sockclose $sockname
    }
  }
}
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](qtd|qod|qotd)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(QOTday)) { notice $nick Please try again in a few seconds. | halt }
    set %QOTday $iif($left($1,1) == @, msg $chan, notice $nick) $col
    sockopen QOTday  www.coolquotes.com 80
} }
on *:SOCKOPEN:QOTday: {
  sockwrite -nt $sockname GET / HTTP/1.1
  sockwrite -nt $sockname Host: www.coolquotes.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:QOTday: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<td width="96%" valign="top" class="tohoma12">(.+)/i)) {
      %QOTday $+ Today's quote of the day is: $regml(1) $+ 
      unset %QOTday | sockclose $sockname
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](hex)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if (($sock(Hex)) || ($sock(Hex2))) { notice $nick Please try again in a few seconds. | halt }
      if ($left($2,1) == $chr(35)) {
        %hexNum = $2 | %hexNick = $nick | set %hexMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
        sockopen Hex2 en.wikipedia.org 80
      }
      else {
        if (($2 == green) && (!$3)) { %hexCol = Green (HTML/CSS green) } | else { %hexCol = $2- }
        %hexCol = $replacex(%hexCol,$chr(40),\ $+ $chr(40),$chr(41),\ $+ $chr(41),$chr(47),\ $+ $chr(47))
        %hexNick = $nick | %hexNext = 0 | set %hexMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
        sockopen Hex en.wikipedia.org 80
      }
    }
    else { notice $nick Please include the color you want to convert. }
} }
on *:SOCKOPEN:Hex: {
  sockwrite -nt $sockname GET /wiki/List_of_colors HTTP/1.1
  sockwrite -nt $sockname Host: en.wikipedia.org
  sockwrite -nt $sockname User-Agent: Firefox
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Hex:{
  if ($sockerr) { echo -a SOCKERR | halt }
  else {
    .timerHex 1 1 /hexOff
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/title="(.+)"> $+ %hexCol $+ <\/a>/i)) { %hexNext = 1 }
    if (($regex(%sockreader,/"font-family:monospace;">(.+)<\/td>/i)) && (%hexNext == 1)) {
      %hexMsg $+ Hex for $replace(%hexCol,\ $+ $chr(40),$chr(40),\ $+ $chr(41),$chr(41),\ $+ $chr(47),$chr(47)) $+ : $regml(1) $+ .
      unset %hexNick %hexMsg %hexCol %hexNext | .timerHex off | sockclose $sockname | halt
    }
  }
}
alias hexOff { notice %hexNick That color was not found in my list. | sockclose Hex | unset %hexNick %hexMsg %hexCol %hexNext }

on *:SOCKOPEN:Hex2: {
  sockwrite -nt $sockname GET /wiki/List_of_colors HTTP/1.1
  sockwrite -nt $sockname Host: en.wikipedia.org
  sockwrite -nt $sockname User-Agent: Firefox
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Hex2:{
  if ($sockerr) { echo -a SOCKERR | halt }
  else {
    .timerHex 1 1 /hexOff2
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/title="(.+)">(.+)<\/a>/i)) { %hexNum2 = $regml(2) }
    if ($regex(%sockreader,/"font-family:monospace;"> $+ %hexNum $+ <\/td>/i)) {
      %hexMsg $+ Color for %hexNum $+ : %hexNum2 $+ .
      unset %hexNick %hexMsg %hexNum %hexNum2 | .timerHex off | sockclose $sockname | halt
    }
  }
}
alias hexOff2 { notice %hexNick That hex was not found in my list. | sockclose Hex2 | unset %hexNick %hexMsg %hexNum %hexNum2 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias Bytes {
  if ($1) { %L.Bytes = $1- }
  else { %L.Bytes = LlamaBot }
  sockopen WB en.wikipedia.org 80
}
on *:SOCKOPEN:WB: {
  sockwrite -nt $sockname GET /w/index.php?title= $+ %L.Bytes $+ &action=history HTTP/1.1
  sockwrite -nt $sockname Host: en.wikipedia.org
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:WB: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/(.*) bytes/i)) { echo 5 -a Current %L.Bytes bytes:4 $right($regml(1),6) | sockclose WB | unset %L.Bytes | halt }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](Weather)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if ($sock(Weather)) { notice $nick Please try again in a few seconds. | halt }
      %City = $2- | %Wchan = $chan | %Wcity = 1 | %Wtemp = 1
      set %Wmsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      sockopen Weather www.wunderground.com 80
    }
    else { notice $nick You need to specify a zip code or a "city, state". }
} }
on *:SOCKOPEN:Weather:{
  sockwrite -nt $sockname GET /cgi-bin/findweather/getForecast?query= $+ $replacex(%City,$chr(32),+,$chr(44),$chr(37) $+ 2C) HTTP/1.1
  sockwrite -nt $sockname Host: www.wunderground.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Weather:{
  if ($sockerr) { echo SOCKERR | halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/There has been an error/i)) { %Wmsg $+ There was an error with your search; please try again with different input. | .timer 1 1 WRes | halt }
    if (($regex(%sockreader,/<h1>(.+)<\/h1>/i)) && (%Wcity == 1)) { if ($right($regml(1),1) != $chr(32)) { %Wmsg $+ That input is too general.  Try narrowing your search (use a zip code, etc.) | .timer 1 1 WRes | halt } | else { %Wmsg $+ Weather for $col2(%Wchan) $+ $left($regml(1),$calc($len($regml(1)) - 1)) $+ $col(%Wchan) $+ : | %Wcity = 0 | .timer 1 1 WRes  } }
    if (($regex(%sockreader,/pwsunit="english" pwsvariable="tempf" english="&deg;F" metric="&deg;C" value="(.+)">/i)) && (%Wtemp == 1)) { %Wmsg $+ Temperature: $col2(%Wchan) $+ $regml(1) $chr(176) $+ F $col(%Wchan) $+ ( $+ $round($calc(5 / 9 * ($regml(1) - 32)),1) $chr(176) $+ C)  | %Wtemp = 0 | .timer 1 1 WRes }
    if ($regex(%sockreader,/<div class="b" style="font-size: 14px;">(.+)<\/div>/i)) { %Wmsg $+ Condition: $col2(%Wchan) $+ $regml(1) | .timer 1 1 WRes }
  }
}
alias WRes { unset %Wmsg %City %Wcity %Wtemp %Wchan | sockclose Weather }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias Rating { sockopen USC main.uschess.org 80 }
on *:SOCKOPEN:USC: {
  sockwrite -nt $sockname GET /assets/msa_joomla/MbrDtlMain.php?13914595 HTTP/1.1
  sockwrite -nt $sockname Host: main.uschess.org
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:USC:{
  if ($sockerr) { echo -a SOCKERR | halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/(.+) \(Based on (.+) games\)&nbsp/i)) {
      echo -a Matt's rating: $regml(1) - Based on $regml(2) games.
      sockclose $sockname
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;on $*:TEXT:/^!(calc|calculator|calculate)/Si:#:{ if ($chan !isin %notlist) { notice $nick $2- = $bytes($calc($2-),db) } }
;on $*:TEXT:/^@(calc|calculator|calculate)/Si:#:{ if ($chan !isin %notlist) { msg $chan $col $+ $2- = $bytes($calc($2-),db) } }

on $*:TEXT:/^[!@](calc|gcalc|calculator|calculate)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(Calc)) { notice $nick Please try again in a few seconds. | halt }
    set %calcMSG $iif($left($1,1) == @, msg $chan, notice $nick) $col
    %equation = $replacex($2-,+,$chr(37) $+ 2B,$chr(32),+,x,*)
    sockopen Calc www.google.com 80
} }
on *:SOCKOPEN:Calc:{
  sockwrite -nt $sockname GET /search?hl=en&q= $+ %equation HTTP/1.1
  sockwrite -nt $sockname Host: www.google.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10 (.NET CLR 3.5.30729)
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Calc:{
  if ($sockerr) { echo -a SOCKERR | halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<h2 class=r style="font-size:138%"><b>(.+) = (.+)<\/b><\/h2><tr><td>/i)) {
      %calcMSG $+ $replace($regml(1),<font size=-2> </font>,$chr(44)) = $replace($regml(2),<font size=-2> </font>,$chr(44),&#215;,X,<sup>,^,</sup>,) $+ 
      unset %calcMSG %equation | sockclose Calc
    }
    if ($regex(%sockreader,/<\/html>/i)) {
      %calcMSG $+ That equation appears to be invalid using Google.  Trying again:
      %calcMSG $+ $replacex(%equation,$chr(37) $+ 2B,+,+,$chr(32)) = $calc($replacex(%equation,$chr(37) $+ 2B,+,+,$chr(32))) $+ 
      unset %calcMSG %equation | sockclose Calc
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](mu|forsaken)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(FMU)) { notice $nick Please try again in a few seconds. | halt }
    set %FMU.msg $iif($left($1,1) == @, msg $chan, notice $nick) $col
    if ($2) { %FMU.name = $2- | sockopen FMU www.forsaken-mu.com 80 }
    else { notice $nick You need to specify a username. }
} }
alias MU {
  if ($sock(FMU)) { echo -s Try again in a few seconds! | halt }
  else { if ($1) { %FMU.name = $1- } | else { %FMU.name = z3z1ma } | set %FMU.msg echo -a $col | sockopen FMU www.forsaken-mu.com 80 }
}
on *:SOCKOPEN:FMU:{
  sockwrite -nt $sockname GET /CharInfo.aspx?c= $+ %FMU.name HTTP/1.1
  sockwrite -nt $sockname Host: www.forsaken-mu.com
  sockwrite -nt $sockname User-Agent: Mozilla
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:FMU:{
  if ($sockerr) { echo SOCKERR | halt }
  else {
    .timerUnsetFMU 1 1 sockclose FMU
    var %sockreader | sockread %sockreader | echo 2 -s %sockreader
    if ($regex(%sockreader,/<character name="(.+)" resets/i)) { %FMU.msg = %FMU.msg $+ MU Stats for $regml(1) - }
    if ($regex(%sockreader,/<resets="(.+)" level/i)) { %FMU.msg = %FMU.msg Resets: $regml(1) $+  }
    if ($regex(%sockreader,/<paidstats="(.+)">/i)) { %FMU.msg = %FMU.msg Paid stats: $regml(1) ( $+ $calc($floor($calc($regml(1) / 35)) / 10) rr) }
    if ($regex(%sockreader,/<level="(.+)" class/i)) { %FMU.msg = %FMU.msg Level: $regml(1) $+  }
    if ($regex(%sockreader,/<pks="(.+)" paidstats/i)) { %FMU.msg = %FMU.msg PKs: $regml(1) $+  }
    if ($regex(%sockreader,/<class="(.+)" classstage/i)) { %FMU.msg = %FMU.msg Class: $regml(1) $+  }
    if ($regex(%sockreader,/<ranking score="(.+)" full/i)) { %FMU.msg = %FMU.msg Ranking: $regml(1) $+  }
    ;if ($regex(%sockreader,/<online server="Forsaken-(.+)">/i)) { %MUtotal = %MUtotal Online, server $regml(1) * }
    if ($regex(%sockreader,/<\/account>/i)) { %FMUmsg | unset %FMU.* | sockclose FMU }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:*youtube.com/watch?v=*:#,?:{ if ($chan !isin %notlist) {
    if ($sock(Youtube)) { halt }
    if ($regex($1-,/youtube\.com\/watch\?v=(.+)&/i)) { %Youtube = $regml(1) }
    else if ($regex($1-,/youtube\.com\/watch\?v=(.+)/i)) { %Youtube = $regml(1) }
    if ($chan) { %youtChan = $chan } | else { %youtChan = $nick }
    sockopen Youtube www.youtube.com 80
} }
on *:SOCKOPEN:Youtube:{
  sockwrite -nt $sockname GET /watch?v= $+ %Youtube HTTP/1.1
  sockwrite -nt $sockname Host: www.youtube.com
  sockwrite -nt $sockname User-Agent: Mozilla Firefox
  sockwrite -nt $sockname $crlf
  %youVar = 1
  %colorzzz = 1
}
on *:SOCKREAD:Youtube:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<meta name=\"title\" content=\"(.+)\">/i)) { %youtTitle = Title: $replace($regml(1),&quot;,") }
    if ($regex(%sockreader,/class=\"watch-view-count\">(.+)<\/strong><br>views<\/span>/i)) { %youtViews = Views: $regml(1) }
    if ($regex(%sockreader,/length_seconds/i)) { ;echo %colorzzz -s %sockreader | inc %colorzzz | %youtLength = Length: $floor($calc($regml(2) / 60)) $+ : $+ $iif($len($calc($regml(2) % 60)) == 1,0 $+ $calc($regml(2) % 60),$calc($regml(2) % 60)) }
    ;if ($regex(%sockreader,/\"master-sprite old-watch ratingL ratingL-(.+)\" title=\"(.+)\"><\/button><\/div><div id=\"ratingMessage\" ><div id=\"defaultRatingMessage\"><span class=\"smallText\">(.+) ratings<\/span>/i)) { %youtRating = Rating: $regml(1) $+ /5 } ;( $+ $regml(3) ratings)
    if ($regex(%sockreader,/<\/html>/i)) { sockclose Youtube | youtMSG }
  }
}
alias youtMSG { msg %youtChan $col(%youtChan) $+ Info for http://www.youtube.com/watch?v= $+ %Youtube | msg %youtChan $col(%youtChan) $+ %youtTitle $+ $iif(%youtViews,$chr(32) $chr(124) $v1,$null) $+ $iif(%youtLength,$chr(32) $chr(124) $v1,$null) $+ $iif(%youtRating,$chr(32) $chr(124) $v1,$null) | unset %Youtube %yout* }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](players|online)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(RSplay)) { notice $nick Please try again in a few seconds. | halt }
    set %rsMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
    sockopen RSplay  www.runescape.com 80
} }
on *:SOCKOPEN:RSplay: {
  sockwrite -nt $sockname GET / HTTP/1.1
  sockwrite -nt $sockname Host: www.runescape.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:RSplay: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/>There are currently (.+) people playing!</i)) {
      %rsMsg $+ There are currently $bytes($regml(1),b) people playing RuneScape.
      unset %rsMsg | sockclose $sockname
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](price|rsprice|cost|rscost|ge)/Si:#: { if ($chan !isin %notlist) {
    if (*!*@Swift-47199DEC.hsd1.mi.comcast.net iswm $address($nick,2)) { notice $nick Your IP is banned from this command. }
    else {
      if (($sock(Price)) || ($sock(Price.*))) { notice $nick Please try again in a few seconds. | halt }
      set %priceMsg $iif($left($1,1) == @, msg $chan , notice $nick) $col
      if ($2 isnum) {
        if (!$3) { notice $nick Please specify an item to look up. }
        else {
          if ($2 > 9) { notice $nick Invalid number of items (1-9). }
          else if ($2 < 1) { notice $nick Invalid number of items (1-9). }
          else { if ($2 > 3) { set %priceMsg notice $nick $col } | %nNum = $2 | %Item = $replace($3-,$chr(32),+) }
        }
      }
      else if (!$2) { notice $nick Please specify an item to look up. }
      else { %nNum = 1 | %Item = $replace($2-,$chr(32),+) }
      %priceChan = $chan | %pL = 1 | %totSaid = 0
      sockopen Price itemdb-rs.runescape.com 80
    }
} }
on *:SOCKOPEN:Price:{
  inc %spam. [ $+ [ %priceChan ] ] $floor($calc(%nNum / 1.5))
  sockwrite -nt $sockname GET /results.ws?query= $+ %Item $+ &price=all&members= HTTP/1.1
  sockwrite -nt $sockname Host: itemdb-rs.runescape.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Price:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/0 items matched the search term: '<i>/i)) { %priceMsg $+ " $+ $replace(%Item,+,$chr(32)) $+ " was not found by the Grand Exchange database. | sockclose Price | halt }
    if ($regex(%sockreader,/(.+) items matched the search term: '<i>/i)) {
      if ($regml(1) < %nNum) { %nNum = $regml(1) }
      %priceMsg $+ Showing %nNum of $regml(1) matches for " $+ $replace(%Item,+,$chr(32)) $+ ":
    }
    if (%pL <= %nNum) {
      if ($regex(%sockreader,/id=(.+)" alt="(.+)"><\/td>/i)) {
        %Item. [ $+ [ %pL ] ] = $regml(2) | %iCode. [ $+ [ %pL ] ] = $regml(1)
        sockopen Price. [ $+ [ %pL ] ] itemdb-rs.runescape.com 80
        inc %pL
      }
      if ($regex(%sockreader,/<\/html>/i)) { sockclose Price | halt }
    }
    else { sockclose Price | halt }
  }
}
on *:SOCKOPEN:Price.*:{
  sockwrite -nt $sockname GET /viewitem.ws?obj= $+ %iCode. [ $+ [ $right($sockname,1) ] ] HTTP/1.1
  sockwrite -nt $sockname Host: itemdb-rs.runescape.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Price.*:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<b>Minimum price:</b> (.+)/i)) { %iMin. [ $+ [ $right($sockname,1) ] ] = $replace($regml(1),m $+ $chr(32),m,k $+ $chr(32),k) }
    if ($regex(%sockreader,/<b>Market price:</b> (.+)/i)) { %iMed. [ $+ [ $right($sockname,1) ] ] = $replace($regml(1),m $+ $chr(32),m,k $+ $chr(32),k) }
    if ($regex(%sockreader,/<b>Maximum price:</b> (.+)/i)) { %iMax. [ $+ [ $right($sockname,1) ] ] = $replace($regml(1),m $+ $chr(32),m,k $+ $chr(32),k) }
    if ($regex(%sockreader,/<b>7 Days:<\/b> <span class="(.+)">(.+)<\/span>/i)) {
      %iGain. [ $+ [ $right($sockname,1) ] ] = $regml(2)
      %priceMsg $+  $+ %Item. [ $+ [ $right($sockname,1) ] ] $+  - Min: %iMin. [ $+ [ $right($sockname,1) ] ] $+  $col2(%priceChan) Market: %iMed. [ $+ [ $right($sockname,1) ] ] $+  $col(%priceChan) Max: %iMax. [ $+ [ $right($sockname,1) ] ] (7 day gain: %iGain. [ $+ [ $right($sockname,1) ] ] $+ )
      unset %Item. [ $+ [ $right($sockname,1) ] ] %iCode. [ $+ [ $right($sockname,1) ] ] %iMin. [ $+ [ $right($sockname,1) ] ] %iMed. [ $+ [ $right($sockname,1) ] ] %iMax. [ $+ [ $right($sockname,1) ] ] %iGain. [ $+ [ $right($sockname,1) ] ]
      inc %totSaid
      if (%totSaid >= %nNum) { unset %priceMsg %nNum %pL %Item %priceChan %totSaid }
      sockclose $sockname | halt
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
;POSTDATA=origusername=&username= $+ %RSuser $+ &password1=changeme&password2=changeme&day=1&month=0&year=1990&country=225&agree_privacy=on&agree_terms=on
;If it actually works, it will CREATE the account...

on $*:TEXT:/^[!@](checkname|checkusername|rsname|username)/Si:#:{ if ($chan !isin %notlist) {
    if ($len($2-) <= 12) {
      if ($sock(Name)) { notice $nick Please try again in a few seconds. | halt }
      set %RSuser $2- | set %nameMsg $iif($left($1,1) == @, msg $chan, notice $nick)  $+ %c1. [ $+ [ $chan ] ] $+ , $+ %c2. [ $+ [ $chan ] ]
      sockopen -e Name create.runescape.com 443
    }
    else { notice $nick RuneScape usernames may only contain 12 characters. }
} }
on *:SOCKOPEN:Name: {
  echo -a 2a
  sockwrite -nt $sockname GET / HTTP/1.1
  sockwrite -nt $sockname Host: create.runescape.com
  sockwrite -nt $sockname $crlf
  echo -a 2b
}
on *:SOCKREAD:Name: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader | echo -a Sock: %sockreader
    if ($regex(%sockreader,/that username is not available/i)) { echo -a Unavailable }
  }
}
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](stirk|dict2|definition2|define2|dictionary2|w(o)?rd2|def2)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 == LlamaBot) { $iif($left($1,1) == @, msg $chan, notice $nick) $col $+ LlamaBot: A really cool, useful IRC bot that everyone loves... hey, that's me! }
    else if ($2) {
      if ($sock(Dict2)) { notice $nick Please try again in a few seconds. | halt }
      set %word $replace($2-,$chr(32),+)
      set %dictMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      sockopen Dict2 parsers.stirk.org 80
    }
    else { notice $nick Please specify a word to look up. }
} }
on *:SOCKOPEN:Dict2: {
  sockwrite -nt $sockname GET /dictionary.php?word= $+ %word HTTP/1.1
  sockwrite -nt $sockname Host: parsers.stirk.org
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Dict2: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if (<br> isin %sockreader) {
      %dictMsg $+ $iif(($len($nohtml(%sockreader)) > 400),The definition for %word is too long; to see it $+ $chr(44) go to http://parsers.stirk.org/dictionary.php?word= $+ %word, $+ $replace(%word,+,$chr(32)) $+ : $nohtml(%sockreader))
      unset %dictMsg %word | sockclose Dict2
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](dict|definition|define|dictionary|w(o)?rd|def1)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 == LlamaBot) { $iif($left($1,1) == @, msg $chan, notice $nick) $col $+ LlamaBot: A really cool, useful IRC bot that everyone loves... hey, that's me! }
    else if ($2) {
      if ($sock(Dict1)) { notice $nick Please try again in a few seconds. | halt }
      %dWord = $2- | %Define = 0 | %dictChan = $chan
      set %dictMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      set %dictMsg2 $iif($left($1,1) == @, msg $chan, notice $nick) $col
      sockopen Dict1 www.merriam-webster.com 80
    }
    else { notice $nick Please specify a word to look up. }
} }
on *:SOCKOPEN:Dict1: {
  sockwrite -nt $sockname GET /dictionary/ $+ %dWord HTTP/1.1
  sockwrite -nt $sockname Host: www.merriam-webster.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Dict1: {
  if ($sockerr) { halt }
  else {
    .timerDictClose2 1 1 DictUnset2
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/isn't in the dictionary/i)) { %dictMsg $+  $+ %dWord does not appear to be a word in the dictionary. | halt }
    if ($regex(%sockreader,/can be found at Merriam-WebsterUnabridged/i)) { %dictMsg $+  $+ %dWord was not found in this dictionary (try !urban or !define2). | halt }
    if ($regex(%sockreader,/xmlns:mwref(.+)Main Entry: <strong>(.+)<\/strong>(.+)<p class=\"d\"> (.+)(<\/p>|<strong>4<\/strong>)/i)) {
      %dict1 = $regml(1) | %dict2 = $regml(2) | %dict3 = $regml(3) | %dict4 = $remove($regml(4),<strong>:</strong>)
      %dict4 = $replace($nohtml(%dict4),$chr(32) $+ :,:,1,$chr(32) $+ 1:,2,$chr(32) $+ 2:,3,$chr(32) $+ 3:)
      %dictMsg $+  $+ $col2(%dictChan) $+ $nohtml(%dict2) $+  $+ $col(%dictChan) - $iif($len(%dict4) > 350,$left(%dict4,350) $+ ...,%dict4)
    }
  }
}
alias DictUnset2 {
  unset %dictMsg %dictMsg2 %dWord %Define %dictChan %dict1 %dict2 %dict3 %dict4
  sockclose Dict1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](urban|ud)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 == LlamaBot) {
      $iif($left($1,1) == @, msg $chan, notice $nick) $col $+ LlamaBot: A really cool, useful IRC bot that everyone loves.
      $iif($left($1,1) == @, msg $chan, notice $nick) $col $+ Example: I invited LlamaBot to my channel yesterday.  It's the best!
    }
    else if ($2) {
      if ($sock(Dict3)) { notice $nick Please try again in a few seconds. | halt }
      %dWord = $replace($2-,$chr(32),+) | %Define = 0 | %Example = 0
      set %dictMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      sockopen Dict3 www.urbandictionary.com 80
    }
    else { notice $nick Please specify a word to look up. }
} }
on *:SOCKOPEN:Dict3: {
  sockwrite -nt $sockname GET /define.php?term= $+ %dWord HTTP/1.1
  sockwrite -nt $sockname Host: www.urbandictionary.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:Dict3: {
  if ($sockerr) { halt }
  else {
    .timerDictClose 1 1 DictUnset
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<div id='not_defined_yet'>/i)) { %dictMsg $+  $+ $replace(%dWord,+,$chr(32)) was not found in the urban dictionary. | DictUnset | halt }
    if ($regex(%sockreader,/<div class='definition'>/i)) {
      if (<br/> isin %sockreader) { %dText = $nohtml($replace($remove(%sockreader,$mid(%sockreader,$calc($pos(%sockreader,<br/>) - 1),1)),<br/>,$chr(32))) }
      else { %dText = $nohtml(%sockreader) }
      %dictMsg $+  $+ $replacex(%dWord,+,$chr(32)) $+ : $iif($len(%dText) > 350,$left(%dText,350) $+ ...,%dText)
    }
    if ($regex(%sockreader,/<div class='example'>/i)) {
      if (<br/> isin %sockreader) { %dText = $nohtml($replace($remove(%sockreader,$mid(%sockreader,$calc($pos(%sockreader,<br/>) - 1),1)),<br/>,$chr(32))) }
      else { %dText = $nohtml(%sockreader) }
      %dictMsg $+ Example: $iif($len(%dText) > 350,$left(%dText,350) $+ ...,%dText)
      DictUnset
    }
  }
}
alias DictUnset { unset %dictMsg %dWord %dText | sockclose Dict3 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](rsnews|news)/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(News)) { notice $nick Please try again in a few seconds. | halt }
    set %newsMsg $iif($left($1,1) = @, msg $chan, notice $nick) $col
    sockopen News runescape.com 80
} }
on *:SOCKOPEN:News:{
  sockwrite -nt $sockname GET / HTTP/1.1
  sockwrite -nt $sockname Host: runescape.com
  sockwrite -nt $sockname $crlf
  %nTitle = true
}
on *:SOCKREAD:News:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<h3>(.+)<\/h3>/i)) { if (%nTitle = true) { %nTitle = $regml(1) | %nDate = true } }
    if ($regex(%sockreader,/<span>(.+)<\/span>/i)) { if (%nDate = true) { %nDate = $regml(1) | %news = true } }
    if ($regex(%sockreader,/<p>(.+)<a/i)) {
      if (%news = true) {
        %news = $regml(1)
        %newsMsg $+ Featured RuneScape news: %nTitle ( $+ %nDate $+ ) - %news
        unset %newsMsg %nTitle %nDate %news
      }
    }
  }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](movie|imdb|rt|rottentomatoes|rating)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if (($sock(IMDB)) || ($sock(IMDB2))) { notice $nick Please try again in a few seconds. | halt }
      set %movieMsg $iif($left($1,1) = @, msg $chan, notice $nick) $col
      %movieName = $replace($2-,$chr(32),+)
      sockopen IMDB www.imdb.com 80
      sockopen RT www.rottentomatoes.com 80
    }
    else { notice $nick Please specify a movie to look up. }
} }
on *:SOCKOPEN:IMDB:{
  sockwrite -nt $sockname GET /find?s=tt&q= $+ %movieName HTTP/1.1
  sockwrite -nt $sockname Host: www.imdb.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:IMDB:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/Media from&nbsp;<a href=\"\/title\/tt(.+)\/\" onclick/i)) { %movieLink = tt $+ $regml(1) | sockopen IMDB2 www.imdb.com 80 | CloseMovies IMDB 0 }
    if ($regex(%sockreader,/<\/html>/i)) { %movieMsg $+ No movies were matched ( http://www.imdb.com/find?s=tt&q= $+ %movieName ) | CloseMovies IMDB 1 }
  }
}

on *:SOCKOPEN:IMDB2:{
  sockwrite -nt $sockname GET /title/ $+ %movieLink $+ / HTTP/1.1
  sockwrite -nt $sockname Host: www.imdb.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:IMDB2:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<title>(.+)<\/title>/i)) { %movieTitle = $regml(1) }
    if ($regex(%sockreader,/Rated (.+) for (.+)/i)) { %movieRating = $replace(%sockreader,Rated,Rated,for,for) }
    if ($regex(%sockreader,/([0-9]+) min/i)) { %movieTime = $iif(%movieTime,$v1,$regml(1)) }
    if ($regex(%sockreader,/<b>([0-9].[0-9])\/10<\/b>/i)) { %moviePop = $iif(%moviePop,$v1,$regml(1)) }
    if ($regex(%sockreader,/<\/html>/i)) { %movieMsg $+  $+ %movieTitle $+  - IMDB: %moviePop $+ /10 stars. $+ $iif(%movieRating,$chr(32) $v1,$null)  Approx %movieTime minutes. | CloseMovies IMDB 2 }
  }
}

on *:SOCKOPEN:RT:{
  sockwrite -nt $sockname GET /search/full_search.php?search= $+ %movieName HTTP/1.1
  sockwrite -nt $sockname Host: www.rottentomatoes.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:RT:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<a href="/m/(.+)/">(.+)</a>/i)) { %movieLink = $regml(1) | sockopen RT2 www.rottentomatoes.com 80 | CloseMovies RT 0 }
    if ($regex(%sockreader,/<\/html>/i)) { %movieMsg $+ No movies were matched ( http://www.rottentomatoes.com/search/full_search.php?search= $+ %movieName ) | CloseMovies RT 1 }
  }
}

on *:SOCKOPEN:RT2:{
  sockwrite -nt $sockname GET /m/ $+ %movieLink $+ / HTTP/1.1
  sockwrite -nt $sockname Host: www.rottentomatoes.com
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:RT2:{
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/\"v:name\">(.+)<\/span>(.+)<\/h1>/i)) { %movieTitle2 = $regml(1) $+ $regml(2) }
    if ($regex(%sockreader,/<span property=\"v:value\">(.+)<\/span><span property=\"v:ratingSystem\"/i)) { %movieRating2 = $regml(1) }
    if ($regex(%sockreader,/\"movie_rating_reason\" style=\"display: none\">(.+)<\/span>/i)) { %movieRating2 = Rated %movieRating2 $+  $+ $remove($regml(1),</span>) }
    if ($regex(%sockreader,/\"v:runtime\" content=\"(.+)\">(.+)<\/span><\/p><p><span class=\"label\">Genre/i)) { %movieTime2 = $regml(2) }
    if ($regex(%sockreader,/\"v:genre\">(.+)<\/span><\/a><\/span>/i)) { %movieGenre2 = $regml(1) }
    if ($regex(%sockreader,/<li class=\"ui-tabs-selected\"><a title=\"(.+)%\" href/i)) { %moviePop2 = $regml(1) }
    if ($regex(%sockreader,/<\/html>/i)) { %movieMsg $+  $+ %movieTitle2 $+  - Rotten Tomatoes: $iif(%moviePop2,$v1,N/A) $+ % fresh. $+ $iif(%movieRating2,$chr(32) $remove($v1,.) $+ .,$null)  Approx %movieTime2 $+ .  Genre: %movieGenre2 $+ . | CloseMovies RT 2 }
  }
}

alias CloseMovies {
  if ($1 == IMDB) {
    if ($2 == 0) { sockclose IMDB }
    if ($2 == 1) { sockclose IMDB | %movieDoneIMDB = 1 }
    if ($2 == 2) { sockclose IMDB2 | %movieDoneIMDB = 1 }
  }
  if ($1 == RT) {
    if ($2 == 0) { sockclose RT }
    if ($2 == 1) { sockclose RT | %movieDoneRT = 1 }
    if ($2 == 2) { sockclose RT2 | %movieDoneRT = 1 }
  }
  if ((%movieDoneIMDB) && (%movieDoneRT)) { unset %movie* }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
