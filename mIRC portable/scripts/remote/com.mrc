;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; COM related ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:!com:?:{ if (($nick == LlamaBot) || ($nick == Coop|AFK)) {
    msg $nick - SendKey(key) - includes ENTER
    msg $nick - SendKey2(key) - discludes ENTER
    msg $nick - Cascade(operation) - ops include CascadeWindows, MinimizeAll,
    msg $nick --- ShutDownWindows, TileHorizontally, TileVertically, UndoMinimizeAll
    msg $nick - EndProcess(process) - ends all instances of that process (Firefox.exe, etc.)
    msg $nick - Popup(message, optional) - gives a popup w/ message or fake warning
    msg $nick - IE(site) - opens the internet and goes to that site (include http!)
    msg $nick - AskBox(message) - opens a box with input (input -> #LlamaBot)
    msg $nick - AskBoxOff() - closes the input box
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias AskBox { if ($1) {
    /window -c @Question
    .timerAskBox -m 0 10 /RepAsk $1-
} }
alias RepAsk { if (!$window(@Question)) {
    /window -doe0a @Question 500 300 400 100
    /echo @Question [Kevin asks]: $1-
} }
on *:INPUT:@Question: {
  echo @Question [You say]: $1-
  echo @Question [I say]: Thanks, you can close now.
  .timerAskBox off
  /msg #LlamaBot [Input]: $1-
}
alias AskBoxOff {
  /timers off
  /window -c @Question
}


alias Ninja {
  /timerNinja 0 2 /SendAlf
}
alias SendAlf {
  .comopen SendA wscript.shell
  var %i = 97 | while (%i <= 122) {
    if ($com(SendA,sendkeys,1,bstr*,$chr(%i))) { }
    inc %i
  }
  .comclose SendA
}


;alias SendKey { .comopen Send wscript.shell | echo -s Don't worry about this number: $com(Send,sendkeys,1,bstr*, $1- $+ {ENTER}) | .comclose Send }
alias SendKey {
  .comopen Send wscript.shell
  if ($1) { echo -s $com(Send,sendkeys,1,bstr*, $1- $+ {ENTER}) | .comclose Send }
  else { echo -s $com(Send,sendkeys,1,bstr*,Why hello there :D{ENTER}) | .comclose Send }
}
alias SendKey2 {
  .comopen Send wscript.shell
  if ($1) { echo -s $com(Send,sendkeys,1,bstr*, $1-) | .comclose Send }
  else { echo -s $com(Send,sendkeys,1,bstr*,Why hello there :D) | .comclose Send }
}


alias Cascade {
  .comopen Cascade Shell.Application
  if ($comerr) { echo comopen failed | halt }
  if ($1) { echo -s $com(Cascade, $1 ,1) }
  .comclose Cascade
}


alias EndProcess {
  .comopen Locator WbemScripting.SWbemLocator
  if ($comerr) { echo comopen failed | halt }
  echo -s $com(Locator,ConnectServer,3, dispatch* Services)
  echo Result: $com(Locator).result
  .comclose Locator
  if $com(Services) {
    if ($1) { echo -s $com(Services, ExecQuery,3,string,SELECT Name FROM Win32_Process WHERE Name = " $+ $1 $+ ",dispatch* Instances) }
    else { echo -s $com(Services, ExecQuery,3,string,SELECT Name FROM Win32_Process WHERE Name = "Firefox.exe",dispatch* Instances) }
    echo -s $com(Services).result
    .comclose Services
  }
  if $com(Instances) {
    echo -s $com(Instances,Count,3)
    var %c = $com(Instances).result, %i = 1
    while (%i <= %c) {
      echo -s $comval(Instances,%i, Terminate)
      inc %i
    }
    .comclose instances
  }
}


/*
alias PrintTestPage {
  .comopen Locator WbemScripting.SWbemLocator
  if ($comerr) { echo comopen failed | halt }
  echo -s $com(Locator,ConnectServer,3, dispatch* Services)
  echo -s $com(Locator).result
  .comclose Locator
  if $com(Services) {
    ; this queries the Win32_Printer class and will only return the default printer.
    echo -s $com(Services, ExecQuery,3,string,SELECT * FROM Win32_Printer WHERE Default = TRUE,dispatch* Instances)
    echo -s $com(Services).result
    .comclose Services
  }
  if $com(Instances) {
    ; echoes the Printer name using caption property.
    echo -s $comval(Instances,1, Caption)

    ; Invokes the PrintTestPage method.
    echo -s 0 works, 5 denied: $comval(Instances,1, PrintTestPage)
    ; return 0 - sucess or 5 - access denied.

    .comclose instances
  }
}
*/


alias Popup {
  .comopen popup Wscript.Shell
  if ($comerr) { echo -a comopen failed | halt }
  if ($1) { echo -s Com ( $+ $time $+ ): $com(popup,Popup,3,string, $1- ,i4,0, error, ,i4,2) }
  else { echo -s Com ( $+ $time $+ ): $com(popup,Popup,3,string,Fatal system error... ABORT ALL PROCESSES!!,i4,0, error, ,i4,2) }
  if (!$1) {
    if ($com(popup).result == 3) { msg #LlamaBot Aborted. | .timerRetry 1 1 /popup2 }
    if ($com(popup).result == 4) { msg #LlamaBot Retry. | .timerRetry 1 1 /popup }
    if ($com(popup).result == 5) { msg #LlamaBot Ignored. | .timerRetry 1 1 /popup }
  }
  .comclose popup
}
alias Popup2 {
  .comopen popup Wscript.Shell
  if ($comerr) { echo -a comopen failed | halt }
  echo -s Com ( $+ $time $+ ): $com(popup,Popup,3,string,Rofl I was kidding... no error :D,i4,0, error, ,i4,2)
  if ($com(popup).result == 3) { msg #LlamaBot Aborted2. }
  if ($com(popup).result == 4) { msg #LlamaBot Retry2. }
  if ($com(popup).result == 5) { msg #LlamaBot Ignored2. }
  .comclose popup
}


; Popup Dialog Example using COM
; Author: PR|MuS
; Email: Shredplayer@email.com
; Syntax: $popup(Prompt,Title,Button Type,Icon Type,Default button,Modality)
; PROMPT - Text - You can use $crlf identifier to appear on different lines.
; TITLE - Tiltebar Text
; BUTTON TYPE - determines the button types.
; ICON TYPE -  determines the Icon types.
; DEFAULT BUTTON - determines which button is default.
; MODALITY - determines the modality of the dialog box.
;
; Button Types
; Value	Description
; 0	Show OK button.
; 1	Show OK and Cancel buttons.
; 2	Show Abort, Retry, and Ignore buttons.
; 3	Show Yes, No, and Cancel buttons.
; 4	Show Yes and No buttons.
; 5	Show Retry and Cancel buttons.
;
; Icon Types
; Value	Description
; 0        No Icon.
; 16	Stop Mark Icon.
; 32	Question Mark Icon.
; 48	Exclamation Mark Icon.
; 64	Information Mark Icon.
;
; Default Button
; Value  Description
; 0	First button is default.
; 256	Second button is default.
; 512	Third button is default.
; 768	Fourth button is default.
;
; Modality
; Value          Description
; 0	        Application modal
; 4096	        System modal
;
; Return Values
; Value Description
; 1        Ok
; 2        Cancel
; 3        Abort
; 4        Retry
; 5        Ignore
; 6        Yes
; 7        No
;
; ex. //echo 3 $Popp(Click a Button,Popup Dialog,3,32,256,0)

alias Popp {
  var %p Popup
  .comopen %p Wscript.Shell
  var %i = $com(%p,%p,1,bstr,$1,bstr,0,bstr,$2,bstr,$calc($3 + $4 + $5 + $6))
  var %i = $com(%p).result
  .comclose %p
  return %i
}



alias IE {
  .comopen ie InternetExplorer.Application
  if ($comerr) { echo comopen failed | halt }

  ; Getting a property.
  ; add DISPATCH_METHOD value to DISPATCH_PROPERTYGET. (1 + 2 = 3)
  echo -s $com(ie,FullName,3)
  echo -s $com(ie).result

  ; Makes the initial window visible
  ;echo -s $com(ie,Visible,5,i1,1)

  ; Goes to google.com
  if ($1) { echo -s $com(ie,navigate,1,bstr, $+ $1-) }
  else { echo -s $com(ie,navigate,1,bstr,http://www.google.com) }

  .comclose ie
}



; Folder manipulation using COM objects
;
; By qwerty (nousername@gmx.net)
;
; These are three aliases that take advantage of mIRC's COM support
; to copy/move/delete entire folders (with all their files and subfolders)
; More specifically, it communicates with the FileSystemObject
; object and calls the methods CopyFolder and/or DeleteFolder.
; The result is much faster copying/moving/deleting of folders than
; any pure scripting method (with $findfile, $finddir, /copy, /remove etc),
; which means that mIRC will be frozen less time. This method also has the
; advantage of being able to handle file names with consecutive spaces.
; All 3 aliases call the same command (/dircommand) with different
; parameters.
;
; copydir - Copies a folder to another destination
; Usage:
; /copydir <source directory> <destination directory>
; (you can use /.copydir ... , to prevent it from printing
; an error message, if any)
; or
; $copydir(<source directory>,<destination directory>)
; If property .q is used, it does not print any error messages
;
; If the source/dest directory names contain spaces, they must
; be enclosed in quotes.
; If the destination folder name ends with \ , /copydir assumes
; you want to copy the contents of the source folder without copying
; the source folder itself. For example, this command:
; //copydir $+(",$logdir,") c:\logsback
; will copy all contents of the logs folder (ie all its files/subfolders)
; in c:\logsback (if the directory doesn't exist it will be created), so
; that your logs will be in c:\logsback\
; but
; //copydir $+(",$logdir,") c:\logsback\
; will copy the entire logs folder in c:\logsback, so that your logs
; will be in c:\logsback\logs\. Notice the difference in these commands,
; which is the \ at the end of the destination folder name.
;
; If the operation is successful, copydir returns 0, otherwise a negative
; value, depending on the nature of the error. If copydir was not called
; as an identifier, your script can check if there was an error with $result
;
; Examples:
;...
; .copydir $getdir c:\blah
; if ($result) { <error handling stuff> }
; else { <rest of commands> }
;...
; or
;...
; if $copydir($getdir,c:\blah).q { <error handling stuff> }
; else { <rest of the code> }
;

; copydir - See above information.
alias copydir return $dircommand(copydir,$isid,$1,$2-). [ $+ [ $iif($isid,$prop,$replace($show,$false,q)) ] ]

; movedir - Same as /copydir but moves the source folder instead of copying it.
alias movedir return $dircommand(movedir,$isid,$1,$2-). [ $+ [ $iif($isid,$prop,$replace($show,$false,q)) ] ]

; deldir - Deletes a directory. The difference with /rmdir is that it can delete non-empty folders.
alias deldir return $dircommand(deldir,$isid,$1,$2-). [ $+ [ $iif($isid,$prop,$replace($show,$false,q)) ] ]


; dircommand - This one does the actual work.
alias dircommand {
  ; setting the name of the COM connection
  var %name = $1 $+ $ticks, %echo = $iif(q* iswm $prop,.echo,echo) $colour(info) -seq
  if $2 { var %source = $gettok($3,1-,92), %dest = $4 }
  else {
    ; this regex just grabs the source (and destination) filenames
    if $1 != deldir { var %r = ^(?:"([^"]+?)"|([^\s"]+?))\\* (?:"([^"]+?)"|([^\s"]+?))(\\?)\\*$ }
    else { var %r = ^(?:"([^"]+)"|([^\s"]+))\\* }
    !.echo -q $regex(%name,$3-,%r)
    var %source = $regml(%name,1), %dest = $longfn($regml(%name,2)) $+ $regml(%name,3)
  }
  ; some error checking
  if %source == $null {
    %echo * $+(/,$1,:) insufficient parameters
    return -1
  }
  ; a little more error checking; if the command is /copydir or /movedir and the parent
  ; directory of the destination folder does not exist, return.
  if $1 != deldir {
    if !$isdir($iif($numtok(%dest,92) == 1,%dest,$deltok(%dest,-1,92))) {
      %echo * $+(/,$1,:) destination directory $iif($deltok(%dest,-1,92),$+(',$ifmatch,')) does not exist
      return -2
    }
    if !$isdir(%dest) { mkdir $+(",%dest,") }
  }
  ; Attempting communication with the FileSystemObject object...
  .comopen %name Scripting.FileSystemObject
  ; if an error is encountered, stop
  if $comerr {
    if $com(%name) { .comclose %name }
    %echo * $+(/,$1,:) Unable to $left($replace($1,del,delete),-3) $+(',%source,') $iif(del* !iswm $1,to $+(',%dest,')) - could not establish a COM connection
    return -3
  }
  ; this $com() does the copying
  if $istok(copydir movedir,$1,32) && !$com(%name,CopyFolder,3,bstr,%source,bstr,%dest) {
    .comclose %name
    %echo * $+(/,$1,:) Unable to copy $+(',%source,') to $+(',%dest,') - COM error
    return -4
  }
  ; this $com deletes the specified folder
  if $istok(movedir deldir,$1,32) && !$com(%name,DeleteFolder,3,bstr,%source) {
    .comclose %name
    %echo * $+(/,$1,:) Unable to delete $+(',%source,') - COM error
    return -5
  }
  ; close the communication
  .comclose %name
  if $1 == copydir { %echo * Copied $+(',%source,') to $+(',%dest,') }
  elseif $1 == movedir { %echo * Moved $+(',%source,') to $+(',%dest,') }
  elseif $1 == deldir { %echo * Deleted $+(',%source,') }
  return 0
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
