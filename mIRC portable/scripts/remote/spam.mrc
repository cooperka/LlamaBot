;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:.*:#:{ if (($chan !isin %alreadyDot) && ($chan !isin %notList) && (... !isin $1-)) { msg $chan $col $+ To use my commands, try putting a ! or @ in front.  They do not work with a period. | %alreadyDot = %alreadyDot $chan } }

on *:TEXT:!*:#:{ if ($chan !isin %notlist) { SpamStuff $chan } }
on *:TEXT:@*:#:{ if ($chan !isin %notlist) { SpamStuff $chan } }
on *:TEXT:*[[*]]*:#:{ if ($chan !isin %notlist) { SpamStuff $chan } }

alias SpamStuff {
  inc %spam. [ $+ [ $1 ] ] | SpamAli $1
  if (%spam. [ $+ [ $1 ] ] >= 10) {
    %notlist = %notlist $1 | %notlist3 = %notlist3 $1
    msg $1 $col($1) $+ Too much spam!  This channel has been ignored for 60 seconds.
    .timerUnblock1 $+ $1 1 60 set %notlist $remove(%notlist,$1)
    .timerUnblock2 $+ $1 1 60 set %notlist3 $remove(%notlist3,$1)
  }
}

alias SpamAli {
  if (!$timer(Spam $+ $1)) { .timerSpam $+ $1 0 1 SpamAliR $1 }
}

alias SpamAliR {
  dec %spam. [ $+ [ $1 ] ]
  if (%spam. [ $+ [ $1 ] ] <= 0) { unset %spam. [ $+ [ $1 ] ] | .timerSpam $+ $1 off }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:PART:#LlamaBot:{ if (($address($nick,2) == $address($me,2)) && (($nick == Coop|AFK) || ($nick == Coop))) { bs kick #llamabot flood on 1 3 3 | bs set #llamabot dontkickops off | bs set #llamabot dontkickvoices off } }
on *:QUIT:{ if (($address($nick,2) == $address($me,2)) && (($nick == Coop|AFK) || ($nick == Coop))) { bs kick #llamabot flood on 1 3 3 | bs set #llamabot dontkickops off | bs set #llamabot dontkickvoices off } }

on *:JOIN:#LlamaBot:{ if (($address($nick,2) == $address($me,2)) && (($nick == Coop|AFK) || ($nick == Coop))) { bs kick #llamabot flood off } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on ^*:TEXT:*:#LlamaBot:{ SpamStuff2 $nick $chan $1- }

alias SpamStuff2 {
  if (($address($1,2) != $address($me,2)) && ($1 !isop #LlamaBot)) {
    if ((lol isin $3) && (!$4)) { inc %spam. [ $+ [ $1 ] ] }
    inc %spam. [ $+ [ $1 ] ] | SpamAli2 $1
    if (%spam. [ $+ [ $1 ] ] >= 5) {
      if (%spamWarned. [ $+ [ $1 ] ] ) {
        msg $2 $col($2) $+  $+ $1 $+ , you have been muted from $2 for 60 seconds.
        notice $1 $col($2) $+  $+ $1 $+ , you have been muted from $2 for 60 seconds.
        SpamKick $1 $2 | .timerUnblock off
        unset %spamWarned. [ $+ [ $1 ] ] %spam. [ $+ [ $1 ] ]
      }
      else {
        msg $2 $col($2) $+  $+ $1 $+ , you have a spam warning for 5 minutes.
        %spamWarned. [ $+ [ $1 ] ] = 1
        .timerUnblock $+ $1 1 300 unset %spamWarned. [ $+ [ $1 ] ]
        unset %spam. [ $+ [ $1 ] ]
      }
    }
  }
}

alias SpamAli2 {
  if (!$timer(Spam $+ $1)) { .timerSpam $+ $1 -m 0 1100 SpamAliR2 $1 }
}

alias SpamAliR2 {
  dec %spam. [ $+ [ $1 ] ]
  if (%spam. [ $+ [ $1 ] ] <= 0) { unset %spam. [ $+ [ $1 ] ] | .timerSpam $+ $1 off }
}

alias SpamKick {
  else {
    mode $2 +b $address($1,1)
    ;kick $2 $1
    .timerUnbanSpam $+ $1 1 60 SpamKickOver $1 $2
    mm $1
  }
}

alias SpamKickOver { mode $2 +v $1 | mode $2 -b $address($1,1) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
