;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias MrT {
  unset %mr.* | window -c @Morse
  window -de0o @Morse 1050 170 400 210
  if ($1 == 2) { %mr.typeQ = 1 | %mr.typeA = 2 | echo 5 @Morse Beginning Morse testing - X* }
  ;else if ($2 == 3) { %mr.typeQ = 2 | %mr.typeA = 1 | echo 5 @Morse Beginning Morse testing - Rand }
  else { %mr.typeQ = 2 | %mr.typeA = 1 | echo 5 @Morse Beginning Morse testing - *X }
  newLet
}

alias newLet {
  echo @Morse 00.
  tokenize 42 $read(Morse.txt)
  %mr.1 = $1 | %mr.2 = $2
  echo 5 @Morse  $+ %mr. [ $+ [ %mr.typeQ ] ]
}

on *:INPUT:@Morse:{
  if ($1 == %mr. [ $+ [ %mr.typeA ] ]) { echo 3 @Morse  $+ %mr. [ $+ [ %mr.typeA ] ] is correct! }
  else {
    echo 4 @Morse  $+ $1- is incorrect 03(correct: %mr. [ $+ [ %mr.typeA ] ] $+ )
    if (%mr. [ $+ [ %mr.typeA ] ] isnum) { write Morse.txt %mr. [ $+ [ %mr.typeQ ] ] $+ * $+ %mr. [ $+ [ %mr.typeA ] ] }
    else { write Morse.txt %mr. [ $+ [ %mr.typeA ] ] $+ * $+ %mr. [ $+ [ %mr.typeQ ] ] }
  }
  newLet
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;alias next {
;  //run http://dictionary.reference.com/browse/ $+ $read(Vocab2.txt, %i)
;  inc %i
;  .timer 1 1 /tipp
;}
;alias tipp { $tip(t,D-Click for next,...,60,$null,$null,/next) }

;alias copy {
;  %i = 1
;  while (%i <= 201) {
;    tokenize 42 $read(Vocab.txt, %i)
;    /write VocabWord.txt $upper($left($2,1)) $+ $right($2,$calc($len($2) - 1)) $+ : $1
;    inc %i
;  }
;}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias vocab {
  /window -de0 @Vocab 200 100 700 200
  if (($1 isnum) && ($2 isnum)) { %vStart = $1 | %vEnd = $2 }
  else if ($1 == cont) { %vEnd = 201 }
  else { %vStart = -999 | %vEnd = random }
  /newWord
}

alias newWord {
  if (%vStart <= %vEnd) {
    if (%vEnd == random) { tokenize 42 $read(Vocab.txt) }
    else { tokenize 42 $read(Vocab.txt, %vStart) }
    %def = $1 | %word = $2
    echo @Vocab 5 $+ %def $+ 
    %vocab = 1 | %tries = 1 | inc %vStart
  }
  else { echo @Vocab DONE! }
}

on *:INPUT:@Vocab:{ if (%vocab == 1) {
    echo @Vocab $1-
    if ($1- == %word) { echo @Vocab 03 $+ %word is correct! | %vocab = 0 | .timer 1 1 /newWord }
    else if (%tries >= 3) { echo @Vocab 4Incorrect... word: %word $+  | %vocab = 0 | .timer 1 1 /newWord }
    else if (%tries == 2) { echo @Vocab 4Incorrect... hint: $left(%word,2) $+ $str(-,$calc($len(%word) - 3)) $+ $right(%word,1) | inc %tries }
    else if (%tries == 1) { echo @Vocab 4Incorrect... hint: $left(%word,1) $+ $str(-,$calc($len(%word) - 1)) | inc %tries }
    else { echo @Vocab 04 $+ $1- is incorrect. | inc %tries }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
