m&mf |release| documentation :)
===============================
Addons documentation
-----------------------------

.. toctree::
   :maxdepth: 1

   healing.rst
   influencer.rst
   namedb.rst
   peopletracker.rst

Contents
==================

* :ref:`genindex`
* :ref:`search`

.. * :ref:`modindex`

Basics of the system
===============================

What is this system?
-----------------------------
This system is what was previously called m&m, which is no longer available. m&mf is the free, open-source and community-supported version of m&m.

Installing
-----------------------------

Download the system you want to use. If you use classflexing, the Allclass system will enable everything but it has it's kinks. If you plan on sticking to one class, the class system will be the one you download. DO NOT EXTRACT THE SYSTEM. After downloading, open Mudlet and your profile and open the Package Manager. Click install and select the .zip system that you downloaded. It will ask you to select where the m&m file is, you'll want to choose where your profile folder is saved as the file will be there. 

If you run into issues with installing it by the .zip, you can try extracting it and importing the .xml files individually. 

To install the system, use the **mminstall** command. This'll have the system run auto-configuration first - where it'll detect and enable skills that you have. After that, it'll ask you preference questions about the basic and essential options. Feel free to take your time to ask someone else as to what should you set an option to (like for sipping health). The installation otherwise is fairly painless - and you can always change any option you'd like later with the same command.

:warning: Just a heads up, **m&mf** needs to be loaded *before* you login to Lusternia. So when doing the installation, import it first, make sure GMCP is on in Mudlet settings, then login.

After you've finished the installation, it's best to *mmsave* and restart Mudlet so the system is loaded fresh with all the settings.

Enjoy!

Using the system
-----------------------------
The system cures any ailments you get for you automatically - nothing needs to be turned on. Of course, the system won't cure if it's paused, but while it is, it'll still track all afflictions.

:note: you want to use theh **dv** alias to have the system diagnose, **df** to check your defences and **wf** to check your wounds. This will have the system both recognize the output, and also has the feature of the aliases being usable at any time - the system will do the action asap for you.

To pause or unpause the system, you can use the **pp** alias - using it alone will act as a toggle, but you can also do *pp on* and *pp off*. If you'd like to have the system to allow you to sleep peacefully, you should pause it as well.

To enable anti-illusion in the system, you can do **tn ai** or **tn anti-illusion**. When you no longer need it, you can do **tf ai** (having anti-illusion on means the system will at times will do checks on afflictions before curing them; this is slower than just curing them right away).

If you're lagging a lot, and the system is double-doing actions because of that and etc, you can set the *mmconfig lag #* option to help alleviate that. Do set it back to 0 when you're allright, though. You can also view what options have you currently set with *mmconfig* and *mmconfig2* aliases.

To get a better grasp of the system, I'd recommend that you participate in some combat arena events - free-for-alls, wargames, etc - so you'll have a little bit better idea of what to do when a real fight comes. You should also read up on the aeon/sap/choke curing and practice with the two modes of it in the arena - since it's something new and you'll want to at least have a basic idea of what's going on.

That's about it! Do make sure that you have all the curatives necessary on you and you should be just fine. Take time to look through the available options and aliases as well to acquaint yourself with the system.

Using defences
-----------------------------
The system organizes defences around defence modes, in which you can have it put up different defences. The process of putting them up is also in two stages: *defup* and *keepup*.

When you first switch to a defence mode using *mmdefs <mode>*, defup will put up all of the defences that are on its list. Remember that you can tell defup to put up different defences in different modes - that is the difference in modes. After defup is done, the system will say *Ready for combat!*, and defup will be done - it'll care no more about your defences. Instead, keepup takes over. Keepups job, as the name implies, is to make sure its defences always stay up - if one goes down for any reason, it'll put it back up. Keepup can also be disabled or enabled for convenience with *tf keepup*, *tn keepup*.

To add/remove defences to defup or keepup, you can use *mmdefup <defence>* and *mmkeep <defence>*. You can also create new defence modes with *mmcreate defmode <new mode name>*.

To view your current defup list, you can use **mmshow defup**, and to view your current keepup list, **mmshow keepup**. A green X by a defence means that it's on enabled, a deep blue m by a defence means that it's enabled, and the defence also has a small mana drain. A bright M by a defence means that it's enabled and has a large mana drain.

:note: keepup works in a special manner with selfishness - if it's off keepup, keepup will then do generosity for you. This allows you to use *mmkeep selfishness* or *sl* to toggle selfishness.

Adjusting defence menus
^^^^^^^^^^^^^^^^^^^^^^^
If you'd like to hide certain defences or groups from showing in the (huge) list, use the *mmshow hidelist* alias and click on - or + beside defences, or even entire skillsets, to hide or show them.

Using the *do / dofree* system
-------------------------------
The system includes a very nice feature to assist you in everyday tasks - the *do* queue. It allows you to queue actions (that take balance or equilibrium to do) to be done as soon as possible.

Using it is simple, the syntax is - ``do <action>``. If you already have both balance and equilibrium, then the system will do your action at once - otherwise, it'll do it as soon as you regain both balance and equilibrium. If you ask it to do multiple actions, then it'll do them properly, one action per balance/eq regain.

If you'd like the system to do multiple actions _per_ one balance/eq regain - for example, your bashing attacks uses two arms instead of one balance - then you can use the **$** sign to separate commands - ie, ``do swing rat$swing rat`` will swing the rat twice at once.

The really useful feature of do is the `dor` alias. It allows you to repeat an action indefinitely - does it on every balance/eq regain. To use it, you can use *dor <action>* to start it, and *dor* or *dor off* to disable it. For example, *dor kick rat* will kick the rat forever! This, as you might've noticed, is useful in bashing and an example **F2** keybinding is provided to show how to make use of it. You are reponsible for using it, though - don't do anything that is against the rules of Lusternia.

Note that you can also use your own aliases as actions - ie if your bashing alias is **dd**, then **dor dd** will work.

Other aliases provided with do are *dofirst*, *undo*, *undoall*, and *mmshow do*.

Along with *do*, a *dofree* system is also provided - it's for actions that require balance/equilibrium, but don't take it. Aliases for it are similar - *dofree*, *dofreefirst*, *undofree* and *undoallfree*.

:note: monks and warriors should have *config prompt armbalance on* for m&mf to track your armbalance properly.

Ignoring curing things
----------------------------------
*m&mf* has a feature that allows you to ignore curing afflictions - this can come in handy handy in many situations; such as ignoring clumsiness for testing, or ignoring an affliction that you get frequently while bashing but don't want to waste curatives on.

To view a list of all things you can ignore, you can use the *mmshow ignorelist* alias. Warning, the list is big! While some afflictions are self-explanatory, some names require a bit of explanation:

lovers -  lust. Requires rejecting the person(s) to cure.
lovepotion - the potion that'll make you fall in love with others or vice versa. If you added the lovedef on defup or keepup, then this 'affliction' will be treated as good and won't be cured.

To ignore an affliction, you can do *mmignore <affliction>*. It acts as a toggle - so doing it again will remove it from the list.

Lastly, you can use *mmshow ignore* to view all items you've set to ignore.


On affliction locks
----------------------
The system has features to both warn you when you become locked via certain afflictions, and cure the said locks - either usage of the cleanse enchantment/skill, or a powercure (Lowmagic Green/Highmagic Gedulah).

To enable cleanse lock curing, you do *mmconfig cleanse yep**, and to enable powercure curing, **mmconfig <green or gedulah> yep**.

Warnings are done automatically for you on the prompt, and are specially coloured so they don't get in your face too much but are still clearly visible. They're appended after the prompt, before the commands are shown, so they're static in the position as well.

==========    ========= ==================
Lock name     Cure      Afflictions needed
==========    ========= ==================
arms          (none)    missingleftarm, missingrightarm
cleanse a     cleanse   slickness, slitthroat
cleanse b     cleanse   slickness, asthma, crushedwindpipe
green a       powercure slickness, slitthroat, and prone or paralyzed or bound in some way
green b       powercure slickness, asthma, crushedwindpipe, and prone or paralyzed or bound in some way
slow          powercure aeon, concussion
venom         focus     anorexia, asthma and slickness
hemi          smoke     hemiplegyright, hemiplegyleft
==========    ========= ==================

On the scripting side, the *mm.me.locks* table holds all current affliction locks you've got (as a key-value table), and *m&m got lock*, *m&m lost lock* events are raised whenever you gain/lose the affliction locks.

Choke, aeon and sap curing
----------------------------------------------------------
One of the most powerful features of **m&mf** is perfect choke curing. By that, it is implied that the system can do everything - cure (apply salves, outr if necessary and eat herbs, smoke, drink, writhe), keepup defences and etc while in aeon, sap or choke. First two of course have been prioritized to be cured as soon as possible.

Now, there is the problem of you doing stuff while in aeon/sap/choke - anything you do would disrupt the previous command, and if the system is, for example, trying to cure you - commands will be getting in the way and it'll have to keep restarting and etc. Sometimes you can do a command accidentally, when you didn't even mean to disrupt anything, or sometimes you *want* to override what the system is doing - for example, curing you while all you really want to do is tumble away.

That's why the system offers two modes for aeon/sap/choke curing. First one is where if the system is trying to do something, and you (or your scripts) do something as well, it will *deny* that command - so that it does not get sent, and does not disrupt what the system is doing. The second mode is where your commands will *override* what the system is doing - so it will let your commands through, and resume doing stuff after they go through.

The option to change this is *mmconfig blockcommands* - and a shortcut alias of *tsc* is also provided to toggle this quickly in combat.

Which mode is best to use is up to you - if you aren't an experienced combatant yet, then you might want to keep command denying on so you don't get in the systems way of curing. Experienced combatants on the other hand might want to enable command overrides so they can fight offensively in choke, and pause sending commands themselves to let the system cure up important afflictions when necessary.

:note: while in choke curing, aeon or sap the system will prefix an (a) to the prompt. It's just a subtle way to let you know of the situation you're in. Additionally, the a will be red if the system is currently doing something, or will be green if you're currently overriding the system, or will be blue if neither you nor the system are doing anything.

:tip: you can always create aliases with different names for system aliases that you find hard to remember and just copy/paste the script they do.

:tip: if you'd like to issue a command while blockcommands is on, while keeping blockcommands enabled the the max amount of time - you could alias to do this: *mm.config.set("blockcommands", "off") send("my command") mm.config.set("blockcommands", "on")*


Herb precaching
---------------------------------
Another great feature **m&mf** offers you is herb precahing - keeping a certain amount of a herb out in your inventory at all times. This is very useful for two reasons - firstly, m&mf will then be able to eat the herb and then outr it when necessary instead of outr and eat, and this'll shave off sometimes very important miliseconds on an affliction getting cured. Secondly, m&mf won't have to outr the herb and be able to eat it right away if you already have it in aeon/choke/sap.

To setup herb precaching, do **mmsetup pc**. Click on the + besides a herb to increase the amount, - to decrease. Herb precaching preferences are also specific to a defence mode - so you can have some on precache in your combat mode, and less or none in your bashing or normal.

:tip: if you'd like to stop precaching, you can switch to the *empty* defences mode - *mmdefs empty*! (provided you don't fill the empty defence mode with any herbs)

Changing colour highlights
---------------------------------
**m&mf** does some basic highlights on your balances recovery and passive healing. You can change the highlighting as you wish without worrying - it won't affect the system. Just create triggers for the things you'd like to highlight *after* the *m&mf* triggers folder, enable highlight option, and pick your colour(s).


Setting a custom prompt
-----------------------------
Since Lusternia won't be implementing custom prompts like Aetolia allows you to, I've implemented the option in **m&mf**. Setting it is rather easy - no coding is required, and it follows the Aetolia style as well.

You can set a custom prompt with the *mmconfig customprompt <line>* command.

To disable it, you can do *mmconfig customprompt off*, and to enable it back, *mmconfig customprompt on*. If you'd like to see what line did you set your custom prompt to be, you can check *mmconfig2* and click on 'view'.

What goes inside the *<line>* is how you build your prompt - with tags and colurs. Tags start with the @ symbol, colours start with the ^ symbol - and to apply a colour to a tag, you use it before the tag. Available tags are:

==================== ===============
Tag                  What it shows
==================== ===============
@health              your current health
@mana                your current mana
@ego                 your current ego
@willpower           your current willpower
@endurance           your current endurance
@power               your current power
@reserves            your current power reserves
@maxhealth           your maximum health
@maxmana             your maximum mana
@maxego              your maximum ego
@maxwillpower        your maximum willpower
@maxendurance        your maximum endurance
@%health             your current health in percent
@%mana               your current mana in percent
@%ego                your current ego in percent
@%willpower          your current willpower in percent
@%endurance          your current endurance in percent
@mo                  your current momentum (kata users only)
@esteem              your esteem (requires GMCP)
@essence             your Demigod/Ascendant essence (requires GMCP)
@empathy			 your current empathy level (healing users only, requires GMCP)
@commaessence        same as above, but adds commas to make it visually easier
@shortessence        essence in short form, with one decimal spot (ie, 1.1m)
@shortessence2       essence in short form, with two decimal spots (ie, 1.19m)
@%xp                 how much percent in xp have you attained in this level
@-%xp                how much percent in xp do you need until the next level
@defs                defences if you have them - blind, deaf, kafe, rebounding
@eqbal               balance/equilibrium if you have them
@prone               a small 'p' if you are prone
@Prone               a big 'P' if you are prone
@armbal              right/left arm balances if you have them - requires that *config prompt armbalance on* is enabled
@psibal              psionics balances if you have them (psionics users only)
@timestamp           the current timestamp, in hh:mm:ss.zzz format
@diffhealth          shows the difference in health since the last prompt
@diffmana            shows the difference in mana since the last prompt
@(diffhealth)        like diffhealth, but adds () when there's a change
@(diffmana)          like diffmana, but adds () when there's a change
@[diffhealth]        like diffhealth, but adds [] when there's a change
@[diffmana]          like diffmana, but adds [] when there's a change
==================== ===============

Available colours are:

==================== ===================
Colour               What colour it sets
==================== ===================
^1                   proper colour for your current health (green if ok, yellow if wounded, red if badly wounded)
^2                   proper colour for your current mana
^3                   proper colour for your current ego
^4                   proper colour for your current willpower
^5                   proper colour for your current endurance
^6                   proper colour for your current power
^7                   proper colour for your current momentum (kata users only)
^8					 proper colour for your current empathy (healing users only)
^r                   red
^R                   dark red
^g                   green
^G                   dark green
^y                   yellow
^Y                   dark yellow
^b                   blue
^B                   dark blue
^m                   magenta
^M                   dark magenta
^c                   cyan
^C                   dark cyan
^w                   white
^W                   dark white
==================== ===================

This is the initial first go at it which already replicates all from Aetolia that is relevant. I'm up to new tag / colour suggestions to make this more powerful - so feel free to mail in ideas.

Just as Mudlet and m&mf, the custom prompt was designed with speed in mind and optimized to the max. In practical tests, the speed of it is *very* fast - making it hard to measure because the difference on my laptop isn't too noticable. You can test for yourself though - the S: number bottom-right in Mudlet shows your system lag - how much time *all* your triggers took to process the last line. Hold the enter button down on a blank command line so all you'll be getting is a bunch of prompts, and watch the S: number change. Do that with and without the custom prompt, and you'll probably be convinced that it's fast.

Here are some sample prompts for you to get ideas from. Feel free to share your custom prompt so I can add it here: ::

  ^1@healthh, ^2@manam|@%mana%, ^3@%egoe%, ^6@powerp, ^G@%willpowerw%, @%endurancee%, @eqbal @defs-
  5050h, 6600m|100%, 100g%, 10p, 100w%, 100e%, ex dbk-

  ^r[^gH:^1@health^r|^gM:^2@mana^r|^gE:^3@ego^r|^gEnd:^5@%endurance%^r|^gWill:^4@%willpower%^r] [^gP:^6@power^r] [^w@defs ^w@eqbal^r]
  [H:2985|M:2865|E:2694|End:100%|Will:100%] [P:10] [ ex]

  ^r(^1@health^w|^1@%health^r), ^b(^2@mana^w|^2@%mana^b), ^g(^3@ego^w|^3@%ego^g), ^C(^4@%willpower^C), ^c(^5@%endurance^c), ^6@powerp ^w(^w@%xp|@-%xp^w%) (@eqbal@defs@psibal^w)-
  (5869|119), (7104|116), (8588|126), (100), (100), 10p (89|11%) (exdksSi)-

  -- remove @mo if you aren't a monk
   ^G< ^y@mo^G[@eqbal@armbal]^6[@power] ^G| ^1[@health|@%healthh] ^2[@mana|@%manam] ^3[@%egoe] ^G| ^4[@%willpowerwi]^5[@%enduranceen] ^G| [@%xp%][@defs]."

Adding custom tags and colours
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You can also define your own custom tags (that run functions or display a variable) or colours for use in the custom prompt. Doing so is easy, and here are a fre examples: ::

  -- define a custom tag ^magenta that inserts the magenta colour
  mm.adddefinition("^xmagenta", "'<magenta>'")

  -- define a custom tag that displays the value of a variable, 'target'
  mm.adddefinition("@target", "target")

  -- or define a a tag that runs a function, gets the result from it and inserts it.
  mm.adddefinition("@myfunction", "myfunction()")

  -- returns the value of the 'target' variable in red, or 'no target' in green if it's not set
  function myfunction()
    if target then return "<red>"..target else return "<green>no target" end
  end

  -- or define a tag that inserts the timestamp
  mm.adddefinition("@timestamp", "getTime(true, 'hh:mm:ss.zzz')")

From these examples you can derive some rules:

- tags should not 'nest' within each other - declaring a colour tag of ^magenta wouldn't work since we already have ^m and that one would 'steal' it
- colour tags should have the colour name (you can see possible color names by running the showColors() function) inside "'<name here>'"
- tags that just point to variables should just have the variable name in quotes
- tags that point to functions should have the function name with two brackets in quotes
- note: if you'd like the function not to insert any text, then return ""
- tags can really start with anything and aren't limited to ^ or @, but it'll be easier for you to keep the tradition

Tags are not saved upon a profile restart, so you'd want your scripts declaring the necessary tags on startup. If you'd like to change a tag you made previously, then you can just call the functiona again and it will over-write it. Do note that it will also allow you to overwrite the default m&mf tags - you normally shouldn't do that, but if you do it by accident, they will be restored on a profile restart.

What to do if you have a problem?
----------------------------------------------------------
Copy/paste the problem parts that you saw in the game and email to me.

Then, try checking diagnose if it's affliction related, or *def* if it's defences-related. For afflictions, if you're still having a problem - try *mmreset affs* (or *mmreseta* for short).

If it's a problem with missing lines, send me an email with them and they'll be added.

Updating the system
---------------------------

a) delete m&mf in Mudlets Package Manager
b) download new m&mf zip
c) install new m&mf zip itself

Don't worry, your personal settings won't be lost. You can also delete the zip after you've installed it, it's not needed anymore.

It's OK to get several names listed in the package manager when you install it - those are addons. When you uninstall m&mf, they'll all get uninstalled at once as well.

Getting help
-----------------------------
Feel free to ask questions about m&mf either in the m&mf clan or a knowledgeable friend!

Submitting ideas
---------------------------
Please email them in! I'm always looking to improve things for the better and appreciate other views. Also mention if you'd like to avoid being credited in the changelog, or list the name of the character to credit if you have multiple.

Thanks! :)

mmconfig options
-----------------------------

.. glossary::
  :sorted:

  aeonfocus
    specifies if afflictions being cured in slowcuring mode will be focused.

  aeonprios
  	sets a user definied slowcuring priority list optimized for aeon

  adrenaline
    Will cause athletics users to only use adrenaline for the quicksilver defense.

  allheale
    specifies whenever the system should make use of allheale to cure affs or not. Currently, it only makes use of it for blackout. You can disable this if you don't have any allheale potion so the system won't spam trying to use it.

  alwaysrockclimb
    specifies whenever the system should try to save power in combat by climbing normally if it can (and rock climbing only when there are things hindering you) or just outright always rock climbing. Hidden afflictions can slow down rock climbing if the system tries to normally climb first, so if those are an issue and power isn't, you can make the call.

  arena
    specifies if system should work as if you're in the arena or not.

  assumestats
    sets the % of health, mana, and ego which the system will assume you have when afflicted with blackout or recklessness (and thus your real stats are unknown).

  attemptearlystun
    Will attempt to start curing before stun wears off in slowcuring for more effective curing. Considers truetime defence.

  autoarena
  	turns on arena mode when entering an arena and turns it off upon exiting the arena 

  autohide
  	Automatically hides inactive skillsets and shows active skillsets on deflist (runs off gmcp.Char.Skills.Groups event)

  autorecharge
    specifies whenever the system should automatically recharge healing/protection scrolls after using them (make sure you have an energy cube with enough charges for this to work).

  autoreject
    can be 'whitelist', 'blacklist', 'on' of 'off'. Setting this to on or off enables or disables autoreject. Setting it to 'whitelist' means that names on the lust list (mmshow lustlist) are the ones that will *not* be autorejected, while everyone else will be. Setting it to 'blacklist' means that nobody except names on the lustlist will be autorejected. To add/remove names to the lustlist, see the *lustlist* option.

  autorewield
    enables auto-rewielding of items that get forcefully unwielded - so if a weapon gets knocked out of your hand, m&mf will rewield it for you, but won't if you unwield it yourself, willingly. Requires GMCP being enabled in Mudlet settings (that requires Mudlet 2.0+).

  autowounds
   has the system automatically check your wounds after a specific number of warrior hits, so tracking is more accurate. Wounds checking is gagged when the system does it automatically, so that you aren't spammed. This is set at 3 by default for Healers and at 10 for non-Healers.

  beastfocus
    specifies if system should attempt to use beastfocus before regular focus. Will automatically turn off if beast isn't present and it's on.

  blindherb
    sets which herb the system should use to cure blindness. Can be faeleaf or myrtle (default is faeleaf).

  blockcommands
    toggles whenever the system will deny your commands if it's currently doing something in slow curing mode, or your commands override what the system is currently doing.

  bloodboil
    (psychometabolism only) has the system ignore bleeding, instead letting bloodboil take care of it if the defence is up and you're above half ego.

  cleanse
    specifies whenever the system should make use of the cleanse effect (so enchantment or skill) or not. The system currently makes use of it to get out of slickness-related locks, cure sap, and anything else that requires cleanse.

  clot
    lets the system know it can make use of the clotting skill to stop bleeding when you're above the allowed mana level. The system will make use of chervil otherwise if it can't.

  coltsfootid
    sets the pipe ID to use for the coltsfoot pipe. Normally you wouldn't need to use this, as the system can auto-assign IDs from the *pipelist* command - but if you don't have it, you can use this option.

  commandecho
    with this enabled, the system will echo the commands that it's doing on the main screen.

  commandechotype
    you can specify whenever the system should use **plain** or **fancy** command echos. Plain are the default Mudlet ones - one per line with the default color for them. Fancy ones are compressed into one line for better clarity and less spam.

  customprompt
    see *Setting a custom prompt* on how to setup your custom prompt with this.

  deafherb
    sets which herb the system should use to cure deafness. Can be earwort or myrtle (default is myrtle).

  doubledo
  	enables repeating of actions while afflicted with stupidity or void - so the system will do something not once, but twice at once.

  echotype
    sets the style of the systems echos. See *mmsetup colours* for a list of available options.

  enchantments
  	toggles whenever to use rituals/cosmic skills or their charge-based enchantment equivalents instead.

  egouse
    (psychometabolism only) sets the % of max ego above which, if you have the bloodboil defence up and bloodboil option enabled, the system will not clot but let bloodboil cure the bleeding. If you're below this amount, it'll cure bleeding.

  eventaffs
    advanced option - this will have the system raise Mudlet events for when you receive or loss an affliction. The event names are *m&m got aff* and *m&m lost aff*, and the name of the affliction is passed as an argument. The events are raised after the *mm.affl* table is adjusted, so it's safe to operate on it in your event handlers.

  faeleafid
    sets the pipe ID to use for the faeleaf pipe. Normally you wouldn't need to use this, as the system can auto-assign IDs from the *pipelist* command - but if you don't have it, you can use this option.

  focus
    Adds/Removes an affliction to the focus table. Afflictions in the table will always be focused.

  focusbody
    (Deprecated - turn it off) - lets the system know if you have the Focus Body skill in Discipline so it can use it to cure.

  focusmind
    (Deprecated - turn it off) - lets the system know if you have the Focus Mind skill. If you don't have it, the system will just make use of normal (herbs, salves, etc.) cures for mental afflictions.

  focusspirit
    (Deprecated - turn it off) - lets the system know if you have the Focus Spirit ability or whenever it should use it to cure.

  gagbreath
    toggles whenever the system should gag (hide) breating or not. It will completely gag it - commands to put it up will not be shown, and you holding breath and exhaling will be completely gagged as well - so you will see no extra spam, at all.

  gagclot
    toggles whenever the system should gag (hide) clotting or not. This is typically quite spammy, so it's a convenience to have this enabled.

  gagrelight
    toggles whenever the system should gag (hide) pipe relighting or not.

  geniesall
  	Will use the 'curio collection activate genies' command to put up all the genies, removing spam.

  gmcpvitals
  	sets m&mf to pull stats information from Char.Vitals - this means that it won't spam when deffing up locked in modules and will track balance/eq in blackout, among other things.

  green
    (lowmagic only) sets whenever the system should automatically invoke green to cure powercure locks.

  gedulah
    (highmagic only) sets whenever the system should automatically invoke gedulah to cure powercure locks.

  healingskill
    sets the highest ailment type that you can cure with, so the system knows which afflictions can you cure. ie, if you're Transcendent, you'd set it to *regenerate*.

  insomnia
    with this enabled, the system will make use the Insomnia skill in Discipline when mana levels permit for the insomnia defence. Otherwise, it'll use merbloom for the effect.

  lag
    lets the system known if you're lagging or not - you want to use this option when you see the system double-doing command and wasting things too often. 0 is default, ie not lagging, and the number goes up to 3.

  loadsap
  	Will import your sapprios list upon being afflicted by sap and your aeonprios list upon curing sap.

  lustlist
    adds or removes a name to the lust list. See autoreject option on how will m&mf deal with the names on it.

  manause
    sets the % below which the system should *not* use mana. ie, setting it to 30% will have the system not use insomnia, focus mind and etc. if you're at 29% of total maximum mana but revert to normal cures.

  myrtleid
    sets the pipe ID to use for the myrtle pipe. Normally you wouldn't need to use this, as the system can auto-assign IDs from the *pipelist* command - but if you don't have it, you can use this option.

  org
    sets the name of the city/commune you're in (this is needed for org-specific defences).

  queuing
    lets the system know if you have Queuing in Combat. With this enabled, the system will make use of queueing and use normal stancing otherwise.

  parry
    lets the system know whenever you have parry or not so it can make use of it.

  powerfocus
    specifies if the system should use powerfocus when focusing on afflictions.

  preclot
    toggles whenever the system should preclot - that is, start clotting when you receive bleeding but before you take damage from bleeding. Doing so will save you from some bleeding damage, at the cost of a bigger willpower usage in the long term.

  relight
    toggles whenever the system should automatically relight pipes that go out. While it doesn't cause extra spam while lighting them, having the 3 messages appear every once in a while can get annoying - so there's an option. Note though - if the system needs to use a smoke cure, and you have pipe relighting off, it **will** relight that pipe regardless to cure. But don't rely on keeping your pipes unlit in combat; do enable the option if you're going fighting.

  repeatcmd
  	additionally repeats all system commands x times (so repeatcmd 1 will do everything twice, repeatcmd 2 will do everything thrice). Useful for when you're drunk or really insane.

  rockclimbing
    sets whenever you have the rockclimbing skill or not - if you do, the system will make use of it when normal climbing out of a pit can't work.

  sapprios
  	used to load a user definied slowcuring priority list optimized for sap curing

  screeleft
    (nekotai only) sets the poison to use for the screeleft defence.

  screeright
    (nekotai only) sets the poison to use for the screeleft defence.

  scroll
    lets the system know if it should make use of the Healing Scroll for replentishing health, mana or ego when you fall below the set scroll % for the specific stats.

  scrollego
    sets the % of ego at which the system will read a Scroll of Healing should you go below it.

  scrollhealth
    sets the % of health at which the system will read a Scroll of Healing should you go below it.

  scrollid
    sets the ID of your Scroll of Healing. You can find it out by doing *ii scroll*.

  scrollmana
    sets the % of mana at which the system will read a Scroll of Healing should you go below it.

  soap
    sets whenever the system will use the artefact soap or the cleanse enchantment/spell for curing.

  secondarysparkle
    toggles whenever the system uses sparkleberry or the herb that currently gives the sparkle effect for sparkle usage. Do not turn this on (or turn this off if on) when the Nature Domoth Crown is not in effect, since the effect does not work then.

  showchanges
    sets whenever the system will show your health/mana/ego gain or loss on the prompt.

  sipego
    sets the % of ego below which the system will sip bromide.

  siphealth
    sets the % of health below which the system will sip health.

  sipmana
    sets the % of mana below which the system will sip mana.

  sparkle
    toggles whenever the system should use sparkle for healing your health/mana/ego should you fall below the specified levels.

  sparkleego
    sets the % of ego below which the system will eat sparkle.

  sparklehealth
    sets the % of health below which the system will eat sparkle.

  sparkleherb
    sets which herb is available to be used for the sparkle effect. You need to enable secondarysparkle if you actually want the system to use this herb over sparkleberry.

  sparklemana
    sets the % of mana below which the system will eat sparkle.

  stanceskill
    sets the maximum available stance skill in Combat that you have.

  steamid
  	sets the pipe ID to use for the soothing steam pipe. Normally you wouldn't need to use this, as the system can auto-assign IDs from the *pipelist* command - but if you don't have it, you can use this option.

  summer
    (lowmagic only) with this enabled, the system will make use of summer whenever you get vines, roped, shackled, truss, or tangle and you have both balance and equilibrium.

  tipheret
    (highmagic only) see above, this is a summer equivalent.

  unknownany
    sets the amount of unkown afflictions will the system let you have before it diagnoses to find out what they are.

  unknownfocus
    sets the amount of unknown, but focusable affliction the system will let you have before it diagnoses. It will use focus mind meanwhile to cure them meanwhile, but if the amount goes over this limit, it'll diagnose.

  usehealing
    can be either *full*, *partial* or *none* (default is *none*). *full* means that Healing will be mainly used for curing - and normal curing will only be used for afflictions that Healing can't cure, or when you're below the mana limit. *partial* means that normal curing will be used for everything, but supplemented with Healing whenever possible. *none* means that Healing won't be used at all.

  vitaemode
    sets the defences mode into which the system should go into after hitting vitae or being insta-rezzed in any other way. By default, this is set to *empty* so that you aren't screwed into dying again while redeffing. You might, however, want to improve this for yourself by creating a defence mode that has kafe and other basic herb or balance-less essentials and set vitaemode to it - so in a raid situation, you get cloak up right away and don't get killed again, but aren't sitting there in the room forever redeffing.

  waitherbai
  	if any-illusion is enabled, this will have the system not eat herbs while confirming suspicious illusions (slickness).

  warningtype
    can be either *all*, *prompt* or *none* (default is *all*). This is about instakill warnings - with all, then the warning will be prefixed on every line while it's in effect. With prompt, it will only be prefixed to prompt lines - and none will have it not prefix anything.

  wonderall
  	Will use the singular 'wondercorn activate all' to put up all the wondercorn defences, removing spam.

  ccto
    adjusts where do the :term:`cc alias <cc>` and the :ref:`mm.cc() <mm-cc-function>` function report information to. You can set it to a variety of different options:

      * *pt* - will report to the party channels.
      * *clt* - will report to the currently selected clan.
      * *tell person* - will be telling to that selected person.
      * *ot* - will be reporting on the Order channel.
      * *team* - will be reporting to the team channel (in the arena).
      * *short clan name* - will be reporting to that specific clan - you can see the short name of a clan by doing *clans*, the short name is in the dark-yellow brackets.
      * *echo* - will be echoing things back to you, and not telling anyone else.


  changestype
    sets the display showchanges option, when enabled, will use. Possible options are:

      * *full* - default, shows just the exact amount of health/mana that was lost/gained, ie - '# Health'
      * *short* - same as full, though in a more consise format '#h'
      * *fullpercent* - uses a format similar to full, but also shows the amount as a % of your relative max
      * *shortpercent* - uses a format similar to short, but also shows the amount as a % of your relative max

  hook
  	(cavaliers only) enables the use of the `Cavalier Hook <https://sites.google.com/site/xieltalnara/Cavalier>`_ skill when parrying.

Advanced usage
===============================

Scripting with it
-----------------------------

Afflictions
^^^^^^^^^^^^^
The system provides a lot of functions for direct use in your own combat/personal metasystem, and those are described in the m&mf API.

:tip: A lot of functions take a *echoback* argument - it's a boolean value that lets the function know whenever it should echo the results of its work or not.

To check whenever you have a specific affliction, you can check it against the *mm.affl* table - ie, ``if not mm.affl.paralysis then ... end``. You can find out the name of all afflictions by checking the *mmshow ignorelist*. Additionally, if the affliction can has some numeric value attached to it - like how much are you bleeding - then the **mm.affl.<affliction>.count** will be available that has the number (ie, **mm.affl.bleeding.count**).

:note: that the ``mm.affl`` table is read-only - modifying it won't have effect on the system affliction tracking.

For easier scripting, you can also ask the system to raise events for you when you receive or lose an affliction with the *eventaffs* option - so your own combat system can react to you receiving/losing afflictions, without having to make triggers for everything yourself and simply by relying on existing m&mf ones. The system raises two events with this enabled - **m&m got aff** and **m&m lost aff** with the first argument being the affliction name. Several examples are provided in the *m&m/Examples* script folder for you to look at as well.

Checking how long have you had an aff
..........................................
m&mf keeps track of how long an affliction has been on you - and you can enable to see that with *mmconfig showafftimes*. You can also make use of this in your scripts - in a UI, for example, that lists your current afflictions.

To check how long a particular aff has been on you, use this: ::

   getStopWatchTime(mm.affl.<affliction>.sw)

This will tell you in seconds, with up to a thousandths of a second, how long have you had an aff for.

Using this in a UI, you'd probably want to setup a Mudlet Timer to update your affliction lists - because while updating your affs on every prompt might have been okay, if you want to add the times in there, you'd obviously need to update your list more often if you want the times to stay relevant.

Some strategies for dealing with this could be...

 * set a global timer for 1s - this means your times will have 1s precision, so you'd want to round the time you display to the nearest second - **math.round(getStopWatchTime(mm.affl.<affliction>.sw))**
 * set a global timer for 100ms - this'll tick 10 times a second. You'd want to round the time you display to one decimal point - **string.format("%.1f", getStopWatchTime(mm.affl.illness.sw))** will do it.

Here's a little example to show you affs you've got with times: ::

   cecho("<red>Affs:\n")
   for name, aff in pairs(mm.affl) do
     echo(string.format("%-10s (%.1f)\n", name, getStopWatchTime(aff.sw)))
   end

Change the echoes to redirect into a miniconsole, stick that code into a 100ms timer like so, and you'll have something that updates pretty well.)

.. image:: images/updating-aff-counts.png
   :align: center

Balances
^^^^^^^^^^^^^^
To check whenever you have a certain balance, you can check it against the *mm.bals* table - like so: ::

  if mm.bals.balance and mm.bals.equilibrium and not mm.affl.prone then
    dostuff()
  end

You can find the names of all balances by checking *mmshowb* or doing ``display(mm.bals)``. Note that while the *mm.bals* table is modifyable and changes will take effect in the system, there really shouldn't be any cases where you'd need to mess with it.

Defences
^^^^^^^^^^^^^^^
Your current defences are available in the *mm.defc* table. Checking if you have a defence is similar to balances: ::

  if mm.defc.nightkiss then
    send("nightkiss thing")
  else
    send("nature curse thing")
  end

:note: technical note - defences are stored in key-value format, with the defence name being the key, and the value a boolean. If you don't have a defence, it either won't exist in the table, or be set to false - so using *not mm.defc...* is best.

Stats
^^^^^^^^^^^^^^
To check your current stats (health, mana, power, etc) you can look in the *mm.stats* table, for example: ::

  if mm.stats.currentpower >= 8 then
    send("toadcurse enemy")
  end

You can do ``display(mm.stats)`` to see all the available stats. Like balances, changing this table will affect the system, but there should be no reason to do so.

:note: the system also fills mm.stats.momentum for Kata users.

:note: esteem and Demigod/Ascendant essence are only available with GMCP enabled.

Inventory / rift
^^^^^^^^^^^^^^^^^^^
The system tracks the herb contents of your rifts and inventories (for pre-caching and eating optimization purposes).

You can make use of this data by accessing the *mm.me.riftcontents* and *mm.me.invcontents* tables - the key is the herb, and the value is the amount of the herb that's present (if none is present, then the amount is 0). ::

  -- check if we have at least one earwort in inv or not:
  if mm.me.invcontents.earwort > 1 then
    echo("Got some earwort in the inventory!")
  else
    echo("Don't have any earwort in the inventory.")
  end

Lust list
^^^^^^^^^^^^^^^^^^^^^^
If you'd like to have access to the lust list in your triggers, then it is available via *mm.me.lustlist*. The lustlist mode is available via *mm.conf.autoreject* - which can be 'black' or 'white'.

For example, if you'd like to check if a name was on it, you could do: ::

	-- in a trigger, check if the captured name is on our lust list
	if mm.me.lustlist[matches[2]] then
		mm.echof("%s is on our list! murder them!", matches[2])
	else
		mm.echof("Looks like %s is pretty innocent.", matches[2])
	end

Other misc things in mm.me
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
As you might've noticed, mm.me contains a handful of data available for your scripting. To see what's all available in it, you can do display(mm.me) in an alias - currently it also stores your name, class and skills, rift and inventory herb contents, wielded items, lustlist, and the do & dofree queues.

*mm.me* also stores mm.me.healthchange, mm.me.manachange, and mm.me.egochange - the differences in h/m/e stats from the last prompt.

Locks
-----------------------------
m&mf makes the current affliction locks you have available in the *mm.me.locks* key-value table. ::

	-- check if you have no locks
	if not next(mm.me.locks) then mm.echof("not locked!") end

	-- echo all locks
	if next(mm.me.locks) then mm.echof("locks: %s", mm.oneconcat(mm.me.locks)) end

	-- check for a specific one
	if mm.me.locks["green a"] or mm.me.locks["green b"] or mm.me.locks["green c"] then mm.echof("Greenlocked!") end

Configuration options
^^^^^^^^^^^^^^^^^^^^^^^
All of the systems configuration options are available in the *mm.conf* table for reading purposes (for example, you might want to check the value of *mm.conf.paused* in your scripts). If you'd like to set the options, it's recommended that you use the *mm.config.set()* function as it will make sure your values make sense.


Events raised by the system
-----------------------------
The system raises several Mudlet events to help you trigger on reliably.

===================== =========== ============
Event name            Arguments   Description
===================== =========== ============
m&m lost aff          aff name    requires *mmconfig eventaffs* to be enabled. Raised whenever you're cured of an affliction, affliction name being the single argument.
m&m got aff           aff name    requires *mmconfig eventaffs* to be enabled. Raised whenever you become afflicted, affliction name is included as an argument.
m&m before the prompt	(none)			raised right before the system starts processing information ont the prompt - useful for having the last chance to use *mm.ignore_illusion* or benchmark system performance
m&m done with prompt  (none)      raised whenever the system is done with processing prompt information - this means that the *mm.stats* table has been updated and is realiable to be used.
m&m balanceful ready  (none)      raised whenever the balanceful function queue is available (after it has been made or reset). It's recommended to use mm.addbalanceful on this event (since you can't really guarantee whenever your script or m&mf are loaded first in the users profile).
m&m balanceless ready (none)      raised whenever the balanceless function queue is available (after it has been made or reset). It's recommended to use mm.addbalanceless on this event (since you can't really guarantee whenever your script or m&mf are loaded first in the users profile).
m&m done defup        defs mode   raised whenever the defup is done (and you see the 'Ready for combat!' message). The argument given is the defences mode that you're in.
m&m system loaded                 raised after the system has loaded - so you can use the systems functions (balanceful/balanceless, creating your UI, and so on) - without worrying of your script being run first
m&m onshow                        raised when the 'mmshow' is used - you can use this to add your echoes to it
m&m got lock          aff lock    raised whenever you get a particular affliction lock
m&m lost lock         aff lock    raised whenever you cure a particular affliction lock
m&m got def           defence     raised when you obtain a defence
m&m lost def          defence     raised when you lose a defence
m&m redirected aff    from, to    raised when an affliction is redirected to another one in Overhaul mode. For example, with paranoia in Overhaul mode, vertigo would be getting redirected to be paranoia
m&m add skill 	      skillset    raised whenever you activate a previously inactive skillset. Useful for classflexing.
m&m remove skill      skillset    raised whenever you inactivate or forget a previously active skillset. Useful for classflexing.
===================== =========== ============

Scripting to do things on the prompt
--------------------------------------
Often times you'd like to do something on the prompt - update your labels, script some action or etc. while using information provided by the system. Since Mudlet has the feature of matching triggers in the visual order they are in, you can ensure your trigger is always run after m&mf has updated values by placing it below the m&mf group.

This isn't perfect though as it presents two complications - a) whenever you update m&mf, it's trigger folder will be last - ie, you'll have to move it's folder above yours again, and b) it's another trigger to match the prompt when m&mf already matches it.

To solve both of these things, you can instead use the *m&m done with prompt* event that the system raises to 'trigger' on the prompt. While Mudlet events are described in the Mudlet manual, the short rundown to create a handler is like so:

.. hlist::
   :columns: 1

   * create a new Script
   * put ``m&m done with prompt`` into the *Add User Defined Event Handler* box and press enter
   * create a function in the script that will do your stuff
   * give the script itself the same name as the function name

Then you can do whatever you'd like to do in the function. If you don't know the syntax for how to create a function, it's `described in the Lua manual <http://www.lua.org/manual/5.1/manual.html#2.5.9>`_, and the basic format is like so: ::

  function *my function name*()
    *stuff I want to do in my function*
  end

  -- example:
  function foo()
    echo("hi!")
  end

  -- now doing:
  foo()

  -- will run the function, and the function will echo *hi!*

.. image:: images/prompt-example.png
   :align: center

Scripting to do actions on balance/eq
--------------------------------------
While the system already offers a do queue that's easy to use in simple aliases or just the command input lint, it also offers a more "proper scripting friendly" way of easily using the balance queue, not having to track balance/equilibrium, and not interfering with the systems actions.

How it works is so - you give m&mf a function that you want to be done when you get balance/equilibrium back, and the system will run the function for you. So inside that function, you can decide whenever you need to send some command or not - which is better than queueing a command for the next balance/equilibrium regain since the conditions can change in the mean time.

There are two types of functions m&mf accepts - one that require balance/equilibrium but **do not use any**, and one that require balance/equilibrium and do use either of them.

To add a balanceless function, you can use ``mm.addbalanceless(name, function)`` - name is a unique name for the function (this will make re-updating it easy) and function is your action function ::

  function myfunction ()
    send("say i'm going to say hi every balance I get!")
  end

  mm.addbalanceless("my sample function", myfunction)

  -- or even this would work:
  mm.addbalanceless("my sample function", function () send("say i'm going to say hi every balance I get!") end)

Updating your function is easy - running mm.addbalanceless again with the same name will replace the old function with the new one for you.

The mm.clearbalanceless() function is also available to remove all balanceless functions from the queue and serves as a way to 'start over' after you modify a function that's in the queue already.

The balanceful queue has a similar function for you to use - *mm.addbalanceful(name, function)*. It is, however different in the sense that if your function **has to** return either a boolean value of *true*, or a *number*, if your function did an action. If you want m&mf to wait a custom amount of seconds before re-trying your action in case it failed, then return a number - otherwise return true if you did send a command: ::

  function myfunction()
    if i_should_kick then
      send("kick weevil")
      return true
    elseif i_should_punch then
      send("punch weevil")
      return 1.4 --set a custom timeout to 1.4s - if in 1.4s we didn't punch, the function will be run again for us
    end

    return false
  end

  mm.addbalanceful("my sample function", myfunction)

You have the ``mm.clearbalanceful()`` function as well to clear the balanceful queue of m&mf.

You may run into a case where you change a condition that one of your balanceless or balanceful relies on, and thus need to re-run your function(s) again to check against the new conditions. You don't want to call your function(s) directly because that'd mean you would need to check all the relevant balances, deafeating the purpose of this all - so instead, you can use the *mm.work_gnomes_work()* function - it'll call all functions again if you have the balances.

Lastly, there is a problem of using mm.addbalanceful / mm.addbalanceless functions to begin with in your scripts *after* m&mf is loaded (otherwise the functions won't exist!). One way to make certain that m&mf is loaded first is by moving the m&mf Scripts folder above your own script. That, however, is rather clumsy - and you can avoid it by hooking onto the two Mudlet events m&mf raises for you: **m&m balanceless ready** and **m&m balanceful ready**. Using mm.addbalanceful / mm.addbalanceless on these events will guarantee the functions exist first, and makes sure your functions are re-added when the queues are cleared.

Handling do/dofree queues manually
-------------------------------------
The system makes use of ``mm.me.dofreequeue`` for keeping track of dofree items and ``mm.me.doqueue`` for keeping track of do items. You may modify the tables as you wish - read from them, insert and remove values and the system will go by them. Additionally. ``mm.me.doqueue.repeating`` can be toggled to be `true` or `false` to have the first item in the queue be repeated indefinitely.

Ignoring afflictions/cures
-----------------------------
You can have the system ignore an affliction by registering it in the **mm.ignore** table - for example, by doing ``mm.ignore.clumsiness = true``. You'd do ``mm.ignore.clumsiness = nil`` to remove it. This can be useful for a variety of things - either being able to test with clumsiness on, having the system ignore useless afflictions in bashing, or having it ignore cures that you don't have the ingridients to cure.

In the future, it'll also allow you to be more specific about ignoring things - ie don't ignore an affliction wholly, but only a certain balance cure for it, if there's demand for that.

Managing your own priorities
-------------------------------
One of the many nice new things **m&mf** brings to the table is very customizable curing priorities. You can re-prioritize afflictions on the fly, or make whole lists of them that you can switch depending on who are you fighting, or even share your lists with others.

The current priority lists can be seen by using the **mmshowprios <balance>** alias or the *mm.printorder* function. There are six of them, divided by balances - herb (eating+smoking), focus (body+mind+spirit), salve, purgative, sip, balance (for things that require having both balance and eq to do), plus a special choke/aeon/sap mode one (it'll be most commonly called as slow curing mode, but it applies to aeon and sap as well). There is a seventh one called misc as well for all general actions, but they typically don't make sense to prioritize (except when in slow curing mode - but as stated above, that has its own priority queue). Priorities are sorted in descending order - so the **higher** the number of a cure is, the more important it is.

:note: you want to keep aeon/sap cures high in the slow curing mode priority queue so the system will try to cure those as soon as possible. If you put them lower, it will cure more important afflictions before curing aeon/sap (if you have them) - which certainly isn't efficient.

:tip: you may want to use priority list to help prioritize wounds curing against warriors/monks - warriors depend on wounds for afflictions, while monks don't (they do however increase their damage with wounds).

There are two ways to change the priority of an affliction - either by changing it singularly, or by loading a whole new list of priorities. Let's start with the first method for the sake of easier experimentation.

The m&mf function for swapping priorities is *mm.prio_swap*. You can use it in two ways - either to swap an affliction with another, or to set/swap it with one at a given priority number:::

  -- swap paranoia with masochism.
  -- we pass 'true' at the end to make it seem like it came from an alias, so we'll get an echo about it working.
  mm.prio_swap("paranoia", "herb", "masochism", "herb", true)

  -- swap paranoia with whatever aff has a priority of 400, or set it to 400 if none is there.
  -- no 'true' at the end means we won't ever get an echo from it; ideal for scripting.
  mm.prio_swap("paranoia", "herb", 400)

The **mmswap** alias is also provided so you can play around with this easier, although you'll most likely find that writing custom aliases for the swaps you'll want to do to be more efficient.

There are two functions provided that help you tell what is the current priority of something - *mm.prio.getnumber(what, balance)* and *mm.prio.getaction(number, balance)*. The first you can use to find out what number an affliction/defence is in a balance, and second you can use to find out what affliction/defence is in a given number.

For example, if you wanted to swap two things temporarily, you could do: ::

  -- swap truedeaf to the top of the queue (or so) temporarily
  local old_truehearing_prio = mm.prio.getnumber("truedeaf", "herb")
  mm.prio_swap("truedeaf", "herb", 1000)

  -- now it's pretty high up, if not the first even in herb balance... lets swap it back 10s after
  tempTimer(10, function ()
    mm.prio_swap("truedeaf", "herb", old_truehearing_prio)
  end)

To move an individual priority up or down in the list, you can use ``mm.prio.insert(action, balance, number)``. This will appropriately bump the rest of priorities down as necessary to make room. This function works for all balances but the slowcuring one at the moment. ::

   -- move paranoia herb cure to the 30th spot, bumping down whatever was the 29, and everything else below it as necessary
   mm.prio.insert("paranoia", "herb", 30)

The other, more long-term way to set priorities is to create whole lists of them that you can load via importing or exporting. You can share the files with others as well!

To export your priorities, you can use the *mm.prio.export (name, options, echoback)* function or the *mm exportprio <name> [<options>]ww* alias. *name* is the name you'd like to give to the priority list, *options* is a list of balances for it to export that you can selectively provide. If you don't provide it, it'll export all priorities.

When you export a priority with the *echoback* arg enabled, it'll also tell you where it saved the file - it'll be somewhere in your m&mf config folder. If you'd like to share this file with someone else, you can just send it to them, have them place it in their m&mf config folder (not the system one, but one that is inside their Mudlet profile) and import it in.

Once exported, you can also edit all priorities within that file by opening it in a text editor (ie Notepad++, Geany, etc. Notepad and Wordpad that come with Windows might have problems displaying the linebreaks properly). If a priority for a balance has no 'holes' in it - then afflictions will be displayed in descending order, without a number attached to them (you can attach one if you'd like though). If there are holes, then after the first hole, afflictions will be displayed with their explicit priority number listed in front. Be sure to preserve the syntax of the file - my recommendation would be to just copy/paste things about in it and change the priority numbers if any.

To import the priority list, you can use the *mm.prio.import(name, echoback, report_errors)* function or the *mm importprio <name>* alias. The *report_errors* argument of the function will, as the name suggests, report any errors it gets from when loading the file instead of supressing them by defaul (you could introduce an error by accident when modifying the priorities).

To view the list of priorities that you can load, you can use the *mm listprios* alias or the *mm.prio.list()* function.

More fine-grained control of the system
-----------------------------------------
Several points about controlling the system more precisely if you'd like to...

Adding your own affliction triggers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
There are two ways of telling a system that an aff came in a trigger: ``mm.valid.proper_<aff>()`` and ``mm.valid.simple<aff>()``. If the first function exists for that aff, then it should be used - otherwise, use the second (the differences between them is that *proper_* does some checks later in case the aff can be avoided, ie prone and and acrobatics balancing). An easy idiom for this can be like so: ::

  (mm.valid.proper_<aff> or mm.valid.simple<aff>)()

  -- for example:

  (mm.valid.proper_prone or mm.valid.simpleprone)()
  (mm.valid.proper_crippledleftleg or mm.valid.simplecrippledleftleg)()

Using this would also future-proof your code to use the *proper_* function in case it is introduced.

You can also see the list of possible afflictions with *mmshow afflist* - afflictions that have a *proper_* function will have *pr* suffixed to them. If you're on a recent enough version of Mudlet, then you'll be able to click on them to see the function you'll need to use as well.

Working with balances
^^^^^^^^^^^^^^^^^^^^^^^
All balances are stored in the ``mm.bals`` table as key-value pairs. A balance is set to *false* if you don't have it, *true* if you do, or *unset* if it is unknown (for example, arm balances when they aren't showing on the prompt).

You can read and change the values in the table and the system will respect them. Do note that though that the system tracks balances from the prompt already.

.. _adding-removing-affs-manual:

Adding/removing afflictions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If you'd like to add an affliction right away, you can use ``mm.addaff("<aff>")``. This will return *true* if it was added, and *false* if you already have it. This will bypass anti-illusion, so calling this on in a trigger with the illusion message after will still add the aff.

To remove an affliction right away, use ``mm.removeaff("<aff>")``. This will return *true* if the affliction was removed, or *false* if you didn't have it to begin with.

See *mmshow ignorelist* for the list of affliction names.

Customizing anti-illusion
----------------------------
m&mf has extensive anti-illusion that can be enabled with *tn a*. It tracks all actions and cures it does, so illusions alleging that it did something that that didn't happen won't do anything. Additionally, it double-checks certain rather important afflictions that you really did obtain them before curing them.

Still though, there at times when you'd like to customize the anti-illusion for yourself. Doing so is simple - just call `mm.ignore_illusion()` on a line that you consider an illusion, and the system will ignore it. This works with single-line as well as multi-line triggers.


Doing your own stance/parry calculations
-------------------------------------------
Another nice feature of m&mf is that it allows you to easily use your own, custom parry/stance functions for calculating parry / set what should be stanced, and the system will take care of making it happening.

Parry
^^^^^^^^^^

To set a custom parry function, set it to *mm.sp_config.parry* - and make sure it takes a table as an argument, like so: ::

  function my_custom_parry_maths(tbl)
    display(tbl)
  end
  mm.sp_config.parry = my_custom_parry_maths

  -- or...
  mm.sp_config.parry = function (tbl)
    display(tbl)
  end

The table given will be a key-value table in the format of limb = #, where # is the wound damage amount that the limb is over the parry level. If the limb damage isn't over the parry level (which is mm.sp_config.parry_actionlevel and mm.sp_config.stance_actionlevel), then it won't be included. For example, if your head wounds level is at 275, and your head wounds are at 1000, then head = 725. If you'd like to get all the actual amounts each time in the table, then simply set all limb levels at zero.

Once you do the math of how much parry should go to each limb, set the values of *all* limbs in mm.sp_config.parry_shouldbe table (in the format of limb = #, or 0 if it should be so). ie: ::

  mm.sp_config.parry = function (tbl)
    -- as an example, show our wound levels
    display(tbl)

    mm.sp_config.parry_shouldbe.head = 0
    mm.sp_config.parry_shouldbe.chest = 25
    mm.sp_config.parry_shouldbe.gut = 25
    mm.sp_config.parry_shouldbe.rightarm = 25
    mm.sp_config.parry_shouldbe.leftarm = 25
    mm.sp_config.parry_shouldbe.leftleg = 25
    mm.sp_config.parry_shouldbe.rightleg = 0

    -- or...
    mm.sp_config.parry_shouldbe = {
      head = 0, chest = 25, gut = 25,
      rightarm = 25, leftarm = 25, rightleg = 0, leftleg = 0
    }
  end

Stance
^^^^^^^^^^
The situation with stance is similar - set *mm.sp_config.stance* to be your own custom function, and it'll be passed a table that has all the wounds-affected limbs in it. The result of what should be stanced should be set in *mm.stance_shouldbe* as a string.

You can also check the *mm.sp_config.stance_skills* list to make sure the person does have that stance skill.

Customizing wound damage tracking
----------------------------------
You can customize the systems wound level tracking from hits by setting your own or adjusting values in the *mm.wounds_data* table. It's best that you copy the whole table, or parts that you'll be customizing, into a separate script of it's own that is *after* m&mf's script - such that your customizations will stay through updates.

The table has two components - monks and knights, and inside each are the definitions of how much damage does a specific skill does. The value can either be a set static one, or a function that returns how much damage is done. *mm.addwounds* accepts any number of additional parameters at the end of it, so if you'd like, that can be passed onto the calculating function in the *mm.wounds_data* table.

Note that not all attacks by default are separated out in the table - if you'll be doing quality improvements on the capture triggers, please do share them so it's easier to deal with in updates.

Alias list
===============================

.. glossary::

  pp
    toggles pause/unpause in the system. You can also use *pp on* and *pp off* to set the status explicitly.

  df
    has the system check 'def' for you as soon as possible.

  dv
    has the system check diagnose for you as soon as possible.

  wf
    has the system check wounds for you as soon as possible.

  sl
    toggles selfishness upkeep or removal; shortcut for *mmkeep selfishness*.

  ss
    toggles rebounding upkeep; shortcut for *mmkeep rebounding*.

  hh
    shortcut alias for toggling sipping priority between health, mana and ego. You can also use it as *hh health*, *hh mana* or *hh ego* to set the priority. If you specify a vital to prioritize, it will keep the existing order between the other two vitals.

  cc
    announces text on a channel (pt, clt, etc.) as specified by :term:`mmconfig ccto <ccto>`. This can be useful to learn to use instead of *sqt* since then you could change ccto to report on any clan or party and still use one short and quick alias for communicating with a group in a raid.

  shh
    shortcut alias for toggling the health priority as the first one in aeon/sap/choke curing. Doing it again will set health priority back to normal.

  tn
    turns things on in the system - currently anti-illusion and keepup.

  tf
    turns things that can be turned on off. See above.

  inra
  	rifts all groupable items. This requires GMCP to be on, and it uses groupable, not riftable items because Lusternia doesn't transmit the information unlike other IREs. Generally though, groupable items are riftable.

  do <action>
    adds an action that requries balance/equilibrium to do, and takes one of them, to the do queue - so the system will do it asap for you.

  do# <action>
    does an action a certain number of times only.

  dor
    toggles repeat of the first action in do.

  dor <action>
    adds an action on the top of the do queue and enables infinite repeat of it.

  dofirst <action>
    adds a action to the top of the do queue (to be done first).

  dofree <action>
    adds an action that requires balance/equilibrium to do but does not take either of them. The system will do all queued dofree actions asap.

  dofreefirst <action>
    adds an action to the top of the dofree queue (to be done first).

  undo
    removes one action from the top of the do queue.

  undoall
    removes all actions from the do queue.

  undofree
    removes one action from the top of the dofree queue.

  undoallfree
    removes all actions from the dofree queue.

  vaeon
    for use only in cases when you've gotten aeon, and the system hasn't realized that you did - using this alias will let it know.

  p(h|t|g|rl|ll|ra|la)
    (for use in manual parry mode) sets which limb should be parried (ie, 'ph' will parry head, 'pra' will parry the right arm).

  cll
    a quick toggle for the mmconfig clot option (use clot skill or chervil for bleeding).

  mss
    a quick toggle for the mmconfig sparkle option (make use of sparkle effect or not).

  msa
    a quick toggle for the mmconfig secondarysparkle option (make use of sparkleberry or a herb that provides the effect).

  mdd
    a quick toggle for the mmconfig scroll option (make use of a Healing scroll or not).

  trk
    a quick toggle for the mmconfig showchanges option (display health/mana/ego gain/loss on prompt or not).

  tsc
    a quick toggle for the mmconfig blockcommands option (let the system deny your commands if it's doing something, or allow your commands to override the systems).

  ss
    a quick toggle for the mmkeep rebounding option (keep rebounding up or not).

  sl
    a quick toggle for the mmkeep selfishness option (keep selfishness up, or not and strip it).

  br
    a quick toggle for the mmkeep breath option (keep the breathing defence up or not).

  th
    a quick toggle for the mmkeep truedeaf option (keep the truehearing defence up or not).

  rfl
    toggles reflect mode - the system will make sure you're reflected! (requires reflect skill) You can also use *rfl on/off*.

  mminstall
    starts the installation of the system.

  mmdocs
  	opens up the m&mf documentation in your browser

  mmsetup pc
    shows the current configuration of the herb precache system, for the current defences mode you're in. You can adjusts the amounts by clicking on + or - beside the herb.

  mmsetup colours
    displays a list of available colour echos you can have, and a way to pick one by clicking on it.

  mmshow
    shows general information about the system - what defence mode are you in, if the system is currently in defup - what defence is it waiting on, whenever anti-illusion and keepup are enabled/disabled.

  mmshowa or mmshow affs
    shows which afflictions you currently have.

  mmshowb or mmshow bals
    shows which balances you currently have - green means you have it, regular means you don't.

  mmshowd or mmshow defs
    shows which defences the system thinks you currently have. You also hover your mouse over a defence name to see it's description, and click on it to be taken to the Lusternia wiki page for it.

  mmshowp or mmshow precache
    shows the current herb precache setup and allows you to adjust it.

  mmshow defup
    shows the defup defences for the mode you're currently in. If you'd like to view them for another mode, you can pause the system, switch, see, and go back.

  mmshow keepup
    shows the keepup defences for the mode you're currently in.

  mmshowh or mmshow hidelist
    shows the list of defences / groups which are currently shown or not. To toggle whenever a defence or a group of defences should be shown or not in defence lists, click on the + or - sign beside it.

  mmshow ignorelist
  	shows a list of all things - defences and afflictions - that you can ignore.

  mmshow afflist
  	shows a list of affliction names used by the system. *pr* besides a name means that affliction has a *mm.valid.proper_<affliction>()* function, which should be used instead of the usual *mm.valid.simple<affliction>()*. If you're on a recent enough version of Mudlet, then you can click on the affliction to get the text for the function. See *Adding your own triggers* for more.

  mmshowo or mmshow overhaul
  	shows a list of afflictions that can be toggled between Overhaul and old curing modes. Greyed out and unclickable afflictions are those that the game and m&mf haven't implemented Overhaul cures yet for. White and clickable afflictions are those that the game and m&mf have implemented Overhaul curing for, but isn't enabled for use in m&mf - click on the affliction to enable Overhaul curing. Light green afflictions are those in Overhaul cure mode, and dark green afflictions are those that are implicitly in Overhaul cure mode, due to other afflictions replacing them.

  mmconfig
    displays what are general options of the system are set to.

  mmconfig2
    displays more advanced options of the system, plus pipe status.

  mmconfig <option> <value>
    sets a given option to a given value. See **mmconfig options** in this document for the list of available ones, or do *mmconfig list* in-game. Note that the value is optional if it's just an on/off option - if you don't give it a value, it'll act as a toggle (ie mmconfig clot will turn clot on/off).

  mmconfig list
    displays a lost of configurable options in the system.

  mmdefs *<mode>*
    does into the specified defence mode (to see which ones are available, use mshow). This'll also have defup start putting up defup defences for that mode - and keepup ones after defup is done, if keepup is on.

  mmdefup *<defence>* [on/off]
    adds/removes a defence to the defup mode for the current defence.

  mmkeep *<defence>* [on/off]
    adds/remove a defence to the keepup list. Note that keepup can also be enabled/disabled as a feature, and it won't put defences up when it's disabled.

  mmcreate defmode *<name>*
    creates a new fences mode with the given name. You may wish to have more than the default basic/combat ones in order to specialize for situations (ie when you're out bashing, raiding orgA, raiding orgB, etc.)

  mmrename defmode *<current name> <new name>*
    renames an existing defmode to the new name.

  mmdelete defmode *<current name> <new name>*
    deletes an existing defmode. You can't delete a defmode you're currently in though, so switch first if you want to delete the current one.

  mmreseta or mmreset affs
    resets all afflictions the system thinks it has, to be used in a case where diagnose doesn't fix the issue.

    :note: this should only be used in extreme cases when something is wrong with the system, and any cases that lead the system to such a state should be fixed - so please report them.

  mmshowprios *<balance>*
    shows the current priority lists for a particular balance. Possible balances are: herb, focus, salve, purgative, sip, balance, misc and slowcuring. The misc balance is for all things that work on their own balances and typically don't make sense to prioritize. slowcuring is referred to choke/aeon/sap curing - where since you can only be doing one thing at a time, all cures are placed into one priority and you can change them about as you wish.

  mmcleargaps *<balance>*
    clears all gaps for priority numbers of a given balance by compacting them. Use 'slowcuring' as the balance name for the slow curing priorities.

  mmexportprio <prio name> [<select balances to export>]
    exports balance prios to a given file name. By default, it'll export prios of all balances - but if you'd like, you can also tell it to export only select ones (ie, *mmexportprio mystuff* will export all balances, but *mmexportprio myselff sip, salve* will only export sip and salve ones in it). The file will be saved in the m&mf/prios folder (use *mm listprios* to see the exact path)

  mmimportprio [<name>]
    imports a prio list with the given name (it should be located in the m&mf/prios system folder). If you don't give it a name, it'll spawn a file picker dialog for you, so you can locate the file for it.

  mm listprios
    lists all priorities that are stored in the m&mf/prios folder, and also lists the actual location of the said folder.

  mmswap <aff name you'd like to be more important> <balance> <aff name you'd like to swap it with> <balance>
    swaps the two things, such that the first one now has the higher priority. For example, *mmswap asthma salve pox salve* will make sure that the salve cure for asthma has higher priority than pox. This isn't a toggle - doing it multiple times won't switch it back and forth.

  mmswap <aff name> <balance> <priority number>
    swaps the cure on the given balance with another at a given number. ie, *mmswap asthma salve 30* will set the salve cure for asthma at priority number 30 (and if anything was there previously, it'll be set to what asthma was).

  mmset <aff name> <balance> <priority number>
    sets the cure on the given balance to be on the given number. ie, ``mmset lightpipes physical 5`` will set the action for lightpipes at priority number 5 - and if anything was there previously, it will be shuffled down to make space. For the aeon/retardation curing, use ``mmset lightpipes_physical slowcuring 5`` instead.

  mmsetup sp
    starts the setup of the stance/parry system.

  mmsp nextprio <limb>
    sets the next limb in priority for the stance/parry setup.

  mmsp stancelevel <limb> <amount>
    sets the amount of wound damage for a particular limb for stance. If that limb gets above the specified wound amount, stance will consider it when deciding what to stance.

  mmsp parrylevel <limb> <amount>
    sets the amount of wound damage for a particular limb for parry. If that limb gets above the specified wound amount, parry will consider it when deciding what to parry.

  mmsp parrystrat <strategy name>
    sets the parry strategy that the system should use.

  mmsp stancestrat <strategy name>
    sets the stance strategy that the system should use.

  mmsp defaultstance <stance>
    sets the default stance that the system should use (when you login).

  mmsp show
    shows system information on all about stance/parry.

  mmversion
    shows the systems version.

  mmsave
    manually saves system settings. The system saves all settings when you do 'quit' (it's triggered to the message), however if you wish to disconnect without quitting first, this would be the alias to use to get the system to save everything.

  mmshow lustlist
  	shows the list of names that are on the lustlist - names that we're either avoiding rejecting or only rejecting, bashed on your autoreject option.

  whoi
    checks the who list for you, even when you're off prime. Does not show people hidden with gems. If you have the enemy highlighter script, it'll also divide the names into enemies and non-enemies.

  va
  	toggles riding keepup on/off - shortcut for *mmkeep riding*

  va (on|off)
    explicitly enables or disables riding. If you'd like to use this in an alias/trigger/script, use *mm.defs.keepup("riding", "on")* or *off*.


Common questions
===============================

* Why does the system apply mending twice sometimes while bashing?

	If you'll carefully read the line(s) on which it does that, you'll notice that it doesn't say *which* limb was crippled - thus the system applies to both just to make sure all possibilities are covered.

m&mf API
===============================

.. glossary::
  :sorted:

  mm.me.lustlist {}

	A key-value table of names which m&mf will be ignoring in auto-rejection. Values can be stored as any true value.

  mm.ignore {}

	A key-value table of afflictions which m&mf will be ignoring in curing. You can see the list of possible affliction names with **mmshow ignorelist**, and values can be stored as any true/false value. ::

	  -- make prone be ignored from a script:
	  mm.ignore.prone = true

	  -- make prone not be ignored:
	  mm.ignore.prone = false

  mm.bals {}

	A key-value table of balances - *true* if you have a balance, *false* if you don't, and *unset* if known (assumed true).

  mm.me.locks {}

  	A key-value table of the current affliction locks you have - in the format of <afflock> = true.

  mm.overhaul {}

  	A read-only key-value table listing which afflictions are enabled for Overhaul curing. If an affliction is being replaced by another, it will show up as well with a string mentioning which affliction is replacing it.

.. function:: mm.app()

    Toggles whenever the system is paused.

.. function:: mm.app(true or false)

    Explicitly sets if the system should be paused or unpaused.

.. function:: mm.can_usemana()

   checks whenever your current mana is above the manause limit. **Returns:** boolean `true` or `false`.

.. function:: mm.inslowcuringmode()

    checks whenever you're in the slow curing mode (aeon/choke/sap) or not. **Returns:** boolean `true` or `false`.

.. function:: mm.doadd(what, echoback)

    Adds *what* to the end of the do queue (so it should require both balance/equilibrium and use one of them). You can split actions inside *what* with the $ sign, and it's executed as a command input - so this can be an alias or just text to send directly to the MUD. Can work as a drop-in replacement to the *send(what)* function.

.. function:: mm.doaddfree(what, echoback)

    Adds *what* to the end of the dofree queue (requires balance/equilibrium, takes none). See *mm.doadd* on the specifics.

.. function:: mm.dofirst(what, echoback)

    Adds *what* to the start of the do queue.

.. function:: mm.dofreefirst(what, echoback)

    Adds *what* to the start of the dofree queue.

.. function:: mm.dor(nil, echoback)

    Toggles the do-repeat mode of the do queue - when enabled, it'll repeat the first action in the do queue indefinitely.

.. function:: mm.dor("off", echoback)

    Disables the do-repeat mode of the do queue.

.. function:: mm.dor(what, echoback)

    Adds *what* to the top of the do queue, and enables the do-repeat mode.

.. function:: mm.doshow()

    Displays all actions that are in the do, dofree queues and whenever do-repeat mode is enabled.

.. function:: mm.undo(what, echoback)

    Removes one action from the top of the do queue if *what* is not provided, or removes *what* if it's provided and is in the queue.

.. function:: mm.undoall(echoback)

    Removes one action from the top of the dofree queue.

.. function:: mm.undofree(echoback)

    Clears the do queue completely.

.. function:: mm.undoallfree(echoback)

    Clears the dofree queue completely.

.. function:: mm.donext()

    Has the system do the next thing in the do queue right away. This function is mostly useful for when you've used the do queue on an action that didn't take any balance or equilibrium as expected - you can trigger it to ''mm.donext()'' and the do queue will go again.

.. function:: mm.showprecache()

    Displays the herb precache setup along with the buttons to edit it.

.. function:: mm.setprecache(herb, amount, flag, echoback, show_list)

    Sets the precache amount for a given herb. **herb** is the short name of the herb you'd like to set it add, **flag** is what you'd like to do - can be *add*, *set* or *subtract* and **amount** is what you'd like the flag to operate with. **show_list** will have the function re-display the whole list after the amount is set.

.. function:: mm.echof(what)

    Echos given text with the systems function, and accepts the same conventions as `string.format <http://www.lua.org/manual/5.1/manual.html#pdf-string.format>`_ does. ie: ::

      mm.echof("hello, #%d:", 5)

.. function:: mm.echofn(what)

		Same as mm.echof(), but does not auto-add a "\n" at the end, so you can ''echo()'' or ''echoLink()'' things after it.

.. function:: mm.reset.affs(echoback)

    Resets all system afflictions. Should never need to be used under normal circumstances; if it does happen then most likely something needs reporting and fixing.

.. function:: mm.reset.defs(echoback)

    Resets all your current defences.

.. function:: mm.dv()

    Has the system check (and sync) *diagnose* as soon as possible.

.. function:: mm.awf()

    Has the system check (and sync) your wounds status as soon as possible.

.. function:: mm.adf()

    Has the system check (and sync) your defences list from the game.

.. function:: mm.addbalanceful(name, func)

    Adds the given function to the balanceful system queue - so it is executed whenever you regain both balance/equilibrium. See *Scripting to do actions on balance/eq* on usage. *name* should be a unique name for the function *func* is the function itself.

.. function:: mm.addbalanceless(name, func)

    Adds a given function to the balanceless system queue.

.. function:: mm.clearbalanceful()

    Clears the balanceful queue completely, and raises the 'm&m balanceful ready' Mudlet event.

.. function:: mm.clearbalanceless()

    Clears the balanceless queue completely, and raises the 'm&m balanceless ready' Mudlet event.

.. function:: mm.removebalanceful(name)

    Removes the function associated with the name from the balanceful queue.

.. function:: mm.removebalanceless(name)

    Removes the function associated with the name from the balanceless queue.

.. function: mm.work_gnomes_work()

    Has the system run the balanceless & balanceful queue functions. Useful to use in scripting; if you've just changed a condition in your functiona and want it to be run for you if it's possible, this is the function to use.

.. function:: mm.togglesip()

    Toggles whenever health or mana should have higher priority.

.. function:: mm.togglesip("health" or "mana")

    Sets which one should have higher priority explicitly.

.. function:: mm.prio_makefirst(action, balance)

    This will swap something to be the most important one in sap-aeon-choke mode. Useful for, lets say, healing your health - typically you'd want to be curing affs before sipping, but if you're low, you could use this to quickly have the system heal up a bit. *action* is the action to modify, *balance* the balance of an action to modify.

.. function:: mm.prio_undofirst()

    Undoes the first action in slow curing mode to what it was before.

.. function:: mm.sp_setparry(what, echoback)

    If parry is in the manual mode, this will set the parry to be 100% at the given limb. *what* can be h, c, g, rl, ll, ra, or la which correspond to the given limb.

.. function:: mm.show_keepup()

    Displays the keepup defences list for the current mode.

.. function:: mm.show_defup()

    Displays the defup defences list for the current mode.

.. function:: mm.ashow()

    Displays general options of the system (tn/tf ones).

.. function:: mm.aconfig()

    Displays the general configuration of the system (mmconfig ones).

.. function:: mm.aconfig2()

    Displays more advanced configuration of the system, and pipe statuses (mmconfig ones).

.. function:: mm.create_defmode(defencemode, echoback)

    Creates a new defences mode with the given name.

.. function:: mm.defs.switch(defence, echoback)

    Switches to the given defence mode, and starts the defup procedure. ::

    	-- switch to the empty mode on-demand
    	mm.defs.switch("empty")

.. _mm-defs-defup:

.. function:: mm.defs.defup(defence, status, defencemode, echoback, showmenu)

	Adds/removes a defence to defup.

	* *defence* if the defence you'd like to add/remove, see *mmshow defup* for a list of available ones.
	* *status* is where you specify whenever you'd like to add or remove it: if you pass it *nil*, it'll toggle it. Otherwise, giving it true/false, or "on"/"off" or something similar will set it explicitly.
	* *defencemode* optinal, it's the defence mode you'd like to add/remove the defence in: if you give it *nil*, it'll be the current one, otherwise pick an available one from the defence modes list in *mmshow*.
	* *echoback* is optional, a true/false to show the message mentioning whenever a defence was removed or added.
	* *showmenu* is optional, a true/false to show the whole mmdefup menu. ::

		-- toggles blacktea defup in the current mode, showing no message
		mm.defs.defup("blacktea")

		-- explicitly turns on blacktea defup in the current mode, showing no msg
		mm.defs.defup("blacktea", "yep")

		-- explicitly turns on blacktea defup in the current mode, showing a msg that it's on
		mm.defs.defup("blacktea", "yep", nil, true)

		-- explicitly turns blacktea defup off in the basic mode, with a msg
		mm.defs.defup("blacktea", "nope", "basic", true)

		-- you can also check first and disable only if you have the defence on keepup
		if mm.defkeepup[mm.defs.mode].rebounding then
	 	  mm.defs.keepup("rebounding", "off")
		end

	:note: You can check if a defence is on keepup in the current mode with ``mm.defkeepup[mm.defs.mode].<def>``, ie to see if quicksilver is on keepup right now - ``mm.defkeepup[mm.defs.mode].quicksilver``.

.. function:: mm.defs.keepup(defence, status, defencemode, echoback, showmenu)

	Adds/removes a defence to defup, with the arguments all the same as :ref:`mm.defs.defup() <mm-defs-defup>`.

.. function:: mm.delete_defmode(which, echoback)

    Deletes the given defence mode.

.. function:: mm.rename_defmode(which, newname, echoback)

    Renames a defence mode to the new name.

.. function: mm.defs.keepup(defence, status, mode, echoback)

    Changes the keepup status of a defence. *defence* is the defence you'd like to change, and this is the only argument required. *status* is a true/false value that will have the function make sure the defence is on or off keepup - if status is missing, the defence will be toggled, ie: ::

      -- this toggles rebounding keepup status
      mm.defs.keepup("rebounding")

      -- this makes sure it's on
      mm.defs.keepup("rebounding", true)

    *mode* is for which defence mode should this be set - use *nil* if you want to set it for the current mode that the system is in.

.. function:: mm.printorder(balance)

    Displays the priority order for the given balance. The higher the action is, the more important it is and will be done sooner than the ones below it. Possible balances are "herb", "salve", "sip", "scroll",  "purgative", "physical", "focus", "sparkle", and "misc".

.. function:: mm.printordersync()

    Displays the priority order for the slow curing mode.

.. function:: mm.ignorelist()

    Displays a list of all the possible things you can have the system ignore (by setting a key in the *mm.ignore* table to true).

.. function:: mm.showaffs()

    Displays all your current afflictions.

.. function:: mm.showbals()

    Displays the status of all your current balances (if the balance is in green, that means you have it).

.. function:: mm.show_current_defs()

    Displays the status of all your current defences.

.. function:: mm.prio.insert(action, balance, number)

    Inserts a priority at a given position. If there is nothing at the new position, then it simply inserts and leaves a hole in the previous position. If there already is something in the new position, then it will take the priority out of its old spot, move items up to clear the gap created, and then insert the priority at the location, shifting items down as necessary. As a result of this, the item at the old location will move one up (because it has to - to clear the gap), your item will get inserted, and the rest of items will be below it. As a result of this, if you're inserting something at a position to be above an item, insert at itemposition+1.

	    -- move paranoia herb cure to the 30th spot, bumping down whatever was the 29, and everything else below it as necessary
	    mm.prio.insert("paranoia", "herb", 30)

.. function:: mm.prio_swap(what, balance, arg2, nil, echoback)

    Swaps action *what* with the balance of *balance* with the action that has a priority number of *arg2*.

.. function:: mm.prio_swap(what, balance, arg2, arg3, echoback)

    Swaps action *what* with the balance of *balance* with the action *arg2* that has a balance of *arg3*.

.. function:: mm.prio_slowswap(what, whatwith, echoback)

    Swaps action *what* (should be in the format of action_balance, ie *healhealth_sip*) with *whatwith*, which should be in a similar format. ::

    	-- swap health sipping with cleanse
    	mm.prio_slowswap("healhealth_sip", "cleanse_physical")

    	-- or swap health sipping with to number of a priority
    	mm.prio_slowswap("healhealth_sip", 34)

.. function:: mm.asave()

    Has the system save all settings.

.. function:: mm.givewarning(tbl)

    Has the system give a noticable warning to the user. *tbl* is a key-value table that accepts *initialmsg*, *prefixwarning*, *duration* and *startin* values. *prefixwarning*, will prefix a warning to the prompt or all lines (if the mmconfig warningtype option is set). *duration* determines how long should the warning be prefixed for (if you don't give a value, default is 4 seconds). *startin* is the time the prefixing should start in (defaults to 0). ie: ::

        -- this will give just a one-time warning
        mm.givewarning({
          initialmsg = "You're getting hungry! Get some food NOW."
        })

        -- this will give an initial warning, and after one second, prefix 'Bob chasming you' to the prompt or all lines for 5 seconds (or do nothing if warningtype is off)
        mm.givewarning({
          initialmsg = "Bob is still chasming you! Hinder, blind, or run.",
          prefixwarning = "Bob chasming you",
          startin = 1,
          duration = 5
        })

.. function:: mm.config.set(option, value, echoback)

    Sets the option *option* to the value of *value*.

.. function:: mm.prio.cleargaps(balance, echoback)

    Clears and gaps in the given balance (balance name can also be "slowcuring" for the slow curing mode). For example, if one action has a number of 1 and another of 2, they'll become 1 and 2, respectively.

.. function:: mm.prio.import(name, echoback, report_errors, use_default)

    Imports a priority *name*. *report_errors* is whenever errors during importing should be reported or not, *use_default* means it'll import the default, embedded system priorities.

.. function:: mm.prio.export (name, nil, echoback)

    Exports all priority balances to a priority list of the given *name*.

.. function:: mm.prio.export (name, options, echoback)

    Exports selective balances as specified by *options* - which is a list table of all the balances that should be included in the export (use "slowcuring" for the slow curing mode priority list).

.. function:: mm.prio.usedefault(echoback)

    Resets the system priorities to the default ones that come with the system.

.. function:: mm.prio.getnumber(what, balance)

    Returns the number a given item is in a balance. Helpful if you want to switch some things temporarily. ::

      -- example:
      display(mm.prio.getnumber("asthma", "salve"))

.. function:: mm.prio.getaction(number, balance)

    Returns the affliction / defence that is at the given number in the balance. ::

      -- example:
      display(mm.prio.getaction(40, "herb"))

.. function:: mm.ignoreskill(skill, newstatus, echoback)

    Sets whenever a skill or a skillgroup shouldn't be displayed in defence lists (this is what mmshow hidelist uses).

.. function:: mm.ignore_illusion()

    Ignores the current paragraph as an illusion so the doesn't act on it. This means that all lines since the last prompt until the next prompt will be ignored.

.. function:: mm.addwounds(class, attack, where, ...)

		Adds a corresponding amount of wound damage on a given limb.

		* **class** is the name of the `mm.woundsdata[]` table you'd like to use
		* **attack** is the name of the key (which can be either a number, or a function that returns a number) you'd like to use from `mm.woundsdata[class]`
		* **where** is the name of the limb as a string, or a table with limb names, where the damage should be applied to
		* **...** is an optional amount of arguments that'll be passed onto the calculating function in `mm.woundsdata[class][attack]`, if any.

.. function:: mm.addaff(aff)

		Lets the system know that you have an affliction right away. See :ref:`adding-removing-affs-manual` for use.

.. function:: mm.removeaff(aff)

		Removes the affliction from the list of affs you currently have right away.  See :ref:`adding-removing-affs-manual` for use.

.. _mm-cc-function:

.. function:: mm.cc(text_to_say)

   Use this function to announce things on a communication channel (clan, party, etc). Where the function will say things can be configured with :term:`vconfig ccto <ccto>`, and it's usefulness comes in the fact that it won't do anything if the system is paused or you have aeon/retardation - so you can safely use mm.cc() in your triggers without adding conditions to them. It's also convenient to use because you can adjust where it goes with vconfig ccto - without needing to redo all your triggers or fiddle with variables. The equivalent :term:`cc <cc>` alias also uses this function. ::

      -- example from a trigger
      (begin of line) The end of your cudgel forms a noxious, dripping burl and you point it at
      (regex) ^The end of your cudgel forms a noxious, dripping burl and you point it at (\w+)\. The burl pops and ruptures, sending a swirling mass of wasps forth to the (\w+)\.$

      if mm.isEnemy(multimatches[2][2]) then -- mm.isEnemy will be available soon
        mm.cc("LoS %s %s", multimatches[2][2], multimatches[2][3])
      end

.. function:: mm.prompttrigger(name, function)

   Sets a function to be run for you on the prompt. The function will only be run once on the next prompt. If you use this multiple times before the prompt with the same name, then only the latest function will be executed - which makes this quite a boon in certain cases.

   You might find this useful to work with when you can't exactly do the standard Mudlet paradigm of open gate / close gate with a prompt trigger, because the gate-opener line might be variable, or all the lines are the same and etc. Using this, you can easily defer the processing until the prompt happens. ::

      mindnet_entered = mindnet_entered or {}
      mindnet_entered[#mindnet_entered+1] = matches[2]

      -- gets called only once, so a group entering does not spam
      mm.prompttrigger("mindnet entered", function()
        send(string.format("pt %s (%d) ENTERED %s!", mm.concatand(mindnet_entered), #mindnet_entered, gmcp.Room.Info.area))

        mindnet_entered = nil
      end)

.. function:: mm.prompttrigger(name, nil)

   Clears a prompt trigger function of that name (so it will not run on the next prompt). ::

      -- nothing will actually happen
      mm.prompttrigger("mindnet entered", function() mm.echof("hi!") end)
      mm.prompttrigger("mindnet entered", nil)

.. function:: mm.enableoverhaul(affliction, echoback)

	Sets an affliction to be cured using Overhaul curing.

.. function:: mm.disableoverhaul(affliction, echoback)

	Disables an affliction from being cured using Overhaul curing and reverts to using old cures instead.
