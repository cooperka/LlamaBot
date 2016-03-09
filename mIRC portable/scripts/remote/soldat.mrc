;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias host { run C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldatserver.exe }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on ^$*:TEXT:/^(\[r\])[!@]/Si:#LlamaBot,?:{
  endProcess soldatserver.exe | host
  msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ server has been rehosted with the following changes:
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^!(soldat|sd)(map|download|dl)/Si:#LlamaBot,?:{ notice $nick You can download the new Soldat maps from http://llamabot.webs.com/maps.rar (if you don't have WinRAR, you can get it from http://download.cnet.com/WinRAR/3000-2250_4-10007677.html?tag=mncol ) }
on $*:TEXT:/^@(soldat|sd)(map|download|dl)/Si:#LlamaBot,?:{ msg #LlamaBot $col(#LlamaBot) $+ You can download the new Soldat maps from http://llamabot.webs.com/maps.rar (if you don't have WinRAR, you can get it from http://download.cnet.com/WinRAR/3000-2250_4-10007677.html?tag=mncol ) }

on $*:TEXT:/((how |where )?((do|can) (I|you) (get|d(own)?l(oad)?|have|obtain)|(are|r))( th(e|ose|ese)| (yo)?ur)?( new)?( s(ol)?d(at)?)? map)/Si:#LlamaBot:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : You can download the new Soldat maps from http://llamabot.webs.com/maps.rar (if you don't have WinRAR, you can get it from http://download.cnet.com/WinRAR/3000-2250_4-10007677.html?tag=mncol )
} }

on $*:TEXT:/(I need( the| your)?( s(ol)?d(at)?)? map)/Si:#LlamaBot:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : You can download the new Soldat maps from http://llamabot.webs.com/maps.rar (if you don't have WinRAR, you can get it from http://download.cnet.com/WinRAR/3000-2250_4-10007677.html?tag=mncol )
} }

on $*:TEXT:/(It says( that( it)?| it)? ("|')?(could not|couldn(')?t) d(own)?l(oad)?( the| a)? file)/Si:#LlamaBot:{ if ($chan !isin %notlist3) {
    msg $chan $col $+ $nick $+ : You can download the new Soldat maps from http://llamabot.webs.com/maps.rar (if you don't have WinRAR, you can get it from http://download.cnet.com/WinRAR/3000-2250_4-10007677.html?tag=mncol )
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


on $*:TEXT:/^!((sd|soldat)( |-)?(web)?( |-)?site)/Si:#LlamaBot:{ notice $nick The LlamaBot Soldat commands can be found at http://llamabot.webs.com/Soldat.htm }
on $*:TEXT:/^@((sd|soldat)( |-)?(web)?( |-)?site)/Si:#LlamaBot:{ msg #LlamaBot $col(#LlamaBot) $+ The LlamaBot Soldat commands can be found at http://llamabot.webs.com/Soldat.htm }


on $*:TEXT:/^(\[r\])?[!@](s(d)?|soldat)(-)?(g|game)(-)?(s|stat)/Si:#LlamaBot,?:{
  set %sdGMsg $iif($left($1,1) == @, msg #LlamaBot, notice $nick) $col(#LlamaBot)
  if ($remove($read(%sdGame, 2), Players:) != $chr(32) $+ 0) {
    %sdGMsg $+ Current Soldat server stats:
    %sdGMsg $+ $replace($read(%sdGame, 2),Players:,Players:) | $replace($read(%sdGame, 3),Map:,Map:) | $replace($read(%sdGame, 4),Gamemode:,Gamemode:) | $replace($read(%sdGame, 5),Timeleft:,Time left:)
  }
  else { %sdGMsg $+ There is no Soldat game currently going on. }
  unset %sdIP %sdGMsg
}


on $*:TEXT:/^(\[r\])?[!@](sd|soldat)(-)?(stat|s)/Si:#LlamaBot,?:{
  if ($2) {
    set %sdMsg $iif($left($1,1) == @, msg #LlamaBot, notice $nick) $col(#LlamaBot)
    var %i = 1 | while (%i < $lines(%sdRec)) {
      if ($read(%sdRec, %i) == name= $+ $2-) { %sdIP = $replace($read(%sdRec, $calc(%i - 1)),[,,],) | goto A }
      inc %i
    }
    :A
    if (%sdIP) {
      %sdMsg $+ Soldat stats for $readini(%sdRec, %sdIP, name) $+ :
      %sdMsg $+ Kills: $readini(%sdRec, %sdIP, kills) | Deaths: $readini(%sdRec, %sdIP, deaths) | K/D ratio: $calc($floor($calc($readini(%sdRec, %sdIP, kills) / $readini(%sdRec, %sdIP, deaths) * 1000)) / 1000)
      ;| Time in-game: $calc($floor($calc($readini(%sdRec, %sdIP, time) / 60 * 10)) / 10) minutes.
    }
    else { %sdMsg $+ That Soldat username was not found. }
    unset %sdIP %sdMsg
  }
  else { notice $nick Please specify a name to get the stats for. }
}


on $*:TEXT:/^(\[r\])?[!@]((start)?server(host|open|start)?|host(server)?)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ($2) {
      if ($2 == none) {
        write -r/^Game_Password=/ C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini Game_Password=
        msg #LlamaBot $col(#LlamaBot) $+ I have just hosted a Soldat server named ~GPN~ - no pass required, the IP is $ip and the port is 23093
      }
      else {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Game_Password $2-
        msg #LlamaBot $col(#LlamaBot) $+ I have just hosted a Soldat server named ~GPN~ - the pass is $2- the IP is $ip and the port is 23093
      }
    }
    else {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Game_Password north
      msg #LlamaBot $col(#LlamaBot) $+ I have just hosted a Soldat server named ~GPN~ - the pass is north the IP is $ip and the port is 23093
    }
    host
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](server)?(rehost|\[r\])/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ($2) {
      if ($2 == none) {
        write -r/^Game_Password=/ C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini Game_Password=
        msg #LlamaBot $col(#LlamaBot) $+ I have just re-hosted the ~GPN~ Soldat server - no pass required, the IP is $ip and the port is 23093
      }
      else {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Game_Password $2-
        msg #LlamaBot $col(#LlamaBot) $+ I have just re-hosted the ~GPN~ Soldat server - the pass is $2- the IP is $ip and the port is 23093
      }
    }
    else {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Game_Password north
      msg #LlamaBot $col(#LlamaBot) $+ I have just re-hosted the ~GPN~ Soldat server - the pass is north the IP is $ip and the port is 23093
    }
    endProcess soldatserver.exe | host
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](server|s(ol)?d(at)?)?(close|quit|unhost)/Si:#LlamaBot,?:{ if (((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) && (!$2)) {
    endProcess soldatserver.exe | msg #LlamaBot $col(#LlamaBot) $+ I have just closed the ~GPN~ Soldat server.
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](server)?(addmap|am)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    addmap $2-
} | else { notice $nick You don't have the access level to do that. } }

alias addmap {
  tokenize 32 $remove($1-,$chr(44))
  var %i = 1 | while (%i <= $0) {
    if ($file(C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\maps\ $+ $ [ $+ [ %i ] ] $+ .PMS)) {
      write C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt $ [ $+ [ %i ] ]
      if %MapAdd { %MapAdd = %MapAdd $+ $chr(44) }
      %MapAdd = %MapAdd $col2(#LlamaBot) $+  $+ $ [ $+ [ %i ] ] $+ $col(#LlamaBot) $+ 
    }
    else {
      if (%mapdoesnt) { %mapdoesnt = %mapdoesnt $+  $+ $chr(44) $+  $ [ $+ [ %i ] ] }
      else { %mapdoesnt = These maps were not found: $ [ $+ [ %i ] ] }
    }
    inc %i
  }
  if (%MapAdd) { msg #LlamaBot $col(#LlamaBot) $+ I have added the following map(s) to the ~GPN~ Soldat server: %MapAdd $+ . (Rehost required) }
  else { msg #LlamaBot $col(#LlamaBot) $+ No maps have been added. }
  if (%mapdoesnt) { msg #LlamaBot $col(#LlamaBot) $+ %mapdoesnt }
  unset %MapAdd %mapdoesnt
}

on $*:TEXT:/^(\[r\])?[!@](server)?(setmap|sm )/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ((*norm* iswm $1-) || (*def* iswm $1-)) {
      write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt
      tokenize 32 MrSnowman Villa Blox Bridge Bunker RatCave Cambodia Daybreak Tropiccave
      var %i = 1 | while (%i <= $0) {
        write C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt $ [ $+ [ %i ] ]
        if %MapAdd { %MapAdd = %MapAdd $+ $chr(44) }
        %MapAdd = %MapAdd $col2(#LlamaBot) $+  $+ $ [ $+ [ %i ] ] $+ $col(#LlamaBot) $+  | inc %i
      }
      msg #LlamaBot $col(#LlamaBot) $+ I have set the following maps on the ~GPN~ Soldat server: %MapAdd $+ . (Rehost required)
    }
    else if (((*ctf* iswm $1-) && (*ctf_* !iswm $1-)) || (*cap* iswm $1-) || ((*htf* iswm $1-) && (*htf_* !iswm $1-)) || (*hold* iswm $1-)) {
      write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt
      tokenize 32 Castle_Wars OpenFlag DP2 ShortLong ctf_Ash
      var %i = 1 | while (%i <= $0) {
        write C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt $ [ $+ [ %i ] ]
        if %MapAdd { %MapAdd = %MapAdd $+ $chr(44) }
        %MapAdd = %MapAdd $col2(#LlamaBot) $+  $+ $ [ $+ [ %i ] ] $+ $col(#LlamaBot) $+  | inc %i
      }
      msg #LlamaBot $col(#LlamaBot) $+ I have set the following maps on the ~GPN~ Soldat server: %MapAdd $+ . (Rehost required)
    }
    else if ((*saw* iswm $1-) || (*small* iswm $1-)) {
      write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt
      tokenize 32 Arena2 Arena2_2
      var %i = 1 | while (%i <= $0) {
        write C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt $ [ $+ [ %i ] ]
        if %MapAdd { %MapAdd = %MapAdd $+ $chr(44) }
        %MapAdd = %MapAdd $col2(#LlamaBot) $+  $+ $ [ $+ [ %i ] ] $+ $col(#LlamaBot) $+  | inc %i
      }
      msg #LlamaBot $col(#LlamaBot) $+ I have set the following maps on the ~GPN~ Soldat server: %MapAdd $+ . (Rehost required)
    }
    else {
      write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt
      msg #LlamaBot $col(#LlamaBot) $+ ~GPN~ maps have been cleared...
      addmap $2-
    }
    unset %MapAdd
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](server)?(clear|c)(map|m$|list)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt | msg #LlamaBot $col(#LlamaBot) $+ I have just cleared the ~GPN~ maps list. (Rehost required)
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](uba|(clear(all)?ban|unbanall))/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\banned.txt | msg #LlamaBot $col(#LlamaBot) $+ I have unbanned all accounts from ~GPN~. (Rehost required)
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@]((set|add)?(rand(om)?)?bot|ab |sb )/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ($2- isin off none zero) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_1 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_2 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_3 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_4 0
      msg #LlamaBot $col(#LlamaBot) $+ There are no longer any bots in ~GPN~. (Rehost required)
    }
    else {
      if ($calc($2 + $3 + $4 + $5) > 30) { notice $nick The max number of bots is 30.  You have $calc($2 + $3 + $4 + $5) $+ . }
      else if ((($2 isnum) && ($2 >= 0)) && ((!$3) || (($3 isnum) && ($3 >= 0))) && ((!$4) || (($4 isnum) && ($4 >= 0))) && ((!$5) || (($5 isnum) && ($5 >= 0)))) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots $calc($2 + $3 + $4 + $5)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_1 $iif($2,$2,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_2 $iif($3,$3,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_3 $iif($4,$4,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_4 $iif($5,$5,0)
        msg #LlamaBot $col(#LlamaBot) $+ There are now $calc($2 + $3 + $4 + $5) bots in ~GPN~:04 $iif($2,$2,0) 12 $+ $iif($3,$3,0) 08 $+ $iif($4,$4,0) 09 $+ $iif($5,$5,0) $col(#LlamaBot) $+ (Rehost required)
      }
      else { notice $nick Invalid format: !setbots Alpha:0-30 (Bravo:0-30) (Charlie:0-30) (Delta:0-30) }
    }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](smp |(set)?(max(imum)?)?(ping))/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if (($2 isnum) && ($2 >= 0) && ($2 <= 999)) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Max_Ping $2
      msg #LlamaBot $col(#LlamaBot) $+ The max ping for ~GPN~ is now $2 (Rehost required)
    }
    else { notice $nick Invalid format: !smp Ping:0-999 }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](s(m)?g |(set)?(max(imum)?)?(gren))/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if (($2 isnum) && ($2 >= 0) && ($2 <= 5)) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades $2
      msg #LlamaBot $col(#LlamaBot) $+ The grenade limit for ~GPN~ is now $2 (Rehost required)
    }
    else { notice $nick Invalid format: !smg Grenades:0-5 }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^@(soldat|sd)( )?(cmd|command|help)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    msg #LlamaBot $col(#LlamaBot) $+ Soldat commands (in-game only) are as follows --
    msg #LlamaBot $col(#LlamaBot) $+ !pause (or !p) - pauses the game, !unpause (or !up) - unpauses the game, !restart (or !r) - restarts the game, !unbanlast (or !ub) - unbans the last player banned
    msg #LlamaBot $col(#LlamaBot) $+ !map <map> - changes to that map, !next (or !n) - starts a new game on the next map (currently not working completely), !alpha / !bravo / !spec - sets you to the specified team (!spec means spectator)
} | else { notice $nick You don't have the access level to do that. } }

on $*:TEXT:/^!(soldat|sd)( )?(cmd|command|help)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    notice $nick Soldat commands (in-game only) are as follows --
    notice $nick  !pause (or !p) - pauses the game, !unpause (or !up) - unpauses the game, !restart (or !r) - restarts the game, !unbanlast (or !ub) - unbans the last player banned
    notice $nick  !map <map> - changes to that map, !next (or !n) - starts a new game on the next map (currently not working completely), !alpha / !bravo / !spec - sets you to the specified team (!spec means spectator)
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@]((set)?( |-)?(game|server|weapon|wep)( |-)?(type|style|mode)|gt )/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ((*help* iswm $1-) || (*info* iswm $1-)) {
      inc %spam. [ $+ [ $chan ] ]
      set %SDGTMsg $iif($left($1,1) == @, msg #LlamaBot, notice $nick) $col(#LlamaBot)
      %SDGTMsg $+ Normal: Deathmatch, all weapons, 4 grenades, 2 frequency
      %SDGTMsg $+ Saws / Knives / Fists / CC (Saws Knives Laws): Deathmatch, 0 grenades, 0 frequency
      %SDGTMsg $+ Explosives: Deathmatch, M79/Law only, 5 grenades, 2 frequency
      %SDGTMsg $+ Snipers: Deathmatch, Barret/Knife only, 0 grenades, 2 frequency
      %SDGTMsg $+ Game types: DM / Team DM / Point Match / CTF / HTF / Rambo / Infiltration
      unset %SDGTMsg
    }
    else if ((*all* iswm $1-) || (*norm* iswm $1-) || (*def* iswm $1-)) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_FlameGod 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Predator 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Berserker 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Vest 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Cluster 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 2
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 4
      msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Default (Deathmatch, powerups reset, rehost required)
    }
    else {
      var %gtunknown = 0
      if ((*snl* iswm $1-) || (*skl* iswm $1-) || (*slk* iswm $1-) || (*lks* iswm $1-) || (*lsk* iswm $1-) || (*ksl* iswm $1-) || (*kls* iswm $1-) || (*cc* iswm $1-) || (*cq* iswm $1-) || (*second* iswm $1-) || ((*saw* iswm $1-) && (*kni* iswm $1-) && (*law* iswm $1-))) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Knives, Saws, and Laws. (Deathmatch, Rehost required)
      }
      else if (*saw* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Chainsaws only. (Deathmatch, Rehost required)
      }
      else if (*kni* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Knives only. (Deathmatch, Rehost required)
      }
      else if (*fist* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Fists only. (Deathmatch, Rehost required)
      }
      else if (*xplo* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 2
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 5
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Explosives. (Deathmatch, Rehost required)
      }
      else if ((*snipe* iswm $1-) || (*barret* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 2
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 0
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Snipers. (Deathmatch, Rehost required)
      }
      else { inc %gtunknown }

      if (*team* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 2
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Team Deathmatch. (no weapons changed, Rehost required)
      }
      else if ((*death* iswm $1-) || (*dm* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Deathmatch. (no weapons changed, Rehost required)
      }
      else if ((*point* iswm $1-) || (*pm* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 1
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Pointmatch. (no weapons changed, Rehost required)
      }
      else if ((*flag* iswm $1-) || (*ctf* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 3
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Capture the Flag. (no weapons changed, Rehost required)
      }
      else if ((*rambo* iswm $1-) || (*rm* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 4
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Rambomatch. (no weapons changed, Rehost required)
      }
      else if (*inf* iswm $1-) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 5
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Infiltration. (no weapons changed, Rehost required)
      }
      else if ((*hold* iswm $1-) || (*htf* iswm $1-)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 6
        msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ game-type is now Hold the Flag. (no weapons changed, Rehost required)
      }
      else { inc %gtunknown }
    }
    if (%gtunknown == 2) { notice $nick That game type is unknown.  Try using !gt help }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@]((add|rem(ove)?)( |-)?(weapon|wep)|(aw |rw ))/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ((*help* iswm $1-) || (*info* iswm $1-)) {
      set %SDWTMsg $iif($left($1,1) == @, msg #LlamaBot, notice $nick) $col(#LlamaBot)
      %SDWTMsg $+ Format: !add/remove weapon Name1 Name2 ...
      %SDWTMsg $+ !aw Name adds that weapon, !rw Name removes that weapon.
      unset %SDWTMsg
    }
    else if (($len($1) < 15) && ($len($2) < 15) && ($len($3) < 15) && ($len($4) < 15) && ($len($5) < 15)) {
      if ((*rem* iswm $1-5) || (*rw* iswm $1-5)) {
        var %weaponfound = 0
        if ((*eagle* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 0
          msg #LlamaBot $col(#LlamaBot) $+ The Desert Eagles are now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*hk* iswm $1-5) || (*mp5* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 0
          msg #LlamaBot $col(#LlamaBot) $+ The HK MP5 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*ak* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 0
          msg #LlamaBot $col(#LlamaBot) $+ The AK-74 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*steyr* iswm $1-5) || (*aug* iswm $1-5) || (1 isin $2-4)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 0
          msg #LlamaBot $col(#LlamaBot) $+ The SteyrAUG is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*spas* iswm $1-5) || (*shotgun* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 0
          msg #LlamaBot $col(#LlamaBot) $+ The Spas 12 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*ruger* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 0
          msg #LlamaBot $col(#LlamaBot) $+ The Ruger 77 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*m79* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 0
          msg #LlamaBot $col(#LlamaBot) $+ The M79 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*barret* iswm $1-5) || (*snipe* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 0
          msg #LlamaBot $col(#LlamaBot) $+ The Barret M82A1 is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*fm* iswm $1-5) || (*minimi* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 0
          msg #LlamaBot $col(#LlamaBot) $+ The FM Minimi is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*xm* iswm $1-5) || (*minigun* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 0
          msg #LlamaBot $col(#LlamaBot) $+ The XM214 Minigun is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*socom* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 0
          msg #LlamaBot $col(#LlamaBot) $+ The USSOCOM is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*knife* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 0
          msg #LlamaBot $col(#LlamaBot) $+ The Combat Knife is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*saw* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 0
          msg #LlamaBot $col(#LlamaBot) $+ The Chainsaw is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*law* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 0
          msg #LlamaBot $col(#LlamaBot) $+ The LAW is now off in the ~GPN~ server.
          %weaponfound = 1
        }
        if (%weaponfound != 1) { notice $nick That weapon is unknown. }
      }
      else if ((*add* iswm $1-5) || (*aw* iswm $1-5)) {
        if ((*eagle* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 1
          msg #LlamaBot $col(#LlamaBot) $+ The Desert Eagles are now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*hk* iswm $1-5) || (*mp5* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 1
          msg #LlamaBot $col(#LlamaBot) $+ The HK MP5 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*ak* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 1
          msg #LlamaBot $col(#LlamaBot) $+ The AK-74 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*steyr* iswm $1-5) || (*aug* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 1
          msg #LlamaBot $col(#LlamaBot) $+ The SteyrAUG is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*spas* iswm $1-5) || (*shotgun* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 1
          msg #LlamaBot $col(#LlamaBot) $+ The Spas 12 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*ruger* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 1
          msg #LlamaBot $col(#LlamaBot) $+ The Ruger 77 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*m79* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 1
          msg #LlamaBot $col(#LlamaBot) $+ The M79 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*barret* iswm $1-5) || (*snipe* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 1
          msg #LlamaBot $col(#LlamaBot) $+ The Barret M82A1 is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*fm* iswm $1-5) || (*minimi* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 1
          msg #LlamaBot $col(#LlamaBot) $+ The FM Minimi is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if ((*xm* iswm $1-5) || (*minigun* iswm $1-5)) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 1
          msg #LlamaBot $col(#LlamaBot) $+ The XM214 Minigun is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*socom* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 1
          msg #LlamaBot $col(#LlamaBot) $+ The USSOCOM is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*knife* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
          msg #LlamaBot $col(#LlamaBot) $+ The Combat Knife is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*saw* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 1
          msg #LlamaBot $col(#LlamaBot) $+ The Chainsaw is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if (*law* iswm $1-5) {
          writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 1
          msg #LlamaBot $col(#LlamaBot) $+ The LAW is now on in the ~GPN~ server.
          %weaponfound = 1
        }
        if (%weaponfound != 1) { notice $nick That weapon is unknown. }
      }
    }
    else { notice $nick Please use shorter weapon names. }
} | else { notice $nick You don't have the access level to do that. } }



on $*:TEXT:/^(\[r\])?[!@]((set)?powerup(s)?|sp )/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if ($2- isin off none zero) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_FlameGod 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Predator 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Berserker 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Vest 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Cluster 0
      msg #LlamaBot $col(#LlamaBot) $+ There are no longer any powerups in ~GPN~. (Rehost required)
    }
    else if ($2- isin normal default) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_FlameGod 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Predator 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Berserker 0
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Vest 1
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Cluster 1
      msg #LlamaBot $col(#LlamaBot) $+ Powerups in ~GPN~ are now: Flame:off Pred:on Zerk:off Vest:on Cluster:on (Rehost required)
    }
    else {
      if ((($2 == 0) || ($2 == 1) || ($2 == on) || ($2 == off)) && (($3 == 0) || ($3 == 1) || ($3 == on) || ($3 == off)) && (($4 == 0) || ($4 == 1) || ($4 == on) || ($4 == off)) && (($5 == 0) || ($5 == 1) || ($5 == on) || ($5 == off)) && (($6 == 0) || ($6 == 1) || ($6 == on) || ($6 == off)) && (!$7)) {
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_FlameGod $replace($2,on,1,off,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Predator $replace($3,on,1,off,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Berserker $replace($4,on,1,off,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Vest $replace($5,on,1,off,0)
        writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Cluster $replace($6,on,1,off,0)
        msg #LlamaBot $col(#LlamaBot) $+ Powerups in ~GPN~ are now: Flame: $+ $replace($2,1,on,0,off) Pred: $+ $replace($3,1,on,0,off) Zerk: $+ $replace($4,1,on,0,off) Vest: $+ $replace($5,1,on,0,off) Cluster: $+ $replace($6,1,on,0,off) (Rehost required)
      }
      else { notice $nick Invalid format: !powerups Flame:on/off Pred:on/off Zerk:on/off Vest:on/off Cluster:on/off }
    }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@]((set)?freq(uency)?|sf )/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    if (($2 isnum) && ($2 >= 0) && ($2 <= 5)) {
      writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency $2
      msg #LlamaBot $col(#LlamaBot) $+ The frequency for ~GPN~ is now $2 (Rehost required)
    }
    else { notice $nick Invalid format: !sf Frequency:0-5 }
} | else { notice $nick You don't have the access level to do that. } }


on $*:TEXT:/^(\[r\])?[!@](s(ol)?d(at)?)?r(r|es(et)?)/Si:#LlamaBot,?:{ if ((($nick ishop #LlamaBot) || ($nick isop #LlamaBot)) || (!$chan)) {
    write -c C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\mapslist.txt
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini NETWORK Max_Ping 200
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_1 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_2 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_3 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Random_Bots_4 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_FlameGod 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Predator 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Berserker 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Vest 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Cluster 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME GameStyle 0
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Bonus_Frequency 2
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_1 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_2 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_3 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_4 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_5 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_6 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_7 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_8 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_9 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_10 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_11 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_12 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_13 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Weapon_14 1
    writeini C:\Users\Kevin\Desktop\Kevin\Soldat\Dedicated-Server\soldat.ini GAME Max_Grenades 4
    msg #LlamaBot $col(#LlamaBot) $+ The ~GPN~ server has been completely reset to normal (Rehost required).
} | else { notice $nick You don't have the access level to do that. } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
