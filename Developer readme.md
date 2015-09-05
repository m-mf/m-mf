# Source code layout

    bin/                      = preprocessed files + Lua libraries
    bin/notify                = LuaNotify library for signal processing
    bin/pl                    = Penlight library for a miscellany of useful features, cut=down version
    bin/default_prios         = default priorities for m&mf
    bin/*.lua                 = pre-processed Lua files - don't edit these, but the raw-mm.*.lua ones instead.
    doc/                      = documentation in Sphinx.
    output/                   = storage location for build systems
    own m&mf/                 = your own Svof that your Mudlet profile loads
    m&m template/             = template folder containing things that need to be packed up into the final Svof
    compile.lua               = pulls m&mf files together into one big one that can be loaded in, used by generate.lua
    file.lua                  = Lua library with basic file functions, used by generate.lua
    luapp.lua                 = Lua preprocessing libraries, allows compile-time modification of Lua code - helps with some of the monotonous and repeating functions / table entries
    classlist.lua             = List of classes and their skillsets, used by generate.lua
    raw-*                     = original m&mf core files, that are transformed into postprocessed ones and stored in bin/
    raw-end.lua               = Last file run by m&mf when loading, does minor cleanup only.
    raw-mm.actionsystem.lua   = m&mf's action system. Every single thing that m&mf does like cure an affliction, put up a defence is an action. Rule of thumb is that all send()'s should be an action (there's just an exception to send commands to serverside to be done, as those commands cannot be interrupted in any way)
    raw-mm.aliases.lua        = functions for m&mf's aliases, that should call other core functions as necessary to do their work.
    raw-mm.carriontracker.lua = Blacktalon carrion tracker addon.
    raw-mm.config.lua         = m&mf's configuration (mmconfig) and tn/tf system
    raw-mm.controllers.lua    = core system functions that can be behind aliases/triggers - includes prompt function, GMCP stats function, affliction lock tracking, aeon/retardation deny/override system, etc.
    raw-mm.customprompt.lua   = m&mf's custom prompt feature
    raw-mm.defs.lua           = everything to do about m&mf's defences - database, tracking, switching, etc.
    raw-mm.demesne.lua        = Demense tracker addon.
    raw-mm.dict.lua           = brains of m&mf, where it knows every action (affliction, defence, balance, etc) - when to use it, how to use it
    raw-mm.dor.lua            = m&mf's DOR system, implemented as a balanceless and a balancefun action
    raw-mm.empty.lua          = functions tracking all of the empty cures
    raw-mm.funnies.lua        = m&mf's humour - welcome message, protips and dying messages
    raw-mm.harvester.lua      = Harvesting addon.
    raw-mm.healing.lua        = Healing other people addon (using Healing on self is built-in).
    raw-mm.influencer.lua     = Influencing addon.
    raw-mm.install.lua        = Installation procedure - audotects skills (before GMCP came along, by ABing and gagging) and asks questions for things it couldn't
    raw-mm.meldtracker.lua    = Meld tracker addon (paints your meld and breakpoints on mudlets map)
    raw-mm.misc.lua           = Miscallaneous functions that don't have a place elsewhere plus a few Lua helpers
    raw-mm.namedb.lua         = NameDB addon
    raw-mm.peopletracker.lua  = Peopletracker addon, integrates with Mudlet's mapper
    raw-mm.pipes.lua          = pipe tracking
    raw-mm.plsorter.lua       = plist sorter addon.
    raw-mm.prio.lua           = m&mf's priority handling functions
    raw-mm.rift.lua           = rift, inventory tracking and use of right actions depending on normal/aeon curing
    raw-mm.setup.lua          = m&mf loading files
    raw-mm.skeleton.lua       = essential core files, including balance checks that decide what should be done
    raw-mm.sp.lua             = stance/parry system
    raw-mm.valid.diag.lua     = Diagnose tracking
    raw-mm.valid.main.lua     = Definitions of all trigger functions - recording in-game data in most accurate way, while not getting tricked by illusions
    raw-mm.valid.simple.lua   = functions for adding afflictions directly from triggers


This the order that things happen on the prompt function:

    \
     |onprompt
     |signals.before_prompt_processing
     |  \
     |   |prompt_stats
     |   |cn.addupwounds
     |   |sk.acrobatics_pronecheckf (toggled)
     |   |valid.check_life
     |
     |send_in_the_gnomes
     |  \
     |   |lifevision.validate
     |   |signals.after_lifevision_processing
     |      \
     |       |sk.onprompt_beforeaction_do
     |       |(custom prompt)
     |       |cnrl.checkwarning
     |       |sp_checksp
     |   |make_gnomes_work
     |
     |signals.after_prompt_processing
     |  \
     |   |cnrl.dolockwarning



# How to's

## View system debug log
1. install [Logger](http://forums.mudlet.org/viewtopic.php?f=6&t=1424)
1. view mudlet-data/profiles/\<profile>/log/m-mf.txt

## Gotcha with luapp
If luapp, the pre-processor has an error compiling, it doesn't seem to print any errors. The preprocessed file will just stop at the erroring line.

## Converting an aff to overhaul
1. add the new trigger line for the balance in Mudlet
1. add new balance in raw-mm.dict.lua for the affliction
1. add cure in raw-mm.empty.lua
1. add cure function in raw-mm.main.lua
1. update overhauldata table in raw-mm.setup.lua

