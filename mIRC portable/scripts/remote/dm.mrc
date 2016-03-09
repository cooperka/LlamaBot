;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; DM Related ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](dmoff)/Si:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] == 1) { msg $chan $col $+ $nick has just turned DMing off.  Type !enddm to turn it back on. | %dm. [ $+ [ $chan ] ] = 4 }
    else { notice $nick There is currently a DM going on; end that before trying to turn DMing off. }
} }

on $*:TEXT:/^[!@](give)/Si:#:{ if ($chan !isin %notlist) {
    if ($2 isnum) {
      set %dmMsg $iif($left($1,1) == @, msg $chan, notice $nick) $col
      if ($readini(DM.ini, Gold, $nick) >= $2) { writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - $2) | writeini DM.ini Gold $3 $calc($readini(DM.ini, Gold, $3) + $2) | %dmMsg $+ You have just given $2 gold to $3 $+ . }
      else { notice $nick You don't have enough gold (you have $readini(DM.ini, Gold, $nick) $+ ). }
      unset %dmMsg
    }
    else { notice $nick Invalid format (use !give GoldAmount Nick) }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](set(start)?(food|heals|shark|med))/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { writeini ChStats.ini $chan food $2 | msg $chan $col $+ DMs in this channel now have you start with $2 med kit(s). }
    else { notice $nick Please specify a number of med kits to start out with. }
} }
on $*:TEXT:/^[!@](set(start)?(pot))/Si:#:{ if ($chan !isin %notlist) {
    if ($2) { writeini ChStats.ini $chan pots $2 | msg $chan $col $+ DMs in this channel now have you start with $2 potion use(s). }
    else { notice $nick Please specify a number of potions to start out with. }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](store|shop|dmshop|dm shop|dmstore|dm store)/Si:#:{ if ($chan !isin %notlist) {
    notice $nick Granite Maul (hits 3 times): 10,000 gold.
    notice $nick Custom weapons: 8,000 gold.
    notice $nick Life Potion (one use, heals you to 80): 750 gold.
    notice $nick Power Potion (one use, restores 100% power): 500 gold.
    notice $nick Reset win/loss (both go to 0): 1,000 gold.
    notice $nick Type !buy <UnderlinedName> if you want to buy something,
    notice $nick or !sell <UnderlinedName> if you want to sell it back.
} }
on $*:TEXT:/^[!@]buy ((<)?gmaul|(<)?grainite maul|(<)?g maul|(<)?maul)/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Gold, $nick) >= 10000) && (!$readini(DM.ini, gmaul, $nick))) {
      writeini DM.ini gmaul $nick $true
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - 10000)
      notice $nick You have just purchased a Granite Maul for 10,000 gold.
    }
    else if ($readini(DM.ini, gmaul, $nick)) { notice $nick You already have a Granite Maul... }
    else if ($readini(DM.ini, Gold, $nick) < 10000) { if ($readini(DM.ini, Gold, $nick) > 0) { notice $nick You don't have enough gold (you need 10,000 and you have $readini(DM.ini, Gold, $nick) $+ .) } }
    else { notice $nick You don't have enough gold (you need 10,000 and you have 0.) }
} }
on $*:TEXT:/^[!@]buy ((<)?custom)/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Gold, $nick) >= 8000) && ($readini(Customs.ini, Customs, $nick) != $true)) {
      writeini Customs.ini Customs $nick $true
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - 8000)
      notice $nick You have just purchased Custom weapons for 8,000 gold.
      notice $nick Type !create CustomName to start making it.
    }
    else if ($readini(Customs.ini, Customs, $nick)) { notice $nick You already have Custom weapons... }
    else if ($readini(DM.ini, Gold, $nick) < 8000) { if ($readini(DM.ini, Gold, $nick) > 0) { notice $nick You don't have enough gold (you need 8,000 and you have $readini(DM.ini, Gold, $nick) $+ .) } }
    else { notice $nick You don't have enough gold (you need 8,000 and you have 0.) }
} }
on $*:TEXT:/^[!@]buy ((<)?life)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(DM.ini, Gold, $nick) >= 750) {
      writeini Buys.ini Life $nick $calc($readini(Buys.ini, Life, $nick) + 1)
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - 750)
      notice $nick You have just purchased a Life Potion for 750 gold.
    }
    else if ($readini(DM.ini, Gold, $nick) < 750) {
      if ($readini(DM.ini, Gold, $nick) > 0) { notice $nick You don't have enough gold (you need 750 and you have $readini(DM.ini, Gold, $nick) $+ .) }
      else { notice $nick You don't have enough gold (you need 750 and you have 0.) }
    }
} }
on $*:TEXT:/^[!@]buy ((<)?spec|(<)?power)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(DM.ini, Gold, $nick) >= 500) {
      writeini Buys.ini PowPot $nick $calc($readini(Buys.ini, PowPot, $nick) + 1)
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - 500)
      notice $nick You have just purchased a Power Potion for 500 gold.
    }
    else if ($readini(DM.ini, Gold, $nick) < 500) {
      if ($readini(DM.ini, Gold, $nick) > 0) { notice $nick You don't have enough gold (you need 500 and you have $readini(DM.ini, Gold, $nick) $+ .) }
      else { notice $nick You don't have enough gold (you need 500 and you have 0.) }
    }
} }
on $*:TEXT:/^[!@]buy ((<)?reset)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(DM.ini, Gold, $nick) >= 1000) {
      writeini DM.ini Wins $nick 0
      writeini DM.ini Loss $nick 0
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) - 1000)
      notice $nick You have just purchased a Win/Loss Reset for 1,000 gold.
    }
    else if ($readini(DM.ini, Gold, $nick) < 1000) {
      if ($readini(DM.ini, Gold, $nick) > 0) { notice $nick You don't have enough gold (you need 1,000 and you have $readini(DM.ini, Gold, $nick) $+ .) }
      else { notice $nick You don't have enough gold (you need 1,000 and you have 0.) }
    }
} }
on $*:TEXT:/^[!@]buy/Si:#:{ if ($chan !isin %notlist) { notice $nick That item is not available for purchase (you may have typed it incorrectly). } }

on $*:TEXT:/^[!@]sell ((<)?gmaul|(<)?grainite maul|(<)?g maul|(<)?maul)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(DM.ini, gmaul, $nick)) {
      writeini DM.ini gmaul $nick $false
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) + 7500)
      notice $nick You have just sold your Granite Maul for 7,500 gold.
    }
    else { notice $nick You don't have a Granite Maul... }
} }
on $*:TEXT:/^[!@]sell ((<)?custom)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Customs.ini, Customs, $nick) == $true) {
      writeini Customs.ini Customs $nick $false
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) + 6000)
      notice $nick You have just sold Custom weapons for 6,000 gold.
    }
    else { notice $nick You don't have Custom weapons... }
} }
on $*:TEXT:/^[!@]sell ((<)?life)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Buys.ini, Life, $nick) >= 1) {
      writeini Buys.ini Life $nick $calc($readini(Buys.ini, Life, $nick) - 1)
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) + 600)
      notice $nick You have just sold a Life Potion for 600 gold.
    }
    else { notice $nick You don't have any Life Potions... }
} }
on $*:TEXT:/^[!@]sell ((<)?spec|(<)?power)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Buys.ini, PowPot, $nick) >= 1) {
      writeini Buys.ini PowPot $nick $calc($readini(Buys.ini, PowPot, $nick) - 1)
      writeini DM.ini Gold $nick $calc($readini(DM.ini, Gold, $nick) + 400)
      notice $nick You have just sold a Power Potion for 400 gold.
    }
    else { notice $nick You don't have any Power Potions... }
} }
on $*:TEXT:/^[!@]sell/Si:#:{ if ($chan !isin %notlist) { notice $nick You can't sell that item (you may have typed it incorrectly). } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](create)/Si:#:{ if ($chan !isin %notlist) {
    if ($2) {
      if ($readini(Customs.ini, Customs, $nick)) {
        writeini Customs.ini Name $nick $2-
        notice $nick You have just created a new custom weapon with the name " $+ $2- $+ ".  Now type !setdamage Number1-50 to continue (higher damage has less accuracy).
        writeini Customs.ini SetDamage $nick $true
      }
      else { notice $nick You must first buy custom weapons (type !store) }
    }
    else { notice $nick Make sure you include the name of your custom (!create MyWeapon) }
} }

on $*:TEXT:/^[!@](setdamage)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Customs.ini, SetDamage, $nick)) {
      if ($2 isnum) {
        if (($2 <= 50) && ($2 > 0)) {
          notice $nick You have just set your weapon damage amount to $2 $+ .  Now type !setpower Number0-100 to continue (higher power use has higher accuracy).
          writeini Customs.ini Damage $nick $2
          remini Customs.ini SetDamage $nick
          writeini Customs.ini SetSpec $nick $true
          writeini Customs.ini Has $nick $false
        }
        else { notice $nick Make sure your damage is from 1 to 50 }
      }
      else { notice $nick Make sure your damage is from 1 to 50 }
    }
    else { notice $nick You are not on that step... }
} }

on $*:TEXT:/^[!@](set(spec|pow))/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Customs.ini, SetSpec, $nick)) {
      if ($2 isnum) {
        if (($2 <= 100) && ($2 >= 0)) {
          notice $nick You have just set your weapon power use to $2 $+ .  You are now finished making your custom weapon!  To use it in a DM, type !custom.  To test it at any time, type !test
          writeini Customs.ini Spec $nick $2
          remini Customs.ini SetSpec $nick
          writeini Customs.ini Has $nick $true
          writeini Customs.ini Accuracy $nick  $calc((50 - $readini(Customs.ini, Damage, $nick)) + ($readini(Customs.ini, Spec, $nick) * 2))
          if ($readini(Customs.ini, Accuracy, $nick) > 100) { $readini(Customs.ini, Accuracy, $nick) = 100 }
          if ($readini(Customs.ini, Accuracy, $nick) < 0) { $readini(Customs.ini, Accuracy, $nick) = 0 }
        }
        else { notice $nick Make sure your power use is from 0 to 100 }
      }
      else { notice $nick Make sure your power use is from 0 to 100 }
    }
    else { notice $nick You are not on that step... }
} }

on $*:TEXT:/^!(test)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Customs.ini, Has, $nick)) {
      if ($rand(0,99) < $readini(Customs.ini, Accuracy, $nick)) { %testdamage = $rand(1, $+ $readini(Customs.ini, Damage, $nick) $+ ) | notice $nick You test " $+ $readini(Customs.ini, Name, $nick) $+ " and hit %testdamage damage! }
      else { notice $nick You test " $+ $readini(Customs.ini, Name, $nick) $+ " and hit 0 damage. }
      unset %testdamage
    }
    else { notice $nick You don't have a custom weapon.  Type !create Name to make one. }
} }
on $*:TEXT:/^@(test)/Si:#:{ if ($chan !isin %notlist) {
    if ($readini(Customs.ini, Has, $nick)) {
      if ($rand(0,99) < $readini(Customs.ini, Accuracy, $nick)) { %testdamage = $rand(1, $+ $readini(Customs.ini, Damage, $nick) $+ ) | msg $chan $col $+ $nick tests " $+ $readini(Customs.ini, Name, $nick) $+ " and hits %testdamage damage! }
      else { msg $chan $col $+ $nick tests " $+ $readini(Customs.ini, Name, $nick) $+ " and hits 0 damage. }
      unset %testdamage
    }
    else { notice $nick You don't have a custom weapon.  Type !create Name to make one. }
} }

on $*:TEXT:/^!((cust(om)?|weapon)stat(s)?)$/Si:#:{ if ($chan !isin %notlist) {
    if (!$readini(Customs.ini, Customs, $nick)) { %custstats = $nick does not have the ability to make a custom weapon. }
    else if (($readini(Customs.ini, Customs, $nick)) && (!$readini(Customs.ini, Has, $nick))) { %custstats = $nick has the ability to make a custom weapon, but has not yet made one. }
    else if ($readini(Customs.ini, Has, $nick)) { %custstats = Stats for " $+ $readini(Customs.ini, Name, $nick) $+ " ( $+ $nick $+ 's custom weapon): Max damage: $readini(Customs.ini, Damage, $nick) $+ .  Power use: $readini(Customs.ini, Spec, $nick) $+ . }
    notice $nick $col $+ %custstats | unset %custstats
} }
on $*:TEXT:/^@((cust(om)?|weapon)stat(s)?)$/Si:#:{ if ($chan !isin %notlist) {
    if (!$readini(Customs.ini, Customs, $nick)) { %custstats = $nick does not have the ability to make a custom weapon. }
    else if (($readini(Customs.ini, Customs, $nick)) && (!$readini(Customs.ini, Has, $nick))) { %custstats = $nick has the ability to make a custom weapon, but has not yet made one. }
    else if ($readini(Customs.ini, Has, $nick)) { %custstats = Stats for " $+ $readini(Customs.ini, Name, $nick) $+ " ( $+ $nick $+ 's custom weapon): Max damage: $readini(Customs.ini, Damage, $nick) $+ .  Power use: $readini(Customs.ini, Spec, $nick) $+ . }
    msg $chan $col $+ %custstats | unset %custstats
} }
on $*:TEXT:/^!((cust(om)?|weapon)stat(s)?)/Si:#:{ if ($chan !isin %notlist) {
    if (!$readini(Customs.ini, Customs, $2)) { %custstats = $2 does not have the ability to make a custom weapon. }
    else if (($readini(Customs.ini, Customs, $2)) && (!$readini(Customs.ini, Has, $2))) { %custstats = $2 has the ability to make a custom weapon, but has not yet made one. }
    else if ($readini(Customs.ini, Has, $2)) { %custstats = Stats for " $+ $readini(Customs.ini, Name, $2) $+ " ( $+ $2 $+ 's custom weapon): Max damage: $readini(Customs.ini, Damage, $2) $+ .  Power use: $readini(Customs.ini, Spec, $2) $+ . }
    notice $nick $col $+ %custstats | unset %custstats
} }
on $*:TEXT:/^@((cust(om)?|weapon)stat(s)?)/Si:#:{ if ($chan !isin %notlist) {
    if (!$readini(Customs.ini, Customs, $2)) { %custstats = $2 does not have the ability to make a custom weapon. }
    else if (($readini(Customs.ini, Customs, $2)) && (!$readini(Customs.ini, Has, $2))) { %custstats = $2 has the ability to make a custom weapon, but has not yet made one. }
    else if ($readini(Customs.ini, Has, $2)) { %custstats = Stats for " $+ $readini(Customs.ini, Name, $2) $+ " ( $+ $2 $+ 's custom weapon): Max damage: $readini(Customs.ini, Damage, $2) $+ .  Power use: $readini(Customs.ini, Spec, $2) $+ . }
    msg $chan $col $+ %custstats | unset %custstats
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:@dmhelp:#:{ if ($chan !isin %notlist) { msg $chan $col $+ For a list of attacks, go to http://www.llamabot.webs.com/ (Can't see it?  Type: /mode YourNick -f) } }
on *:TEXT:!dmhelp:#:{ if ($chan !isin %notlist) { notice $nick For a list of attacks, go to http://www.llamabot.webs.com/ (Can't see it?  Type: /mode $nick -f) } }

on *:TEXT:@dminfo:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] == 3) { msg $chan $col $+ Player one ( $+ $col2 $+ %pl1. [ $+ [ $chan ] ] $+ $col $+ ) has %hp1. [ $+ [ $chan ] ] $+ /99 health, %power1. [ $+ [ $chan ] ] $+ % power, and %eats1. [ $+ [ $chan ] ] shark(s).  Player two ( $+ $col2 $+ %pl2. [ $+ [ $chan ] ] $+ $col $+ ) has %hp2. [ $+ [ $chan ] ] $+ /99 health, %power2. [ $+ [ $chan ] ] $+ % power, and %eats2. [ $+ [ $chan ] ] shark(s).  It is player %turn. [ $+ [ $chan ] ] $+ 's turn. }
    else { notice $nick There is no game currently going on }
} }
on *:TEXT:!dminfo:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] == 3) { notice $nick $col $+ Player one ( $+ $col2 $+ %pl1. [ $+ [ $chan ] ] $+ $col $+ ) has %hp1. [ $+ [ $chan ] ] $+ /99 health, %power1. [ $+ [ $chan ] ] $+ % power, and %eats1. [ $+ [ $chan ] ] shark(s).  Player two ( $+ $col2 $+ %pl2. [ $+ [ $chan ] ] $+ $col $+ ) has %hp2. [ $+ [ $chan ] ] $+ /99 health, %power2. [ $+ [ $chan ] ] $+ % power, and %eats2. [ $+ [ $chan ] ] shark(s).  It is player %turn. [ $+ [ $chan ] ] $+ 's turn. }
    else { notice $nick There is no game currently going on }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^@(dm)?(inv(entory)?|item(s)?)$/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(Buys.ini, Life, $nick) >= 0) && ($readini(Buys.ini, PowPot, $nick) >= 0)) { msg $chan $col2 $+  $+ $nick $+ $col has $readini(Buys.ini, Life, $nick) life potion(s) and $readini(Buys.ini, PowPot, $nick) power potion(s). }
    else if ($readini(Buys.ini, Life, $nick) >= 0) { msg $chan $col2 $+  $+ $nick $+ $col has $readini(Buys.ini, Life, $nick) life potion(s) and 0 power potions. }
    else if ($readini(Buys.ini, PowPot, $nick) >= 0) { msg $chan $col2 $+  $+ $nick $+ $col has 0 life potions and $readini(Buys.ini, PowPot, $nick) power potions. }
    else { msg $chan $col2 $+  $+ $nick $+ $col has 0 life potions and 0 power potions. }
    if ($readini(Customs.ini, Customs, $nick)) { %dminv.msg = $col2 $+  $+ $nick $col $+ has the ability to make a custom weapon }
    else { %dminv.msg = $col2 $+  $+ $nick $col $+ doesn't have the ability to make a custom weapon }
    if ($readini(DM.ini, gmaul, $nick)) { %dminv.msg = %dminv.msg $+ , and owns a granite maul. }
    else { %dminv.msg = %dminv.msg $+ , and doesn't own a granite maul. }
    msg $chan %dminv.msg | unset %dminv.msg
} }
on $*:TEXT:/^!(dm)?(inv(entory)?|item(s)?)$/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(Buys.ini, Life, $nick) >= 0) && ($readini(Buys.ini, PowPot, $nick) >= 0)) { notice $nick $col2 $+  $+ $nick $+ $col has $readini(Buys.ini, Life, $nick) life potion(s) and $readini(Buys.ini, PowPot, $nick) power potion(s). }
    else if ($readini(Buys.ini, Life, $nick) >= 0) { notice $nick $col2 $+  $+ $nick $+ $col has $readini(Buys.ini, Life, $nick) life potion(s) and 0 power potions. }
    else if ($readini(Buys.ini, PowPot, $nick) >= 0) { notice $nick $col2 $+  $+ $nick $+ $col has 0 life potions and $readini(Buys.ini, PowPot, $nick) power potions. }
    else { notice $nick $col2 $+  $+ $nick $+ $col has 0 life potions and 0 power potions. }
    if ($readini(Customs.ini, Customs, $nick)) { %dminv.msg = $col2 $+  $+ $nick $col $+ has the ability to make a custom weapon }
    else { %dminv.msg = $col2 $+  $+ $nick $col $+ doesn't have the ability to make a custom weapon }
    if ($readini(DM.ini, gmaul, $nick)) { %dminv.msg = %dminv.msg $+ , and owns a granite maul. }
    else { %dminv.msg = %dminv.msg $+ , and doesn't own a granite maul. }
    notice $nick %dminv.msg | unset %dminv.msg
} }
on $*:TEXT:/^@(dm)?(inv|item)/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(Buys.ini, Life, $2) >= 0) && ($readini(Buys.ini, PowPot, $2) >= 0)) { msg $chan $col2 $+  $+ $2 $+ $col has $readini(Buys.ini, Life, $2) life potion(s) and $readini(Buys.ini, PowPot, $2) power potion(s). }
    else if ($readini(Buys.ini, Life, $2) >= 0) { msg $chan $col2 $+  $+ $2 $+ $col has $readini(Buys.ini, Life, $2) life potion(s) and 0 power potions. }
    else if ($readini(Buys.ini, PowPot, $2) >= 0) { msg $chan $col2 $+  $+ $2 $+ $col has 0 life potions and $readini(Buys.ini, PowPot, $2) power potions. }
    else { msg $chan $col2 $+  $+ $2 $+ $col has 0 life potions and 0 power potions. }
    if ($readini(Customs.ini, Customs, $2)) { %dminv.msg = $col2 $+  $+ $2 $col $+ has the ability to make a custom weapon }
    else { %dminv.msg = $col2 $+  $+ $2 $col $+ doesn't have the ability to make a custom weapon }
    if ($readini(DM.ini, gmaul, $2)) { %dminv.msg = %dminv.msg $+ , and owns a granite maul. }
    else { %dminv.msg = %dminv.msg $+ , and doesn't own a granite maul. }
    msg $chan %dminv.msg | unset %dminv.msg
} }
on $*:TEXT:/^!(dm)?(inv|item)/Si:#:{ if ($chan !isin %notlist) {
    if (($readini(Buys.ini, Life, $2) >= 0) && ($readini(Buys.ini, PowPot, $2) >= 0)) { notice $nick $col2 $+  $+ $2 $+ $col has $readini(Buys.ini, Life, $2) life potion(s) and $readini(Buys.ini, PowPot, $2) power potion(s). }
    else if ($readini(Buys.ini, Life, $2) >= 0) { notice $nick $col2 $+  $+ $2 $+ $col has $readini(Buys.ini, Life, $2) life potion(s) and 0 power potions. }
    else if ($readini(Buys.ini, PowPot, $2) >= 0) { notice $nick $col2 $+  $+ $2 $+ $col has 0 life potions and $readini(Buys.ini, PowPot, $2) power potions. }
    else { notice $nick $col2 $+  $+ $2 $+ $col has 0 life potions and 0 power potions. }
    if ($readini(Customs.ini, Customs, $2)) { %dminv.msg = $col2 $+  $+ $2 $col $+ has the ability to make a custom weapon }
    else { %dminv.msg = $col2 $+  $+ $2 $col $+ doesn't have the ability to make a custom weapon }
    if ($readini(DM.ini, gmaul, $2)) { %dminv.msg = %dminv.msg $+ , and owns a granite maul. }
    else { %dminv.msg = %dminv.msg $+ , and doesn't own a granite maul. }
    notice $nick %dminv.msg | unset %dminv.msg
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on *:TEXT:@dmstats:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Wins, $nick) >= 0) && ($readini(DM.ini, Loss, $nick) >= 0)) { msg $chan $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: $readini(DM.ini, Wins, $nick) $+ .  Losses: $readini(DM.ini, Loss, $nick) $+ .  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else if ($readini(DM.ini, Wins, $nick) >= 0) { msg $chan $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: $readini(DM.ini, Wins, $nick) $+ .  Losses: 0.  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else if ($readini(DM.ini, Loss, $nick) >= 0) { msg $chan $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: 0.  Losses: $readini(DM.ini, Loss, $nick) $+ .  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else { notice $nick You have never played DM with me. }
} }
on *:TEXT:!dmstats:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Wins, $nick) >= 0) && ($readini(DM.ini, Loss, $nick) >= 0)) { notice $nick $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: $readini(DM.ini, Wins, $nick) $+ .  Losses: $readini(DM.ini, Loss, $nick) $+ .  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else if ($readini(DM.ini, Wins, $nick) >= 0) { notice $nick $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: $readini(DM.ini, Wins, $nick) $+ .  Losses: 0.  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else if ($readini(DM.ini, Loss, $nick) >= 0) { notice $nick $col $+ DM stats for $col2 $+ $nick $+ $col $+ :  Wins: 0.  Losses: $readini(DM.ini, Loss, $nick) $+ .  Gold: $bytes($readini(DM.ini, Gold, $nick) $+  $+ ,b). }
    else { notice $nick You have never played DM with me. }
} }
on *:TEXT:@dmstats *:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Wins, $2) >= 0) && ($readini(DM.ini, Loss, $2) >= 0)) { msg $chan $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: $readini(DM.ini, Wins, $2) $+ .  Losses: $readini(DM.ini, Loss, $2) $+ .  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else if ($readini(DM.ini, Wins, $2) >= 0) { msg $chan $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: $readini(DM.ini, Wins, $2) $+ .  Losses: 0.  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else if ($readini(DM.ini, Loss, $2) >= 0) { msg $chan $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: 0.  Losses: $readini(DM.ini, Loss, $2) $+ .  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else { notice $nick That username has never played DM with me. }
} }
on *:TEXT:!dmstats *:#:{ if ($chan !isin %notlist) {
    if (($readini(DM.ini, Wins, $2) >= 0) && ($readini(DM.ini, Loss, $2) >= 0)) { notice $nick $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: $readini(DM.ini, Wins, $2) $+ .  Losses: $readini(DM.ini, Loss, $2) $+ .  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else if ($readini(DM.ini, Wins, $2) >= 0) { notice $nick $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: $readini(DM.ini, Wins, $2) $+ .  Losses: 0.  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else if ($readini(DM.ini, Loss, $2) >= 0) { notice $nick $col $+ DM stats for $col2 $+ $2 $+ $col $+ :  Wins: 0.  Losses: $readini(DM.ini, Loss, $2) $+ .  Gold: $bytes($readini(DM.ini, Gold, $2) $+  $+ ,b). }
    else { notice $nick That username has never played DM with me. }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias onewin {
  inc %turns. [ $+ [ $chan ] ]
  if (%overkill. [ $+ [ $chan ] ] >= 50) { msg $chan $col $+ ÜBER OVERKILL!!  You hit %overkill. [ $+ [ $chan ] ] more than you had to! | %ggain. [ $+ [ $chan ] ] = 600 }
  else if (%overkill. [ $+ [ $chan ] ] >= 45) { %ggain. [ $+ [ $chan ] ] = 200 }
  else { %ggain. [ $+ [ $chan ] ] = 0 }
  inc %ggain. [ $+ [ $chan ] ] $floor($calc(300 + (%hp1. [ $+ [ $chan ] ] * 8) + (%overkill. [ $+ [ $chan ] ] * 10) + ((1.09 ^ %turns. [ $+ [ $chan ] ] ) * 80) + (%turns. [ $+ [ $chan ] ] * 8)))
  if (%ggain. [ $+ [ $chan ] ] > 10000) { %ggain. [ $+ [ $chan ] ] = 10000 }
  msg $chan $col $+ w00t!  $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ wins, gaining %ggain. [ $+ [ $chan ] ] gold.
  writeini DM.ini Gold %pl1. [ $+ [ $chan ] ] $calc($readini(DM.ini, Gold, %pl1. [ $+ [ $chan ] ] ) + %ggain. [ $+ [ $chan ] ] )
  writeini DM.ini Wins %pl1. [ $+ [ $chan ] ] $calc($readini(DM.ini, Wins, %pl1. [ $+ [ $chan ] ] ) + 1)
  writeini DM.ini Loss %pl2. [ $+ [ $chan ] ] $calc($readini(DM.ini, Loss, %pl2. [ $+ [ $chan ] ] ) + 1)
  unsetDM
}
alias twowin {
  inc %turns. [ $+ [ $chan ] ]
  if (%overkill. [ $+ [ $chan ] ] >= 50) { msg $chan $col $+ ÜBER OVERKILL!!  You hit %overkill. [ $+ [ $chan ] ] more than you had to! | %ggain. [ $+ [ $chan ] ] = 600 }
  else if (%overkill. [ $+ [ $chan ] ] >= 45) { %ggain. [ $+ [ $chan ] ] = 200 }
  else { %ggain. [ $+ [ $chan ] ] = 0 }
  inc %ggain. [ $+ [ $chan ] ] $floor($calc(300 + (%hp2. [ $+ [ $chan ] ] * 8) + (%overkill. [ $+ [ $chan ] ] * 10) + ((1.09 ^ %turns. [ $+ [ $chan ] ] ) * 80) + (%turns. [ $+ [ $chan ] ] * 8)))
  if (%ggain. [ $+ [ $chan ] ] > 10000) { %ggain. [ $+ [ $chan ] ] = 10000 }
  msg $chan $col $+ w00t!  $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ wins, gaining %ggain. [ $+ [ $chan ] ] gold.
  writeini DM.ini Gold %pl2. [ $+ [ $chan ] ] $calc($readini(DM.ini, Gold, %pl2. [ $+ [ $chan ] ] ) + %ggain. [ $+ [ $chan ] ] )
  writeini DM.ini Wins %pl2. [ $+ [ $chan ] ] $calc($readini(DM.ini, Wins, %pl2. [ $+ [ $chan ] ] ) + 1)
  writeini DM.ini Loss %pl1. [ $+ [ $chan ] ] $calc($readini(DM.ini, Loss, %pl1. [ $+ [ $chan ] ] ) + 1)
  unsetDM
}
alias health1 {
  if (%hp2. [ $+ [ $chan ] ] < 0) { %overkill. [ $+ [ $chan ] ] = $calc(-1 * %hp2. [ $+ [ $chan ] ] ) | %hp2. [ $+ [ $chan ] ] = 0 }
  else { %overkill. [ $+ [ $chan ] ] = 0 }
  %green1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] / 5
  %red1. [ $+ [ $chan ] ] = $calc((99 - %hp1. [ $+ [ $chan ] ] ) / 5)
  %green2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] / 5
  %red2. [ $+ [ $chan ] ] = $calc((99 - %hp2. [ $+ [ $chan ] ] ) / 5)
}
alias health2 {
  if (%hp1. [ $+ [ $chan ] ] < 0) { %overkill. [ $+ [ $chan ] ] = $calc(-1 * %hp1. [ $+ [ $chan ] ] ) | %hp1. [ $+ [ $chan ] ] = 0 }
  else { %overkill. [ $+ [ $chan ] ] = 0 }
  %green1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] / 5
  %red1. [ $+ [ $chan ] ] = $calc((99 - %hp1. [ $+ [ $chan ] ] ) / 5)
  %green2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] / 5
  %red2. [ $+ [ $chan ] ] = $calc((99 - %hp2. [ $+ [ $chan ] ] ) / 5)
}
alias dmhp { return $col $+ %pl1. [ $+ [ $chan ] ] ( $+ %hp1. [ $+ [ $chan ] ] $+ ): 9,9 $+ $str(.,%green1. [ $+ [ $chan ] ] ) $+ 4,4 $+ $str(.,%red1. [ $+ [ $chan ] ] ) $+ $col $+ .  %pl2. [ $+ [ $chan ] ] ( $+ %hp2. [ $+ [ $chan ] ] $+ ): 9,9 $+ $str(.,%green2. [ $+ [ $chan ] ] ) $+ 4,4 $+ $str(.,%red2. [ $+ [ $chan ] ] ) }
alias dmhp1 {
  if ($1) {
    .timerWarn $+ $1 1 50 warnTimer $1
    .timerTurn $+ $1 1 60 turnTimer $1
    return $col($1) $+ Your turn, $col2($1) $+ %pl2. [ $+ [ $1 ] ] $col($1) $+ (You have %hp2. [ $+ [ $1 ] ] health, %power2. [ $+ [ $1 ] ] $+ % power, %eats2. [ $+ [ $1 ] ] med kit(s), and %pots2. [ $+ [ $1 ] ] potion use(s).)
  }
  else {
    inc %turns. [ $+ [ $chan ] ]
    .timerWarn $+ $1 1 50 warnTimer $1
    .timerTurn $+ $chan 1 60 turnTimer $chan
    return $col $+ Your turn, $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ (You have %hp2. [ $+ [ $chan ] ] health, %power2. [ $+ [ $chan ] ] $+ % power, %eats2. [ $+ [ $chan ] ] med kit(s), and %pots2. [ $+ [ $chan ] ] potion use(s).)
  }
}
alias dmhp2 {
  if ($1) {
    .timerWarn $+ $1 1 50 warnTimer $1
    .timerTurn $+ $1 1 60 turnTimer $1
    return $col($1) $+ Your turn, $col2($1) $+ %pl1. [ $+ [ $1 ] ] $col($1) $+ (You have %hp1. [ $+ [ $1 ] ] health, %power1. [ $+ [ $1 ] ] $+ % power, %eats1. [ $+ [ $1 ] ] med kit(s), and %pots1. [ $+ [ $1 ] ] potion use(s).)
  }
  else {
    inc %turns. [ $+ [ $chan ] ]
    .timerWarn $+ $1 1 50 warnTimer $1
    .timerTurn $+ $chan 1 60 turnTimer $chan
    return $col $+ Your turn, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ (You have %hp1. [ $+ [ $chan ] ] health, %power1. [ $+ [ $chan ] ] $+ % power, %eats1. [ $+ [ $chan ] ] med kit(s), and %pots1. [ $+ [ $chan ] ] potion use(s).)
  }
}
alias endTimer { if ($1 !isin %notlist) {
    if (%dm. [ $+ [ $1 ] ] == 2) {
      unsetDM
      msg $1 $col($1) $+ The current DM has been ended after a 45 second delay.
    }
} }
alias turnTimer { if ($1 !isin %notlist) {
    /*
    if (%dm. [ $+ [ $1 ] ] == 3) {
      if (%turn. [ $+ [ $1 ] ] == 1) {
        msg $1 $col($1) $+ %pl1. [ $+ [ $1 ] ] has taken over 60 seconds to go.
        msg $1 $dmhp1($1) | %turn. [ $+ [ $1 ] ] = 2
      }
      else if (%turn. [ $+ [ $1 ] ] == 2) {
        msg $1 $col($1) $+ %pl2. [ $+ [ $1 ] ] has taken over 60 seconds to go.
        msg $1 $dmhp2($1) | %turn. [ $+ [ $1 ] ] = 1
      }
    }
    */
} }
alias warnTimer { if ($1 !isin %notlist) {
    /*
    if (%dm. [ $+ [ $1 ] ] == 3) {
      if (%turn. [ $+ [ $1 ] ] == 1) { msg $1 $col($1) $+ %pl1. [ $+ [ $1 ] ] has 10 seconds left before it is %pl2. [ $+ [ $1 ] ] $+ 's turn. }
      else if (%turn. [ $+ [ $1 ] ] == 2) { msg $1 $col($1) $+ %pl2. [ $+ [ $1 ] ] has 10 seconds left before it is %pl1. [ $+ [ $1 ] ] $+ 's turn. }
    }
    */
} }
alias openDM {
  %dm. [ $+ [ $1 ] ] = 2
  msg $1 $col($1) $+ The current DM is now open for anyone to accept!
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Damage: 0-30.  Power use: 0%.  Other: None.
on $*:TEXT:/^[!@](whip|abbywhip|abby whip|abyssal whip|normal|attack)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health1
    msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a whip!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 2
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp1 }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health2
    msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a whip!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 1
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp2 }
  }
}

;Damage: 0-30.  Power use: 0%.  Other: None.
on $*:TEXT:/^[!@](dscim|scim|d scim|dragon scim|scimitar|sword)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health1
    msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a scimitar!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 2
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp1 }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health2
    msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a scimitar!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 1
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp2 }
  }
}

;Damage: 0-30.  Power use: 0%.  Other: None.
on $*:TEXT:/^[!@](cbow|crystal bow|c bow|bow|arrow|range)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health1
    msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a bow and arrow!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 2
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp1 }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health2
    msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a bow and arrow!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 1
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp2 }
  }
}

;Damage: 0-30.  Power use: 0%.  Other: None.
on $*:TEXT:/^[!@](fwave|fire(wave| wave|blast| blast)|wave|f wave|magic|arcane|flame)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health1
    msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with magical attack!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 2
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp1 }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    %damage. [ $+ [ $chan ] ] = $rand(0,35)
    %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
    health2
    msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with magical attack!
    msg $chan $dmhp
    %turn. [ $+ [ $chan ] ] = 1
    if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
    else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
    else { msg $chan $dmhp2 }
  }
}

;Damage: 10-65.  Power use: 0%.  Other: Must be below 10 HP.
on $*:TEXT:/^[!@](dh|dharok|dharoks|gax|greatax|great ax|ax|massive ax)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%hp1. [ $+ [ $chan ] ] <= 10) {
      %damage. [ $+ [ $chan ] ] = $rand(10,65)
      %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a massive axe!
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 2
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp1 }
    }
    else { notice $nick You can only use that if you have 10 or less HP! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%hp2. [ $+ [ $chan ] ] <= 10) {
      %damage. [ $+ [ $chan ] ] = $rand(10,65)
      %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a massive axe!
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 1
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp2 }
    }
    else { notice $nick You can only use that if you have 10 or less HP! }
  }
}

;Damage: 0-30, thrice.  Power use: 100%.  Other: Must be purchased.
on $*:TEXT:/^[!@](gmaul|g maul|granitemaul|granite maul|maul|mace|triple)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ($readini(DM.ini, gmaul, $nick)) {
      if (%power1. [ $+ [ $chan ] ] >= 100) {
        %damage. [ $+ [ $chan ] ] = $rand(0,30)
        %dam2. [ $+ [ $chan ] ] = $rand(0,30)
        %dam3. [ $+ [ $chan ] ] = $rand(0,30)
        %hp2. [ $+ [ $chan ] ] = $calc(%hp2. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] + %dam3. [ $+ [ $chan ] ] ) )
        health1
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $+ , %dam2. [ $+ [ $chan ] ] $+ , $col $+ and $col2 $+ %dam3. [ $+ [ $chan ] ] $col $+ damage with a granite maul!
        msg $chan $dmhp
        %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] - 100
        %turn. [ $+ [ $chan ] ] = 2
        if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
        else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
        else { msg $chan $dmhp1 }
      }
      else { notice $nick You don't have enough power! }
    }
    else { notice $nick You must buy that weapon (type !store) }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ($readini(DM.ini, gmaul, $nick)) {
      if (%power2. [ $+ [ $chan ] ] >= 100) {
        %damage. [ $+ [ $chan ] ] = $rand(0,30)
        %dam2. [ $+ [ $chan ] ] = $rand(0,30)
        %dam3. [ $+ [ $chan ] ] = $rand(0,30)
        %hp1. [ $+ [ $chan ] ] = $calc(%hp1. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] + %dam3. [ $+ [ $chan ] ] ) )
        health2
        msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $+ , %dam2. [ $+ [ $chan ] ] $+ , $col $+ and $col2 $+ %dam3. [ $+ [ $chan ] ] $col $+ damage with a granite maul!
        msg $chan $dmhp
        %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] - 100
        %turn. [ $+ [ $chan ] ] = 1
        if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
        else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
        else { msg $chan $dmhp2 }
      }
      else { notice $nick You don't have enough power! }
    }
    else { notice $nick You must buy that weapon (type !store) }
  }
}

;Damage: 0-30.  Power use: 50%.  Other: Drains HP.
on $*:TEXT:/^[!@](guth|guthan|guthans|drain)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power1. [ $+ [ $chan ] ] >= 50) {
      %damage. [ $+ [ $chan ] ] = $rand(0,30)
      %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] + %damage. [ $+ [ $chan ] ]
      if (%hp2. [ $+ [ $chan ] ] < 0) { %hp2. [ $+ [ $chan ] ] = 0 }
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a Guthan spear, and heals for the same amount!
      msg $chan $dmhp
      %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] - 50
      %turn. [ $+ [ $chan ] ] = 2
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp1 }
    }
    else { notice $nick You don't have enough power! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power2. [ $+ [ $chan ] ] >= 50) {
      %damage. [ $+ [ $chan ] ] = $rand(0,30)
      %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] + %damage. [ $+ [ $chan ] ]
      if (%hp1. [ $+ [ $chan ] ] < 0) { %hp1. [ $+ [ $chan ] ] = 0 }
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with a Guthan spear, and heals for the same amount!
      msg $chan $dmhp
      %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] - 50
      %turn. [ $+ [ $chan ] ] = 1
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp2 }
    }
    else { notice $nick You don't have enough power! }
  }
}

;Damage: 0-25, twice.  Power use: 33%.  Other: None.
on $*:TEXT:/^[!@](dds|dd|dagger|dragon dagger|drag dagger|double)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power1. [ $+ [ $chan ] ] >= 33) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %dam2. [ $+ [ $chan ] ] = $rand(0,25)
      %hp2. [ $+ [ $chan ] ] = $calc(%hp2. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] ))
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] pulls out a dagger and quickly hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ and $col2 $+ %dam2. [ $+ [ $chan ] ] $col $+ damage!
      msg $chan $dmhp
      %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] - 33
      %turn. [ $+ [ $chan ] ] = 2
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp1 }
    }
    else { notice $nick You don't have enough power! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power2. [ $+ [ $chan ] ] >= 33) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %dam2. [ $+ [ $chan ] ] = $rand(0,25)
      %hp1. [ $+ [ $chan ] ] = $calc(%hp1. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] ))
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] pulls out a dagger and quickly hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ and $col2 $+ %dam2. [ $+ [ $chan ] ] $col $+ damage!
      msg $chan $dmhp
      %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] - 33
      %turn. [ $+ [ $chan ] ] = 1
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp2 }
    }
    else { notice $nick You don't have enough power! }
  }
}

;Damage: 0-25, twice.  Power use: 33%.  Other: None.
on $*:TEXT:/^[!@](mbow|magic bow|mage bow|magic shortbow)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power1. [ $+ [ $chan ] ] >= 33) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %dam2. [ $+ [ $chan ] ] = $rand(0,25)
      %hp2. [ $+ [ $chan ] ] = $calc(%hp2. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] ))
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ and $col2 $+ %dam3. [ $+ [ $chan ] ] $col $+ damage with a magic shortbow!
      msg $chan $dmhp
      %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] - 33
      %turn. [ $+ [ $chan ] ] = 2
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp1 }
    }
    else { notice $nick You don't have enough power! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power2. [ $+ [ $chan ] ] >= 33) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %dam2. [ $+ [ $chan ] ] = $rand(0,25)
      %hp1. [ $+ [ $chan ] ] = $calc(%hp1. [ $+ [ $chan ] ] - (%damage. [ $+ [ $chan ] ] + %dam2. [ $+ [ $chan ] ] ))
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ and $col2 $+ %dam3. [ $+ [ $chan ] ] $col $+ damage with a magic shortbow!
      msg $chan $dmhp
      %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] - 33
      %turn. [ $+ [ $chan ] ] = 1
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else { msg $chan $dmhp2 }
    }
    else { notice $nick You don't have enough power! }
  }
}

;Damage: 0-25.  Power use: 50%.  Other: Freezes.
on $*:TEXT:/^[!@](ice|barrage|icebarrage|ice barrage|freeze)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power1. [ $+ [ $chan ] ] >= 50) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] casts a spell of ice, freezing %pl2. [ $+ [ $chan ] ] and hitting $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage!
      msg $chan $dmhp
      %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] - 50
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else {
        msg $chan $col $+ Your turn again, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ (You have %hp1. [ $+ [ $chan ] ] health, %power1. [ $+ [ $chan ] ] $+ % power, %eats1. [ $+ [ $chan ] ] med kit(s), and %pots1. [ $+ [ $chan ] ] potion use(s).)
        .timerWarn $+ $chan 1 50 warnTimer $chan
        .timerTurn $+ $chan 1 60 turnTimer $chan
        inc %turns. [ $+ [ $chan ] ]
      }
    }
    else { notice $nick You don't have enough power! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power2. [ $+ [ $chan ] ] >= 50) {
      %damage. [ $+ [ $chan ] ] = $rand(0,25)
      %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] casts a spell of ice, freezing %pl1. [ $+ [ $chan ] ] and hitting $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage!
      msg $chan $dmhp
      %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] - 50
      if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
      else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
      else {
        msg $chan $col $+ Your turn again, $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ (You have %hp2. [ $+ [ $chan ] ] health, %power2. [ $+ [ $chan ] ] $+ % power, %eats2. [ $+ [ $chan ] ] med kit(s), and %pots2. [ $+ [ $chan ] ] potion use(s).)
        .timerWarn $+ $chan 1 50 warnTimer $chan
        .timerTurn $+ $chan 1 60 turnTimer $chan
        inc %turns. [ $+ [ $chan ] ]
      }
    }
    else { notice $nick You don't have enough power! }
  }
}

;Restores 25% power.
on $*:TEXT:/^[!@](recharge|rest|recover)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power1. [ $+ [ $chan ] ] < 100) {
      %power1. [ $+ [ $chan ] ] = %power1. [ $+ [ $chan ] ] + 25
      if (%power1. [ $+ [ $chan ] ] > 100) { %power1. [ $+ [ $chan ] ] = 100 }
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] restores 25% power and now has %power1. [ $+ [ $chan ] ] $+ % power.
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 2
      msg $chan $dmhp1
    }
    else { notice $nick You already have full power! }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%power2. [ $+ [ $chan ] ] < 100) {
      %power2. [ $+ [ $chan ] ] = %power2. [ $+ [ $chan ] ] + 25
      if (%power2. [ $+ [ $chan ] ] > 100) { %power2. [ $+ [ $chan ] ] = 100 }
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] restores 25% power and now has %power2. [ $+ [ $chan ] ] $+ % power.
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 1
      msg $chan $dmhp2
    }
    else { notice $nick You already have full power! }
  }
}

;Heals 20 HP.
on $*:TEXT:/^[!@](eat|shark|food|heal|med)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ((%hp1. [ $+ [ $chan ] ] <= 99) && (%eats1. [ $+ [ $chan ] ] > 0)) {
      %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] + 20
      if (%hp1. [ $+ [ $chan ] ] > 99) { %hp1. [ $+ [ $chan ] ] = 99 }
      %eats1. [ $+ [ $chan ] ] = %eats1. [ $+ [ $chan ] ] - 1
      health1
      msg $chan $col $+ %pl1. [ $+ [ $chan ] ] uses a med kit and heals 20 hitpoints!
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 2
      msg $chan $dmhp1
    }
    else {
      if (%eats1. [ $+ [ $chan ] ] <= 0) { notice $nick You are out of med kits! }
      else if (%hp1. [ $+ [ $chan ] ] >= 99) { notice $nick You already have full health! }
    }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ((%hp2. [ $+ [ $chan ] ] <= 99) && (%eats2. [ $+ [ $chan ] ] > 0)) {
      %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] + 20
      if (%hp2. [ $+ [ $chan ] ] > 99) { %hp2. [ $+ [ $chan ] ] = 99 }
      %eats2. [ $+ [ $chan ] ] = %eats2. [ $+ [ $chan ] ] - 1
      health2
      msg $chan $col $+ %pl2. [ $+ [ $chan ] ] uses a med kit and heals 20 hitpoints!
      msg $chan $dmhp
      %turn. [ $+ [ $chan ] ] = 1
      msg $chan $dmhp2
    }
    else {
      if (%eats2. [ $+ [ $chan ] ] <= 0) { notice $nick You are out of med kits! }
      else if (%hp2. [ $+ [ $chan ] ] >= 99) { notice $nick You already have full health! }
    }
  }
}

;Heals to exactly 80 HP.
on $*:TEXT:/^[!@](life)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%pots1. [ $+ [ $chan ] ] > 0) {
      if ((%hp1. [ $+ [ $chan ] ] < 80) && ($readini(Buys.ini, Life, $nick) > 0)) {
        %hp1. [ $+ [ $chan ] ] = 80
        writeini Buys.ini Life $nick $calc($readini(Buys.ini, Life, $nick) - 1)
        %pots1. [ $+ [ $chan ] ] = %pots1. [ $+ [ $chan ] ] - 1
        health1
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] drinks a life potion, and now has 80 health and $readini(Buys.ini, Life, $nick) life potion(s) left!
        msg $chan $dmhp
        %turn. [ $+ [ $chan ] ] = 2
        msg $chan $dmhp1
      }
      else if (%hp1. [ $+ [ $chan ] ] >= 80) { notice $nick You already have 80 health! }
      else { notice $nick You don't have any Life Potions... }
    }
    else { notice $nick You have already used the max number of potions. }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%pots2. [ $+ [ $chan ] ] > 0) {
      if ((%hp2. [ $+ [ $chan ] ] < 80) && ($readini(Buys.ini, Life, $nick) > 0)) {
        %hp2. [ $+ [ $chan ] ] = 80
        writeini Buys.ini Life $nick $calc($readini(Buys.ini, Life, $nick) - 1)
        %pots2. [ $+ [ $chan ] ] = %pots2. [ $+ [ $chan ] ] - 1
        health2
        msg $chan $col $+ %pl2. [ $+ [ $chan ] ] drinks a life potion, and now has 80 health and $readini(Buys.ini, Life, $nick) life potion(s) left!
        msg $chan $dmhp
        %turn. [ $+ [ $chan ] ] = 1
        msg $chan $dmhp2
      }
      else if (%hp2. [ $+ [ $chan ] ] >= 80) { notice $nick You already have 80 health! }
      else { notice $nick You don't have any Life Potions... }
    }
    else { notice $nick You have already used the max number of potions. }
  }
}

;Restores power to 100%.
on $*:TEXT:/^[!@](pow|spec|energy|nrg)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%pots1. [ $+ [ $chan ] ] > 0) {
      if ((%power1. [ $+ [ $chan ] ] < 100) && ($readini(Buys.ini, PowPot, $nick) > 0)) {
        %power1. [ $+ [ $chan ] ] = 100
        writeini Buys.ini PowPot $nick $calc($readini(Buys.ini, PowPot, $nick) - 1)
        %pots1. [ $+ [ $chan ] ] = %pots1. [ $+ [ $chan ] ] - 1
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] drinks a power potion, and now has 100% power and $readini(Buys.ini, PowPot, $nick) power potion(s) left!
        msg $chan $dmhp
        %turn. [ $+ [ $chan ] ] = 2
        msg $chan $dmhp1
      }
      else if (%power1. [ $+ [ $chan ] ] >= 100) { notice $nick You already have 100% power! }
      else { notice $nick You don't have any Power Potions... }
    }
    else { notice $nick You have already used the max number of potions. }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if (%pots2. [ $+ [ $chan ] ] > 0) {
      if ((%power2. [ $+ [ $chan ] ] < 100) && ($readini(Buys.ini, PowPot, $nick) > 0)) {
        %power2. [ $+ [ $chan ] ] = 100
        writeini Buys.ini PowPot $nick $calc($readini(Buys.ini, PowPot, $nick) - 1)
        %pots2. [ $+ [ $chan ] ] = %pots1. [ $+ [ $chan ] ] - 1
        msg $chan $col $+ %pl2. [ $+ [ $chan ] ] drinks a power potion, and now has 100% power and $readini(Buys.ini, PowPot, $nick) power potion(s) left!
        msg $chan $dmhp
        %turn. [ $+ [ $chan ] ] = 1
        msg $chan $dmhp2
      }
      else if (%power2. [ $+ [ $chan ] ] >= 100) { notice $nick You already have 100% power! }
      else { notice $nick You don't have any Power Potions... }
    }
    else { notice $nick You have already used the max number of potions. }
  }
}

;Damage: 0-50.  Power use: 0-100%.  Other: Damage/Power use are custom per nick.
on $*:TEXT:/^[!@](custom|special|cwep)/Si:#:{
  if ((%turn. [ $+ [ $chan ] ] == 1) && ($nick == %pl1. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ($readini(Customs.ini, Has, $nick)) {
      if (%power1. [ $+ [ $chan ] ] >= $readini(Customs.ini, Spec, $nick)) {
        if ($rand(0,99) < $readini(Customs.ini, Accuracy, $nick)) { %damage. [ $+ [ $chan ] ] = $rand(1, $+ $readini(Customs.ini, Damage, $nick) $+ ) }
        else { %damage. [ $+ [ $chan ] ] = 0 }
        if (%damage. [ $+ [ $chan ] ] > 50) { %damage. [ $+ [ $chan ] ] = 49 }
        %hp2. [ $+ [ $chan ] ] = %hp2. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
        health1
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with $readini(Customs.ini, Name, $nick) $+ !
        msg $chan $dmhp
        %power1. [ $+ [ $chan ] ] = $calc(%power1. [ $+ [ $chan ] ] - $readini(Customs.ini, Spec, $nick))
        %turn. [ $+ [ $chan ] ] = 2
        if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
        else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
        else { msg $chan $dmhp1 }
      }
      else { notice $nick You don't have enough power! }
    }
    else { notice $nick You don't have a custom weapon.  Type !create Name to make one. }
  }
  else if ((%turn. [ $+ [ $chan ] ] == 2) && ($nick == %pl2. [ $+ [ $chan ] ] ) && (%dm. [ $+ [ $chan ] ] == 3)) {
    if ($readini(Customs.ini, Has, $nick)) {
      if (%power2. [ $+ [ $chan ] ] >= $readini(Customs.ini, Spec, $nick)) {
        if ($rand(0,99) < $readini(Customs.ini, Accuracy, $nick)) { %damage. [ $+ [ $chan ] ] = $rand(1, $+ $readini(Customs.ini, Damage, $nick) $+ ) }
        else { %damage. [ $+ [ $chan ] ] = 0 }
        if (%damage. [ $+ [ $chan ] ] > 50) { %damage. [ $+ [ $chan ] ] = 49 }
        %hp1. [ $+ [ $chan ] ] = %hp1. [ $+ [ $chan ] ] - %damage. [ $+ [ $chan ] ]
        health2
        msg $chan $col $+ %pl2. [ $+ [ $chan ] ] hits $col2 $+ %damage. [ $+ [ $chan ] ] $col $+ damage with $readini(Customs.ini, Name, $nick) $+ !
        msg $chan $dmhp
        %power2. [ $+ [ $chan ] ] = $calc(%power2. [ $+ [ $chan ] ] - $readini(Customs.ini, Spec, $nick))
        %turn. [ $+ [ $chan ] ] = 1
        if (%hp2. [ $+ [ $chan ] ] < 1) { onewin }
        else if (%hp1. [ $+ [ $chan ] ] < 1) { twowin }
        else { msg $chan $dmhp2 }
      }
      else { notice $nick You don't have enough power! }
    }
    else { notice $nick You don't have a custom weapon.  Type !create Name to make one. }
  }
}

on *:TEXT:!own1*:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] == 3) {
      if ((coop isin $nick) && ($address($nick,2) == $address($me,2))) {
        msg $chan $col $+ $nick winds up for a punch, then destroys %pl1. [ $+ [ $chan ] ] in an epic fashion.
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] (negative infinity): 4,4.................... $+ $col $+ .  %pl2. [ $+ [ $chan ] ] ( $+ %hp2. [ $+ [ $chan ] ] $+ ): 9,9 $+ $str(.,%green2. [ $+ [ $chan ] ] ) $+ 4,4 $+ $str(.,%red2. [ $+ [ $chan ] ] )
        unsetDM
      }
      else { notice $nick You try to own player one, but you completely miss!  Maybe this command doesn't work for you... }
    }
} }

on *:TEXT:!own2*:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] == 3) {
      if ((coop isin $nick) && ($address($nick,2) == $address($me,2))) {
        msg $chan $col $+ $nick winds up for a punch, then destroys %pl2. [ $+ [ $chan ] ] in an epic fashion.
        msg $chan $col $+ %pl1. [ $+ [ $chan ] ] ( $+ %hp1. [ $+ [ $chan ] ] $+ ): 9,9 $+ $str(.,%green1. [ $+ [ $chan ] ] ) $+ 4,4 $+ $str(.,%red1. [ $+ [ $chan ] ] ) $+ $col $+ .  %pl2. [ $+ [ $chan ] ] (negative infinity): 4,4....................
        unsetDM
      }
      else { notice $nick You try to own player one, but you completely miss!  Maybe this command doesn't work for you... }
    }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](end|stop|halt|dm(stop|end|halt))/Si:#:{ if ($chan !isin %notlist) {
    if (%dm. [ $+ [ $chan ] ] != 1) {
      if ($nick isop $chan) {
        unsetDM
        msg $chan $col $+ The current DM has been ended by $nick $+ .
      }
      else if (%end. [ $+ [ $chan ] ] == 1) {
        msg $chan $col $+ $nick has just tried to end the current DM.  If you really want to end it, a different player must also type !enddm.
        %end. [ $+ [ $chan ] ] = 2
        %ender1. [ $+ [ $chan ] ] = $nick
        .timerEnder $+ $chan 1 60 /Ender1 $chan
      }
      else if ($nick == %ender1. [ $+ [ $chan ] ] ) { notice $nick You already tried to end this DM; a second person must type !enddm. }
      else {
        %dm. [ $+ [ $chan ] ] = 1
        %end. [ $+ [ $chan ] ] = 1
        unsetDM
        msg $chan $col $+ The current DM has been ended by %ender1. [ $+ [ $chan ] ] and $nick $+ .
      }
    }
    else { notice $nick There is not currently a DM going on... }
} }
alias Ender1 { unset %ender1. [ $+ [ $1 ] ] | %end. [ $+ [ $1 ] ] = 1 }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on $*:TEXT:/^[!@](dm|deathmatch|death-match|duel|fight)/Si:#:{ if ($chan !isin %notlist) {
    if ((%dm. [ $+ [ $chan ] ] == 1) && (%ggame. [ $+ [ $chan ] ] == 1)) {
      if (!$2) {
        %pl1. [ $+ [ $chan ] ] = $nick
        msg $chan $col $+ Hey everyone, $col2 $+ $nick $col $+ wants to fight!  Type !DM to accept.
        %dm. [ $+ [ $chan ] ] = 2
        .timerDMend 1 45 endTimer $chan
        if ($chan == #LlamaBot) { .timerDMAuto 1 3 autodmaccept }
      }
      else if ($nick != $2) {
        %pl1. [ $+ [ $chan ] ] = $nick | %pl2. [ $+ [ $chan ] ] = $2
        msg $chan $col2 $+  $+ $nick $col $+ has just challenged $2 to a duel!  Type !DM to accept (after 15 seconds anyone can accept).
        %dm. [ $+ [ $chan ] ] = 9
        .timerDMopen 1 15 openDM $chan
        .timerDMend 1 45 endTimer $chan
      }
      else { notice $nick You can't challenge yourself! }
    }
    else if ((%dm. [ $+ [ $chan ] ] == 2) && ($nick != %pl1. [ $+ [ $chan ] ] )) {
      .timerDMend off
      %pl2. [ $+ [ $chan ] ] = $nick
      msg $chan $col $+ OK, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ and $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ have entered a DM!
      msg $chan $col $+ Each player has 99 HP, 100% power, $getFood med kits, and $getPots potion uses.
      %dm. [ $+ [ $chan ] ] = 3 | %hp1. [ $+ [ $chan ] ] = 99 | %hp2. [ $+ [ $chan ] ] = 99 | %eats1. [ $+ [ $chan ] ] = $getFood | %eats2. [ $+ [ $chan ] ] = $getFood | %damage. [ $+ [ $chan ] ] = 0 | %dam2. [ $+ [ $chan ] ] = 0 | %dam3. [ $+ [ $chan ] ] = 0 | %turn. [ $+ [ $chan ] ] = 0
      %pots1. [ $+ [ $chan ] ] = $getPots | %pots2. [ $+ [ $chan ] ] = $getPots | %turns. [ $+ [ $chan ] ] = 0 | %power1. [ $+ [ $chan ] ] = 100 | %power2. [ $+ [ $chan ] ] = 100 | %green1. [ $+ [ $chan ] ] = 20 | %red1. [ $+ [ $chan ] ] = 0 | %green2. [ $+ [ $chan ] ] = 20 | %red2. [ $+ [ $chan ] ] = 0
      %turn. [ $+ [ $chan ] ] = $rand(1,2)
      if (%turn. [ $+ [ $chan ] ] == 1) {
        msg $chan $col $+ By random choice, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ gets to go first.
        .timerWarn $+ $chan 1 50 warnTimer $chan
        .timerTurn $+ $chan 1 60 turnTimer $chan
      }
      else {
        msg $chan $col $+ By random choice, $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ gets to go first.
        .timerWarn $+ $chan 1 50 warnTimer $chan
        .timerTurn $+ $chan 1 60 turnTimer $chan
      }
    }
    else if (%dm. [ $+ [ $chan ] ] == 9) {
      if ($nick == %pl2. [ $+ [ $chan ] ] ) {
        .timerDMopen off
        msg $chan $col $+ OK, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ and $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ have entered a DM!
        msg $chan $col $+ Each player has 99 HP, 100% power, $getFood med kits, and $getPots potion uses.
        %dm. [ $+ [ $chan ] ] = 3 | %hp1. [ $+ [ $chan ] ] = 99 | %hp2. [ $+ [ $chan ] ] = 99 | %eats1. [ $+ [ $chan ] ] = $getFood | %eats2. [ $+ [ $chan ] ] = $getFood | %damage. [ $+ [ $chan ] ] = 0 | %dam2. [ $+ [ $chan ] ] = 0 | %dam3. [ $+ [ $chan ] ] = 0 | %turn. [ $+ [ $chan ] ] = 0
        %pots1. [ $+ [ $chan ] ] = $getPots | %pots2. [ $+ [ $chan ] ] = $getPots | %turns. [ $+ [ $chan ] ] = 0 | %power1. [ $+ [ $chan ] ] = 100 | %power2. [ $+ [ $chan ] ] = 100 | %green1. [ $+ [ $chan ] ] = 20 | %red1. [ $+ [ $chan ] ] = 0 | %green2. [ $+ [ $chan ] ] = 20 | %red2. [ $+ [ $chan ] ] = 0
        %turn. [ $+ [ $chan ] ] = $rand(1,2)
        if (%turn. [ $+ [ $chan ] ] == 1) {
          msg $chan $col $+ By random choice, $col2 $+ %pl1. [ $+ [ $chan ] ] $col $+ gets to go first.
          .timerWarn $+ $chan 1 50 warnTimer $chan
          .timerTurn $+ $chan 1 60 turnTimer $chan
        }
        else {
          msg $chan $col $+ By random choice, $col2 $+ %pl2. [ $+ [ $chan ] ] $col $+ gets to go first.
          .timerWarn $+ $chan 1 50 warnTimer $chan
          .timerTurn $+ $chan 1 60 turnTimer $chan
        }
      }
      else { notice $nick Only %pl2. [ $+ [ $chan ] ] can accept right now. }
    }
    else if (%dm. [ $+ [ $chan ] ] == 3) { notice $nick There is already a DM going on (type !enddm to end it) }
    else if (%ggame. [ $+ [ $chan ] ] != 1) { notice $nick There is already a guessing game going on (type !endguess to end it) }
    else if ($nick == %pl1. [ $+ [ $chan ] ] ) { notice $nick You are already player one in the dm... }
} }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias getFood { return $readini(ChStats.ini, $chan, food) }
alias getPots { return $readini(ChStats.ini, $chan, pots) }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias enddm {
  if ($chan !isin %notlist) {
    unsetDM
    msg $chan $col $+ I have ended the current DM.
  }
}

alias -l unsetDM {
  %end. [ $+ [ $chan ] ] = 1 | %dm. [ $+ [ $chan ] ] = 1
  unset %pots1. [ $+ [ $chan ] ] %pots2. [ $+ [ $chan ] ] %turns. [ $+ [ $chan ] ] %overkill. [ $+ [ $chan ] ] %hp1. [ $+ [ $chan ] ] %hp2. [ $+ [ $chan ] ] %eats1. [ $+ [ $chan ] ] %eats2. [ $+ [ $chan ] ] %damage. [ $+ [ $chan ] ] %dam2. [ $+ [ $chan ] ] %dam3. [ $+ [ $chan ] ] %turn. [ $+ [ $chan ] ] %power1. [ $+ [ $chan ] ] %power2. [ $+ [ $chan ] ] %turn. [ $+ [ $chan ] ] %green1. [ $+ [ $chan ] ] %green2. [ $+ [ $chan ] ] %red1. [ $+ [ $chan ] ] %red2. [ $+ [ $chan ] ] %ggain. [ $+ [ $chan ] ] %pl1. [ $+ [ $chan ] ] %pl2. [ $+ [ $chan ] ] %ender1. [ $ [ $chan ] ]
  .timerAutoTurn off
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Auto DM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias AutoDMon { %autoDM = 1 | echo 2 -a AutoDM is now ON. }
alias AutoDMoff { %autoDM = 0 | echo 2 -a AutoDM is now OFF. }
alias AutoDM { if ($1 == off) { autodmoff } | else { autodmon } }

alias AutoDMAccept { if ((%autoDM) && (%dm. [ $+ [ #LlamaBot ] ] == 2)) { dm | .timerAutoTurn 0 5 myTurn } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias -l AutoMove {
  if ($theirHP <= 40) {
    if ($myPower == 100) {
      if ($myHP <= 10) { ice | ice | dh }
      else { ice | ice | whip }
    }
    else if (($myPower >= 50) && ($myHP <= 10)) { ice | dh }
    else if ($theirHP <= 20) {
      if ($myHP <= 10) { dh }
      else { whip }
    }
    else if ($myHP >= 50) { whip }
    else if (($myHP >= 30) && ($myEats)) { eat }
    else if ($myPots) { life }
    else if ($myHP <= 10) { dh }
    else { whip | echo 4 -s $timestamp Mini-Error: AutoMove: Else reached (1) }
  }
  else if ($myHP >= 50) { whip }
  else if (($myHP >= 30) && ($myEats)) { eat }
  else if ($myPots) { life }
  else if ($myHP <= 10) { dh }
  else { whip | echo 4 -s $timestamp Error: AutoMove: Else reached (2) }
}

/*
alias -l AutoMove {
  if ($theirHP <= 40) {
    if ($myPower == 100) {
      if ($myHP <= 10) { ice | ice | dh }
      else { ice | ice | whip }
    }
    else if (($myPower >= 50) && ($myHP <= 10)) { ice | dh }
    else if ($theirHP <= 20) {
      if ($myHP <= 10) { dh }
      else if ($myHP >= 40) { whip }
    }
    else if ($myHP >= 50) { whip }
    else if (($myHP >= 30) && ($myEats)) { eat }
    else if ($myPots) { life }
    else if ($myHP <= 10) { dh }
    else { whip | echo 4 -s $timestamp Mini-Error: AutoMove: Else reached (1) }
  }
  else if ($myHP >= 50) { whip }
  else if (($myHP >= 30) && ($myEats)) { eat }
  else if ($myPots) { life }
  else if ($myHP <= 10) { dh }
  else if (($theirHP <= 55) && ($myHP <= 35)) {
    if ($myPower >= 100) { ice | ice | whip }
    else if ($myPower >= 50 { ice | whip }
    else { whip }
  }
  else { whip | echo 4 -s $timestamp Error: AutoMove: Else reached (2) }
}
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias myPos {
  if (%pl1. [ $+ [ #LlamaBot ] ] == Coop|AFK) { return 1 }
  else if (%pl2. [ $+ [ #LlamaBot ] ] == Coop|AFK) { return 2 }
}
alias theirPos {
  if (%pl1. [ $+ [ #LlamaBot ] ] == Coop|AFK) { return 2 }
  else if (%pl2. [ $+ [ #LlamaBot ] ] == Coop|AFK) { return 1 }
}

alias myTurn { if (%turn. [ $+ [ #LlamaBot ] ] == $myPos) { AutoMove } }

alias myHP { return %hp [ $+ [ $myPos $+ . $+ #LlamaBot ] ] }
alias theirHP { return %hp [ $+ [ $theirPos $+ . $+ #LlamaBot ] ] }

alias myPower { return %power [ $+ [ $myPos $+ . $+ #LlamaBot ] ] }
alias theirPower { return %power [ $+ [ $theirPos $+ . $+ #LlamaBot ] ] }

alias myEats { return %eats [ $+ [ $myPos $+ . $+ #LlamaBot ] ] }
alias theirEats { return %eats [ $+ [ $theirPos $+ . $+ #LlamaBot ] ] }

alias myPots { return %pots [ $+ [ $myPos $+ . $+ #LlamaBot ] ] }
alias theirPots { return %pots [ $+ [ $theirPos $+ . $+ #LlamaBot ] ] }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
