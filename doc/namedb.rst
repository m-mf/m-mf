m&mf NameDB
======================
NameDB is a script whose job is to "know" people - who is a person, and what they are. With this in your toolbox, you, and your aliases/triggers/scripts, can tell people apart.

NameDB is a dataminer script that collects information either automatically or by you providing it, and then provides you the same information for use.

For you yourself, the script provides a sophisticated **highlighting feature** - that can highlight, bold, italicize or underline names. It can highlight a person by their citizenship, your org/guild/order enemy status, or a special watchfor list you can manipulate. The highlighter "stacks" properly - if a person belongs to a group that should be underlined as well as to a group that should be in red, their name will be both underlined and in red. You can also **ignore names** you don't want highlighted. All of this is configurable from your scripts or by hand, via an intuitive menu (**mmconfig politics**):

.. image:: images/namedb-politics.png
   :align: center

For your **triggers/aliases/scripts**, there is a *multitude* of uses where this comes in handy. The most basic one is giving **intelligence to your triggers** - for example, if you want to make a trigger that will automatically geyser enemies flying above you, with NameDB your script will know if it's an enemy or not before geysering - saving annoyances of your allies! If you only want to announce enemies or particular citizens for demesne watch, you can. All that without manually managing lists of people - saves you a lot of hassle. You could even analyze and know exactly, at a glance, what classes a raiding group consists of with its help! These are just a few examples. NameDB can help you with a ton of things, including extracting names from lines and so on.

NameDB allows you to store your own notes on a person, as well as remembering their title, class, org, org rank, guild, might, a custom importance level, their xp rank, and whenever they're guild/order or org enemies. You can also explicitly set them to be enemies or allies to you, or have that be auto-determined altogether (based on their citizenship or being enemied to your org/guild/order).

Working with it
^^^^^^^^^^^^^^^
NameDB by default datamines everyone it comes across from cw, hw, citizens, guild/order/org enemies and qw lists (you can turn this off with **mmconfig autohonors off**) and other lists that involve names. It'll automatically gag the honors of a person while doing that, so you don't get spammed out - and it leaves the titles or guides/immortals intact, so you can tell when is the first time it notices them (as a little feature). You can enable/disable auto-honors with **mmconfig autohonors**.

.. image:: images/namedb-checking.png
   :align: center

Once NameDB knows somebody, it'll be helping you from there on - either with highlights or by allowing you to script with it. There are tons of places where your triggers could use help differentiating allies/friendlies, for example automatically enemying enemies as you see them, enemy-only demesne announces, and so on.

:note: Because the city/commune frequently isn't shown on HONORS, names that have just been checked might not be getting highlighted - they are still being researched (checked on the website) for their city/commune. So if NameDB says it's done checking, and you check qw again, and some names don't have the highlights yet - it's fine, in a few moments they will have them.

If you'd like to add gemmed/offline people to it, honors them manually (with the *honors person* syntax). You can also script the addition of them (or build an importer) with the *ndb.addname(name)* function.

:protip: You can create custom highlighting categories by adding people to fake Orders (their validity isn't checked, and everything/all options get auto-created for any order name).

NameDB doesn't highlight your own name so it won't blend in, plus some people wouldn't want to have it highlight. It's fairly easy to add a highlight trigger in Mudlet if you want to see it highlighted - put your name in as the substring in a new trigger, and tick the highlight checkbox.

Your home org for *mmconfig politics* is set via *mmconfig org <org>*.

Scripting with it
^^^^^^^^^^^^^^^^^^
To begin scripting with NameDB, check the :ref:`api`. There, all currently available functions are detailed to you, with practical examples that help you understand how to use them. If you need any help with them, feel free to ask on the m&mf clan.

NameDB is designed to be built upon and extended - feel free to use its building blocks to build upon it or expand it.

::note:: Do not use any of NameDB's internal functions (that is, those not listed on API) in your scripts - they are not documented for a reason - they may be changed, or deleted altogether, breaking your scripts. The ones on the API won't be (same with m&mf API functions) - use those instead!

To query the database for data, make use of `Mudlet's db <http://wiki.mudlet.org/w/Manual:Database_Functions>`_ API.

Here are some practical examples: ::

  -- print a list of all Gloms CR4+'s known
  vlua for _, person in pairs(db:fetch(ndb.db.people, {db:eq(ndb.db.people.org, "Glomdoring"), db:gte(ndb.db.people.org_rank, 4)})) do print(person.name) end

Forcing an update on data
-------------------------
To update or add a person to NameDB, you can manually *honors* them. If you'd like to do it via scripting, the preferred way is to set the persons might xp rank to -1 ("unknown") in the DB and raise a new data event. Here's an example::

  -- force an update on a single name, Bouff
  local temp_name_list = { {name = "Bouff", xp_rank = -1} }
  db:merge_unique(ndb.db.people, temp_name_list)
  raiseEvent("NameDB got new data")


  -- force an update on many names, from a list of names you've got
  local names = {"Bouff", "Lianca", "Teela", "Malifuus"}
  local temp_name_list = {}
  for i = 1, #names do
    temp_name_list[#temp_name_list+1] = {name = names[i], xp_rank = -1}
  end

  db:merge_unique(ndb.db.people, temp_name_list)
  raiseEvent("NameDB got new data")

Incompatibilities
^^^^^^^^^^^^^^^^^^^^^^^
If you are syncing your Mudlet profile using Dropbox, make sure *not* to sync the **Database_namedb.db** file - Dropbox seems to corrupt it and make it inoperable.

Be wary of storing it on a Linux NFS share as well - that seems to present issues as well.

Future additions
^^^^^^^^^^^^^^^^
NameDB opens up for a *ton* of possibilities to be improved upon. Here are some ideas I've got that'll be added in the future:

* storing a persons max health and mana
* rogues as a category, so they can be highlighted
* a way to remember when you've last seen a person, and
* an option to highlight only recently seen people
* making all of whois clickable
* add a highlighting category for guild members
* org allies tracking
* add background highlighting for names

If you've got more ideas, let me know. If you'd like to make any ideas happen yourself, you're free to do so - the code is there.

Contributing to NameDB
^^^^^^^^^^^^^^^^^^^^^^
All the code for NameDB is available for you to modify and improve upon. You do, however, assume the risk of breaking it on yourself by doing so!

Please contribute the changes you do to NameDB back, so they can be integrated with future releases and the wider community.

Aliases
^^^^^^^^
.. glossary::

  whois <person>
    Gives you a a complete dossier on a person that NameDB knows of:

    .. image:: images/namedb-whois.png
       :align: center

  mmconfig politics
    Gives you a menu where you can adjust org relationship stances, and setup highlights.

  mmconfig autohonors yep/nope
    Sets whenever NameDB should automatically honors new people it comes across to gather information about them or not.

  ndb
    NameDB alias cheetsheet - shows the same information as this aliases list. Hover your mouse or click on an alias to see the description.

  ndb long
    NameDB alias cheetsheet, with the descriptions expanded.

  qw
    Checks the QW list, from which ndb will be able to pick up new names from.

  qw update
    Re-checks all names on the QW list, even if they're already and currently known.

  qwc
    Checks the QW list, from which ndb will be able to pick up new names from. It'll also display you a menu of players present by their organization affiliation, sorted:

    .. image:: images/namedb-qwc.png
       :align: center

  ppof <org>
    Reports the members of an org to an m&mf cc channel. You can shorten the name of an org, ie *ppof glom* will work.

  guild/order/city/commune enemies
    Sets the enemy status of the people that NameDB knows of from those lists. This won't auto-add names it doesn't know for checking (so your db doesn't get filled up with dormant people and they'll be getting highlighted for no reason).

  guild/order/city/commune enemies add
    Sets the enemy status of the people from those lists, and auto-adds names it doesn't know for checking.

  cwho
    Adds the persons class information into cwho list. An (h) will be visible if the person is a Demigod or an Ascendant - H stands for them being able to access Havens. The cwho list looks best with ``CONFIG PREFERREDWIDTH 100`` in order to have the class name fit in.

    .. image:: images/namedb-cwho.png
       :align: center

  ndb honorsnew
    If mmconfig autohonors is off, ndb honorsnew will allow NameDB to honors the new people it knows of.

  ndb cancel
    Stops honors'ing the list of people that need to be checked.

  npp
    Stops/resumes name highlighting. You might want to turn highlighting off for wargames, for example, where the game-provided colors are more important.

  npp on/off
    Stops/resumes name highlighting explicitly.

  mmconfig highlightignore <person>
    Adds/removes a name on the list that keeps track of who should not be highlighted.

  mmshow highlightignore
    Shows the list of persons who shouldn't be highlighted.

  iff <person> ally/enemy/auto
    Explicitly sets a persons status to you, overriding the auto-determination of enemy vs non-enemy by NameDB.

    Making them an ally will make NameDB disregard their citizenship and political stances and whenever they're a guild/order/city/commune enemy - thus never considering them an enemy.

    Making them an enemy will always consider them an enemy, disregarding anything else.

    Setting it to auto will have NameDB compute their status to you depending on a number of things - if they're in a org that is considered an enemy to you, or if they're a guild/org/order enemy, they'll be considered an enemy. Otherwise, they won't be an enemy. Note that if someone is in an org that is allied with yours and they are an enemy of your org, they will not be considered an enemy.

  ndb set <person> notes <notes>
    Adjusts the notes you have on the person to the new ones. If you do *whois person* and click on *'edit'*, you an edit current notes you have on them. You can use the same color formatting from a cecho to color your notes (ie *<red> text*), and insert \n's in the same manner to get a linebreak.

  ndb export
    Opens up a menu where you can export your data. It allows you to selectively export fields (so you don't have to share everything, for example, not your notes), and which people to export (atm, it's everybody).

  ndb import
    Opens up a menu where you can import exported NameDB data. You can selectively choose which fields about a person should be imported - they will overwrite what you've had. This will not clear your names in NameDB that you've got already - if you'd like to start clean, use 'ndb delete all'.

  ndb delete <person>
    Wipes an individual entry from NameDB.

  ndb delete all
    Wipes all data from the database, essentially making you start over clean. You have to use this alias twice for it to go off. If you have a lot of names (10k+), expect to wait a few seconds for it to finish.

  ndb update all
    Re-checks every person in the database. This can't be undone, only paused (with *ndb cancel*) - NameDB will re-check everybody as you've asked it to, so don't do it on a whim!

  ndb set <person> class <class>
    Manually sets/adjusts the persons class. It's always stored in lowercase by NameDB. NameDB automatically picks up the class from cwho and gwho lists, but this isn't possible for everyone.

  ndb set <person> city/commune/org <city/commune>
    Manually changes the persons city/commune. It's always stored in proper case (first letters capitalized) by NameDB. NameDB automatically picks it up from honors for you already.

  ndb set <person> title <title>
    Adjusts the persons title as NameDB knows it. It's not really useful for much, as titles change all the time, but the option to set/retrieve them is there for you.

  ndb set <person> org_rank <rank>
    Manually adjusts the persons org rank. 0 is known, 1 is cr1 and 6 is cr6. NameDB automatically picks up the org rank from honors for you when it is shown.

  ndb set <person> guild <guild>
    Manually adjusts the persons guild affiliation. NameDB can only capture this from gwho or guild members, so you'd want to use this for setting others' guilds if that's something you want to track.

  ndb set <person> order <order>
    Manually adjusts the persons Order affiliation. NameDB stores it with proper titlecase, and it'll pull information from ORDER MEMBERS for you. You will need to manually input the members of other Orders though.

  ndb set <person> might <might>
    Adjusts the persons might (lessons invested vs you) relative to you - 0 is 0% of your might, 100 is equal to you. *-1* is unknown, and will cause NameDB to re-honors the person. NameDB automatically captures this from honors.

  ndb set <person> importance <number>
    Manually sets a persons "importance". This isn't used by NameDB, but it's a way for you to explicitly prioritize people without relying on heuristics such as org rank and might.

  ndb set <person> xp_rank <number>
    Manually sets the persons rank in experience in the game. *-2* is unranked, *-1* is unknown - this'll cause NameDB to auto-honors the person. Any other number is their actual rank. NameDB automatically captures this from honors.

  ndb set <person> immortal <yep/nope>
    Manually adjusts whenever somebody is an Immortal or not. This means Gods, Ephemereals and admins. NameDB automatically captures this from honors.

  ndb set <person> orgenemy/guildenemy/orderenemy <yep/nope>
    Manually sets whenever the person is your orgs, guilds or orders enemy.  NameDB automatically captures this from the enemy lists, but you can adjust it manually as well.

  ndb stats
    A little stats alias showing the number of people known and city populations.

  mmconfig watchfor <name>
    Adds or removes a person on the watchfor list - used in as a custom highlighting category in NameDB. You can script this as well - put the name down as a key in the ``mm.me.watchfor`` table. To remove a name, set it to nil (not false).

.. _api:

API
^^^
.. glossary::

  ndb.isenemy(name)
    Returns true if the person is your enemy - whenever they are explicitly marked as one via *iff <name> enemy>* or they are in a org that you are at war with per *mmconfig politics*, or they are a org, guild or order enemy.

    This function is useful to use in auto-action triggers, for example only geyser your enemies and not everybody: ::

      if ndb.isenemy(matches[2]) then
        mm.doadd("cast geyser at " .. matches[2])
      end

    Or automatically pick up monolith sigils and enemy drops: ::

      -- pattern (perl regex): ^(\w+) drops a monolith sigil\.$

      if ndb.isenemny(matches[2]) then
        mm.doaddfree("get monolith")
      end

    Or only announce enemies on mindnet: ::

      if ndb.isenemy(matches[2]) then
        mm.cc("%s has entered %s!", matches[2], gmcp.Room.Info.area)
      end

  ndb.isperson(name)
    Returns true if the given name is one NameDB knows of.

    This function is useful for making your attacks differentiate between PvP and bashing, as one example: ::

      if ndb.isperson(target) then
        send("kick "..target, false)
      else
        send("kill "..target, false)
      end

    In another example, you could automatically enemy in your target alias: ::

      target = matches[2]

      if ndb.isperson(target) and not mm.inslowcuringmode() then
        send("enemy "..target)
      end

  ndb.exists(name)
    Returns true if the given character name exists as NameDB knows it.

  ndb.getname(name)
    Returns a table with all information known about a name - useful to use if you want to check multiple fields of a person.

    Here's an example that shows the persons class, guild and org at once: ::

      local person = ndb.getname("Vadi")

      -- if ndb doesn't know the person, it'll return nil, so handle that
      if not person then mm.echof("I'm afraid I don't know Vadi yet.") return end

      mm.echof("Vadi's class that we know of is %s, and he's a %s in %s.", person.class, person.guild, person.org)

  ndb.findname(line)
    Given a line, returns the first character name it finds on it.

  ndb.findnames(line)
    Given a line, returns a list of known character names found on it. If no names are found, it returns nil.

  ndb.isclass(name, class)
    Returns true if the given person is known to be of that class.

    An example of use: ::

      -- on a trigger where the person lands in your room
      if ndb.isclass(matches[2], "blacktalon") then
        mm.echof("This person is a melder!")
      end

  ndb.getclass(name)
    Returns the known class of a person. If the person isn't known, it returns nil - and if the class isn't known, it returns "".

  ndb.setclass(name, class)
    Sets the class on a given person.

  ndb.getorg(name)
    Returns the known org of a person. If the person isn't known, it returns nil - and if the org isn't known, it returns "". ::

      -- check if somebody is from a particular org. The org name should be capitalized.
      if ndb.getorg(matches[2]) == "Hallifax" then

  ndb.isglom(name)
  ndb.ismag(name)
  ndb.iscelest(name)
  ndb.ishalli(name)
  ndb.isgaudi(name)
  ndb.isseren(name)
    Convenience functions, return true if the person belongs to the given org. You might want to use ndb.isenemy() when checking for enemies instead, as then you can configure which citizens you consider your enemies to be via a menu, instead of having to change all your code.

    Here are some examples: ::

      if ndb.isglom(matches[2]) then

      if not ndb.ishalli("Bob") then

  ndb.getnotes(name)
    Returns the notes that you've stored about a person - or "" if you haven't got any.

  ndb.isdemigod(name)
    Returns true or false depending on whenever the person is a known Demigod or Ascendant. If the person isn't known, it returns nil. ::

      -- see if a given person is a Demigod
      if ndb.isdemogid("Vadi") then
        mm.echof("Vadi is a demi/ascendant!")
      end

  ndb.setdemigod(name, status)
    Sets whenever a person is a Demigod or not. The status can be a ``true``/``false`` boolean or a string affirmation (yep/nope and so on) value. ::

      ndb.setdemigod("Vadi", true)
      ndb.setdemigod("Vadi", "yep")

      ndb.setdemigod("Unnamednewbie", false)
      ndb.setdemigod("Unnamednewbie", "nope")

  ndb.setiff(name, status)
    Adjusts ``iff`` (see the ``iff`` alias) of a person. Status can be ``auto``, ``ally`` or ``enemy``. ::

      -- we don't like Bob anymore. Set him to be treated as an enemy now by ndb.isenemy()
      ndb.setiff("Bob", "enemy")

  ndb.isimmortal(name)
    Returns true or false depending on whenever the person is a known Immortal (that is - Guide, God or Ephemeral).

  ndb.getpluralorg(org, count)
    Given a org affiliation and a number of citizens from it, returns either the singlar or plural variation of the org name. ::

      -- the following will say: There are 5 Gloms
      local org, amount = "Glomdoring", 5
      mm.cc("There are %s %s", amount, ndb.getpluralorg(org, amount))

      -- the following will say: 1 Seren
      local org, amount = "Serenwilde", 1
      mm.cc("%s %s", amount, ndb.getpluralorg(org, amount))

  ndb.getcolor(name)
    Returns you the cecho color for the given persons name, or '' if there is none (they aren't highlighted). You can use this to make echoes where peoples names are colored as they would be by NameDB. ::

      -- you can insert the color as a variable, between ..'s:
      cecho("Highlights: "..ndb.getcolor("Iosai").."Iosai<a_grey>, "..ndb.getcolor("Vadi").."Vadi")

      -- or be a bit more fancy about it, using string.format to insert the color:
      for _, name in ipairs({"Iosai", "Vadi", "Viynain", "Shuyin", "Svorai"}) do
        cecho(string.format("Name in color: %s%s\n", ndb.getcolor(name), name))
      end

  ndb.getcolorp(name)
    Returns you the foreground color that the person would be highlighted as, if they are meant to be. If they aren't meant to be highlighted or the person isn't known, returns nil.

  ndb.shouldbold(name)
    Returns true if the persons name would be bolded by NameDB, or false otherwise. This would be helpful to use in conjunction with `setBold() <http://wiki.mudlet.org/w/Manual:UI_Functions#setBold>`_. ::

      -- enables or disables bolding, depending whenever Aradors name is bolded by NameDB
      setBold(ndb.shouldbold("Arador"))
      echo("Arador")
      resetFormat()

  ndb.shoulditalicize(name)
    Returns true if the persons name would be italicized by NameDB, or false otherwise. This would be helpful to use in conjunction with `setItalics() <http://wiki.mudlet.org/w/Manual:UI_Functions#setItalics>`_. ::

      -- enables or disables undernlined text, depending whenever Aradors name is italicized by NameDB
      setItalics(ndb.shoulditalicize("Arador"))
      echo("Arador")
      resetFormat()

  ndb.shouldunderline(name)
    Returns true if the persons name would be underlined by NameDB, or false otherwise. This would be helpful to use in conjunction with `setUnderline() <http://wiki.mudlet.org/w/Manual:UI_Functions#setUnderline>`_. ::

      -- enables or disables undernlined text, depending whenever Aradors name is underlined by NameDB
      setUnderline(ndb.shouldunderline("Arador"))
      echo("Arador")
      resetFormat()

  ndb.isorgenemy(name)
    Similar to ndb.isenemy - but ignores whenever someone is a guild enemy or not. So it checks everything else that ndb.isenemy checks (citizenship, iff, and org) while ignoring the status of someone being your guild's enemy.

  "NameDB highlights reloaded" (event)
    This Mudlet event is raised when NameDB reloads all name highlights - so that you can make temp triggers after this event that take advantage of already-highlighted text.

  mm.config.set("ndbpaused", option, true)
    Disables or enables NameDB highlighting (same as what the ``npp`` alias does). ``option`` is a toggle in the same manner as ``svo.config.set()`` operates - it can be ``true``, ``false``, ``"on"``, ``"off"`` and so on. The last argument, ``true``, has to be there for the function to take effect.
