;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Help ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/((how )?(do|can) (I|you) (change|set)( the| my)? lang(uage)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change your language settings: /ns set language Number (1=English, 2=French, 3=German, 4=Italian, 5=Portuguese, 6=Spanish, 7=Turkish, 8=Catalan, 9=Greek, 10=Dutch, 11=Russian, 12=Hungarian, 13=Polish)
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set) my (name|nick|user))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change your nick: /nick Nick
} }

on $*:TEXT:/((how )?(do|can) (I|you) (((make (.+) a )?(chan(nel)? )?((half|h)?(-| )?op|voice|admin))|(change|set) (access|permission) ((for|in) my chan(nel)?|level(s)?)))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set access levels in your channel: /cs access #Channel add Nick Level.  Levels: -2=Auto-Kick, 3=Voice, 4=Half-Op, 5-9=Op, 10-9999=Admin
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|turn (on|off)) (secure(-)?(h)?op|secure ((h)?op|operator|level)))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To turn on/off secure-ops (makes it so that you can’t add or remove ops or hops): /cs set #Channel secureops off/on
} }

on *:RAWMODE:#:{ if ($chan !isin %notlist3) {
    if (($nick != ChanServ) && ((+h isin $1) || (+o isin $1))) { %modechange. [ $+ [ $2 $+ . [ $+ [ $chan ] ] ] ] = $nick | .timermodemsg 1 20 unset %modechange. [ $+ [ $2 $+ . [ $+ [ $chan ] ] ] ] }
    else if (($nick == ChanServ) && ((-h isin $1) || (-o isin $1)) && (%modechange. [ $+ [ $2 $+ . [ $+ [ $chan ] ] ] ] )) { msg $chan $col $+ %modechange. [ $+ [ $2 $+ . [ $+ [ $chan ] ] ] ] $+ : To turn on/off secure-ops (makes it so that you can’t add or remove ops or hops): /cs set #Channel secureops off/on | unset %modechange. [ $+ [ $2 $+ . [ $+ [ $chan ] ] ] ] }
} }

on $*:TEXT:/((how )?(do|can) (I|you) (boot|kick) (nicks|people|users|a user|a nick|a person|someone))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To boot someone: /kick #Channel Nick Reason
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set) (a|my) chan(nel)? (key|pass|pw))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set a channel key (password): /mode #Channel +k Key.  To join it: /join #Channel Key
} }

on $*:TEXT:/((how )?(do|can) (I|you) join (a|my) channel (if it|that) has a (key|pass|pw))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To join a channel that has a key (password): /join #Channel Key
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|turn (on|off)) auto(-voice|voice| voice))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set auto-voice: /cs levels #Channel set autovoice Number (-1 for autovoice, 3 to turn it off)
} }

on $*:TEXT:/((how )?(do|can) (I|you) (invite|add|get)( a| this)?( custom)? (bot(s)?|llamabot|you)))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To invite a custom bot (such as RuneScript or LlamaBot) to a channel: /invite BotName #Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) ((un)?assign|invite|add|get)( a)?( service(es)?)? bot(s)?))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To assign/unassign a services bot (such as X) to a channel: /bs (un)assign #Channel BotName
    msg $chan $col $+ $nick $+ : To see a list of the available bots (all do the same things): /bs botlist
} }

on $*:TEXT:/((how )?(do|can) (I|you) (see|view|get) a list of( available)? bot(s)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To see a list of the available bots (all do the same things): /bs botlist
} }

on $*:TEXT:/((how )?(do|can) (I|you) ((change|set|add|turn (on|off))( word)? (censor(s)?|filter(s)?)|(censor|filter) words))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To add a badwords list to your channel: /bs badwords #Channel add/del Word
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|add|turn (on|off)) (flood|spam)( control)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : For flood control: /bs kick #Channel flood on/off Kicks-till-ban Lines Seconds
    ;To have it kick ops and voices (by default it doesn't): /bs set #Chan dontkickops off and /bs set #Chan dontkickvoices off
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|add) a( custom| chan(nel)?)? (greet|welcome))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set a greet for your channel: /cs set #Channel entrymsg Greet.  If no greet is supplied, the entrymsg will be unset.
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|add) (my|a|the)( chan(nel)?)? topic)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change the topic of a channel: /cs topic #Channel Topic.  Or you could do: /topic #Channel Topic
} }

on $*:TEXT:/((how )?(do|can) (I|you) un(-ban| ban|ban) my(self| nick| user))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To unban yourself from a channel you had op+ in, type: /cs unban #Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) un(-ban| ban|ban) (nicks|people|users|a user|a nick|a person|someone))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To unban someone from a channel: /mode #Channel -b Nick/Host
} }

on $*:TEXT:/((how )?(do|can) (I|you) ban (nicks|people|users|a user|a nick|a person|someone))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To ban someone from a channel: /mode #Channel +b Nick/Host
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|turn (on|off))( my| a)? censor(s)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To turn off/on censors: /mode YourNick -f/+f
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set) my (pass|pw))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change your password: /ns set password Pass
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|add) (my own|a) (greet|welcome))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set a greet for yourself: /ns set greet Greet
} }

on $*:TEXT:/((how )?(do|can) (I|you) (use|have) a (part|quit) (msg|message|reason))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To use a quit/part message: /quit Message (or: /part Message)
} }

on $*:TEXT:/((how )?(do|can) (I|you) (part|leave|close) a chan(nel)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To leave a channel: /part #Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) (disconnect|quit|leave|close)( from)? irc)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To disconnect from IRC: /quit
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set|make|use|add) a(n)? (away|afk) (msg|message|reason))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set an away message: /away Reason
} }

on $*:TEXT:/((how )?(do|can) (I|you) reg(ister)? my (name|nick|user))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To register your nick: /ns register Password Email
} }

on $*:TEXT:/((how )?(do|can) (I|you) reg(ister)? (my|a) chan(nel)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To register your channel: /cs register #Channel Password Description
} }

on $*:TEXT:/((how )?(do|can) (I|you) change (my|the|a) chan(nel)? (founder|starter|owner))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change the channel owner: /cs set #Channel founder Nickname
} }

on $*:TEXT:/((how )?(do|can) (I|you) ((msg|message|pm|private (msg|message)) ((my|a) friend|nicks|people|users|a user|a nick|a person|someone)|send a pm))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To speak privately with someone: double click their name on the right sidebar OR: /query Name Message
} }

on $*:TEXT:/((how )?(do|can) (I|you) (recover|release) (my|a) (name|nick|user))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To recover a nick: /ns recover Nick Pass.  Then: /ns release Nick Pass
} }

on $*:TEXT:/((how )?(do|can) (I|you) (see|view)( the| my)?(( chan(nel)?)? access level(s)?|access level(s)? for (the|my|a) (chan(nel)?)?))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To see access levels of a channel: /cs access #Channel list
} }

on $*:TEXT:/(((how )?(do|can) (I|you) ((make|see|view|do|set)( text| this)?( the)?( to)?( diff(erent)?)? color(ful|s)?|color text|add (color|text effects)))|how to color text)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To use colors, hold down the Ctrl key then press k.  Let go of both, then type in the number of the color you want followed by your text.  If you want a background color, put in a comma then a second number followed by the text.  For a list of all the colors, say: !colors
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set)( the| my)?( default| user(s)?)? color)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To change the colors of users on mIRC, press Alt+B then select the colors tab, then click Add. To make the colors similar to the SwiftKit client: //tokenize 46 * 4 @.* 7 % .* 2 +.* 10.on $chr(124) .cnick $!*
} }

on $*:TEXT:/((how )?(do|can) (I|you) (join|go to) (another|a different|a) chan(nel)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To join another channel: /join #Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) (get|find) (my|a) chan(nel)? (key|pass|pw))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To get the key to a channel: /cs getkey #Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) (erase|clear|get rid of) my (chan(nel)?(s)?)? access( list)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To clear your channel's access list: /cs access #Channel clear
} }

on $*:TEXT:/((how )?(do|can) (I|you) (erase|clear|get rid of) my (chan(nel)?(s)?)? (akick|auto(-| )?kick)( list)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To clear your channel's akick list: /cs akick #Channel clear
} }

on $*:TEXT:/((how )?(do|can) (I|you) (erase|clear|get rid of) my (chan(nel)?(s)?)? ban( list)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To clear your channel's ban list: /cs clear #Channel bans
} }

on $*:TEXT:/((how )?(do|can) (I|you) lock (my|the|a) topic)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To lock your topic: /cs set #Channel topiclock on/off
} }

on $*:TEXT:/((how )?(do|can) (I|you) (see|view|list)( all( of)?)? my( own)? access( level(s)?)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To see what access you have in other channels: /ns alist
} }

on $*:TEXT:/((how )?(do|can) (I|you) (send|give)( a memo to)? (nicks|people|users|a user|a nick|a person|someone)( a memo)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To send a memo: /ms send Nick Message
} }

on $*:TEXT:/((how )?(do|can) (I|you) (clear|empty|kick (all( users| nicks| people)?|everyone)) (from (my|a) chan(nel)?|a chan(nel)?))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To clear channel of users: /cs clear #Channel users
} }

on $*:TEXT:/((how )?(do|can) (I|you) (un(-| )?group|drop) (a|my) (name|nick|user))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To drop a nick from a group: /ns drop Nick
} }

on $*:TEXT:/((how )?(do|can) (I|you) (set|make) a chan(nel)? (transfer|link))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To have one channel transfer you to another: /cs set #Channel mlock +lL 1 #Linked-Channel
} }

on $*:TEXT:/((how )?(do|can) (I|you) (make|create|start) a (new)? chan(nel)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To start a new channel, simply join an empty one (/join #Channel) then register it (/cs register #Channel Password Description)
} }

on $*:TEXT:/((how )?(do|can) (I|you) (disconnect|ghost) (nicks|people|users|a user|a nick|a person|someone|my(-| )?self|a( )?nother))/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To ghost someone (disconnect them): /ns ghost Nick NicksPassword
} }

on $*:TEXT:/((how )?(do|can) (I|you) (change|set)( a| the| my)?( chan(nel)?(s)?)? mode(s)?)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To set a mode: /mode #Channel/Nick +/-Mode (To see a list of modes: /helpop chmodes)
} }

/*
on $*:TEXT:/((how )?(do|can) (I|you) set mode (\+|-)?m)/Si:#:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : To make it so only voices+ can talk: /mode #Channel +m
} }
/+e /say Mode e (overrides channel bans): /mode #channel +e nick/host
/-e /say Mode e (turns off override of channel bans): /mode #channel -e nick/host
/+k /say Mode k (key required to join): /mode #channel +k key
/-k /say Mode k (no key required to join): /mode #channel -k key
/+p /say Mode p (blocks others from seeing what channels you are on with whois): /mode nick +p
/-p /say Mode p (removes the block from seeing what channels you are on with whois): /mode nick -p
/+s /say Mode s (blocks others from seeing what channels you are on with whois and list): /mode nick +s
/-s /say Mode s (removes the block from seeing what channels you are on with whois and list): /mode nick -s
/+f /say Mode f (adds censors): /mode #channel +f
/-f /say Mode f (no censors): /mode #channel -f
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
