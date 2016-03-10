*Originally at http://llamabot.webs.com/dmcommands.htm*

## DEATHMATCH

The DeathMatch (commonly referred to as "DM") is LlamaBot's most used, most fun, and most advanced utility.  In this entertaining game, two players in the channel fight each other in a multiplayer duel, using a variety of attacks from a simple "whip" to a powerful "maul" that must be purchased in the DM store with gold that you earn by defeating other players.  Each time you defeat an opponent, you earn a certain amount of gold based on a complex formula that ensures an accurate amount is given based on various different events that can occur, not the least of which is the number of turns taken to finish the duel.  All of the commands for LlamaBot's DeathMatch are explained below, organized into different categories in the same manner as the Home page.

## STARTING / STOPPING / INFORMATION / CHANNEL OPTIONS

!DM (Name) (starts or accepts a death match - if a name is specified, only they can accept for 15 seconds)

!enddm (ends the DM)

[!@]DMhelp (gives some information about DMing and a link to this site)
[!@]DMinfo (gives information about the current DM)
[!@]DMstats (Name) (tells you the number of wins, losses, and amount of gold someone has - if no name is specified, it uses your own)
[!@]inventory (Name) (lists all the items someone has, including how many Power potions and Life potions, and whether or not they can use Custom weapons or a Granite maul - if no name is specified, it uses your own)
[!@]customstats (Name) (lists the name, max damage, and power use of someone's custom weapon - if no name is specified, it uses your own)

!DMoff (disables the !dm command for your channel until the !enddm command is used)

!setheals Number (sets the starting number of med kits per player per DM)
!setpots Number (sets the total number of potions allowed per player per DM)

## THE STORE

!store (displays a list of all items you can buy using the gold you have earned)
!buy ItemName (buys that item from the store)
!sell ItemName (sells that item back to the store for a slightly lower price than originally paid)

The following is a list of all the items you can buy in the store.  The "ItemName" (see above) is underlined for each item:

Granite Maul (hits 3 times): 10,000 gold.
Custom weapons (see below): 8,000 gold.
Life Potion (one use, heals you to 80 health): 750 gold.
Power Potion (one use, restores 100% power): 500 gold.
Reset wins/losses (both go back to 0): 1,000 gold.

## ATTACKS

The following commands are listed as they would be in RuneScape, but more generic attacks are also accepted.  These attacks include !double attack (the same as !dds), !axe (the same as !dh), !med kit (the same as !eat), etc.

Normal attacks:
!whip (normal attack: 0-35 damage, takes no power)
!fwave (same as whip)
!cbow (same as whip)
!dscim (same as whip)

Attacks that use power:
!dds (double attack: 0-25 damage each, takes 25% power)
!mbow (same as dds)
!dh (strong attack: 10-65 damage, takes no power, must have less than 10 HP)
!guthans (healing attack: 0-30 damage, takes 50% power)
!gmaul (triple attack: 0-25 damage each, takes 100% power - must be bought from the store)
!ice (freeze attack: 0-25 damage, takes 50% power, gives you an extra turn)
!custom (attacks with your custom weapon)

Defensive actions:
!restore (restores 25% power)
!heal (uses one of 5 med kits to heal 20 health)
!life (drinks one of your life potions, giving you exactly 80 health - must be bought from the store)
!power (drinks one of your power potions, giving you 100% power - must be bought from the store)

## CUSTOM WEAPONS

In order to create a custom weapon, you need to buy the ability to do so from the store.  To do that, type "!buy customs" once you have obtained at least 8,000 gold.  Once you have purchased the ability to create one, use the following three steps to customize it.

!create WeaponName (starts the process of making a custom weapon, or changes the name of your weapon if you have one already)

!setdamage Damage (sets the maximum damage for your custom weapon, with higher damage leading to lower accuracy)

!setpower PowerUse (sets the amount of power each attack uses, with a higher power use leading to higher accuracy)

After it has been created and customized, you can use !test to see how often it misses.  If you are unhappy with the results, try setting the damage lower or the power use higher.

!test (test your weapon to see how often and how high it hits)

!custom (attacks with your custom weapon during a DeathMatch)
