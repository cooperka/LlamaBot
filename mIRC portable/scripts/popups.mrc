[mpopup]
n0=Server
n1=.Lusers:/lusers
n2=.Motd:/motd
n3=.Time:/time
n4=Names
n5=.#mIRC:/names #mirc
n6=.#irchelp: /names #irchelp
n7=.names ?:/names #$$?="Enter a channel name:"
n8=Join
n9=.#mIRC:/join #mirc
n10=.#irchelp:/join #irchelp
n11=.join ?:/join #$$?="Enter a channel to join:"
n12=Query
n13=.query ?:/query $$?="Enter nickname to talk to:"
n14=Other
n15=.Whois ?:/whois $$?="Enter a nickname:"
n16=.Query:/query $$?="Enter a nickname:"
n17=.Nickname:/nick $$?="Enter your new nickname:"
n18=.Away
n19=..Set Away...:/away $$?="Enter your away message:"
n20=..Set Back:/away
n21=.List Channels:/list
n22=-
n23=Edit Notes:/run notepad.exe notes.txt
n24=Quit IRC:/quit Leaving

[bpopup]
n0=Commands
n1=Query user:/query $$?="Enter nickname and message:"
n2=Send notice:/notice $$?="Enter nickname and message:"
n3=Whois user:/whois $$?="Enter nickname:"
n4=Send CTCP
n5=.Ping:/ctcp $$?="Enter nickname:" ping
n6=.Time:/ctcp $$?="Enter nickname:" time
n7=.Version:/ctcp $$?="Enter nickname:" version
n8=Set Away
n9=.On:/away $$?="Enter away message:"
n10=.Off:/away
n11=Invite user:/invite $$?="Enter nickname and channel:"
n12=Ban user:/ban $$?="Enter channel and nickname:"
n13=Kick user:/kick $$?="Enter channel and nickname:"
n14=Ignore user:/ignore $$?="Enter nickname:"
n15=Unignore user:/ignore -r $$?="Enter nickname:"
n16=Quit IRC:/quit
[lpopup]
n0=Info:/uwho $1
n1=Whois:/whois $$1
n2=Query:/query $$1
n3=-
n4=Set Access
n5=.Op:/mode # +ooo $$1 $2 $3
n6=.Deop:/mode # -ooo $$1 $2 $3
n7=.Hop:/mode # +hhh $$1 $2 $3
n8=.Dehop:/mode # -hhh $$1 $2 $3
n9=.Voice:/mode # +vvv $$1 $2 $3
n10=.Devoice:/mode # -vvv $$1 $2 $3
n11=Ban/Kick/Ignore
n12=.Ignore:/ignore $$1 1
n13=.Unignore:/ignore -r $$1 1
n14=.Kick:/kick # $$1
n15=.Kick (why):/kick # $$1 $$?="Reason:"
n16=.Ban:/ban $$1 2
n17=.Ban, Kick:/ban $$1 2 | /timer 1 1 /kick # $$1
n18=.Ban, Kick (why):/ban $$1 2 | /timer 1 1 /kick # $$1 $$?="Reason:"
n19=CTCP
n20=.Ping:/ctcp $$1 ping
n21=.Time:/ctcp $$1 time
n22=.Version:/ctcp $$1 version
n23=DCC
n24=.Send:/dcc send $$1
n25=.Chat:/dcc chat $$1
n26=-
n27=Invite Bots
n28=.DustBot:/invite dustbot $chan
n29=.Vectra:/invite vectra $chan
n30=.RuneScript:/invite runescript $chan
n31=-
n32=Slap:/me slaps $$1 around a bit with an enourmous trout!
n33=Huggle:/me huggles $$1 4<3
n34=Cookie:/me gives $$1 a cookie
n35=-
n36=Kick:/kick # $$1

[qpopup]
n0=Info:/uwho $$1
n1=Whois:/whois $$1
n2=Query:/query $$1
n3=-
n4=Ignore:/ignore $$1 1 | /closemsg $$1
n5=-
n6=CTCP
n7=.Ping:/ctcp $$1 ping
n8=.Time:/ctcp $$1 time
n9=.Version:/ctcp $$1 version
n10=DCC
n11=.Send:/dcc send $$1
n12=.Chat:/dcc chat $$1
n13=-
n14=Log:/run $mircdir $+ logs\ $+ $replace($$1,$chr(124),_) $+ .SwiftIRC.log

[cpopup]
n0=Channel Modes:/channel
n1=Log:/run $mircdir $+ logs\ $+ $replace($chan,$chr(124),_) $+ .SwiftIRC.log
