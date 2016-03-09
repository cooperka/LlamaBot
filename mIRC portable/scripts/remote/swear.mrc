;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:*@~~t@  @@@*:#LlamaBot:{ if (rat isin $nick) { mm2 $nick | .timerunmmryan 1 60 unmm $chan $nick } }
on *:TEXT:*L    __/   []\*:#LlamaBot:{ if (rat isin $nick) { mm2 $nick | .timerunmmryan 1 60 unmm $chan $nick } }
on *:TEXT:*blarg*:#LlamaBot:{ if (rat isin $nick) {
    if (%blargCount2) { mm2 $nick | .timerUnblarg 1 120 unmm $chan $nick | .timerBlarg2Unset 1 600 unset %blargCount2 %blargCount }
    else if (%blargCount) { kick $chan $nick 5,15Please, no rapid blargs (next time it's a 2 minute mute). | %blargCount2 = 1 | .timerBlarg2Unset 1 600 unset %blargCount2 %blargCount }
    else { %blargCount = 1 | .timerBlargUnset 1 30 unset %blargCount }
} }
on *:TEXT:*govnaw*:#LlamaBot:{ if (rat isin $nick) { kick $chan $nick 5,15A cow pie lands on Ryan's face and knocks him out of the channel... } }

;on $*:TEXT:*:#LlamaBot:{ if ((shit isin $1-) || (fuck isin $1-) || (bitch isin $1-)) {
;    inc %swear. [ $+ [ $nick ] ] | mm2 $nick | msg $chan 4,15 $+ $nick $+ , please don't swear ( $+ $calc(30 * (%swear. [ $+ [ $nick ] ] + 1)) second mute). | .timerunbanswe $+ $nick 1 $calc(30 * (%swear. [ $+ [ $nick ] ] + 1)) unmm $chan $nick
;} }

alias mm { mode $chan -aohv $1 $1 $1 $1 | mode $chan +m }
alias mm2 { mode $chan -aohv $1 $1 $1 $1 | mode $chan +m | mode $chan +b $address($1,1) }

alias unmm { mode $1 -b $address($2,1) | mode $1 +v $2 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
