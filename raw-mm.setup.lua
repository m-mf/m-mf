-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

version = "$(version)"

#if DEBUG_actions then
  if Logger then Logger:LogSection("m-mf", {"timestamp", split = 5000, "keepOpen"}) end
#end

local luanotify = {}
luanotify.signal = require("notify.signal")

local lfs = require "lfs"

local debug = require "debug"

openURL = openURL or openUrl
-- !!
local pl = {}
pl.pretty = require "pl.pretty"
pl.config = require "pl.config"
pl.dir = require "pl.dir"
pl.string = require "pl.stringx"
pl.tablex = require "pl.tablex"
pl.OrderedMap = require "pl.OrderedMap"


local phpTable
phpTable = function (...) -- abuse to: http://richard.warburton.it
  local newTable,keys,values={},{},{}
  newTable.pairs=function(self) -- pairs iterator
    local count=0
    return function()
      count=count+1
      return keys[count],values[keys[count]]
    end
  end
  setmetatable(newTable,{
    __newindex=function(self,key,value)
      if not self[key] then table.insert(keys,key)
      elseif value==nil then -- Handle item delete
        local count=1
        while keys[count]~=key do count = count + 1 end
        table.remove(keys,count)
      end
      values[key]=value -- replace/create
    end,
    __index=function(self,key) return values[key] end
  })
  local arg = {...}
  for x=1,#arg do
    for k,v in pairs(arg[x]) do newTable[k]=v end
  end
  return newTable
end

-- credit: http://lua-users.org/wiki/IteratorsTutorial
function ripairs(t)
  local function ripairs_it(t,i)
    i=i-1
    local v=t[i]
    if v==nil then return v end
    return i,v
  end
  return ripairs_it, t, #t+1
end

openURL = openURL or openUrl

local actions, sk, vm, cn, cnrl = false, {}, {}, {}, {}
conf              = conf or {}
config            = {}
defc              = defc or {} -- current defences
defs              = defs or {}
ignore            = ignore or {}
lifep             = {}
local lifevision  = lifevision or {l = pl.OrderedMap()}
local affs        = {}
local balanceless = {}
local cp          = {}
local signals     = {}
local sps         = {}
local sys         = {}
overhaul          = overhaul or {}
sp                = sp or {} -- stance.parry
sp_config         = {}
stats             = stats or {}
valid             = valid or {}

reset = {}
prio = {}
local affmt = {
  __tostring = function (self)
      local result = {}
      for i,k in pairs(self) do
        if k.p.count then
          result[#result+1] = i .. ": " ..getStopWatchTime(k.sw).."s (" .. k.p.count .. ")"
        else
          result[#result+1] = i .. ": " ..getStopWatchTime(k.sw).."s"
        end
      end

      return table.concat(result, ", ")
  end
}
setmetatable(affs, affmt)

affl = affl or {}

local oldecho = conf.commandecho
signals.aeony = luanotify.signal.new()

signals.canoutr = luanotify.signal.new()
signals.canoutr:connect(function ()
  if (affs.webbed or affs.bound or affs.transfixed or affs.roped or affs.impale or ((affs.crippledleftarm or affs.mangledleftarm or affs.mutilatedleftarm) and (affs.crippledrightarm or affs.mangledrightarm or affs.mutilatedrightarm))) then
    sys.canoutr = false
  else
    sys.canoutr = true
  end
end)

signals.removed_from_rift = luanotify.signal.new()
signals.moved = luanotify.signal.new()

signals.systemstart = luanotify.signal.new()

#if DEBUG then
signals.systemstart:connect(function ()
end)
#end

signals.connected = luanotify.signal.new()
signals.loggedin = luanotify.signal.new()
signals.quit = luanotify.signal.new()
#if DEBUG then
signals.quit:connect(function ()
  if Logger then Logger:CloseLog("m-mf") end
end)
#end
signals.quit:add_pre_emit(function () signals.saveconfig:emit() end)
signals.systemend = luanotify.signal.new()

-- gmcp ones
signals.gmcpcharname = luanotify.signal.new()
signals.gmcpcharname:connect(function ()
  signals.enablegmcp:emit()
end)
signals.gmcproominfo = luanotify.signal.new()
signals.gmcpcharitemslist = luanotify.signal.new()
signals.gmcpcharskillsinfo = luanotify.signal.new()
signals.gmcpcharskillslist = luanotify.signal.new()
signals.gmcpcharskillsgroups = luanotify.signal.new()
signals.gmcpcharitemsupdate = luanotify.signal.new()
signals.gmcpcharafflictionsadd = luanotify.signal.new()
signals.gmcpcharafflictionsremove = luanotify.signal.new()
signals.gmcpcharafflictionslist = luanotify.signal.new()
signals.gmcpchardefencesadd = luanotify.signal.new()
signals.gmcpchardefencesremove = luanotify.signal.new()
signals.gmcpchardefenceslist = luanotify.signal.new()

signals["mmapper updated pdb"] = luanotify.signal.new()
signals.sysexitevent = luanotify.signal.new()

do
  local oldnum, oldarea
  signals.gmcproominfo:connect(function (...)
    if oldnum ~= gmcp.Room.Info.num then
      signals.newroom:emit(_G.gmcp.Room.Info.name)
      oldnum = gmcp.Room.Info.num
    end

    signals.anyroom:emit(_G.gmcp.Room.Info.name)

    if oldarea ~= gmcp.Room.Info.area then
      signals.newarea:emit(_G.gmcp.Room.Info.area)
      oldarea = gmcp.Room.Info.area
    end
  end)
end

-- atcp ones
signals.charname = luanotify.signal.new()
signals.roombrief = luanotify.signal.new()

do
  local oldnum
  signals.roombrief:connect(function (...)
    if oldnum ~= atcp.RoomNum then
      signals.newroom:emit(({...})[1])
      oldnum = atcp.RoomNum
    end

    signals.anyroom:emit(({...})[1])
  end)
end

-- general ones
signals.relogin = luanotify.signal.new()
signals.enablegmcp = luanotify.signal.new()
signals.enablegmcp:add_post_emit(function ()
  if not sys.enabledgmcp then
    sys.enabledgmcp = true
  else
    signals.relogin:emit()
    echof("Welcome back!")
  end

  -- app("off", true) -- this triggers a dict() run too early before login
  if dont_unpause_login then dont_unpause_login = nil
  else conf.paused = false end
end)
signals.newroom = luanotify.signal.new()
signals.newarea = luanotify.signal.new()
signals.anyroom = luanotify.signal.new()
signals.changed_maxhealth = luanotify.signal.new()
signals.changed_maxmana = luanotify.signal.new()
signals.changed_maxego = luanotify.signal.new()

signals.before_prompt_processing = luanotify.signal.new()
signals.after_prompt_processing = luanotify.signal.new()
signals.after_lifevision_processing = luanotify.signal.new()

signals.curedwith_focusmind = luanotify.signal.new()
signals.loadconfig = luanotify.signal.new()
signals.saveconfig = luanotify.signal.new()
signals.sysdatasendrequest = luanotify.signal.new()
signals.orgchanged = luanotify.signal.new()
#if skills.healing then
signals.healingskillchanged = luanotify.signal.new()
#end

signals.saveconfig:add_post_emit(function ()
  echo"\n"
  echof("Saved system settings.")
end)

signals.loadedconfig = luanotify.signal.new()
signals.sapafflicted = luanotify.signal.new()
signals.sapcured = luanotify.signal.new()

paragraph_length = 0

conf.siphealth = 80
#if skills.stag then
conf.mdbaghealth = 50
#end
conf.sipmana = 70
conf.sipego = 80
conf.scrollhealth = 30
conf.scrollmana = 30
conf.scrollego = 30
conf.sparklehealth = 60
conf.sparklemana = 60
conf.sparkleego = 60
conf.scrollid = 0
conf.assumestats = 0


conf.paused = false
conf.autoarena = false
conf.arena = false
conf.oldwarrior = false
conf.lag = 0
sys.wait = 0.7 -- for lag
conf.aillusion = false
conf.keepup = true
conf.sparkleherb = "coltsfoot"
conf.vitaemode = "empty"
conf.attemptearlystun = false
conf.adrenaline = false

conf.sacdelay = 0.5 -- delay after which the systems curing should resume in sync mode
conf.pindelay = 0.050

conf.bleedamount = 60
conf.manause = 35

conf.bashing = true

-- have skills?
conf.focusbody = false
conf.focusmind = false
conf.cleanse = false

conf.beastfocus = false
conf.aeonfocus = true
conf.powerfocus = false

conf.commandecho = true
conf.blockcommands = true
conf.commandechotype = "fancy"
conf.warningtype = "all"
conf.blindherb = "faeleaf"
conf.deafherb = "myrtle"

conf.autoreject = "white"
conf.doubledo = false

conf.ridingskill = "mount"
conf.ridingsteed = "pony"
conf.wonderall = false
conf.geniesall = false

conf.changestype = "shortpercent"

#if skills.healing then
if conf.succor then
  conf.autowounds = 3
else
  conf.autowounds = 10
end
#else
conf.autowounds = 10
#end

#if skills.healing then
conf.usehealing = "partial"
conf.succor = true
#end

#if skills.shamanism then
conf.clawamount = 700
#end

#if skills.illusions then
conf.changerace = "human"
#end

conf.gagclot = true
conf.gagrelight = false
conf.relight = true

conf.showafftimes = true
conf.waitherbai = true
conf.loadsap = false
conf.aeonprios = "current"

sys.sync = false
sys.deffing = false
sys.balanceid = 0
sys.balancetick = 1
sys.sipego = 0
sys.lagcount, sys.lagcountmax = 0, 3
sys.actiontimeout = 3
sys.actiontimeoutid = false
sys.manause = 0
sys.sipmana, sys.siphealth, sys.sparklehealth, sys.sparklemana, sys.scrollmana, sys.scrollhealth, sys.scrollego, sys.sparkleego = 0, 0, 0, 0, 0, 0, 0, 0
#if skills.stag then
sys.mdbaghealth = 0
#end
doqueue, dofreequeue = {repeating = false}, {}

sys.sp_satisfied, sys.blockparry = false, false
sys.canoutr = true

---

stats.nextlevel,
stats.currenthealth, stats.maxhealth,
stats.currentmana, stats.maxmana,
stats.currentego, stats.maxego,
stats.currentpower,
stats.currentendurance, stats.maxendurance,
stats.currentwillpower, stats.maxwillpower = 1,1,1,1,1,1,1,1,1,1,1,1

stats.esteem = 0
stats.essence = 0


---
me         = {}
me.skills  = {}
me.wielded = {}
me.dmplist = {}
me.locks   = {}
me.focus   = {}
me.artifacts = {}
me.prone = false
me.lastprone = false

$(
local paths = {}; paths.oldpath = package.path; package.path = package.path..";./?.lua;./bin/?.lua;"; local pretty = require "pl.pretty"; package.path = paths.oldpath

_put(string.format("me.class = \"%s\"\n", guild))
_put("me.skills = ".. pretty.write(skills))
)
---
#if skills.healing then
enableAlias("m&m Deepheal")
#else
disableAlias("m&m Deepheal")
#end

me.doqueue = doqueue
me.dofreequeue = dofreequeue
me.lustlist = {} -- list if names not to add lovers aff for
---

local dict

local prompt_stats

local defences = {}
local defs_data
local oneconcatwithval
local oldsend
local defupfinish, process_defs, defdefup
local doingaction, checkaction, checkany, killaction, actions_performed, bals_in_use, usingbal, doaction, actionfinished
local wait_tbl

local index_map = pl.tablex.index_map

local addaff, removeaff, checkanyaffs, updateaffcount

sk.salvetick, sk.herbtick, sk.focustick, sk.teatick, sk.purgativetick, sk.siptick, sk.luciditytick, sk.steamtick, sk.wafertick, sk.icetick = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
sk.overhaul = sk.overhaul or {}


local diag_list = {}

local rub_cleanse, clear_balance_prios, clear_sync_prios

local we_had_a_cure, arnica_cure, smoke_cure, focusmind_cure, focusspirit_cure, sip_cure
local promptcount, lastpromptnumber = 0, 0

local config_dict, vecho

local previous_vessel, next_vessel, next_deathmark, previous_deathmark, next_random_vessel

local make_prio_table, make_sync_prio_table

local findbybal, findbybals


local make_gnomes_work, send_in_the_gnomes, make_gnomes_work_async, make_gnomes_work_sync

local apply_cure, sacid, eat, applyarnica

local send = _G.send

local update

-- possible afflictions that need to go through a check first
local affsp = {}

local rift, pipes = {}, {}

local check_focus, check_salve, check_sip, check_purgative, check_herb, check_scroll, check_sparkle, check_misc, check_balanceless_acts, check_allheale, check_balanceful_acts, check_lucidity, check_steam, check_wafer, check_ice

local generics_enabled, generics_enabled_for_blackout, generics_enabled_for_passive, enable_generic_trigs, disable_generic_trigs, check_generics

local passive_cure_paragraph, generics_enabled_for_passive

local sp_something_to_parry, sp_checksp, sp_limbs

local lastlit

local install = {}

local life = {}
echos, echosd = {}, {}

sk.ignored_defences, sk.ignored_defences_map = {}, {}

pflags = {}

sk.overhauldata = {
  epilepsy       = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"trembling"}},
  paranoia       = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"dizziness", "vertigo", "hypochondria"} },
  sensitivity    = { newbalances = {"lucidity"}, oldbalances = {"herb", "salve"}, replaces = {"shyness", "masochism"} },
  confusion      = { newbalances = {"lucidity"}, oldbalances = {"purgative", "herb", "focus"}, replaces = {"agoraphobia"}},
  recklessness   = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"vapors"}},
  hallucinating  = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"claustrophobia", "vestiphobia"}},
  clumsiness     = { newbalances = {"lucidity"}, oldbalances = {"herb"}, replaces = {"loneliness", "dementia", "weakness"}},
  stupidity      = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"daydreaming", "narcolepsy"}},
  addiction      = { newbalances = {"lucidity"}, oldbalances = {"herb", "focus"}, replaces = {"gluttony"}},
  unknownlucidity      = { newbalances = {"lucidity"}, oldbalances = {}, replaces = {}},
  unknownsteam   = {newbalances = {"steam"}, oldbalances = {}, replaces = {}},
  unknownwafer   = {newbalances = {"wafer"}, oldbalances = {}, replaces = {}},
  egovice        = { newbalances = {"steam"}, oldbalances = {"herb"}},
  manabarbs      = { newbalances = {"steam"}, oldbalances = {"herb"}},
  achromaticaura = { newbalances = {"steam"}, oldbalances = {"herb"}},
  powerspikes    = { newbalances = {"steam"}, oldbalances = {"herb"}},
  disloyalty     = { newbalances = {"steam"}, oldbalances = {"purgative"}},
  pacifism       = { newbalances = {"steam"}, oldbalances = {"herb", "focus"}, replaces = {"peace", "inlove"}},
  illuminated    = { newbalances = {"steam"}, oldbalances = {"focus"}},
  healthleech    = { newbalances = {"steam"}, oldbalances = {"purgative", "herb"}},
  aeon           = { newbalances = {"steam"}, oldbalances = {"purgative", "herb"}},
  paralysis      = { newbalances = {"wafer"}, oldbalances = {}},
  haemophilia    = { newbalances = {"wafer"}, oldbalances = {"purgative", "herb"}},
  powersap       = { newbalances = {"wafer"}, oldbalances = {"purgative"}},
  scabies        = { newbalances = {"wafer"}, oldbalances = {"salve"}},
  dysentery      = { newbalances = {"wafer"}, oldbalances = {"purgative"}, replaces = {"worms"}},
  pox            = { newbalances = {"wafer"}, oldbalances = {"salve"}, replaces = {"sunallergy"}},
  vomiting       = { newbalances = {"wafer"}, oldbalances = {"purgative"}, replaces = {"vomitblood"}},
  rigormortis    = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  taintsick      = { newbalances = {"wafer"}, oldbalances = {"focus"}, replaces = {"crotamine"}},
  anorexia       = { newbalances = {"lucidity"}, oldbalances = {"herb"}, replaces = {"throatlock"}},
  asthma         = { newbalances = {"wafer"}, oldbalances = {"salve"}},
  slickness      = { newbalances = {"steam"}, oldbalances = {"herb"}},
  blind          = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  trueblind      = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  deaf           = { newbalances = {"steam"}, oldbalances = {"herb","wafer"}},
  truedeaf          = { newbalances = {"steam"}, oldbalances = {"herb","wafer"}},
  attraction        = { newbalances = {"steam"}, oldbalances = {"herb","wafer"}},
  massivetimewarp   = { newbalances = {"steam"}, oldbalances = {"herb","focus"}},
  majortimewarp     = { newbalances = {"steam"}, oldbalances = {"herb","focus"}},
  moderatetimewarp  = { newbalances = {"steam"}, oldbalances = {"herb","focus"}},
  minortimewarp     = { newbalances = {"steam"}, oldbalances = {"herb","focus"}},
  massiveinsanity   = { newbalances = {"lucidity"}, oldbalances = {"herb","focus"}},
  majorinsanity     = { newbalances = {"lucidity"}, oldbalances = {"herb","focus"}},
  moderateinsanity  = { newbalances = {"lucidity"}, oldbalances = {"herb","focus"}},
  slightinsanity    = { newbalances = {"lucidity"}, oldbalances = {"herb","focus"}},
  clotleftshoulder  = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  clotrightshoulder = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  clotlefthip       = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  clotrighthip      = { newbalances = {"wafer"}, oldbalances = {"herb"}},
  completelyaurawarped = { newbalances = {"steam"}, oldbalances = {"herb"}, replaces = {"aurawarp"}},
  massivelyaurawarped  = { newbalances = {"steam"}, oldbalances = {"herb"}, replaces = {"aurawarp"}},
  aurawarped           = { newbalances = {"steam"}, oldbalances = {"herb"}, replaces = {"aurawarp"}},
  moderatelyaurawarped = { newbalances = {"steam"}, oldbalances = {"herb"}, replaces = {"aurawarp"}},
  slightlyaurawarped   = { newbalances = {"steam"}, oldbalances = {"herb"}, replaces = {"aurawarp"}},
}
sk.overhaulredirects = {}

for aff, data in pairs(sk.overhauldata) do
  if data.replaces then
    for _, otheraff in ipairs(data.replaces) do
      sk.overhaulredirects[otheraff] = aff
    end
  end
end

sk.overhauldefaults = {}

local function assert(condition, msg, extra)
  if not condition then
    if extra then extra(msg) end
    error(msg)
  end
end

local function display(what)
  if type(what) ~= "table" then
    echo(what)
  else
    echo(pl.pretty.write(what)) end
end

signals.aeony:add_pre_emit(function ()
  if (affs.aeon or affs.sap or affs.choke or affs.retardation) and not sys.sync then
    oldecho = conf.commandecho
    conf.commandecho = true
    sys.sync = true
    signals.sysdatasendrequest:unblock(cnrl.processcommand)
    echo("\n")
    echof("Slow curing mode enabled.")

    -- kill actions prior to this, so we can do aeon
    local s,m = pcall(function()
      for k,v in actions:iter() do
        if v.p.balance ~= "waitingfor" and v.p.balance ~= "aff" then
          killaction(dict[v.p.action_name][v.p.balance])
        end
      end
    end)
    if not s then
      echoLink("(e!)", [[$(sys).echof("The problem was: ]]..tostring(m)..[[.")]], 'Oy - there was a problem. Click on this link and submit a bug report with what it says along with a copy/paste of what you saw.')
    end
  elseif sys.sync and not (affs.aeon or affs.sap or affs.choke or affs.retardation) then
    conf.commandecho = oldecho
    sys.sync = false
    signals.sysdatasendrequest:block(cnrl.processcommand)
    echo("\n")
    echof("Slow curing mode disabled.")
  end
end)

signals.systemstart:connect(function ()
  (tempExactMatchTrigger or tempTrigger)("You open your mouth but say nothing.",
    [[mm.valid.saidnothing()]]);

  (tempExactMatchTrigger or tempTrigger)("You move sluggishly into action.",
    [[mm.valid.webeslow()]]);

  (tempExactMatchTrigger or tempTrigger)("Thick shadows drag against your every action.",
    [[mm.valid.webeslow()]]);

  (tempExactMatchTrigger or tempTrigger)("The sticky sap coating your body causes you to move unbearably slowly.",
    [[mm.valid.webeslow()]]);

  (tempExactMatchTrigger or tempTrigger)("Your locked throat prevents you from speaking.",
    [[mm.valid.canttalk()]]);

  (tempExactMatchTrigger or tempTrigger)("You try to speak, but the hole in your throat inhibits your abilities.",
    [[mm.valid.holythroat()]]);
end)

color_table.a_blue        = {0, 85, 255}
color_table.a_brown       = {128, 128, 0}
color_table.a_cyan        = {0, 255, 255}
color_table.a_darkblue    = {0, 0, 128}
color_table.a_darkcyan    = {0, 128, 128}
color_table.a_darkgreen   = {0, 179, 0}
color_table.a_darkgrey    = {128, 128, 128}
color_table.a_darkmagenta = {128, 0, 128}
color_table.a_darkred     = {128, 0, 0}
color_table.a_darkwhite   = {192, 192, 192}
color_table.a_darkyellow  = {0, 179, 0}
color_table.a_green       = {0, 255, 0}
color_table.a_grey        = {192, 192, 192}
color_table.a_magenta     = {255, 0, 255}
color_table.a_red         = {255, 0, 0}
color_table.a_white       = {255, 255, 255}
color_table.a_yellow      = {255, 255, 0}
color_table.blaze_orange  = {255, 102, 0}

-- check if the person imported the xml many times by accident
signals.systemstart:connect(function ()
  local toomany, types = {}, {"alias", "trigger"} -- add scripts when exists() function supports it

  for _, type in ipairs(types) do
    if exists("m&m", type) > 1 then
      toomany[#toomany+1] = type
    end
  end

  if #toomany == 0 then return end

  tempTimer(10, function () echof("Warning! You have multiple %s m&mf folders while you only should have one per aliases, triggers, etc. Delete the extra ones.", table.concat(toomany, ", ")) end)
end)

-- fix iffy table.save

function table.save( sfile, t )
	local tables = {}
	table.insert( tables, t )
	local lookup = { [t] = 1 }
	local file, msg = io.open( sfile, "w" )
	if not file then return nil, msg end

	file:write( "return {" )
	for i,v in ipairs( tables ) do
		table.pickle( v, file, tables, lookup )
	end
	file:write( "}" )
	file:close()

	return true
end

-- load the lust list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/m&m/config/lustlist"

  if lfs.attributes(conf_path) then
    local t = {}
    table.load(conf_path, t)
    update(me.lustlist, t)
  end
end)

-- load the focus list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir().."/m&m/config/focus"

  if lfs.attributes(conf_path) then
    local t = {}
    table.load(conf_path, t)
    update(me.focus, t)
  end
end)

signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir().."/m&m/config/artifacts"

  if lfs.attributes(conf_path) then
    local t = {}
    table.load(conf_path, t)
    update(me.artifacts, t)
  end
end)


signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/lustlist", me.lustlist) end)

signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/focus", me.focus) end)
signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/artifacts", me.artifacts) end)

-- load the ignore list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/m&m/config/ignore"

  if lfs.attributes(conf_path) then
    local t = {}
    local ok, msg = pcall(table.load,conf_path, t)
    if ok then
      update(ignore, t)
    else
      os.remove(conf_path)
      tempTimer(10, function()
        echof("Your ignore file got corrupted for some reason - I've deleted it so the system can load other stuff OK. (%q)", msg)
      end)
    end
  end
end)

signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/ignore", ignore) end)

-- load the overhaul list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/m&m/config/overhaul"


  if lfs.attributes(conf_path) then
    local t = {}
    local ok, msg = pcall(table.load,conf_path, t)
    if ok then
      update(overhaul, t)
      sk.overhaul = deepcopy(overhaul)
    else
      os.remove(conf_path)
      tempTimer(10, function()
        echof("Your overhaul file got corrupted for some reason - I've deleted it so the system can load other stuff OK. (%q)", msg)
      end)
    end
  end
end)
signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/overhaul", overhaul) end)

-- load the overhauldefaults list
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/m&m/config/overhauldefaults"

  if lfs.attributes(conf_path) then
    local t = {}
    table.load(conf_path, t)
    update(sk.overhauldefaults, t)
  end

  if lfs.attributes(conf_path) then
    local t = {}
    local ok, msg = pcall(table.load,conf_path, t)
    if ok then
      update(sk.overhauldefaults, t)
    else
      os.remove(conf_path)
      tempTimer(10, function()
        echof("Your overhauldefaults file got corrupted for some reason - I've deleted it so the system can load other stuff OK. (%q)", msg)
      end)
    end
  end
end)
signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/overhauldefaults", sk.overhauldefaults) end)

-- after system has loaded, disable overhaul affs not already disabled by default
signals.systemstart:connect(function ()
  local enabledaffs = {}

  -- data bug: lovers was confused with inlove. wipe and re-set
  disableoverhaul("lovers")
  disableoverhaul("inlove")
  disableoverhaul("peace")
  disableoverhaul("pacifism")
  sk.overhauldefaults.pacifism = nil

  for aff, _ in pairs(sk.overhauldata) do
    if not sk.overhaul[aff] and not sk.overhauldefaults[aff] then
      enableoverhaul(aff)
      sk.overhauldefaults[aff] = true
      enabledaffs[#enabledaffs+1] = aff
    end
  end

  if next(enabledaffs) then
    echof("Enabled Overhaul mode for %s affliction%s.", concatand(enabledaffs), #enabledaffs == 1 and '' or 's')
  end
end)

sk.arena_areas = {
  --Gaudiguch
  ["Pyrodome of the Kaleidoscopic Trials"] = true,
  --Hallifax
  ["the Skylark Commemorative Demiplane"] = true,
  --Glomdoring
  ["the Shadowvale Arena"] = true,
  --Serenwilde
  ["the Glade of Champions"] = true,
  --New Celest
  ["the Pearl of the Amberle"] = true,
  --Magnagora
  ["the Midnight Coliseum"] = true,
  --Avenger
  ["the Klangratch Tourny Fields"] = true
}
