;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^!(wikiw|wikiurl|sox)/Si:#:{ if ($chan !isin %notlist) { if ($2) { var %wikiFind = $2- } | else { var %wikiFind = $nick } | notice $nick The Wikipedia stats for %wikiFind can be found at http://toolserver.org/~soxred93/count/index.php?name= $+ $replace(%wikiFind,$chr(32),+) $+ &lang=en&wiki=wikipedia } }
on $*:TEXT:/^@(wikiw|wikiurl|sox)/Si:#:{ if ($chan !isin %notlist) { if ($2) { var %wikiFind = $2- } | else { var %wikiFind = $nick } | msg $chan $col $+ The Wikipedia stats for $col2 $+  %wikiFind $col $+ can be found at http://toolserver.org/~soxred93/count/index.php?name= $+ $replace(%wikiFind,$chr(32),+) $+ &lang=en&wiki=wikipedia } }

on $*:TEXT:/^!(globalw|globalurl|vvv)/Si:#:{ if ($chan !isin %notlist) { if ($2) { var %wikiFind = $2- } | else { var %wikiFind = $nick } | notice $nick The Wikimedia project stats for %wikiFind can be found at http://toolserver.org/~vvv/sulutil.php?user= $+ $replace(%wikiFind,$chr(32),+) $+  } }
on $*:TEXT:/^@(globalw|globalurl|vvv)/Si:#:{ if ($chan !isin %notlist) { if ($2) { var %wikiFind = $2- } | else { var %wikiFind = $nick } | msg $chan $col $+ The Wikimedia project stats for $col2 $+  %wikiFind $col $+ can be found at http://toolserver.org/~vvv/sulutil.php?user= $+ $replace(%wikiFind,$chr(32),+) $+  } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@]wiki(pedia)?((user)?name|user)(check)?/Si:#:{ if ($chan !isin %notlist) {
    if ($sock(WikiName)) { notice $nick Please try again in a few seconds. | halt }
    set %WikiNamemsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
    if ($2) { %WikiNamechan = $chan | %WikiNamechan = $chan | %WikiName = $2- | %WikiNameYes = 0 | sockopen WikiName en.wikipedia.org 80 }
    else { notice $nick Please include a username to check. }
} }
on *:SOCKOPEN:WikiName:{
  sockwrite -nt $sockname GET /w/index.php?title=Special%3AListUsers&username= $+ %WikiName $+ &group=&limit=10 HTTP/1.1
  sockwrite -nt $sockname Host: en.wikipedia.org
  sockwrite -nt $sockname User-Agent: Mozilla/5.0
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:WikiName: {
  if ($sockerr) { halt }
  else {
    .timerWikiNameclose 1 1 WikiNameclose
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/title=User:(.+)&amp;action=edit/i)) { if (User: $+ %WikiName isincs %sockreader) { %WikiNameYes = 1 | .timerWikiNameclose off | WikiNameclose } }
    if ($regex(%sockreader,/<\/html>/i)) { .timerWikiNameclose off | WikiNameclose }
  }
}
alias WikiNameclose {
  sockclose WikiName
  if (%WikiNameYes) { %WikiNamemsg $+ The username $col2(%WikiNamechan) $+ %WikiName $+ $col(%WikiNamechan) is taken (case sensitive) on http://en.Wikipedia.org/ }
  else { %WikiNamemsg $+ The username $col2(%WikiNamechan) $+ %WikiName $+ $col(%WikiNamechan) is available (case sensitive) on http://en.Wikipedia.org/ }
  unset %WikiName*
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](ed(d)?it)/Si:#:{ if ($chan !isin %notlist) {
    set %wiki.Name. [ $+ [ %wikiNum ] ] $iif($2,$replace($2-,$chr(32),+),$nick)
    set %wiki.Msg. [ $+ [ %wikiNum ] ] $iif($left($1,1) == @, msg $chan, notice $nick) 1,15
    %wiki.More. [ $+ [ %wikiNum ] ] = 0

    sockopen WikiSox [ $+ [ %wikiNum ] ] toolserver.org 80
    inc %wikiNum
} }

on $*:TEXT:/^[!@](wik(k)?i)/Si:#:{ if ($chan !isin %notlist) {
    set %wiki.Name. [ $+ [ %wikiNum ] ] $iif($2,$replace($2-,$chr(32),+),$nick)
    set %wiki.Msg. [ $+ [ %wikiNum ] ] $iif($left($1,1) == @, msg $chan, notice $nick) 1,15
    %wiki.More. [ $+ [ %wikiNum ] ] = 1

    sockopen WikiSox [ $+ [ %wikiNum ] ] toolserver.org 80
    sockopen WikiVvv [ $+ [ %wikiNum ] ] toolserver.org 80
    inc %wikiNum
    inc %spam. [ $+ [ $chan ] ] 2
} }

on *:SOCKOPEN:WikiSox*:{
  sockwrite -nt $sockname GET /~soxred93/count/index.php?name= $+ %wiki.Name. [ $+ [ $remove($sockname,WikiSox) ] ] $+ &lang=en&wiki=wikipedia HTTP/1.0
  sockwrite -nt $sockname Host: toolserver.org
  sockwrite -nt $sockname $crlf
  %wiki.Closed. [ $+ [ $sockname ] ] = 0
}
on *:SOCKREAD:WikiSox*: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/does not exist/i)) { %wiki.Msg. [ $+ [ $remove($sockname,WikiSox) ] ]  $+ $replace(%wiki.Name. [ $+ [ $remove($sockname,WikiSox) ] ],+,$chr(32)) does not exist on Wikipedia.  | sockclose WikiVvv [ $+ [ $remove($sockname,WikiSox) ] ] | sockclose $sockname | unset %wiki.*. [ $+ [ $remove($sockname,WikiSox) ] ] }
    if ($regex(%sockreader,/info<\/h2>Username: <a href="http:\/\/en.wikipedia.org\/wiki\/User:(.+)">(.+)<\/a><br \/>/i)) { writeini Wiki.ini $remove($sockname,WikiSox) urName $regml(2) }
    if ($regex(%sockreader,/<\/a><br \/>(.+)<\/b><br \/><h2>Namespace/i)) { writeini Wiki.ini $remove($sockname,WikiSox) Stuff $replace($regml(1),<br />, $+ $chr(32) $+ $chr(124) $+ $chr(32),: $+ $chr(32),: $+ $chr(32),<b>,,</b>,) }
    if ($regex(%sockreader,/<tr><td class=date>(.+)<\/td><td>(.+)<\/td><td>/i)) { writeini Wiki.ini $remove($sockname,WikiSox) monEdt @*12,15 $+ $regml(2) @*01,15this month }
    if ($regex(%sockreader,/<\/table><h2>Logs<\/h2>(.+)<br \/><h2>/i)) { writeini Wiki.ini $remove($sockname,WikiSox) SpecialStuff $replace($regml(1),<br />, $+ $chr(32) $+ $chr(124) $+ $chr(32),: $+ $chr(32),: $+ $chr(32)) }
    if ($regex(%sockreader,/<\/html>/i)) {
      if (%wiki.More. [ $+ [ $remove($sockname,WikiSox) ] ] == 0) { wikiMessage $remove($sockname,WikiSox) }
      else {
        %wiki.Closed. [ $+ [ $sockname ] ] = 1
        if (%wiki.Closed. [ $+ [ $replace($sockname,Sox,Vvv) ] ] == 1) { wikiMessage $remove($sockname,WikiSox) }
      }
      sockclose $sockname
    }
  }
}

on *:SOCKOPEN:WikiVvv*:{
  sockwrite -nt $sockname GET /~vvv/sulutil.php?user= $+ %wiki.Name. [ $+ [ $remove($sockname,WikiVvv) ] ] HTTP/1.1
  sockwrite -nt $sockname Host: toolserver.org
  sockwrite -nt $sockname $crlf
  %wiki.Closed. [ $+ [ $sockname ] ] = 0
}
on *:SOCKREAD:WikiVvv*: {
  if ($sockerr) { halt }
  else {
    var %sockreader | sockread %sockreader
    if ($regex(%sockreader,/<p>Total editcount: <b>(.+)<\/b><\/p>/i)) { if ($regml(1) == 0) { writeini Wiki.ini $remove($sockname,WikiVvv) glbEdt @ $+ $regml(1) $+ @ (user may not exist) } | else { writeini Wiki.ini $remove($sockname,WikiVvv) glbEdt $regml(1) } }    
    if ($regex(%sockreader,/<\/html>/i)) {
      %wiki.Closed. [ $+ [ $sockname ] ] = 1
      if (%wiki.Closed. [ $+ [ $replace($sockname,Vvv,Sox) ] ] == 1) { wikiMessage $remove($sockname,WikiVvv) }
      sockclose $sockname
    }
  }
}

alias wikiMessage {
  var %wiki = $1

  tokenize 124 $readini(Wiki.ini, %wiki, Stuff) $(|,) $readini(Wiki.ini, %wiki, SpecialStuff)
  var %i = 1 | while (%i <= $0) {
    writeini Wiki.ini %wiki $left($wikiReturn(%wiki,$ [ $+ [ %i ] ] ),6) $right($wikiReturn(%wiki,$ [ $+ [ %i ] ] ),$calc($len($wikiReturn(%wiki,$ [ $+ [ %i ] ] )) - 6))
    inc %i
  }
  remini Wiki.ini %wiki Stuff
  remini Wiki.ini %wiki SpecialStuff
  %wiki.pink. [ $+ [ %wiki ] ] = $iif(%wiki.pink. [ $+ [ %wiki ] ],$calc($v1 / 3),0)

  if (%wiki.More. [ $+ [ %wiki ] ] == 0) {
    %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $totEdt(%wiki) $delEdt(%wiki) - $monEdt(%wiki)
  }
  else {
    %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $livEdt(%wiki) - $monEdt(%wiki) - 10,15 $+ $bytes($calc($glbEdt(%wiki) + %wiki.del. [ $+ [ %wiki ] ] ),b) 01,15global

    if (%wiki.pink. [ $+ [ %wiki ] ] ) {
      %wiki.String. [ $+ [ %wiki ] ] = $iif($urBlkd(%wiki),$chr(44) $v1,$null) $+ $iif($actCre(%wiki),$chr(44) $v1,$null) $+ $iif($pgsDel(%wiki),$chr(44) $v1,$null) $+ $iif($pgsMov(%wiki),$chr(44) $v1,$null) $+ $iif($pgsPat(%wiki),$chr(44) $v1,$null) $+ $iif($pgsPro(%wiki),$chr(44) $v1,$null) $+ $iif($pgsRes(%wiki),$chr(44) $v1,$null) $+ $iif($urRMod(%wiki),$chr(44) $v1,$null) $+ $iif($urUBlk(%wiki),$chr(44) $v1,$null) $+ $iif($pgUPro(%wiki),$chr(44) $v1,$null) $+ $iif($flsUpl(%wiki),$chr(44) $v1,$null)
      if (%wiki.pink. [ $+ [ %wiki ] ] > 8) {
        %wiki.pink1. [ $+ [ %wiki ] ] = $ceil($calc(%wiki.pink. [ $+ [ %wiki ] ] / 3))
        %wiki.pink2. [ $+ [ %wiki ] ] = $ceil($calc((%wiki.pink. [ $+ [ %wiki ] ] - %wiki.pink1. [ $+ [ %wiki ] ] ) / 2))
        %wiki.pink3. [ $+ [ %wiki ] ] = $calc(%wiki.pink. [ $+ [ %wiki ] ] - (%wiki.pink1. [ $+ [ %wiki ] ] + %wiki.pink2. [ $+ [ %wiki ] ] ))
        echo -a %wiki.pink1. [ $+ [ %wiki ] ] %wiki.pink2. [ $+ [ %wiki ] ] %wiki.pink3. [ $+ [ %wiki ] ]
        %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $right(%wiki.String. [ $+ [ %wiki ] ],$calc($len(%wiki.String. [ $+ [ %wiki ] ] ) - 2))
      }
      else if (%wiki.pink. [ $+ [ %wiki ] ] > 4) {
        %wiki.pink1. [ $+ [ %wiki ] ] = $ceil($calc(%wiki.pink. [ $+ [ %wiki ] ] / 2))
        %wiki.pink2. [ $+ [ %wiki ] ] = $calc(%wiki.pink. [ $+ [ %wiki ] ] - %wiki.pink1. [ $+ [ %wiki ] ] )
        echo -a %wiki.pink1. [ $+ [ %wiki ] ] %wiki.pink2. [ $+ [ %wiki ] ]
        %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $right(%wiki.String. [ $+ [ %wiki ] ],$calc($len(%wiki.String. [ $+ [ %wiki ] ] ) - 2))
      }
      else {
        %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $right(%wiki.String. [ $+ [ %wiki ] ],$calc($len(%wiki.String. [ $+ [ %wiki ] ] ) - 2))
      }
    }
    if ($urGrps(%wiki)) {
      if ($regex($urGrps(%wiki),$chr(44) $+ .* $+ $chr(44) $+ .* $+ $chr(44))) {
        %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $urGrps(%wiki)
        %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $fstEdt(%wiki)
      }
      else { %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $urGrps(%wiki) 01,01-01,15 $fstEdt(%wiki) }
    }
    else { %wiki.Msg. [ $+ [ %wiki ] ] $+  $urName(%wiki) 01,01-01,15 $fstEdt(%wiki) }
  }

  remini Wiki.ini %wiki
  unset %wiki.* [ $+ [ %wiki ] ]
}

alias wikiReturn {
  if      (User groups isin $2-)            { return urGrpsUser groups:@*07,15 $replace($remove($2-,User groups:,$chr(32)),$chr(44),@*01 $+ $chr(44) $+ 15 $+ $chr(44) $+ @*07 $+ $chr(44) $+ 15 $+ $chr(32)) }
  else if (First edit isin $2-)             { return fstEdt $+ $replace($left($2-,25),:,:@*05 $+ $chr(44) $+ 15) }
  else if (Unique articles edited isin $2-) { return uniqAE@*13,15 $+ $remove($2-,Unique articles edited:,$chr(32)) @*01,15unique articles edited }
  else if (Average edits per page isin $2-) { return avgEdt $+ $remove($2-,Average edits per page:,$chr(32)) avg edits? }
  else if (Total edits isin $2-)            { return totEdt@*03,15 $+ $remove($2-,Total edits $chr(40) $+ including deleted $+ $chr(41) $+ :,$chr(32)) @*01,15edits }
  else if (Deleted edits isin $2-)          { %wiki.del. [ $+ [ $1 ] ] = $remove($2-,Deleted edits:,$chr(32)) | return delEdt(@*04,15 $+ $remove($2-,Deleted edits:,$chr(32)) @*1,15deleted) }
  else if (Live edits isin $2-)             { return livEdt@*03,15 $+ $remove($2-,Live edits:,$chr(32)) @*01,15live edits }
  else if (Users blocked isin $2-)          { inc %wiki.pink. [ $+ [ $1 ] ] | return urBlkd@*13,15 $+ $bytes($remove($2-,Users blocked:,$chr(32)),b) @*01,15blocks }
  else if (Accounts created isin $2-)       { inc %wiki.pink. [ $+ [ $1 ] ] | return actCre@*13,15 $+ $bytes($remove($2-,Accounts created:,$chr(32)),b) @*01,15accounts created }
  else if (Pages deleted isin $2-)          { inc %wiki.pink. [ $+ [ $1 ] ] | return pgsDel@*13,15 $+ $bytes($remove($2-,Pages deleted:,$chr(32)),b) @*01,15deletes }
  else if (Pages moved isin $2-)            { inc %wiki.pink. [ $+ [ $1 ] ] | return pgsMov@*13,15 $+ $bytes($remove($2-,Pages moved:,$chr(32)),b) @*01,15moves }
  else if (Pages patrolled isin $2-)        { inc %wiki.pink. [ $+ [ $1 ] ] | return pgsPat@*13,15 $+ $bytes($remove($2-,Pages patrolled:,$chr(32)),b) @*01,15patrols }
  else if (Pages protected isin $2-)        { inc %wiki.pink. [ $+ [ $1 ] ] | return pgsPro@*13,15 $+ $bytes($remove($2-,Pages protected:,$chr(32)),b) @*01,15protects }
  else if (Pages restored isin $2-)         { inc %wiki.pink. [ $+ [ $1 ] ] | return pgsRes@*13,15 $+ $bytes($remove($2-,Pages restored:,$chr(32)),b) @*01,15restores }
  else if (User rights modified isin $2-)   { inc %wiki.pink. [ $+ [ $1 ] ] | return urRMod@*13,15 $+ $bytes($remove($2-,User rights modified:,$chr(32)),b) @*01,15user right modifications }
  else if (Users unblocked isin $2-)        { inc %wiki.pink. [ $+ [ $1 ] ] | return urUBlk@*13,15 $+ $bytes($remove($2-,Users unblocked:,$chr(32)),b) @*01,15unblocks }
  else if (Pages unprotected isin $2-)      { inc %wiki.pink. [ $+ [ $1 ] ] | return pgUPro@*13,15 $+ $bytes($remove($2-,Pages unprotected:,$chr(32)),b) @*01,15unprotects }
  else if (Files uploaded isin $2-)         { inc %wiki.pink. [ $+ [ $1 ] ] | return flsUpl@*13,15 $+ $bytes($remove($2-,Files uploaded:,$chr(32)),b) @*01,15uploads }
  else                                      { echo 4 -s ERROR: wikiReturn not found | return }
}

alias urName { return $replace($readini(Wiki.ini, $1, urName),*,,@,) }
alias monEdt { return $replace($readini(Wiki.ini, $1, monEdt),*,,@,) }
alias glbEdt { return $replace($readini(Wiki.ini, $1, glbEdt),*,,@,) }
alias urGrps { return $replace($readini(Wiki.ini, $1, urGrps),*,,@,) }
alias fstEdt { return $replace($readini(Wiki.ini, $1, fstEdt),*,,@,) }
alias uniqAE { return $replace($readini(Wiki.ini, $1, uniqAE),*,,@,) }
alias avgEdt { return $replace($readini(Wiki.ini, $1, avgEdt),*,,@,) }
alias totEdt { return $replace($readini(Wiki.ini, $1, totEdt),*,,@,) }
alias delEdt { return $replace($readini(Wiki.ini, $1, delEdt),*,,@,) }
alias livEdt { return $replace($readini(Wiki.ini, $1, livEdt),*,,@,) }
alias urBlkd { return $replace($readini(Wiki.ini, $1, urBlkd),*,,@,) }
alias actCre { return $replace($readini(Wiki.ini, $1, actCre),*,,@,) }
alias pgsDel { return $replace($readini(Wiki.ini, $1, pgsDel),*,,@,) }
alias pgsMov { return $replace($readini(Wiki.ini, $1, pgsMov),*,,@,) }
alias pgsPat { return $replace($readini(Wiki.ini, $1, pgsPat),*,,@,) }
alias pgsPro { return $replace($readini(Wiki.ini, $1, pgsPro),*,,@,) }
alias pgsRes { return $replace($readini(Wiki.ini, $1, pgsRes),*,,@,) }
alias urRMod { return $replace($readini(Wiki.ini, $1, urRMod),*,,@,) }
alias urUBlk { return $replace($readini(Wiki.ini, $1, urUBlk),*,,@,) }
alias pgUPro { return $replace($readini(Wiki.ini, $1, pgUPro),*,,@,) }
alias flsUpl { return $replace($readini(Wiki.ini, $1, flsUpl),*,,@,) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
