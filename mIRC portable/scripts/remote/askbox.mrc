;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias AskBox {
  window -c @Question
  .timerAskBox -m 0 100 /RepAsk $iif($1,$1-,Please open mIRC - in the task bar.  You can close this window once you say "hi" in #LlamaBot.)
}

alias RepAsk { if (!$window(@Question)) {
    window -doe0a @Question 500 300 500 200
    echo @Question $timestamp <Kevin says> $1-
} }

on *:APPACTIVE:{ if ($active == #LlamaBot) { askboxoff } }

on *:INPUT:@Question: {
  echo @Question $timestamp <You say> $1-
  echo @Question $timestamp <Kevin says> Input received.  You can close this window once you open mIRC.
  .timerAskBox off
  msg #LlamaBot [Input]: $1-
}

alias AskBoxOff {
  .timerAskBox off
  window -c @Question
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
