;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias Beeep {
  if ((%tip) && (%beep)) { beep 4 200 | beepoff }
  else if ((%tip) && (%beeps)) { beep 1 }
}
alias Beeep2 {
  if ((%tip) && (%beep)) { beep 4 200 }
  else if ((%tip) && (%beeps)) { beep 1 }
}

alias Tiip {
  if (((!$appactive) || ($active == @Log)) && (%tip) && (BRB !isin $me)) {
    noop $tip(h,mIRC:,$1- $+ ,60,$null,$null,/brb or|AFK--auto)
  }
}
alias Tiip2 {
  if ((!$appactive) || ($active == @Log)) {
    noop $tip(h,mIRC:,$1- $+ ,60,$null,$null,/brb or|AFK--auto)
  }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:*:#LlamaBot:{ Beeep | Tiip $nick says: $1- | if (%codeMSG) { /decode $2- } }

on *:TEXT:*:?:{ Beeep | Tiip  $+ $nick says: $1- }

on *:ACTION:*:#LlamaBot:{ Beeep | Tiip $nick $1- }

on *:ACTION:*:?:{ Beeep | Tiip  $+ $nick $1- }

on *:JOIN:#LlamaBot:{ if (($nick != $me) && ($nick != X)) { Beeep | Tiip2 4 $+ $nick has joined $chan } }

on *:PART:#LlamaBot:{ Beeep2 | Tiip 14 $+ $nick has left $chan }

on *:QUIT:{ Beeep2 | Tiip 14 $+ $nick has quit }

on *:NICK:{ Beeep2 | Tiip 2 $+ $nick is now $newnick }

on *:APPACTIVE:{
  if ($tip(1)) { tip -c $tip(1) }
  if ($tip(2)) { tip -c $tip(2) }
  if ($tip(3)) { tip -c $tip(3) }
  if ($tip(4)) { tip -c $tip(4) }
  if ($tip(5)) { tip -c $tip(5) }
}

alias mespeak {
  if ($1 == on) { %meSpeak = 1 | echo 2 -a MeSpeak is now ON. }
  else if ($1 == off) { %meSpeak = 0 | echo 2 -a MeSpeak is now OFF. }
}
alias mespeakon { %meSpeak = 1 | echo 2 -a MeSpeak is now ON. }
alias mespeakoff { %meSpeak = 0 | echo 2 -a MeSpeak is now OFF. }

on *:INPUT:#LlamaBot:{
  if (%codeMSG) { if ($left($1,1) != /) { haltdef | /codeMsg $1- } }
  else if (%meSpeak) { if ($left($1,1) !isin !@/) {
      haltdef
      if ("*" iswm $1-) { %MSWs = quotes: $1- }
      else if ((http* iswm $1) && (!$2)) { %MSWs = wants you to visit $1 }
      else if ((sd? iswm $1) && (!$2)) { %MSWs = wonders if you want to play Soldat? }
      else if (? isin $1-) { %MSWs = asks: $1- }
      else if ((idk* iswm $1) && (!$2)) { %MSWs = doesn't know. }
      else if ((lol* iswm $1) && (!$2)) { %MSWs = laughs. }
      else if ((hehe* iswm $1) && (!$2)) { %MSWs = snickers. }
      else if ((muaha* iswm $1) && (!$2)) { %MSWs = produces an evil laugh... }
      else if ((rofl* iswm $1) && (!$2)) { %MSWs = rolls on the floor in hysteria. }
      else if ((= $+ $chr(41) iswm $1) && (!$2)) { %MSWs = smiles. }
      else if ((yes* iswm $1) && (!$2)) { %MSWs = nods his head 'yes'. }
      else if ((no* iswm $1) && (!$2)) { %MSWs = shakes his head 'no'. }
      else if ((hi* iswm $1) && (!$2)) { %MSWs = waves hello. }
      else if ((bye* iswm $1) && (!$2)) { %MSWs = waves goodbye. }
      else if ((woot* iswm $1) && (!$2)) { woot | %MSWs = woots. }
      else if ((*brb* iswm $1-2) && (!$2)) { brb | %MSWs = will be right back. }
      else { %MSWs = says: $1- }
      describe $chan %MSWs
      unset %MSWs
  } }
}

/* ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

for Matt --

on *:DISCONNECT:{ .timerReconnect 0 5 server }
on *:CONNECT:{
  .timerReconnect off
  if (freenode isin $server) { afk | ns id YourPass | join #WikiChan }
  else if (swift isin $server) { afk | ns id YourPass | join #LlamaBot }
}

on *:JOIN:#:{ if ((!$appactive) && (%tip)) { noop $tip($chan,$chan,4 $+ $nick has joined $chan,60) } }
on *:NICK:{ if ((!$appactive) && (%tip)) { noop $tip($chan,$chan,4 $+ $nick is now $newnick,60) } }

on *:TEXT:*:#:{ if ((!$appactive) && ($chan !isin %notip)) {
    if (swift isin $server) {
      if (%tip.Swift == 1) { noop $tip($chan,$chan,$nick says: $1-,60) }
      else if ((%tip.Swift == 2) && ($left($1,1) !isin @!) && ($left($1,5) != 5,15) && ($left($1,5) != 4,15)) { noop $tip($chan,$chan,$nick says: $1-,60) }
      else if ((%tip.Swift == 3) && ($me isin $1-)) { noop $tip($chan,$chan, $+ $nick wants you! $chr(40) $+ $1- $+ $chr(41),60) }
    }
    else if (freenode isin $server) {
      if (%tip.Free == 1) { noop $tip($chan,$chan,$nick says: $1-,60) }
      else if ((%tip.Swift == 2) && ($me isin $1-)) { noop $tip($chan,$chan, $+ $nick wants you! $chr(40) $+ $1- $+ $chr(41),60) }
      else if (%tip.Swift == 3) {
        if ($me isin $1-) { noop $tip($chan,$chan, $+ $nick wants you! $chr(40) $+ $1- $+ $chr(41),60) }
        else if ($nick == AACBot) { noop $tip($chan,$chan,$nick says: $1-,60) }
      }
    }
} }
on *:TEXT:*:?:{ if (!$appactive) {
    if (swift isin $server) { if (%tip.Swift) { noop $tip($nick,Private Message, $+ $nick PMs: $1- $+ ,60) } }
    else if (freenode isin $server) { if (%tip.Free) { noop $tip($nick,Private Message, $+ $nick PMs: $1- $+ ,60) } }
} }
on *:ACTION:*:#:{ if ((!$appactive) && ($chan !isin %notip)) {
    if (swift isin $server) { if (%tip.Swift) { noop $tip($chan,$chan,$nick $1-,60) } }
    else if (freenode isin $server) { if (%tip.Free) { noop $tip($chan,$chan,$nick $1-,60) } }
} }

on *:APPACTIVE:{
  if ($tip(1)) { tip -c $tip(1) }
  if ($tip(2)) { tip -c $tip(2) }
  if ($tip(3)) { tip -c $tip(3) }
  if ($tip(4)) { tip -c $tip(4) }
  if ($tip(5)) { tip -c $tip(5) }
}


/afk {
  if (swift isin $server) { nick NoDoubt|AFK | tipoff }
  else if (freenode isin $server) { nick Arbit[AWAY] | tipoff }
}
/bck {
  if (swift isin $server) { nick Undoubtedly0 | tipon }
  else if (freenode isin $server) { nick Arbitrarily0 | tipon }
}
/tipon {
  if (swift isin $server) { %tip.Swift = 1 | echo 2 -a Swift tips are now ON. }
  else if (freenode isin $server) { %tip.Free = 1 | echo 2 -a Freenode tips are now ON. }
}
/tipbotoff {
  if (swift isin $server) { %tip.Swift = 2 | echo 2 -a Swift bot-related speech will not tip. }
  else if (freenode isin $server) { %tip.Free = 2 | echo 2 -a Freenode tips are now NAME only. }
}
/tipname {
  if (swift isin $server) { %tip.Swift = 3 | echo 2 -a Swift tips are now NAME only. }
  else if (freenode isin $server) { %tip.Free = 3 | echo 2 -a Freenode tips are now NAME and AACBot only. }
}
/tipoff {
  if (swift isin $server) { %tip.Swift = 0 | echo 2 -a Swift tips are now OFF. }
  else if (freenode isin $server) { %tip.Free = 0 | echo 2 -a Freenode tips are now OFF. }
}

*/ ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
