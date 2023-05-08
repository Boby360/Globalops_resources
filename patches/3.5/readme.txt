History
=======
3.5 [30-04-2007]

Bug fixes
=========

Linux server:

    Remote admin password hack
    Moneycheat bug
    Time sync problems
    Map objective removal problem
    Added missing sounds/textures
    Fixed attributes script

Windows server:

    Remote admin password hack
    Moneycheat bug
    Map objective removal problem
    Added missing sounds/textures
    Fixed attributes script
    Fixed a crash/remote code execution bug
    Allow running Windows server and client simultaneously

Windows client:

    Fixed a crash/remote code execution bug
    Added anti-cheat voodoo
    Allow running Windows server and client simultaneously

General bugfixes

    Added favorite_servers.txt
    Added missing world sound file in Chechnya (levelspec_caveindebris03.wav)
    Added missing world sound file in Chechnya (levelspec_machinerunning.wav)
    Added missing texture file in Mexico (detailgrey_detail_01a.dtx)
    Added missing mission briefing texture in Tunnel (tunnel.dtx)
    Added missing missionbriefing texture in Uganda (uganda.dtx)
    Several fixes in the scripts

Fixes in animation.txt

    Added missing seperators [ , ] at death crouch animation values
    Added missing seperators [ , ] at player and hostage walk strafe left animation
    Corrected type errors in death animation
    Changed hostage strafe animation so it should follow beter
    Changed player jump animation against floating/bunny hopping players

Fixes in animspecialty.txt

    Added missing separators [ , ] at player and vip walk strafe left animation
    Changed the bm_run animation for all classes to a fixed animation
    Changed jump animation against floating/bunny hopping players

Fixes in animequip.txt

    Added "drop" value for the objectives of Antartica and Argentina

Quebec

    VIP (Goran Kurcic) can not be killed anymore by both teams

Colombia

    VIP (Jesus Ortiz) can not be killed anymore by own team
    VIP (Jesus Ortiz) corrected MaxHealth to the same value as StartHealth

Chechnya

    VIP (Commander Gredano) can not be killed anymore by own team

SouthChinaSea

    Corrected deathzones at pirates spawnside
    Added invisible walls which block access to exploitable area's

SriLanka

    Changed TransportSight to 3000 (helicopter should not kill people behind wall anymore, hopefully)
    Removed ground under rocks
    Added invisible walls which block access to exploitable area's


3.0 - [24-04-2005] - Unofficial update

Bug fixes
=========
-Several fixes in the scripts.

New features
============
-Added anti-cheat functions into the client files.
-Added new SriLanka and SouthChinaSea map.
-Added Chechnya, Colombia and Quebec into worlds.rez
-Updated the client files to version 1.28.0.0

2.51 - [25-12-2003] - Unofficial update

-Added missing missionbriefing texture in Uganda (uganda.dtx).
-Fixes in animation.txt
 added missing seperators [ , ] at death crouch animation values.


2.5 - [24-11-2003] - Unofficial update

Bug fixes
=========

-Added missing sound file in Mexico (defuse02a.wav).
-Added missing world sound file in Chechnya (levelspec_machinerunning.wav)
-Added missing sound file in Nafrica (vc06b.wav).
-Added missing sound files in Srilanka (vc07a.wav, c404a.wav).
-Added missing texture file in Mexico (detailgrey_detail_01a.dtx).
-Added missing mission briefing texture in Tunnel (tunnel.dtx).
    
-Fixes in animation.txt
 added missing seperators [ , ] at player and hostage walk strafe left animation.
 added missing seperators [ , ] at death animation values.
 type errors in death animation.
 changed hostage strafe animation so it should follow beter.
 changed player jump animation against floating/bunny hopping players.

-Fixes in animspecialty.txt
 added missing seperators [ , ] at player and vip walk strafe left animation.
 changed the bm_run animation for all classes to a fixed animation.
 changed jump animation against floating/bunny hopping players.

-Fix in animequip.txt
 added "drop" value for the objectives of Antartica and Argentina.



2.4 - [11-04-2004] - Unofficial update

Bug fixes
=========

- Getting "free" money when dragging/dropping equipment on armour.


2.3 - [01-02-2004] - Unofficial update

Bug fixes
=========

-VIP (Goran Kurcic) in Quebec can`t be killed anymore by both teams.
-VIP (Jesus Ortiz) in Colombia can`t be killed anymore by own team.
-VIP (Commander Gredano) in Chechnya can`t be killed anymore by own team.


2.2 - [01-11-2003] - Unofficial update

Bug fixes
=========

-The remote admin password is no longer send to the clients.


2.1 - [04-06-2002] - Server side only

Bug fixes
=========

-Logging stops after 20+ hours.
-Message of the day disappears after 20+ hours.

New features
============

-Turn off the anti-speed hack code within the server application


2.0 - [13.05.2002]

Bug fixes
=========

-Server crash when using the LAW.
-Linux server optimizations and bug fixes.
-No sight when using NV/TV goggles.
-Cursor disappears when on exit menu at end of round.
-HUD on/off not saving correctly.
-Server crash after adjusting mirror damage.
-Hide in rock on Sri Lanka.
-Jumping off boat in South China Seas.
-The muzzle flash not appearing in correct location.
-Some shots were getting lost.
-Friendly fire setting affecting the VIP issue.
-You can no longer shoot your own VIP and win the round.
-Grenade issues.
-Reload problem.
-Jiggies/warping problems (this is the anti cheat code acting up).
-Heavy Machine guns now no longer give you one more round after a reload.
-Teammates almost never appear in the spectate mode.
-Laser sight not working properly.
-Secondary fire for remote C4 doesn't toggle from the switch back to the next charge.
-Smoke trail on LAW and Grenade Launcher disappears as soon as the warhead detonates.
-Blood squirt alignment.
-Eyes removed when player gets too many damage decals.
-Kills register as suicides sometimes.
-Missing sound in Chechnya.
-LAW rocket is rotated wrong when fired on extreme angles.
-Another gas mask crash.

New features
============

-Remote server admin including kicking and banning.
-In game voting for kicking and map rotation.
-You can now choose favorite servers.
-Refresh favorite servers.
-New set of filters.
-Server browser distinguishes the different game versions (eg: White=compatible)
-AFK kick as a server side option.
-IP banning as a server side option.
-Improvement to best weapon selection code.
-Shooting your teammates will cost you money. (no more medic cheat to get cash)
-Server side option to force balanced teams when you join.
-Tac map shows enemies when they are outside.
-Network Connection speed moved to browser screen.


1.2 [04-11-2002]

Bug fixes
=========

-Client freeze at round end.
-Server crash when allied teams kill NPC`s.
-Mouse zoom bug.
-Gas/smoke grenade sprite bug.
-C4 bomb pick up issue.
-Other stability fixes.


1.1 - [01.04.2002]

Bug fixes
=========

-Server has been fixed so that client side speed hacks do not work.
-Reload bug (probably fixed).
-Remote C4, various bugs.
-AW50 has correct damage values.
-Gas grenade/gas mask lockup.
-Random client freezes.
-Gas no longer effects users on next round.
-Purchase screen, fixed bug where users were unable to buy items when they have enough money.
-Grenades existing on client but not server (they persist until the client dies).
-Vision enhancements could get out of sync with server.
-Vision enhancements gave inconsistent results while zoomed.
-LCD screen on view model timed C4 is now full bright.
-Pain sounds from damage brushes cause a pain sound every time health goes down.
-Grenade launcher accuracy matches crosshair, tweak of accuracy values.
-Green question mark.
-Joining level late, destructible models not there.
-Added locked server info to browser.
-Moved network connection speed switch to browser window.
-Added missing sound files for frontend and flash grenade.
-Tweaks to player prediction code.
-Server upload bandwidth spikes when players join
-Duplicate clients appeared in spectator/IO mode.
-Scrollbar thumb control could shrink to tiny sizes.
-Upload speed switch added to server.
-Servers report score to gamespy correctly now.
-Servers report their shutdown correctly to gamespy now.
