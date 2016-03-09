/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

http://geotool.servehttp.com/ - Accurate IP locator
http://whatismyip.com/ - Gives your IP
http://hiscore.runescape.com/index_lite.ws?player=coopkev2 - Stats
http://forum.swiftirc.net/viewtopic.php?t=10974 - IPv6
http://forum.swiftirc.net/viewtopic.php?t=16637 - IPv6
http://lmgtfy.com/?q=google+search
http://www.howtocreate.co.uk/sidehtmlentity.html

FB invite all
javascript:elms=document.getElementById('friends').getElementsByTagName('li');for(var fid in elms){if(typeof elms[fid] === 'object'){fs.click(elms[fid]);}}

Max int value: 2,147,483,647

3.141592653589793238462643383279502884197169399375105820974944
 .         1         2         3         4         5         6
5923078164 0628620899 8628034825 3421170679 8214808651 3282306647 0938446095
5058223172 5359408128 4811174502 8410270193 8521105559 6446229489 5493038196

*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/paste /run http://pastebin.com
/wiki {
  if ($1) { /run http://en.wikipedia.org/wiki/ $+ $replace($1-,$chr(32),_) }
  else { /run http://en.wikipedia.org/wiki/LlamaBot }
}
/table { /run http://www.webelements.com }
/mass /run http://www.webqc.org/mmcalc.php
/atoms /run http://www.webqc.org/mmcalc.php
/dict {
  if ($1) { /run http://dictionary.reference.com/browse/ $+ $1 }
  else { /run http://dictionary.reference.com }
}
/define {
  if ($1) { /run http://dictionary.reference.com/browse/ $+ $1 }
  else { /run http://dictionary.reference.com }
}
/fb /run http://www.facebook.com
/sdw /run http://wiki.soldat.nl/Soldat.ini
/goog {
  if ($1 isnum) { echo -a Goog $timestamp $1 }
  else if ($1) { /run www.google.com/search?hl=en&q= $+ $1- }
  else { /run www.google.com }
}
/tpb /run http://thepiratebay.org/search/ $+ $1- $+ /0/7/100
/calculator /run C:\Windows\system32\calc.exe

/dir /run $mircdir
/log {
  if ($1) { run $mircdir $+ logs\ $+ $replace($1,$chr(124),_) $+ .SwiftIRC.log }
  else { run $mircdir $+ logs\#LlamaBot.SwiftIRC.log }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/dust /invite dustbot $chan
/pd /say !part DustBot
/rns /invite runescript $chan
/runescript /invite runescript $chan
/pr /say !part RuneScript
/vect /invite vectra $chan
/pv /say !part Vectra[ $+ $1 $+ ]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/con { /set %codeMSG 1 | echo 2 -a Your messages are now encrypted. }
/coff { /set %codeMSG 0 | echo 2 -a Your messages are no longer encrypted. }
/tipoff { %tip = 0 | echo 2 -s Tips are now OFF. }
/tipon { %tip = 1 | echo 2 -s Tips are now ON. }
/ron /remote on
/roff /remote off
/toff /timers off
/beepon { %beep = 1 | echo 2 -a Beep is now ON. | tipon }
/beepoff { %beep = 0 | echo 2 -a Beep is now OFF. }
/beepson { %beeps = 1 | echo 2 -a Repeated beep is now ON. | tipon }
/beepsoff { %beeps = 0 | echo 2 -a Repeated beep is now OFF. }
/joinon { %joinNotice = 1 | echo 2 -a Join Notice is now ON. }
/joinoff { %joinNotice = 0 | echo 2 -a Join Notice is now OFF. }

/set+f /mode $me +f
/setf /mode $me +f
/set-f /mode $me -f

/id { ns id $1 | cs id #LlamaBot $1 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/woot {
  if ($1) { /say 0,9@∏3,9`@¶9,3¶@∏1,3`@¶3,1¶9,1  w00t for $1-  3,1¶1,3¶@∏9,3`@¶3,9¶@∏0,9`@ }
  else { /say 0,9@∏3,9`@¶9,3¶@∏1,3`@¶3,1¶9,1  w00t for $me  3,1¶1,3¶@∏9,3`@¶3,9¶@∏0,9`@ }
}
/aaw /say 4,1 aaaaaw too bad... 
/gratz /say 3,8 CONGRATULATIONS! 
/cc /say C-C-C-ComboBreaker!
/alert { say 1,1**************************************** | say 1,1**************************************** }
/warn /say 1,8/!\ 0,1[ $+ $1- $+ ] 1,8/!\
/rad { msg $chan *pshhhh* $me to $$1 $+ , $$2- $+ , over... *pshhhh* }
/site /say $col $+ The LlamaBot website: http://www.llamabot.webs.com/
/site2 /say $col $+ The LlamaBot Wikipedia article: http://en.wikipedia.org/wiki/LlamaBot

/space /.timerClear -m 10 1 echo 13 -a $str(@,20)
;/clear /.timerClear -m 10 1 echo 13 -a $str(@,20)

/weird /echo -a ‡πèÕ°ÃØ‡πè ... „Åã„Åí„Å∂„Çì„Åó„Çì„ÅÆ„Åò„ÇÖ„Å§ ... ‚úê‚úè‚úé ... “≥Ã∏“≤Ã∏“≥ ... ‚ô† ‚ô£ ‚ô• ‚ô¶ ... ‚â§ ... …êq…îp«ù…ü∆É…•ƒ±…æ û É…Øuopq…πs án å çx éz ... ???
/face /say ‡πèÕ°ÃØ‡πè

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/calc { echo -a $1- = $bytes($calc($1-),db) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
