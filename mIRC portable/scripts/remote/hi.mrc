;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:INPUT:*:{
  if ((($1 == h) || ($1 == i) || ($1 == ih)) && (!$2) && (%backSpCh)) { haltdef | say hi }
  else if (($1 == ehy) && (!$2) && (%backSpCh)) { haltdef | say hey }
  else if ((($1 == bck) || ($1 == bcak) || ($1 == b/ack)) && (!$2) && ((brb isin $me) || (afk isin $me))) { haltdef | back | say back }
  ;else if (($1 == back) && ($chr(124) isin $me) && (!$2)) { haltdef | back | say Back }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
