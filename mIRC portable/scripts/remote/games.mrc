;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Numbers ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](endnumbers|end numbers|endguess|end guess|stopguess|stop guess|endgame|end game)/Si:#:{ if ($chan !isin %notlist) {
    if (%ggame. [ $+ [ $chan ] ] != 1) {
      msg $chan $col $+ The guessing game has been ended by $nick $+ .
      %ggame. [ $+ [ $chan ] ] = 1
      unset %Secret. [ $+ [ $chan ] ] %NumGuesses. [ $+ [ $chan ] ] %Guess. [ $+ [ $chan ] ]
    }
    else { notice $nick There isn't a guessing game going on right now... }
} }

on $*:TEXT:/^[!@](numbers|number game|numbers game|game$|guessing game|guess game|guessinggame)/Si:#:{ if ($chan !isin %notlist) {
    if ((%dm. [ $+ [ $chan ] ] == 1) && (%ggame. [ $+ [ $chan ] ] == 1)) {
      %Secret. [ $+ [ $chan ] ] = 1 + $rand(1,1000)
      %ggame. [ $+ [ $chan ] ] = 2
      %NumGuesses. [ $+ [ $chan ] ] = 0
      %Guess. [ $+ [ $chan ] ] = 0
      msg $chan $col $+ A guessing game has been started by $nick $+ !
      msg $chan $col $+ Everyone is able to guess.
      msg $chan $col $+ Type !guess Number1to1000
    }
    else {
      if (%ggame. [ $+ [ $chan ] ] != 1) { notice $nick There is already a guessing game going on (!endguess to end) }
      else if (%dm. [ $+ [ $chan ] ] != 1) { notice $nick There is currently a DM going on (!enddm to end) }
    }
} }

on $*:TEXT:/^[!@](guess )/Si:#:{ if ($chan !isin %notlist) {
    if (%ggame. [ $+ [ $chan ] ] == 2) {
      if ($2- == %Secret. [ $+ [ $chan ] ] ) {
        inc %NumGuesses. [ $+ [ $chan ] ]
        msg $chan $col $+ You got it, $nick $+ !  The answer was %Secret. [ $+ [ $chan ] ] $+ .
        msg $chan $col $+ It took you %NumGuesses. [ $+ [ $chan ] ] guesses to get it right.
        %ggame. [ $+ [ $chan ] ] = 1
        unset %Secret. [ $+ [ $chan ] ] %NumGuesses. [ $+ [ $chan ] ] %Guess. [ $+ [ $chan ] ]
      }
      else if ($2- < %Secret. [ $+ [ $chan ] ] ) { msg $chan $col $+  $+ $2- is too low! }
      else if ($2- > %secret. [ $+ [ $chan ] ] ) { msg $chan $col $+  $+ $2- is too high! }
      inc %NumGuesses. [ $+ [ $chan ] ]
    }
} }


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Chess ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias Chess {
  .remove Chess\Moves.txt | //noop $findfile($mircdir,undo*.bmp,0,.remove $1-)
  window -pkodCfB +l @Chess -1 -1 620 620 | drawtext @Chess 1 verdana 10 5 5 Loading... | if ($1) { setlayer $1 @Chess }
  window -pkodCfB +l @Moves -1 -1 100 500 | if ($1) { setlayer $1 @Chess }
  %cNT = 0 | %cToFrom = From | %cTurn = $rand(1,2) | if (%cTurn == 1) { %cWhite = LlamaBot } | else { %cWhite = Undoubtedly0 }
  Board | Moves
}
alias Moves { if ($window(@Chess)) { if ($window(@Moves)) { var %Move = %cNT | while (%Move > 0) { drawtext @Moves 1 verdana 10 2 $calc(%Move * 15) %Move $+ . $read(Chess\Moves.txt, %Move) | dec %Move } } | else { window -pkodCfB +l @Moves -1 -1 100 500 | if ($1) { setlayer $1 @Chess } | .timer -m 1 1 /Moves } } }
alias Board { if ($window(@Chess)) {
    drawrect -rf @Chess $rgb(255,255,255) 1 1 1 90 50

    var %i = 1 | while (%i <= 8) { drawtext @Chess 1 verdana 10 $calc((-17) + (%i * 75)) 605 $chr($calc(64 + %i)) | inc %i }
    %i = 1 | while (%i <= 8) { drawtext @Chess 1 verdana 10 005 $calc(636 - (%i * 75)) %i | inc %i }

    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(95 + (%i * 150)) 000 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 98)) $+ 8) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(20 + (%i * 150)) 075 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 97)) $+ 7) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(95 + (%i * 150)) 150 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 98)) $+ 6) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(20 + (%i * 150)) 225 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 97)) $+ 5) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(95 + (%i * 150)) 300 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 98)) $+ 4) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(20 + (%i * 150)) 375 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 97)) $+ 3) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(95 + (%i * 150)) 450 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 98)) $+ 2) 053 053 | inc %i 2 }
    %i = 0 | while (%i < 4) { drawrect -rf @Chess $rgb(200,200,200) 1 $calc(20 + (%i * 150)) 525 075 075 | inc %i }
    %i = 0 | while (%i <= 6) { drawrect -rf @Chess $rgb(255,255,255) 1 $convert($chr($calc(%i + 97)) $+ 1) 053 053 | inc %i 2 }

    drawrect -r @Chess 0 5 020 000 600 600

    %i = 1 | while (%i <= 7) { drawline -r @Chess 0 1 $calc(20 + (%i * 75)) 000 $calc(20 + (%i * 75)) 600 | inc %i }
    %i = 1 | while (%i <= 7) { drawline -r @Chess 0 1 20 $calc(%i * 75) 620 $calc(%i * 75) | inc %i }
    titlebar @Chess - v1.2 - Made by LlamaBot | Pieces
} }
alias Pieces { if ($window(@Chess)) {
    var %i = 0 | while (%i < 8) { drawpic -ts @Chess $rgb(255,255,255) $calc(43 + (%i * 75)) 090 30 45 Chess\bPawn.bmp | inc %i }
    %i = 0 | while (%i < 8) { drawpic -ts @Chess $rgb(000,255,000) $calc(43 + (%i * 75)) 465 30 45 Chess\wPawn.bmp | inc %i }
    drawpic -ts @Chess $rgb(255,255,255) 043 015 30 45 Chess\bRook.bmp | drawpic -ts @Chess $rgb(255,255,255) 568 015 30 45 Chess\bRook.bmp | drawpic -ts @Chess $rgb(000,255,000) 043 540 30 45 Chess\wRook.bmp | drawpic -ts @Chess $rgb(000,255,000) 568 540 30 45 Chess\wRook.bmp
    drawpic -ts @Chess $rgb(255,255,255) 113 015 41 45 Chess\bKnight.bmp | drawpic -ts @Chess $rgb(255,255,255) 488 015 41 45 Chess\bKnight.bmp | drawpic -ts @Chess $rgb(000,255,000) 113 540 41 45 Chess\wKnight.bmp | drawpic -ts @Chess $rgb(000,255,000) 488 540 41 45 Chess\wKnight.bmp
    drawpic -ts @Chess $rgb(255,255,255) 193 015 30 45 Chess\bBish.bmp | drawpic -ts @Chess $rgb(255,255,255) 418 015 30 45 Chess\bBish.bmp | drawpic -ts @Chess $rgb(000,255,000) 193 540 30 45 Chess\wBish.bmp | drawpic -ts @Chess $rgb(000,255,000) 418 540 30 45 Chess\wBish.bmp
    drawpic -ts @Chess $rgb(255,255,255) 258 018 53 45 Chess\bQueen.bmp | drawpic -ts @Chess $rgb(255,255,255) 333 015 53 45 Chess\bKing.bmp | drawpic -ts @Chess $rgb(000,255,000) 258 543 53 45 Chess\wQueen.bmp | drawpic -ts @Chess $rgb(000,255,000) 333 540 53 45 Chess\wKing.bmp
} }
alias Click {
  %l = 0 | while (%l <= 7) { %i = 0 | while (%i <= 7) {
      if ($inrect($1,$2,$calc(20 + (%i * 75)),$calc(%l * 75),75,75)) {
        if (%cToFrom == From) {
          %cToFrom = To | %cFrom = $chr($calc(65 + %i)) $+ $calc(8 - %l) | ;echo #LlamaBot From: %cFrom
          unset %i %l | halt
        }
        else if (%cToFrom == To) {
          %cToFrom = From | %cTo = $chr($calc(65 + %i)) $+ $calc(8 - %l) | ;echo #LlamaBot To: %cTo
          ;if ($getdot(@Chess,$Convert2(%cFrom)) != $rgb(255,255,255)) { %cColor = grey } | else { %cColor = white }
          Move %cFrom %cTo ;%cColor
          unset %i %l %cTo %cFrom | halt
        }
    } | inc %i } | inc %l
} }
menu @Chess {
  sclick:Click $mouse.x $mouse.y
  Transparency:if ($input(Set Transparency 0-255, eqd, Transparency)) { setlayer $v1 @Chess } | else { halt }
}
alias Convert { var %Value = $mid($1,1,1) $mid($1,2,1) | %Value = $replacex(%Value,a,31,b,106,c,181,d,256,e,331,f,406,g,481,h,556,1,536,2,461,3,386,4,311,5,236,6,162,7,86,8,11) | return %Value }
alias Convert2 { var %Value = $mid($1,1,1) $+ , $+ $mid($1,2,1) | %Value = $replacex(%Value,a,21,b,96,c,171,d,246,e,321,f,396,g,471,h,546,1,526,2,451,3,376,4,301,5,226,6,152,7,76,8,1) | return %Value }
alias Move { if ($window(@Chess)) { drawsave @Chess Chess\undo $+ %cNT $+ .bmp | drawcopy @Chess $convert($1) 53 53 @Chess $convert($2) 53 53 | drawrect -rf @Chess $rgb(255,255,255) 1 $convert($1) 53 53 | inc %cNT | write Chess\Moves.txt $1 -> $2 | Moves | if (noMsg != $3) { msg #LlamaBot !move $1 $2 } } }
alias Undo { if ($window(@Chess)) { dec %cNT | drawpic -s @Chess 0 0 620 620 Chess\undo $+ %cNT $+ .bmp | write -d Chess\Moves.txt | window -c @Moves | Moves | if (noMsg != $1) { msg #LlamaBot !undo } } }
on *:TEXT:!move*:#LlamaBot:{ if (($nick == Undoubtedly0) || (noDoubt isin $nick)) { /Move $2 $3 noMsg | inc %cNT } | else { notice $nick You are not in this chess game. } }
on *:TEXT:!undo:#LlamaBot:{ if (($nick == Undoubtedly0) || (noDoubt isin $nick)) { /undo noMsg } | else { notice $nick You are not playing this game of chess. } }
on *:TEXT:!chess:#LlamaBot:{
  if ($nick != Undoubtedly0) && (NoDoubt !isin $nick) { return }
  if (%chess == 0) { notice $nick Chess is turned off right now. | return }
  .timeryesorno 1 0 chessask $chan $nick | notice $nick Awaiting confirmation...
}
alias chessask {
  var %in = $input(Play chess?,vwy)
  if (%in == $no) { notice $2 Your offer has been declined. | var %chess = 0 }
  else { chess | %chess = 0 | msg $1 5,15A chess game has been started. | msg $1 5,15 $+ %cWhite gets the first move. }
}
alias chessoff { %chess = 0 }
alias chesson { %chess = 1 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
