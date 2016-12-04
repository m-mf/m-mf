-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.


-- misc functions
ignore.deathmarkone, ignore.deathmarktwo, ignore.deathmarkthree, ignore.deathmarkfour, ignore.deathmarkfive = true,true,true,true,true


function errorf(...)
  error(string.format(...))
end

function echon(...)
  local function wrapper(...) decho(string.format(...)) end
  local status, result = pcall(wrapper, ...)
  if not status then error(result, 2) end
  echo("\n")
end

function oneconcat(tbl)
  assert(type(tbl) == "table", "mm.oneconcat wants a table as an argument.")
  local result = {}
  for i,_ in pairs(tbl) do
    result[#result+1] = i
  end

  return table.concat(result, ", ")
end

function oneconcatwithval(tbl)
  assert(type(tbl) == "table", "mm.oneconcatwithval wants a table as an argument.")
  local result = {}
  for i,v in pairs(tbl) do
    result[#result+1] = string.format("%s(%s)", i, v)
  end

  return table.concat(result, ", ")
end

function deleteLineP()
  deleteLine()
  tempLineTrigger(1,1,[[
    if isPrompt() then
      deleteLine()
    end
]])
end

function contains(t, value)
  assert(type(t) == "table", "mm.contains wants a table!")

  for k, v in pairs(t) do
    if v == value then
      return k
    end
  end

  return false
end

--[[ returns true if something is ignored, which it is if:
   - it is ignored in general (or partially with no balances) with or without a filter
   - it is ignored on a specific balance, that matches the filter
 ]]
function ignored(action, baltocheck)
  local ignore = ignore

  if ((type(ignore[action]) == "boolean" and ignore[action]) or
    (type(ignore[action]) == "table" and ignore[action].balances and not next(ignore[action].balances)))
    then return true end

  if baltocheck and type(ignore[action]) == "table" and ignore[action].balances and ignore[action].balances[baltocheck] then return true end

  return false
end

#if skills.healing then
  -- used by 'normal' cure functions to see if we should ignore curing this aff
  function sk.wont_heal_this(aff)
    if type(conf.usehealing) ~= "string" or conf.usehealing ~= "full" then return true end

    if sk.healingmap[aff] then
      return false
    end

    return true
  end
#end

-- balances
bals = bals or {
  lucidity = true, steam = true, wafer = true, ice = true,
  herb = true, sip = true, sparkle = true,
  purgative = true,  salve = true, scroll = true,
  balance = true, equilibrium = true, focus = true, steam = true,
  allheale = true, tea = true, leftarm = "unset", rightarm = "unset", beast = true,
#if skills.psionics then
  super = "unset", sub = "unset", id = "unset",
#end
}

sk.cureoverhaul = {}
for bal, _ in pairs(bals) do
  sk.cureoverhaul[bal] = {}
end

function showbals()
  echof("Balance state: " ..
    (function (tbl)
      local result = {}
      for i,j in pairs(tbl) do
        if j then
          result[#result+1] = string.format("<50,205,50>%s%s", i,getDefaultColor())
        else
          result[#result+1] = string.format("<205,201,201>%s (off)%s", i,getDefaultColor())
        end
      end

      return table.concat(result, ", ")
    end)(bals))
    showprompt()
end

-- checks

-- sip check

local healthchecks = {
  healhealth = {p = dict.healhealth},
  healmana = {p = dict.healmana},
  healego = {p = dict.healego}
}

-- build a table of all the things we need to do with their priority numbers,
-- sort it, and do the topmost thing.
check_sip = function(sync_mode)
  -- can we even sip?
  if not bals.sip or usingbal("sip") or affs.stun or
    affs.sleep or affs.anorexia or affs.throatlock or
    affs.scarab or affs.slitthroat or affs.inquisition or
    affs.crushedwindpipe or affs.damagedthroat or affs.crucified or (affs.missingleftarm and affs.missingrightarm) or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    for i, j in pairs(what) do
      if j.p.sip and j.p.sip.isadvisable() and not ignored(i, "sip") and not overhaul[i] then

      prios[i] = (not sync_mode) and j.p.sip.aspriority or j.p.sip.spriority
      end
    end
  end

  check(affs)
  check(healthchecks)

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].sip) else
    return dict[getHighestKey(prios)].sip end
end

-- purgative check
check_purgative = function(sync_mode)
  -- can we even sip?
  if not bals.purgative or usingbal("purgative") or affs.stun
    or affs.sleep or affs.anorexia or affs.scarab or affs.slitthroat
    or affs.throatlock or affs.inquisition
    or affs.crucified or affs.crushedwindpipe then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    local gotsomething = false
    for i, j in pairs(what) do
      if j.p.purgative and j.p.purgative.isadvisable() and not ignored(i, "purgative") and not overhaul[i]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
      then

      prios[i] = (not sync_mode) and j.p.purgative.aspriority or j.p.purgative.spriority
      gotsomething = true
      end
    end

    return gotsomething
  end

  check(affs)

  if sys.deffing or conf.keepup then
    check(dict_purgative)
  end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].purgative) else
    return dict[getHighestKey(prios)].purgative end
end

-- lucidity check
check_lucidity = function(sync_mode)
  -- can we even sip?
  if not bals.lucidity or usingbal("lucidity") or affs.stun
    or affs.sleep or affs.scarab or affs.slitthroat
    or affs.throatlock or affs.inquisition
    or affs.crucified or affs.crushedwindpipe or affs.damagedthroat or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    local gotsomething = false
    for i, j in pairs(what) do
      if j.p.lucidity and j.p.lucidity.isadvisable() and not ignored(i, "lucidity") and overhaul[i]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
      then

      prios[i] = (not sync_mode) and j.p.lucidity.aspriority or j.p.lucidity.spriority
      gotsomething = true
      end
    end

    return gotsomething
  end

  check(affs)

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].lucidity) else
    return dict[getHighestKey(prios)].lucidity end
end

function valid.winning4()
  killTrigger(winning3Trigger)
  winning4Timer = tempTimer(math.random(10,30), [[mm.valid.winning4TimerAct()]])
end

function valid.winning4TimerAct()
  cecho("\n<blue>Almost there! How do we relieve stress from a night of binge drinking?")
  winning4Trigger = tempExactMatchTrigger("You let out a massive belch into the air.", [[mm.valid.winning5()]])
end

-- steam check
check_steam = function(sync_mode)
  -- can we even smoke?
  if not bals.steam or usingbal("steam") or affs.stun
    or affs.sleep or affs.scarab or affs.inquisition
    or affs.crucified or affs.asthma or affs.collapsedlungs
    or affs.pinlegright or affs.pinlegleft or affs.pinlegunknown
    then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    local gotsomething = false
    for i, j in pairs(what) do
      if j.p.steam and j.p.steam.isadvisable() and not ignored(i, "steam") and overhaul[i]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
      then

      prios[i] = (not sync_mode) and j.p.steam.aspriority or j.p.steam.spriority
      gotsomething = true
      end
    end

    return gotsomething
  end

  check(affs)
  if sys.deffing or conf.keepup then check(dict_steam) end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].steam) else
    return dict[getHighestKey(prios)].steam end
end

-- wafer check
check_wafer = function(sync_mode)
  if not bals.wafer or usingbal("wafer") or affs.sleep or affs.stun or sacid or affs.inquisition or affs.crucified or (affs.missingleftarm and affs.missingrightarm) or (conf.aillusion and conf.waitherbai and sk.checking_herb_ai()) or affs.crushedwindpipe or affs.slitthroat or affs.anorexia or affs.throatlock or affs.scarab or affs.darkfate or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
    return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    local gotsomething = false
    for i, j in pairs(what) do
      if j.p.wafer and j.p.wafer.isadvisable() and not ignored(i, "wafer") and overhaul[i]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
      then

        prios[i] = (not sync_mode) and j.p.wafer.aspriority or j.p.wafer.spriority
        gotsomething = true
      end
    end

    return gotsomething
  end

  check(affs)
  if sys.deffing or conf.keepup then check(dict_wafer) end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].wafer) else
    return dict[getHighestKey(prios)].wafer end
end

check_allheale = function (sync_mode)
  -- can we even sip?
  if not bals.allheale or usingbal("allheale") or not next(affs)
    or affs.sleep or affs.anorexia or affs.scarab or affs.slitthroat
    or affs.throatlock or not conf.allheale or affs.inquisition
    or affs.stun or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    for i, j in pairs(what) do

#if skills.healing then
      if j.p.allheale and j.p.allheale.isadvisable() and not ignored(i, "allheale") and sk.wont_heal_this(i) then
#else
      if j.p.allheale and j.p.allheale.isadvisable() and not ignored(i, "allheale") then
#end

      prios[i] = (not sync_mode) and j.p.allheale.aspriority or j.p.allheale.spriority
      end
    end
  end

  check(affs)

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].allheale) else
    return dict[getHighestKey(prios)].allheale end
end

-- salve check
check_salve = function(sync_mode)
  -- can we even use salves?
  if not bals.salve or usingbal("salve") or not next(affs) or
    affs.sleep or affs.stun or affs.inquisition or
    affs.slickness or affs.crucified or (affs.missingleftarm and affs.missingrightarm) or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  for i, j in pairs(affs) do
    if j.p.salve and j.p.salve.isadvisable() and not ignored(i, "salve") and not overhaul[i]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
    then
      prios[i] = (not sync_mode) and j.p.salve.aspriority or j.p.salve.spriority
    end
  end

  -- have nada?
  if not next(prios) then return false end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].salve) else
    return dict[getHighestKey(prios)].salve end
end

-- ice check
check_ice = function(sync_mode)
  -- can we even use salves?
  if not bals.ice or usingbal("ice") or not next(affs) or
    affs.sleep or affs.stun or affs.inquisition or
    affs.slickness or affs.crucified or (affs.missingleftarm and affs.missingrightarm) or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  for i, j in pairs(affs) do
    if j.p.ice and j.p.ice.isadvisable() and not ignored(i, "ice") and not overhaul[i]
#if skills.healing then
      and sk.wont_heal_this(i)
#end
    then
      prios[i] = (not sync_mode) and j.p.ice.aspriority or j.p.ice.spriority
    end
  end

  -- have nada?
  if not next(prios) then return false end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].ice) else
    return dict[getHighestKey(prios)].ice end
end

-- herb check
function sk.checking_herb_ai()
  return (doingaction"checkslickness") and true or false
end

-- build a table of all the things we need to do with their priority numbers,
-- sort it, and do the topmost thing.
check_herb = function(sync_mode)
  -- can we even eat?
  if not bals.herb or usingbal("herb") or affs.sleep or affs.stun or sacid or affs.inquisition or affs.crucified or (affs.missingleftarm and affs.missingrightarm) or (conf.aillusion and conf.waitherbai and sk.checking_herb_ai()) or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
    return
  end

  -- get all prios in the list
  local prios = {}
  local function check (what)
    for i, j in pairs(what) do
      if j.p.herb and j.p.herb.isadvisable() and not ignored(i, "herb") and not overhaul[i] and
        ((j.p.herb.eatcure and not j.p.herb.applycure and not affs.crushedwindpipe and not affs.slitthroat and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.darkfate) or (j.p.herb.eatcure and j.p.herb.applyherb and not affs.slickness) or (j.p.herb.smokecure and not affs.asthma and not affs.collapsedlungs and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown))
        --[[(not j.p.herb.eatcure or ((not affs.crushedwindpipe or j.p.herb.applyherb) and not affs.slitthroat and
          not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.darkfate)) and
        -- herb.applyherb is mostly to make it work with crushedwindpipe
        ((not j.p.herb.smokecure or j.p.herb.applyherb) or (not affs.asthma and not affs.collapsedlungs and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown))]]
#if skills.healing then
         and sk.wont_heal_this(i)
#end
        then

      prios[i] = (not sync_mode) and j.p.herb.aspriority or j.p.herb.spriority
      end
    end
  end

  check(affs)
  if conf.sparkle and conf.secondarysparkle and bals.sparkle then check(healthchecks) end
  if sys.deffing or conf.keepup then check(dict_herb) end

  -- have nada?
  if not next(prios) then return false end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].herb) else
    return dict[getHighestKey(prios)].herb end
end

-- misc check

-- build a table of all the things we need to do with their priority numbers,
-- sort it, and do the topmost thing.
-- dontbatch means only one such item should be done
check_misc = function(sync_mode)
  -- we -don't- check for sleep here
  if affs.stun then
    return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    for i, j in pairs(what) do
      if j.p.misc and j.p.misc.isadvisable() and not ignored(i, "misc") and not doingaction (i) and
          (not affs.sleep or j.p.misc.action_name == "sleep") and
          ((not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown) or j.p.misc.action_name == "pinlegright" or j.p.misc.action_name == "pinlegleft" or j.p.misc.action_name == "pinlegunknown" or j.p.misc.action_name == "pinlegleft2" or j.p.misc.action_name == "pinlegright2")
#if skills.healing then
         and sk.wont_heal_this(i)
#end
      then
        prios[i] = (not sync_mode) and j.p.misc.aspriority or j.p.misc.spriority
      end
    end
  end

  check(affs)
  check(dict_misc)
  if sys.deffing or conf.keepup then check(dict_misc_def) end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest! Also go down the list in priorities in case you need to dontbatch
  if not sync_mode then
    local set = index_map(prios)

    local highest, lowest = getBoundary(prios)
    local dontbatch
    for i = highest, lowest, -1 do
      if set[i] then
        if not dict[set[i]].misc.dontbatch or not dontbatch then
          doaction(dict[set[i]].misc)

          if dict[set[i]].misc.dontbatch then dontbatch = true; debugf("%s enabled dontbatch", set[i]) end
        end
      end
    end
  else
    -- otherwise, do the highest!
    return dict[getHighestKey(prios)].misc
  end
end

-- focus check

-- build a table of all the things we need to do with their priority numbers,
-- sort it, and do the topmost thing.
check_scroll = function(sync_mode)
  -- can we even use scroll?
  if not conf.scroll or usingbal("scroll") or affs.stun or not bals.scroll
    or affs.sleep or affs.inquisition or affs.pinlegleft or affs.pinlegright or affs.pinlegunknown then
      return
  end

  -- get all prios in the list
  local prios = {}
  for i, j in pairs(healthchecks) do
    if j.p.scroll and j.p.scroll.isadvisable() and not ignored(i, "scroll") and
      not (affs.blind and not defc.trueblind) then
        prios[i] = (not sync_mode) and j.p.scroll.aspriority or j.p.scroll.spriority
    end
  end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].scroll) else
    return dict[getHighestKey(prios)].scroll end
end

check_sparkle = function(sync_mode)
  -- can we even eat?
  if not conf.sparkle or usingbal("sparkle") or affs.stun or not bals.sparkle
    or affs.sleep or affs.inquisition or affs.crucified or affs.darkfate or (affs.mutilatedleftarm and affs.mutilatedrightarm) then
      return
  end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    for i, j in pairs(what) do
      if j.p.sparkle and j.p.sparkle.isadvisable() and not ignored(i, "sparkle") and
        (not affs.crushedwindpipe and not affs.slitthroat and
            not affs.anorexia and not affs.throatlock and not affs.scarab) then
          prios[i] = (not sync_mode) and j.p.sparkle.aspriority or j.p.sparkle.spriority
      end
    end
  end

  if not conf.secondarysparkle then check(healthchecks) end
  if next(affs) then check(dict_sparkleaffs) end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].sparkle) else
    return dict[getHighestKey(prios)].sparkle end
end

check_focus = function(sync_mode)
  -- can we even focus?
  if usingbal("focus") or affs.stun or not bals.focus
    or affs.sleep or not next(affs) or affs.inquisition then
      return
  end

  local can_usemana = can_usemana()

  -- get all prios in the list
  local prios = {}
  local contains = table.contains
  for i, j in pairs(affs) do
    if j.p.focus and j.p.focus.isadvisable() and not ignored(i, "focus") and not (overhaul[i] and contains(sk.overhauldata[i].oldbalances, "focus")) and
      (not j.p.focusmind or not affs.crucified) and
      ((j.p.focus.focusmind and conf.focusmind and not affs.crucified and not affs.darkfate and can_usemana) or
       (j.p.focus.focusbody and conf.focusbody and not affs.impatience) or
       (j.p.focus.focusspirit and conf.focusspirit and not affs.impatience and can_usemana and not affs.manabarbs and not affs.maestoso))
#if skills.healing then
         and sk.wont_heal_this(i)
#end
        then
        prios[i] = (not sync_mode) and j.p.focus.aspriority or j.p.focus.spriority
    end
  end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].focus) else
    return dict[getHighestKey(prios)].focus end
end


-- lifevision system

-- if something was added here, that means it was validated via other
-- means already - all we need to do now is to check if we had lifevision
-- catch the line or no.

-- other_action means do something else than default when done
function lifevision.add(what, other_action, arg)
  lifevision.l:set(what.name, {
    p = what,
    other_action = other_action,
    arg = arg
  })

#if DEBUG_lifevision then
  debugf("lifevision: %s added with '%s' call (%s)", tostring(what.name), other_action and other_action or "default", tostring(arg))
#end

  if not sys.sync then return end
  if actions[what.name] and what.balance ~= "aff" and what.balance ~= "gone" then
    selectCurrentLine()
    setFgColor(0,0,255)
    resetFormat()
  end
end

function lifevision.validate()
  if sys.flawedillusion then
    sys.flawedillusion = false
    for i,j in lifevision.l:iter() do
      actionclear(j.p)
    end
  else
    for i,j in lifevision.l:iter() do
      actionfinished(j.p, j.other_action, j.arg)
    end
  end
  lifevision.l = pl.OrderedMap()
end

updateaffcount = function (which)
  affl[which.name].count = which.count

  raiseEvent("m&m updated aff", which.name, "count", which.count)
end

checkanyaffs = function (...)
  local t = {...}
  for i=1,#t do
    local j = t[i]

    if affs[j.name] then
    return j end
  end
end

-- balanceful check
check_balanceful_acts = function(sync_mode)
#if skills.psionics then
  if affs.sleep or affs.stun or not bals.balance or not bals.equilibrium or affs.pinlegright or affs.pinlegleft or affs.pinlegunknown or not bals.super or not bals.sub or not bals.id or not bals.rightarm or not bals.leftarm then return end
#else
  if affs.sleep or affs.stun or not bals.balance or not bals.equilibrium or affs.pinlegright or affs.pinlegleft or affs.pinlegunknown or not bals.rightarm or not bals.leftarm then return end
#end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    for i, j in pairs(what) do
      -- don't check for rightarm or leftarm, as no afflictions or balances are on it yet
      if j.p.physical.balanceful_act and j.p.physical.isadvisable() and not ignored(i, "balance") and not ignored(i, "equilibrium") and not ignored(i, "super") and not ignored(i, "sub") and not ignored(i, "id") then
        prios[i] = (not sync_mode) and j.p.physical.aspriority or j.p.physical.spriority
      end
    end
  end

  check(dict_balanceful)

  if sys.deffing or conf.keepup then
    check(dict_balanceful_def)
  end

  -- have nada?
  if not next(prios) then return false end

  -- otherwise, do the highest!
  if not sync_mode then
    doaction(dict[getHighestKey(prios)].physical) else
    return dict[getHighestKey(prios)].physical end

  return true
end

-- balanceless check
check_balanceless_acts = function(sync_mode)
#if skills.psionics then
  if affs.sleep or affs.stun or not bals.balance or not bals.equilibrium or affs.pinlegright or affs.pinlegleft or affs.pinlegunknown or not bals.sub or not bals.super or not bals.id or not bals.rightarm or not bals.leftarm then return end
#else
  if affs.sleep or affs.stun or not bals.balance or not bals.equilibrium or affs.pinlegright or affs.pinlegleft or affs.pinlegunknown or not bals.rightarm or not bals.leftarm then return end
#end

  -- get all prios in the list
  local prios = {}
  local function check(what)
    local gotsomething = false

    for i, j in pairs(what) do
      if j.p.physical.balanceless_act and j.p.physical.isadvisable() and not ignored(i, "balance") and not ignored(i, "equilibrium") and not ignored(i, "super") and not ignored(i, "sub") and not ignored(i, "id") then
        prios[i] = (not sync_mode) and j.p.physical.aspriority or j.p.physical.spriority
        gotsomething = true
      end
    end

    return gotsomething
  end

  check(dict_balanceless)

  if sys.deffing or conf.keepup then
    check(dict_balanceless_def)
  end

  -- have nada?
  if not next(prios) then return end

  -- otherwise, do the highest!
  if not sync_mode then
    local set = index_map(prios)

    local highest, lowest = getBoundary(prios)
    for i = highest, lowest, -1 do
      if set[i] then
        doaction(dict[set[i]].physical)
      end
    end
  else
    return dict[getHighestKey(prios)].physical
  end

  return true
end

local balanceless = balanceless or {}
local balanceful = balanceful or {}
local balonly = balonly or {}
local eqonly = eqonly or {}

function sk.balance_controller()
  if sys.balanceid == sys.balancetick then return end

#if skills.psionics then
  if not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and bals.super and bals.sub and bals.id) or (affs.webbed or affs.bound or affs.transfixed or affs.roped or affs.impale or affs.paralysis) then return end
#else
  if not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm) or (affs.webbed or affs.bound or affs.transfixed or affs.roped or affs.impale or affs.paralysis) then return end
#end

  -- loop through all balanceless functions
  for k, f in pairs(balanceless) do
    f()
  end

-- loop through balanceful actions until we get one that takes bal or eq
  local r
  for k,f in pairs(balanceful) do
    r = f()
    if r then
      if type(r) == "number" then
        sys.actiontimeoutid = tempTimer(r, function () sys.balancetick = sys.balancetick + 1; make_gnomes_work() end)
      else
        sys.actiontimeoutid = tempTimer(sys.actiontimeout, function () sys.balancetick = sys.balancetick + 1; make_gnomes_work() end)
      end
      sys.balanceid = sys.balancetick
      break
    end

  end
end

function addbalanceless(name, func)
  assert(name and func, "$(sys).addbalanceless: both name and function are required")
  assert(type(func) == 'function', "$(sys).addbalanceless: function needs to be an actual function, while you gave it a "..type(func))

  balanceless[name] = func
end

function removebalanceless(name)
  balanceless[name] = nil
end

function addbalanceful(name, func)
  assert(name and func, "$(sys).addbalanceful: both name and function are required")
  assert(type(func) == "function", "$(sys).addbalanceful: second argument has to be a function (you gave it a "..type(func)..")")

  balanceful[name] = func
end

function removebalanceful(name)
  balanceful[name] = nil
end

function clearbalanceful()
  balanceful = {}
  addbalanceful("m&m check do", sk.check_do)
  raiseEvent("m&m balanceful ready")
end

function clearbalanceless()
  balanceless = {}
  addbalanceless("m&m check dofree", sk.check_dofree)
  raiseEvent("m&m balanceless ready")
end

raiseEvent("m&m balanceless ready")
raiseEvent("m&m balanceful ready")

-- m&m Got prompt
-- DO WORK!

-- utils
local timer = createStopWatch()

local function find_highest_action(tbl)
  local result
  local highest = 0
  for _,j in pairs(tbl) do
    if j.spriority > highest then
      highest = j.spriority
      result = j
    end
  end

  return result
end

local workload = {check_focus, check_salve, check_sip, check_purgative, check_lucidity,
            check_steam, check_herb, check_wafer, check_ice, check_scroll, check_sparkle, check_misc,
            check_balanceless_acts, check_balanceful_acts, check_allheale}

-- real functions
local function work_slaves_work()
  -- in async, ask each bal to do it's action
  check_focus()
  check_salve()

  check_sip()
  check_purgative()
  check_lucidity()
  check_steam()
  check_herb()
  check_wafer()
  check_ice()

  check_scroll()
  check_sparkle()
  check_misc()

  check_balanceless_acts()

  -- if the system didn't use bal, let it be used for other things.
  if not check_balanceful_acts() and not findbybal"physical" then sk.balance_controller() end

  check_allheale()
end

make_gnomes_work_async = function()
  if conf.paused then return end

  if conf.commandecho and conf.commandechotype == "fancy" then
    send = fancysend
    work_slaves_work()
    fancysendall()
    send = oldsend
  else
    work_slaves_work()
  end
end

work_gnomes_work = function ()
  if conf.paused then return end

  if not findbybal"physical" then sk.balance_controller() end
end

make_gnomes_work_sync = function()
  sk.syncdebug = false
  if conf.paused or sacid then return end

  -- if we're already doing an action, don't do anything!
  local result
  for balance,actions in pairs(bals_in_use) do
    if balance ~= "waitingfor" and balance ~= "gone" and balance ~= "aff" and next(actions) then result = select(2, next(actions)) break end
  end
  if result then
#if DEBUG then
    debugf("doing %s, quitting for now", result.name)
#end
    sk.syncdebug = string.format("[%s]: Currently doing: %s", getTimestamp(getLineCount()):trim(), result.name)
    return
  end

  sk.gnomes_are_working = true

  local action_list = {}
  result = false

  --... check for all bals.
  -- in sync, only return values
  for _, check_func in pairs(workload) do
    result = check_func(true)
    if result then action_list[result.name] = result end
  end

    local actions = pl.tablex.keys(action_list)
  table.sort(actions, function(a,b)
    return action_list[a].spriority > action_list[b].spriority
  end)

  sk.syncdebug = string.format('[%s]: Feasible actions we\'re currently considering doing (in order): %s', getTimestamp(getLineCount()):trim(), (not next(action_list) and '(none)' or concatand(actions)))

  -- nothing to do =)
  if not next(action_list) then sk.gnomes_are_working = false return end

  if conf.commandecho and conf.commandechotype == "fancy" then
    send = fancysend
    doaction(find_highest_action(action_list))
    fancysendall()
    send = oldsend
  else
    doaction(find_highest_action(action_list))
  end
  sk.gnomes_are_working = false
end

-- default is async
signals.aeony:connect(function()
  if sys.sync then
    make_gnomes_work = make_gnomes_work_sync
  else
    make_gnomes_work = make_gnomes_work_async
  end
end)
signals.aeony:emit()

function send_in_the_gnomes()
  --~ startStopWatch(timer)

  -- at first, deal with lifevision.
#if DEBUG_actions then
--debugf("before lifevision.validate()")
#end
  lifevision.validate()
#if DEBUG_actions then
--debugf("after lifevision.validate(), before emit")
#end
  signals.after_lifevision_processing:emit()
#if DEBUG_actions then
--debugf("after emit")
#end

  make_gnomes_work()

  --~ local time = stopStopWatch(timer)
  --~ if time ~= 0 then echo(stopStopWatch(timer) .. "ms ") end
end

function update_rift_view()
  local status, msg = pcall(function () mm_create_riftlabel() end)

  if not status then error(msg) end
end

function sk.makewarnings()
  sk.warnings = {
    nomyrtleid = {
      time = 20,
      msg = "Warning: need to use your <31,31,153>myrtle"..getDefaultColor().." pipe and you don't have one!",
    },
    nocoltsfootid = {
      time = 20,
      msg = "Warning: need to use your <31,31,153>coltsfoot"..getDefaultColor().." pipe and you don't have one!",
    },
    nofaeleafid = {
      time = 20,
      msg = "Warning: need to use your <31,31,153>faeleaf"..getDefaultColor().." pipe and you don't have one!",
    },
    nosteamid = {
      time = 20,
      msg = "Warning: need to use your <31,31,153>steam"..getDefaultColor().." pipe and you don't have one!",
    },
    behead = {
      time = 10,
      msg = "Warning: your head wounds allow for a <253,63,73>behead"..getDefaultColor().."! Need a bit of time to cure them."
    },
    lowwillpower = {
      time = 30,
      msg = "Warning: your <253,63,73>willpower is too low"..getDefaultColor().."! Need to regen some."
    },
    maestoso = {
      time = 5,
      msg = "Warning: <253,63,73>maestoso"..getDefaultColor().." is in the room, leave it to cure aurics!"
    },
    manyvessels = {
      time = 10,
      msg = "Warning: your <253,63,73>vessel amount is too high"..getDefaultColor().."! Need to cure up."
    }
  }
end

signals.systemstart:add_post_emit(sk.makewarnings)
signals.orgchanged:add_post_emit(sk.makewarnings)

sk.warn = function (what)
  if sk.warnings[what].warned then return end

  tempTimer(sk.warnings[what].time, function() sk.warnings[what].warned = false end)
  sk.warnings[what].warned = true

  moveCursorEnd("main")
  echo("\n\n") echof(sk.warnings[what].msg) echo("\n")
end

local missing_drinks, missing_warned_drinks = {}, {}
function sk.got_nothing_to_sip(drinking)
  if find_until_last_paragraph(line) then return end

  missing_drinks[drinking] = (missing_drinks[drinking] or 0) + 1

  if missing_drinks[drinking] >= 3 and not missing_warned_drinks[drinking] then
    missing_warned_drinks[drinking] = true
    tempTimer(5, function() missing_warned_drinks[drinking] = false end)

    echo "\n"
    echof("Missing %s potion for %s :(", drinking.sipcure, drinking.action_name)
  end

  tempTimer(sys.wait * 2, function ()
    missing_drinks[drinking] = missing_drinks[drinking] - 1
    if missing_drinks[drinking] < 0 then missing_drinks[drinking] = 0 end
  end)
end

sk.choke_count = 0
function sk.choke_symptom()
  if not paragraph_length == 0 or affs.choke then return end

  sk.choke_count = sk.choke_count + 1

  if sk.choke_count >= 3 then
    valid.simplechoke()
    echo"\n" echof("auto-detected choke.")
    sk.choke_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.choke_count = sk.choke_count - 1
    if sk.choke_count < 0 then sk.choke_count = 0 end
  end)
end

sk.stupidity_count = 0
function sk.stupidity_symptom()
  if not paragraph_length == 0 or affs.stupidity or affs.damagedskull
   then return end

  sk.stupidity_count = sk.stupidity_count + 1

  if sk.stupidity_count >= 2 then
    valid.simplestupidity()
    echo"\n" echof("auto-detected stupidity.")
    sk.stupidity_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.stupidity_count = sk.stupidity_count - 1
    if sk.stupidity_count < 0 then sk.stupidity_count = 0 end
  end)
end

sk.retardation_count = 0
function sk.retardation_symptom()
  if not paragraph_length == 0 or affs.retardation then return end

  sk.retardation_count = sk.retardation_count + 1

  if sk.retardation_count >= 2 then
    valid.simpleretardation()
    echo"\n" echof("auto-detected retardation.")
    sk.retardation_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.retardation_count = sk.retardation_count - 1
    if sk.retardation_count < 0 then sk.retardation_count = 0 end
  end)
end

sk.blind_count = 0
function sk.blind_symptom()
  if not paragraph_length == 0 or affs.blind then return end

  sk.blind_count = sk.blind_count + 1

  if sk.blind_count >= 3 then
    valid.simpleblind()
    echo"\n" echof("auto-detected blind.")
    sk.blind_count = 0
    return
  end

  tempTimer(1 + sys.wait * 2, function ()
    sk.blind_count = sk.blind_count - 1
    if sk.blind_count < 0 then sk.blind_count = 0 end
  end)
end

sk.impale_count = 0
function sk.impale_symptom()
  if not paragraph_length == 0 or affs.impale then return end

  sk.impale_count = sk.impale_count + 1

  if sk.impale_count >= 3 then
    valid.simpleimpale()
    defs.lost_quicksilver()
    echo"\n" echof("auto-detected impale.")
    sk.impale_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.impale_count = sk.impale_count - 1
    if sk.impale_count < 0 then sk.impale_count = 0 end
  end)
end

sk.crucified_count = 0
function sk.crucified_symptom()
  if not paragraph_length == 0 or affs.crucified then return end

  sk.crucified_count = sk.crucified_count + 1

  if sk.crucified_count >= 3 then
    valid.simplecrucified()
    defs.lost_quicksilver()
    echo"\n" echof("auto-detected crucified.")
    sk.crucified_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.crucified_count = sk.crucified_count - 1
    if sk.crucified_count < 0 then sk.crucified_count = 0 end
  end)
end


sk.shackled_count = 0
function sk.shackled_symptom()
  if not paragraph_length == 0 or affs.shackled then return end

  sk.shackled_count = sk.shackled_count + 1

  if sk.shackled_count >= 3 then
    valid.simpleshackled()
    defs.lost_quicksilver()
    echo"\n" echof("auto-detected shackled.")
    sk.shackled_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.shackled_count = sk.shackled_count - 1
    if sk.shackled_count < 0 then sk.shackled_count = 0 end
  end)
end

sk.aeon_count = 0
function sk.aeon_symptom()
  if not paragraph_length == 0 or affs.aeon then return end

  sk.aeon_count = sk.aeon_count + 1

  if sk.aeon_count >= 3 then
    valid.simpleaeon()
    defs.lost_quicksilver()
    echo"\n" echof("auto-detected aeon.")
    sk.aeon_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.aeon_count = sk.aeon_count - 1
    if sk.aeon_count < 0 then sk.aeon_count = 0 end
  end)
end

sk.sap_count = 0
function sk.sap_symptom()
  if not paragraph_length == 0 or affs.sap then return end

  sk.sap_count = sk.sap_count + 1

  if sk.sap_count >= 3 then
    valid.simplesap()
    defs.lost_quicksilver()
    echo"\n" echof("auto-detected sap.")
    sk.sap_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.sap_count = sk.sap_count - 1
    if sk.sap_count < 0 then sk.sap_count = 0 end
  end)
end

sk.hypochondria_count = 0
function sk.hypochondria_symptom()
  if find_until_last_paragraph(line) or affs.hypochondria then return end

  sk.hypochondria_count = sk.hypochondria_count + 1

  if sk.hypochondria_count >= 3 then
    valid.simplehypochondria()
    sk.hypochondria_count = 0
  end

  tempTimer(12, function ()
    sk.hypochondria_count = sk.hypochondria_count - 1
    if sk.hypochondria_count < 0 then sk.hypochondria_count = 0 end
  end)
end

sk.stun_count = 0
function sk.stun_symptom()
  if not paragraph_length == 0 or affs.stun then return end

  sk.stun_count = sk.stun_count + 1

  if sk.stun_count >= 3 then
    valid.simplestun()
    echo"\n" echof("auto-detected stun.")
    sk.stun_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.stun_count = sk.stun_count - 1
    if sk.stun_count < 0 then sk.stun_count = 0 end
  end)
end

sk.tangle_count = 0
function sk.tangle_symptom()
  if not paragraph_length == 0 or affs.tangle then return end

  sk.tangle_count = sk.tangle_count + 1

  if sk.tangle_count >= 2 then
    valid.simpletangle()
    echo"\n" echof("auto-detected tangle.")
    sk.tangle_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.tangle_count = sk.tangle_count - 1
    if sk.tangle_count < 0 then sk.tangle_count = 0 end
  end)
end

sk.roped_count = 0
function sk.roped_symptom()
  if not paragraph_length == 0 or affs.roped then return end

  sk.roped_count = sk.roped_count + 1

  if sk.roped_count >= 2 then
    valid.simpleroped()
    echo"\n" echof("auto-detected roped.")
    sk.roped_count = 0
    return
  end

  tempTimer(sys.wait * 2, function ()
    sk.roped_count = sk.roped_count - 1
    if sk.roped_count < 0 then sk.roped_count = 0 end
  end)
end

local function update_eventaffs()
  if conf.eventaffs then
    -- addaff
    addaff = function (new)
      if affs[new.name] then return end

      -- if this aff is in overhaul mode, deal with it if redirecting to another aff
      if type(sk.overhaul[new.name]) == "string" then
        local oldaff = new.name
        new = dict[sk.overhaulredirects[new.name]]
        raiseEvent("m&m redirected aff", oldaff, new.name)
      end

      affs[new.name] = {
        p = new,
        sw = new.sw or createStopWatch()
      }
      startStopWatch(affs[new.name].sw)

      if not affl[new.name] then
        affl[new.name] = { sw = affs[new.name].sw }
        raiseEvent("m&m got aff", new.name)
      end
    end

    -- removeaff
    removeaff = function (old)
      if type(old) == "table" then
        for _,aff in pairs(old) do
          removeaff(aff)
        end
        return
      end

      if affl[old] then
        affl[old] = nil
        raiseEvent("m&m lost aff", old)
      end

      local sw = (affs[old] and affs[old].sw or nil)
      affs[old] = nil

      -- call the onremoved handler if any
      if dict[old].onremoved then dict[old].onremoved() end

      if conf.showafftimes and sw then
        echoafftime(stopStopWatch(sw))
      end
    end

  else

    -- addaff
    addaff = function (new)
      if affs[new.name] then return end

      -- if this aff is in overhaul mode, deal with it if redirecting to another aff
      if type(sk.overhaul[new.name]) == "string" then
        local oldaff = new.name
        new = dict[sk.overhaulredirects[new.name]]
        raiseEvent("m&m redirected aff", oldaff, new.name)
      end

      affs[new.name] = {
        p = new,
        sw = new.sw or createStopWatch()
      }
      startStopWatch(affs[new.name].sw)

      affl[new.name] = { sw = affs[new.name].sw }
    end

    -- removeaff
    removeaff = function (old)
      if type(old) == "table" then
        for _,aff in pairs(old) do
          removeaff(aff)
        end
        return
      end

      local sw = (affs[old] and affs[old].sw or nil)
      affs[old] = nil
      affl[old] = nil

      -- call the onremoved handler if any
      if dict[old].onremoved then dict[old].onremoved() end

      if conf.showafftimes and sw then
        echoafftime(stopStopWatch(sw))
      end
    end
  end
end
signals.systemstart:connect(update_eventaffs)

sk.onpromptfuncs = {}
function sk.onprompt_beforeaction_add(name, what)
  sk.onpromptfuncs[name] = what
end

sk.onprompt_beforeaction_do = function()
  for name, func in pairs(sk.onpromptfuncs) do
    local s,m = pcall(func)
    if not s then echof("Your prompttrigger %s had a problem:\n  %s", tostring(name), m) end
  end
  sk.onpromptfuncs = {}
end
signals.after_lifevision_processing:connect(sk.onprompt_beforeaction_do)

sk.lasttrigger = {}
function sk.lasttrigger_add(name, what)
  sk.lasttrigger[name] = what
  enableTrigger("m&m last trigger")
end

sk.lasttrigger_do = function()
  for name, func in pairs(sk.lasttrigger) do
    local s,m = pcall(func)
    if not s then echof("Your last trigger %s had a problem:\n  %s", tostring(name), m) end
  end
  sk.lasttrigger = {}
end

sk.lostbal_focus = function()
  bals.focus = false
  sk.focustick = sk.focustick + 1
  local oldfocustick = sk.focustick

  tempTimer(10, function ()
    if not bals.focus and sk.focustick == oldfocustick then
      bals.focus = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_sip = function()
  bals.sip = false
  sk.siptick = sk.siptick + 1
  local oldsiptick = sk.siptick

  tempTimer(5, function ()
    if not bals.sip and sk.siptick == oldsiptick then
      bals.sip = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_herb = function()
  bals.herb = false
  sk.herbtick = sk.herbtick + 1
  local oldherbtick = sk.herbtick

  tempTimer(5, function ()
    if not bals.herb and sk.herbtick == oldherbtick then
      bals.herb = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_steam = function()
  bals.steam = false
  sk.steamtick = sk.steamtick + 1
  local oldsteamtick = sk.steamtick

  tempTimer(5, function ()
    if not bals.steam and sk.steamtick == oldsteamtick then
      bals.steam = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_salve = function()
  bals.salve = false
  sk.salvetick = sk.salvetick + 1
  local oldsalvetick = sk.salvetick

  tempTimer(5, function ()
    if not bals.salve and sk.salvetick == oldsalvetick then
      bals.salve = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_purgative = function()
  bals.purgative = false
  sk.purgativetick = sk.purgativetick + 1
  local oldpurgativetick = sk.purgativetick

  tempTimer(5, function ()
    if not bals.purgative and sk.purgativetick == oldpurgativetick then
      bals.purgative = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_lucidity = function()
  bals.lucidity = false
  sk.luciditytick = sk.luciditytick + 1
  local oldluciditytick = sk.luciditytick

  tempTimer(5, function ()
    if not bals.lucidity and sk.luciditytick == oldluciditytick then
      bals.lucidity = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_wafer = function()
  bals.wafer = false
  sk.wafertick = sk.wafertick + 1
  local oldwafertick = sk.wafertick

  tempTimer(5, function ()
    if not bals.wafer and sk.wafertick == oldwafertick then
      bals.wafer = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_ice = function()
  bals.ice = false
  sk.icetick = sk.icetick + 1
  local oldicetick = sk.icetick

  tempTimer(5, function ()
    if not bals.ice and sk.icetick == oldicetick then
      bals.ice = true
      make_gnomes_work()
    end
  end)
end

sk.lostbal_tea = function()
  bals.tea = false
  sk.teatick = sk.teatick + 1
  local oldteatick = sk.teatick

  tempTimer(60, function () -- it's a 55s timer!
    if not bals.tea and sk.teatick == oldteatick then
      bals.tea = true
      make_gnomes_work()
    end
  end)
end

function sk.doingstuff_inslowmode()
  local result
  for balance,actions in pairs(bals_in_use) do
    if balance ~= "waitingfor" and balance ~= "gone" and balance ~= "aff" and next(actions) then result = select(2, next(actions)) break end
  end

  if result then return true end
end

--[[function sk.checkwillpower()
  if stats.currentwillpower <= 1000 and not sk.lowwillpower then
    sk.lowwillpower = true
    sk.warn("lowwillpower")

    can_usemana = function()
      return (stats.currentmana > sys.manause and stats.currentwillpower >=100) and true or false
    end

  -- amounts differ so we don't toggle often
  elseif stats.currentwillpower > 1500 and sk.lowwillpower then
    sk.lowwillpower = false

  end
end]]


can_usemana = function()
    return (stats.currentmana > sys.manause) and true or false
end

sk.limbnames = {
  rightarm = true,
  leftarm = true,
  leftleg = true,
  rightleg = true,
  chest = true,
  gut = true,
  head = true
}

#if skills.healing then
  sk.updatehealingmap = function ()
    sk.healingmap = {}
    sk.regenaffs, sk.cursesaffs, sk.sensesaffs = {}, {}, {}
    if not conf.healingskill then return end

    local healdata = pl.OrderedMap {
      {skin        = {"sunallergy", "pox", "scabies", "firstdegreeburn", "seconddegreeburn", "thirddegreeburn", "fourthdegreeburn"}},
      {temperature = {"ablaze", "frozen", "shivering"}},
      -- Healing cannot cure fracturedwindpipe, crushedrightfoot, crushedleftfoot apparently
      {fractures   = {"fracturedleftarm", "fracturedrightarm", "fracturedskull", "brokenjaw", "brokenrightwrist", "brokenleftwrist", "brokenchest", "brokennose", "snappedrib"}},
      {glandular   = {"slickness"}},
      {senses      = {"concussion", "sensitivity", "vertigo", "deaf", "blind"}},
      {neurosis    = {"impatience", "loneliness", "shyness", "anorexia", "void", "masochism"}},
      {breaks      = {"crippledrightarm", "crippledleftarm", "crippledleftleg", "crippledrightleg", "brokenjaw", "brokenrightwrist", "brokenleftwrist", "twistedleftarm", "twistedrightarm", "twistedrightleg", "twistedleftleg", "damagedleftarm", "damagedrightarm", "damagedleftleg", "damagedrightleg"}},
      {choleric    = {"vomiting", "vomitblood", "worms", "hypersomnia", "dysentery"}},
      {curses      = {"recklessness", "healthleech", "achromaticaura", "powerspikes", "manabarbs", "egovice", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"}},
      {muscles     = {"paralysis", "rigormortis", "weakness", "dislocatedleftarm ", "dislocatedrightarm", "dislocatedrightleg", "dislocatedleftleg", "gashedcheek", "slicedtongue", "puncturedchest", "missingrightear", "missingleftear", "slicedrightbicep", "slicedleftbicep", "slicedleftthigh", "slicedrightthigh", "openchest", "opengut", "stiffleftarm", "stiffrightarm", "stiffhead", "stiffgut", "stiffchest", "slitthroat"}},
      {sanguine    = {"haemophilia", "healthleech", "confusion", "furrowedbrow", "scalped"}},
      {blood       = {"arteryrightarm", "arteryleftarm", "arteryleftleg", "arteryrightleg", "haemophilia", "laceratedrightarm", "laceratedleftarm", "laceratedrightleg", "laceratedleftleg", "clotrighthip", "clotlefthip", "clotrightshoulder", "clotleftshoulder", "relapsing", "slicedforehead"}},
      {melancholic = {"puncturedlung", "asthma", "dizziness", "vapors", "sensitivity", "blacklung", "shortbreath", "trembling"}},
      {phobias     = {"agoraphobia", "claustrophobia", "vestiphobia", "hypochondria"}},
      {phlegmatic  = {"aeon", "powersink", "shyness", "weakness", "void"}},
      {nervous     = {"clumsiness", "epilepsy", "dizziness", "vapors", "hemiplegylower", "hemiplegyright", "hemiplegyleft", "piercedrightleg", "piercedleftleg", "piercedrightarm", "piercedleftarm", "narcolepsy", "hypersomnia", "daydreaming"}},
      {depression  = {"addiction", "gluttony"}},
      {auric       = {"aeon", "pacifism", "peace", "powersink", "justice", "jinx", "succumb"}},
      {mania       = {"confusion", "dementia", "hallucinating", "void", "paranoia", "stupidity", "scrambledbrain", "slightinsanity", "moderateinsanity",  "majorinsanity", "massiveinsanity"}},
      {regenerate  = {{burstorgans = "gut"}, {missingrightleg = "legs"}, {missingleftarm = "arms"}, {missingleftleg = "legs"}, {missingrightarm = "arms"}, {eyepeckleft = "head"}, {eyepeckright = "head"}, {mangledleftleg = "legs"}, {mangledleftarm = "arms"}, {mangledrightarm = "arms"}, {mangledrightleg = "legs"}, {crushedchest = "chest"}, {collapsedrightnerve = "arms"}, {collapsedlungs = "chest"}, {collapsedleftnerve = "arms"}, {crackedleftelbow = "arms"}, {crackedrightelbow = "arms"}, {crackedrightkneecap = "legs"}, {crackedleftkneecap = "legs"}, {disembowel = "gut"}, {chestpain = "chest"}, {rupturedstomach = "gut"}, {tendonright = "legs"}, {tendonleft = "legs"}, {concussion = "head"}, {damagedhead = "head"}, {shatteredleftankle = "legs"}, {shatteredrightankle = "legs"}, {shatteredjaw = "head"}, {mutilatedleftarm = "arms"}, {mutilatedrightarm = "arms"}, {mutilatedleftleg = "legs"}, {mutilatedrightleg = "legs"}}}
    }
    --[[ doesn't cure: leglock, throatlock, severedspine, puncturedaura ]]


    -- setup a map of afflictions that we can cure - key is aff, value is the proper aura cure as a string / table if it's a regen
    for aura, afft in healdata:iter() do
      for _, aff in pairs(afft) do
        if type(aff) == "string" then
          sk.healingmap[aff] = aura

          if aura == "curses" then
            sk.cursesaffs[aff] = true end
          if aura == "senses" then
            sk.sensesaffs[aff] = true end
        elseif type(aff) == "table" then
          sk.healingmap[next(aff)] = {aura = aura, side = select(2, next(aff))}

          if aura == "regenerate" then
            sk.regenaffs[next(aff)] = true end
        end
      end

      if aura == conf.healingskill then break end
    end

  end
  signals.healingskillchanged:connect(sk.updatehealingmap)
  signals.systemstart:connect(sk.updatehealingmap)
#end

signals.gmcpcharitemslist:connect(function ()
  if not gmcp.Char.Items.List.location then echof("(GMCP problem) location field is missing from Achaea's response.") return end
  if not sk.inring or gmcp.Char.Items.List.location ~= "inv" then return end

  local hadsomething = {}
  for _, t in pairs(gmcp.Char.Items.List.items) do
    if t.attrib and t.attrib:find("g", 1, true) then

      -- see if we can optimize groupables with 'inr all <type>', making it easier count as well: handle groups first
      if t.name and t.name:find("a group of", 1, true) then
        -- function to scan plurals table
        local check = function(value,input) return input:find("a group of "..value) end

        -- check herbs table
        local found_plural = next(pl.tablex.map(check, rift.herbs_plural, t.name or ""))
        -- check other riftable items table
        found_plural = found_plural or next(pl.tablex.map(check, rift.items_plural, t.name or ""))

        if found_plural and not hadsomething[found_plural] then
          send("inr all "..found_plural, false)
          hadsomething[found_plural] = true
        elseif not found_plural and not hadsomething[t.id] then
          send("inr "..t.id, false)
          hadsomething[t.id] = true
        end

      -- singular herb items that we know of
      elseif t.name and rift.herbs_singular[t.name] and not hadsomething[rift.herbs_singular[t.name]] then
        hadsomething[rift.herbs_singular[t.name]] = true
        send("inr all "..rift.herbs_singular[t.name], false)

      -- singular non-herb items
      elseif t.name and rift.items_singular[t.name] and not hadsomething[rift.items_singular[t.name]] then
        hadsomething[rift.items_singular[t.name]] = true
        send("inr all "..rift.items_singular[t.name], false)


      -- all the rest
      elseif not rift.items_singular[t.name] and not rift.herbs_singular[t.name] and not hadsomething[t.id] then
        send("inr "..t.id, true)
        hadsomething[t.id] = true
      end
    end

#if skills.runes then
    if t.name:find("a blank rune stone", 1, true) or t.name:find("an? %w+ rune") then
      hadsomething[t.id] = true
      send("inrb "..t.id, false)
    end
#end
  end

  sk.inring = nil
  if next(hadsomething) then
    echof("Stuffing everything away...")
  else
    echof("There's nothing to stuff away.")
  end
end)

function sk.showstatchanges()
  local t = sk.statchanges
  if #t > 0 then
    if conf.singleprompt then
      moveCursor(0, getLineNumber()-1)
      moveCursor(#getCurrentLine(), getLineNumber())
      dinsertText(' <192,192,192>('..table.concat(t, ", ")..'<192,192,192>) ')
    else
      decho('<192,192,192>('..table.concat(t, ", ")..'<192,192,192>) ')
    end

    resetFormat()
    if conf.singleprompt then moveCursorEnd() end
  end
end

signals.newroom:connect(function ()
  -- if not autoarena, then no need for this
  if not conf.autoarena then return end

  local t = sk.arena_areas

  local area = atcp.RoomArea or gmcp.Room.Info.area

  if t[area] and not conf.arena then
    conf.arena = true
    raiseEvent("m&m config changed", "arena")
    prompttrigger("arena echo", function()
      local echos = {"Arena mode enabled. Good luck!", "Beat 'em up! Arena mode enabled.", "Arena mode on.", "Arena mode enabled. Kill them all!"}
      itf(echos[math.random(#echos)]..'\n')
    end)
  elseif conf.arena and not t[area] then
    conf.arena = false
    raiseEvent("m&m config changed", "arena`")
    tempTimer(0, function()
      local echos = {"Arena mode disabled."}
      echof(echos[math.random(#echos)]..'\n')

    end)
  end
end)
