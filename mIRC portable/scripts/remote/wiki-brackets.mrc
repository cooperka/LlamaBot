;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:*[[KaC]]*:#LlamaBot:{ }

;on *:TEXT:[[*]]:#:{ if ($chan !isin %notlist) { notice $nick $col $+ The Wikipedia article for $replace($1-,[,,],,@,,!,) $+ : http://en.wikipedia.org/wiki/ $+ $replace($1-,[,,],,$chr(32),_,@,,!,) } }
on *:TEXT:![[*]]:#LlamaBot:{ if ($chan !isin %notlist) { notice $nick $col $+ The Wikipedia article for $replace($1-,[,,],,@,,!,) $+ : http://en.wikipedia.org/wiki/ $+ $replace($1-,[,,],,$chr(32),_,@,,!,) } }
on *:TEXT:@[[*]]:#LlamaBot:{ if ($chan !isin %notlist) { msg $chan $col $+ The Wikipedia article for $replace($1-,[,,],,@,,!,) $+ : http://en.wikipedia.org/wiki/ $+ $replace($1-,[,,],,$chr(32),_,@,,!,) } }

on *:TEXT:*:#LlamaBot:{ if ($chan !isin %notlist) {
    if ($regex($1-,/\[\[+(.+?)\]\]+/g)) {
      var %x = $regml(0) | var %y = $regml(0) | var %i = 1
      if (%x > 5) { %x = 5 } | if (%y > 5) { %y = 5 }
      while (%x) { set $+(%,match,.,%x) $regml(%x) | dec %x }
      while (%i <= %y) { msg $chan $col $+ The Wikipedia article for %match. [ $+ [ %i ] ] $+ : http://en.wikipedia.org/wiki/ $+ $replace(%match. [ $+ [ %i ] ],$chr(32),_) | inc %i }
      unset %match.*
    }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
