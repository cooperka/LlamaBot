;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/op /mode # +ooo $$1 $2 $3
/dop /mode # -ooo $$1 $2 $3
/dhop /mode # -hhh $$1 $2 $3
/sethop { { /mode # +h $me } { /mode # -o $me } }
/setvoice { { /mode # +v $me } { /mode # -h $me } { /mode # -o $me } }
/send /dcc send $1 $2
/chat /dcc chat $1
/ping /ctcp $$1 ping

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/identify /say To identify for your nick: /ns id YourPass
/swiftcolor /say To change the colors of people on mIRC, press Alt+B then select the colors tab, then click Add. To make the colors similar to the SwiftKit client, type: //tokenize 46 * 4 ~&@.* 7 % .* 2 +.* 10.on $chr(124) .cnick $!*
/lang /say To change your language settings: /ns set language Number (1-English, 2-French, 3-German, 4-Italian, 5-Portuguese, 6-Spanish, 7-Turkish, 8-Catalan, 9-Greek, 10-Dutch, 11-Russian, 12-Hungarian, 13-Polish)
/regcode /say To register mIRC: press alt, h, r, then in type your registration info.
/changenick /say To change your nick: /nick Nick
/accesslevel /say To set access levels in your channel: /cs access #channel add nick level.  Levels: -2 AutoKick, 3 voice, 4 Half-Op, 5-9 Op, 10-9999 Admin-Op
/setaccess /say To set access levels in your channel: /cs access #channel add nick level.  Levels: -2 AutoKick, 3 voice, 4 Half-Op, 5-9 Op, 10-9999 Admin-Op
/secureops /say To turn on/off secure-ops (makes it so that you can’t add or delete ops or hops): /cs set #channel secureops off/on
/bootsomeone /say To boot someone: /kick #channel nick reason
/kicksomeone /say To boot someone: /kick #channel nick reason
/key /say To set a channel key (password): /mode #channel +k key.  To join it: /join #channel key
/voiceonly /say Only voices can talk: /mode #channel +m
/autovoice /say To auto-voice: /cs levels #Channel set autovoice -1 (3 to reverse)
/invitebot /say To invite a custom bot: /invite BotName #channel
/custombot /say To invite a custom bot: /invite BotName #channel
/assignbot /say To assign/unassign a services bot: /bs (un)assign #channel BotName (List of bots: /bs botlist)
/servicebot /say To assign/unassign a services bot: /bs (un)assign #channel BotName (List of bots: /bs botlist)
/botlist /say To see a list of bots type: /bs botlist
/censor /say To censor words: /bs badwords #channel add word
/flood /say Flood control: /bs kick #channel flood on/off Kicks-till-ban Lines Seconds.  To have it kick ops and voices (by default it doesn't): /bs set #chan dontkickops off and /bs set #chan dontkickvoices off
/greet /say To set a greet for your channel (must have a service bot): /cs set #channel entrymsg Greet
/stopnamechange /say To stop name changing: /mode #channel +n
/settopic /say To change the topic of the channel: /cs topic #channel topic.  Or: /topic #channel topic
/unbanself /say To unban yourself from a channel you had op+ in type: /cs unban #channel
/unbanother /say To unban someone from your channel: /mode #channel -b nick/host
/nocensor /say To turn off censors: /mode Name -f
/changepass /say To change your password: /ns set password pass
/setpass /say To change your password: /ns set password pass
/selfgreet /say To set a greet for yourself: /ns set greet greet
/personalgreet /say To set a greet for yourself: /ns set greet greet
/quitmessage /say To make a quit message: /quit message
/awaymessage /say To make an away message: /away message
/needvoice /say To set mode +m (channel mute, need a voice to speak): /mode #channel +m
/setmute /say To set mode +m (channel mute, need a voice to speak): /mode #channel +m
/registernick /say To register your nick: /ns register password samePassword email sameEmail
/regnick /say To register your nick: /ns register password email
/registerchannel /say To register your channel: /cs register #channel password description
/registerchan /say To register your channel: /cs register #channel password description
/regchan /say To register your channel: /cs register #channel password description
/changeowner /say To change owner: /cs set #channel founder nickname
/pm /say To pm someone: double click their name on the right sidebar OR /query name message
/recover /say To recover a nick: /ns recover nick pass.  Then: /ns release nick pass
/channelaccess /say To see access levels of a channel: /cs access #channel list
/accesslist /say To see access levels of a channel: /cs access #channel list
/color /say For help with colors while in #irchelp type: !clist
/banchannel /say To ban a channel: /mode #channel +b ~c:#chan-to-ban
/setban /say To ban someone: /mode #channel +b nick/host
/banperson /say To ban someone: /mode #channel +b nick/host
/joinchannel /say To join another channel: /join #channel
/joinchan /say To join another channel: /join #channel
/getkey /say To get the key to a channel: /cs getkey # channel
/clearaccess /say To clear your access list: /cs access #channel clear
/clearakick /say To clear your akick list: /cs akick #channel clear
/clearaban /say To clear your aban list: /cs clear #channel bans
/topiclock /say To lock your topic: /cs set #channel topiclock on/off
/selfaccess /say To see what access you have in other channels: /ns alist
/cant /say That is not possible to do.
/whathelp /say What do you need help with?
/memo /say To send a memo: /ms send nick message
/clearchannel /say To clear channel of users: /cs clear #channel users
/changeserver /say To be able to join the channels you can in SwiftKit: /server IRC.SwiftIRC.net:6667
/swiftkit /say To be able to join the channels you can in SwiftKit: /server IRC.SwiftIRC.net:6667
/joinsk /say To be able to join the channels you can in SwiftKit: /server IRC.SwiftIRC.net:6667
/swiftirc /say To be able to join the channels you can in SwiftKit: /server IRC.SwiftIRC.net:6667
/dropnick /say To drop your nick: /ns drop nick
/transferchannel /say To have a channel transfer you to another one: /cs set #channel mlock +lL 1 #linked-channel
/makechannel /say First do: /join #channel .  Then: /cs register #channel password description
/registerchannel /say First do: /join #channel .  Then: /cs register #channel password description
/ghost /say To ghost someone (disconnect them): /ns ghost Nick NicksPassword
/modehelp /say To set a mode type /mode #channel mode nick/host and type /helpop ?chmodes to see a list of modes.
/modes /say To set a mode type /mode #channel mode nick/host and type /helpop ?chmodes to see a list of modes.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/setup {
  /say To set up mIRC, do all of the following few steps.
  /say View > Font > [Type] Verdana, [Check] Set as default, [Check] Use default, [OK].  You may have to do this for the Status window and private chats as well.
  /say Favorites > Organize Favorites > [Click] the first item in the list, hold [Shift], [Click] the last item in the list, [Click] Delete.  [Click] Add, [Type] #LlamaBot as the Channel, [Check] Join on connect, [OK], [Uncheck] Pop up favorites on connect, [OK].
  /say Tools > Options > + Connect > Options > [Uncheck] Pop up connect dialog on startup, [OK]
  /say To copy information on mIRC, select the text, then release the mouse.  The text will deselect, and will automatically be copied.  [Copy] this and [Paste] it into the chat bar, exactly the same as if you were saying it out loud: //tokenize 46 * 4 ~&@.* 7 % .* 2 +.* 10.on $chr(124) .cnick $!*
  ;timestamp seconds, enable logging
  ;register nick
  ;register mirc
  ;how to PM
  ;get tips
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/tut {
  msg $chan mSL (mIRC's language, like Java or C++) is action-based. $&
    That means, unlike Java or C++, it only does things when something $&
    else triggers it.  At the top of your mIRC window, press the $&
    Scripts Editor button and click the Remote tab to start writing.
}
/tut2 {
  msg $chan The basic format for a Remote command is as follows: $&
    on *:TEXT:TextHere:#Channel: $+ $chr(123) Action $chr(125)
  msg $chan With that code, if someone types "TextHere" in the channel #Channel, $&
    it will do Action.  Scripts written in Remote can't be activated by you.
}
/tut3 {
  msg $chan Another tab within the Scripts Editor is Aliases.  Click that. $&
    The basic format for an Alias command is as follows: $&
    /Keyword $chr(123) Action $chr(125)
  msg $chan For the above script, when you type "/Keyword" it will do Action. $&
    Aliases can only be activated by you.
}
/remo {
  msg $chan Here is an example of a script in Remote: $&
    on *:TEXT:Hello:#: $+ $chr(123) msg $chr(36) $+ chan Hi! $chr(125)
  msg $chan That script will activate in any channel (because nothing is $&
    specified after the '#') when anyone says "Hello".  If someone $&
    does, you will automatically say "Hi!" back.
}
/ali {
  msg $chan Here is an example of a script in Aliases: $&
    /sayHi $chr(123) msg $chr(36) $+ chan Hi, everyone! $chr(125)
  msg $chan That script will activate whenever you type "/sayHi".  If you $&
    do, you will automatically say "Hi, everyone!" in whatever channel you are  currently in.
}
/vars {
  msg $chan Another neat feature of mIRC is Variables (click that tab in $&
    the Scripts Editor.)  Using this, you can store values on your $&
    computer.  All variables start with the '%' character. $&
    For more complex help with variables, type: /help Variables
}
/info {
  msg $chan If you want help writing scripts and I am not available, you can $&
    go to the channel #mSL (do so by typing: /join #mSL). $&
    Before going there, though, try typing this: /help Topic
}
/sockhelp { msg $chan For some basic help with sockets, see http://paste.stirk.org/31084 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
