-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.


--[[
spriority: global async priority. In use when curing in sync mode.
aspriority: inter-balance sync priority. In use when curing in async mode.
isadvisable: determines if it is possible to cure this aff. some things that
  block bals might not block a single aff
]]

$(
function basicdef(which, command, balanceless)
  if type (command) == "string" then
    _put(string.format(which..[[ = {
      physical = {
        %s = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].]]..which..[[ and not defc.]]..which..[[) or (conf.keepup and defkeepup[defs.mode].]]..which..[[ and not defc.]]..which..[[)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone %s) or false
        end,

        oncompleted = function ()
          defences.got("]]..which..[[")
        end,

        onstart = function ()
          send("]]..command..[[", conf.commandecho)
        end
      }
    },]], balanceless and "balanceless_act" or "balanceful_act",
    balanceless and "and not doingaction('"..which.."')" or ""))
  else
    _put(string.format(which..[[ = {
      physical = {
        %s = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].]]..which..[[ and not defc.]]..which..[[) or (conf.keepup and defkeepup[defs.mode].]]..which..[[ and not defc.]]..which..[[)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone %s) or false
        end,

        oncompleted = function ()
          defences.got("]]..which..[[")
        end,

        onstart = function ()
          %s
        end
      }
    },]], balanceless and "balanceless_act" or "balanceful_act",
      balanceless and "and not doingaction('"..which.."')" or "",
      (function(command)
        local t = {}
        for _, cmd in ipairs(command) do
          t[#t+1] = "send('"..cmd.."', conf.commandecho)"
        end
        return table.concat(t, ";")
      end)(command)))
  end
end

function basicdef_withpower(which, command, powercost, balanceless)
  if type (command) == "string" then
    _put(string.format(which..[[ = {
      physical = {
        %s = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (stats.currentpower >= ]]..powercost..[[ and ((sys.deffing and defdefup[defs.mode].]]..which..[[ and not defc.]]..which..[[) or (conf.keepup and defkeepup[defs.mode].]]..which..[[ and not defc.]]..which..[[)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone %s) or false
        end,

        oncompleted = function ()
          defences.got("]]..which..[[")
        end,

        onstart = function ()
          send("]]..command..[[", conf.commandecho)
        end
      }
    },]], balanceless and "balanceless_act" or "balanceful_act",
    balanceless and "and not doingaction('"..which.."')" or ""))
  else
    _put(string.format(which..[[ = {
      physical = {
        %s = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (stats.currentpower >= ]]..powercost..[[ and ((sys.deffing and defdefup[defs.mode].]]..which..[[ and not defc.]]..which..[[) or (conf.keepup and defkeepup[defs.mode].]]..which..[[ and not defc.]]..which..[[)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone %s) or false
        end,

        oncompleted = function ()
          defences.got("]]..which..[[")
        end,

        onstart = function ()
          %s
        end
      }
    },]], balanceless and "balanceless_act" or "balanceful_act",
      balanceless and "and not doingaction('"..which.."')" or "",
      (function(command)
        local t = {}
        for _, cmd in ipairs(command) do
          t[#t+1] = "send('"..cmd.."', conf.commandecho)"
        end
        return table.concat(t, ";")
      end)(command)))
  end
end
)

local dict_balanceful = {}
local dict_balanceless = {}

local dict_cleanse = {}

-- defence shortlists
local dict_balanceful_def  = {}
local dict_balanceless_def = {}
local dict_herb            = {}
local dict_misc            = {}
local dict_misc_def        = {}
local dict_purgative       = {}
local dict_sparkleaffs     = {}
local dict_wafer           = {}
local dict_steam           = {}

local codepaste = {}


--?? find out which stack with each other
codepaste.writhe = function()
  return (
    not doingaction("curingtransfixed") and not doingaction("transfixed") and
    not doingaction("curingpinlegleft") and not doingaction("pinlegleft") and
    not doingaction("curingpinlegright") and not doingaction("pinlegright") and
    not doingaction("curingpinlegleft2") and not doingaction("pinlegleft2") and
    not doingaction("curingpinlegright2") and not doingaction("pinlegright2") and
    not doingaction("curingclampedleft") and not doingaction("clampedleft") and
    not doingaction("curingclampedright") and not doingaction("clampedright") and
    not doingaction("curinghoisted") and not doingaction("hoisted") and
    not doingaction("curingroped") and not doingaction("roped") and
    not doingaction("curingshackled") and not doingaction("shackled") and
    not doingaction("curinggrapple") and not doingaction("grapple") and
    not doingaction("curingtruss") and not doingaction("truss") and
    not doingaction("curingthornlashedleftarm") and not doingaction("thornlashedleftarm") and
    not doingaction("curingthornlashedleftleg") and not doingaction("thornlashedleftleg") and
    not doingaction("curingthornlashedrightarm") and not doingaction("thornlashedrightarm") and
    not doingaction("curingthornlashedrightleg") and not doingaction("thornlashedrightleg") and
    not doingaction("curingthornlashedhead") and not doingaction("thornlashedhead") and
    not doingaction("curingcrucified") and not doingaction("crucified") and
    not doingaction("curingimpale") and not doingaction("impale") and
    not doingaction("curinggore") and not doingaction("gore") and
    not doingaction("curingpinlegunknown") and not doingaction("pinlegunknown") and
    not doingaction("curingtangle") and not doingaction("tangle")
    and not doingaction ("magicwrithe"))
end

codepaste.basicpinwrithe = function()
  return (
    not doingaction("curingtransfixed") and not doingaction("transfixed") and
    not doingaction("curingclampedleft") and not doingaction("clampedleft") and
    not doingaction("curingclampedright") and not doingaction("clampedright") and
    not doingaction("curinghoisted") and not doingaction("hoisted") and
    not doingaction("curingroped") and not doingaction("roped") and
    not doingaction("curingshackled") and not doingaction("shackled") and
    not doingaction("curinggrapple") and not doingaction("grapple") and
    not doingaction("curingtruss") and not doingaction("truss") and
    not doingaction("curingthornlashedleftarm") and not doingaction("thornlashedleftarm") and
    not doingaction("curingthornlashedleftleg") and not doingaction("thornlashedleftleg") and
    not doingaction("curingthornlashedrightarm") and not doingaction("thornlashedrightarm") and
    not doingaction("curingthornlashedrightleg") and not doingaction("thornlashedrightleg") and
    not doingaction("curingthornlashedhead") and not doingaction("thornlashedhead") and
    not doingaction("curingcrucified") and not doingaction("crucified") and
    not doingaction("curingimpale") and not doingaction("impale") and
    not doingaction("curinggore") and not doingaction("gore") and
    not doingaction("curingpinlegunknown") and not doingaction("pinlegunknown") and
    not doingaction("curingtangle") and not doingaction("tangle")
    and not doingaction ("magicwrithe"))
end

codepaste.regen_legs = function()
  return (not doingaction("curingmangledleftleg") and
    not doingaction("curingmangledrightleg") and
    not doingaction("curingmissingleftleg") and
    not doingaction("curingmissingrightleg") and
    not doingaction("curingshatteredrightankle") and
    not doingaction("curingshatteredleftankle") and
    not doingaction("curingtendonright") and
    not doingaction("curingtendonleft") and
    not doingaction("curingtendonunknown") and
    not doingaction("curingcrackedleftkneecap") and
    not doingaction("curingcrackedrightkneecap") and
    not doingaction("curingcrackedunknownkneecap") and
    not doingaction("curingparegenlegs"))
end

codepaste.regen_arms = function()
  return (not doingaction("curingmangledleftarm") and
    not doingaction("curingmangledrightarm") and
    not doingaction("curingmissingleftarm") and
    not doingaction("curingmissingrightarm") and
    not doingaction("curingcollapsedleftnerve") and
    not doingaction("curingcollapsedrightnerve") and
    not doingaction("curingcrackedleftelbow") and
    not doingaction("curingcrackedrightelbow"))
end

codepaste.regen_gut = function()
  return (not doingaction("curingrupturedstomach") and
    not doingaction("curingdisembowel") and
    not doingaction("curingseveredspine") and
    not doingaction("curingburstorgans"))
end

codepaste.regen_chest = function()
  return (not doingaction("curingchestpain") and
    not doingaction("curingcollapsedlungs") and
    not doingaction("curingcrushedchest") and
    not doingaction("curingparegenchest"))
end

codepaste.regen_head = function()
  return (not doingaction("curingdamagedhead") and
    not doingaction("curingeyepeckleft") and
    not doingaction("curingeyepeckright") and
    not doingaction("curingshatteredjaw") and
    not doingaction("curingconcussion"))
end

codepaste.ice_head = function()
  return (not doingaction("curingdamagedskull") and not doingaction("curingdamagedthroat"))
end

codepaste.ice_chest = function()
  return (not doingaction("curingcollapsedlungs") and not doingaction("curingcrushedchest"))
end

codepaste.ice_gut = function()
  return (not doingaction("curingdamagedorgans") and not doingaction("curinginternalbleeding"))
end

codepaste.ice_leftarm = function()
  return (not doingaction("curingdamagedleftarm") and not doingaction("curingmutilatedleftarm"))
end

codepaste.ice_rightarm = function()
  return (not doingaction("curingdamagedrightarm") and not doingaction("curingmutilatedrightarm"))
end

codepaste.ice_leftleg = function()
  return (not doingaction("curingdamagedleftleg") and not doingaction("curingmutilatedleftleg"))
end

codepaste.ice_rightleg = function()
  return (not doingaction("curingdamagedrightleg") and not doingaction("curingmutilatedrightleg"))
end

codepaste.can_refill = function()
  return not ((affs.hemiplegyright and affs.hemiplegyleft) or affs.paralysis)
end

#for _, item in ipairs{"faeleaf", "myrtle", "coltsfoot", "steam"} do
codepaste.smoke_$(item)_pipe = function()
  if pipes.$(item).id == 0 then sk.warn "no$(item)id" end
  if not (pipes.$(item).lit or pipes.$(item).arty) then
    sk.forcelight_$(item) = true
  end

  -- can't smoke non-arty pipes underwater
  if (gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.environment == "deep ocean") and not pipes.$(item).arty then
    return false
  end

  return (not (pipes.$(item).id == 0) and
    (pipes.$(item).lit or pipes.$(item).arty) and
    not (pipes.$(item).puffs == 0))
end

#end

codepaste.balanceful_defs_codepaste = function()
  if not (bals.balance and bals.equilibrium and bals.leftarm and bals.rightarm) then return true end
  if affs.prone then return true end

  for k,v in pairs(dict_balanceful_def) do
    if doingaction(k) then return true end
  end
end

codepaste.cleanse_codepaste = function()
  for k,v in pairs(dict_cleanse) do
    if doingaction(k) then return true end
  end
end

codepaste.tempwarps = function()
  return (not affs.minortimewarp and not affs.slightinsanity
    and not affs.moderatetimewarp and not affs.moderateinsanity
    and not affs.majortimewarp and not affs.majorinsanity
    and not affs.massivetimewarp and not affs.massiveinsanity)
end

codepaste.havetempwarps = function()
  return (affs.minortimewarp or affs.slightinsanity
    or affs.moderatetimewarp or affs.moderateinsanity
    or affs.majortimewarp or affs.majorinsanity
    or affs.massivetimewarp or affs.massiveinsanity)
end

codepaste.dowrithe = function(specific)
#if skills.acrobatics then
  if conf.contort then send("contort", conf.commandecho)
  elseif conf.slip then send("slip", conf.commandecho)
  else send(string.format("writhe%s%s", not specific and '' or ' ', not specific and '' or specific), conf.commandecho) end
#else
  if conf.slip then send("slip", conf.commandecho)
  else send(string.format("writhe%s%s", not specific and '' or ' ', not specific and '' or specific), conf.commandecho) end
#end
end

codepaste.wonderitems = function(which)
  if conf.wonderall then
    return (not doingaction("wondercornbal") and not doingaction("wondercorneq") and not doingaction("wondercornhp") and not doingaction("wondercornmp") and not doingaction("wondercornego") and not doingaction("wondercorndam") and not doingaction("wondercornres"))
  else
    return (not doingaction(which))
  end
end

codepaste.geniedefs = function(which)
  if conf.geniesall then
    return (not doingaction("redgenies") and not doingaction("bluegenies") and not doingaction("yellowgenies"))
  else
    return (not doingaction(which))
  end
end

codepaste.vessels_codepaste = function()
  return (not doingaction "onevessel" and not doingaction "twovessels" and not doingaction "threevessels" and not doingaction "fourvessels" and not doingaction "fivevessels" and not doingaction "sixvessels" and not doingaction "sevenvessels" and not doingaction "eightvessels" and not doingaction "ninevessels" and not doingaction "tenvessels" and not doingaction "elevenvessels" and not doingaction "twelvevessels" and not doingaction"thirteenplusvessels" and not actions.healhealth_herb and not actions.healmana_herb)
end

codepaste.remove_vessels = function()
  removeaff({"onevessel", "twovessels", "threevessels", "fourvessels", "fivevessels",  "sixvessels", "sevenvessels", "eightvessels", "ninevessels", "tenvessels",  "elevenvessels", "twelvevessels", "thirteenplusvessels"})
end

codepaste.remove_deathmarks = function()
  removeaff({"deathmarkone", "deathmarktwo", "deathmarkthree", "deathmarkfour", "deathmarkfive"})
end

codepaste.remove_insanities = function()
  removeaff({"slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity"})
end

codepaste.remove_allergies = function()
  removeaff({"mildallergy", "strongallergy", "severeallergy", "incapacitatingallergy"})
end

codepaste.remove_timewarps = function ()
  removeaff({"minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"})
end

codepaste.remove_aurawarps = function ()
  removeaff({"completelyaurawarped","massivelyaurawarped","aurawarped","moderatelyaurawarped","slightlyaurawarped"})
end

codepaste.remove_burns = function()
  removeaff({"firstdegreeburn", "seconddegreeburn", "thirddegreeburn", "fourthdegreeburn"})
end

codepaste.maestoso_ruined = function()
  sk.lostbal_herb()
  if not affs.maestoso then addaff (dict.maestoso) end
end

codepaste.darkfate_ruined = function()
  if not affs.darkfate then addaff (dict.darkfate) end
end

codepaste.insane_ruined = function()
  sk.lostbal_focus()
end

codepaste.reckstats = function()
  return stats.currenthealth == stats.maxhealth and stats.currentmana == stats.maxmana and stats.currentego == stats.maxego and stats.currentpower == stats.maxpower
end

local wlevel = phpTable(
  {light    = 1},
  {medium   = 423},
  {heavy    = 1267},
  {critical = 3600}
)

local ice_wlevel = phpTable(
  {light = 1},
  {heavy = 35},
  {critical = 75}
)

function sk.get_wound_level(amount)
  local name
    if not conf.oldwarrior then
      for j, k in ice_wlevel:pairs() do
        if amount < k then break end
        name = j
      end
    else
      for j,k in wlevel:pairs() do
        if amount < k then break end
        name = j
      end
    end

  return name or "light"
end

local completely_healed = {}
for _,k in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
  completely_healed[k] = function ()
    dict["light" .. k].count, dict["medium" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = 0, 0, 0, 0
    removeaff{"light"..k, "medium"..k, "heavy"..k, "critical"..k, "numbed"..k}
  end
end

local function update_wound_count(k, amount)
    if not conf.oldwarrior then
      dict["light" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = amount, amount, amount
      removeaff{"light"..k, "heavy"..k, "critical"..k}
    else
      dict["light" .. k].count, dict["medium" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = amount, amount, amount, amount
      removeaff{"light"..k, "medium"..k, "heavy"..k, "critical"..k}
    end
end

local partially_healed = {}
for _,k in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
  partially_healed[k] = function (type)
    local amount

    if not conf.oldwarrior then
      amount = 4
    elseif type == 'deepheal' then amount = math.random(1600, 2000)
    elseif type == 'puer' then amount = math.random(800, 1000)
    elseif type == 'healspring' then amount = math.random(200, 300)
    else amount = math.random(800, 900) end

    if (dict["light"..k].count - amount) < 0 then amount = 0 else amount = dict["light"..k].count - amount end

    if not conf.oldwarrior then
      dict["light" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = amount, amount, amount
      removeaff{"light"..k, "heavy"..k, "critical"..k}
    else
      dict["light" .. k].count, dict["medium" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = amount, amount, amount, amount
      removeaff{"light"..k, "medium"..k, "heavy"..k, "critical"..k}
    end

    addaff(dict[sk.get_wound_level(amount)..k])
  end
end

function focus_aff(aff, cmd)

  local t = {taintsick = "sickening", illuminated = "luminosity", hallucinating = "hallucinations"}
  local c_aff = (t[aff] or aff)

  if (sys.sync and conf.aeonfocus) or me.focus[aff] then
    if conf.beastfocus and bals.beast and not affs.disloyalty then
      if cmd == "dust" then
        eat("dust", "beastfocus", c_aff)
      else
        send(cmd.." beastfocus "..c_aff, conf.commandecho)
      end
    elseif conf.powerfocus and stats.currentpower >= 1 then
      if cmd == "dust" then
        eat("dust", "powerfocus",c_aff)
      else
        send(cmd.." powerfocus "..c_aff, conf.commandecho)
      end
    else
      if cmd == "dust" then
        eat("dust", "focus",c_aff)
      else
        send(cmd.." focus "..c_aff, conf.commandecho)
      end
    end
    return
  end

  if not me.focus[aff] then
    if cmd == "dust" then
      eat("dust")
    else
      send(cmd, conf.commandecho)
    end
    return
  end
end


--[[ dict is to NEVER be iterated over fully; so isadvisable functions can
      typically expect not to check for the common things because pre-
      filtering is done.
  ]]

dict = {
  healhealth = {
    sip = {
      name = false, --"healhealth_sip",
      balance = false, --"sip",
      action_name = false, --"healhealth"
      aspriority = 30,
      spriority = 217,

      isadvisable = function ()
        return ((stats.currenthealth < sys.siphealth) and not doingaction ("healhealth"))
      end,

      oncompleted = function ()
        sk.lostbal_sip()
      end,

      all = function()
        sk.lostbal_sip()
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    scroll = {
      aspriority = 3,
      spriority = 34,

      isadvisable = function ()
        return ((stats.currenthealth < sys.scrollhealth) and (not doingaction ("healhealth") or (stats.currenthealth < (sys.scrollhealth-600))))
      end,

      oncompleted = function ()
        bals.scroll = false
      end,

      noeffect = function()
        bals.scroll = false
      end,

      onstart = function ()
        if not conf.magictome then
          send("read " .. (conf.scrollid == 0 and 'healing' or conf.scrollid), conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge " .. (conf.scrollid == 0 and 'healing' or conf.scrollid) .. " from cube", conf.commandecho) end
        else
          send("read magictome healing", conf.commandecho) end
      end
    },
    sparkle = {
      aspriority = 3,
      spriority = 292,

      isadvisable = function ()
        return ((stats.currenthealth < sys.sparklehealth) and
          (
            not doingaction ("healhealth") or
            (stats.currenthealth < (sys.sparklehealth-600) and not actions.healhealth_herb)
          )
        ) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        local vessel = previous_vessel()
        if vessel then
          removeaff(vessel)
        end
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    herb = {
      aspriority = 147,
      spriority = 320,

      isadvisable = function ()
        return ((stats.currenthealth < sys.sparklehealth) and
          (
            not doingaction ("healhealth") or
            (stats.currenthealth < (sys.sparklehealth-600) and not actions.healhealth_sparkle)
          )
        ) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        sk.lostbal_herb()
        local vessel = previous_vessel()
        if vessel then
          removeaff(vessel)
        end
      end,

      sour = function()
        bals.sparkle = false
        sk.lostbal_herb()
      end,

      eatcure = conf.sparkleherb,
      onstart = function ()
        eat(conf.sparkleherb)
      end,

      empty = function()
        empty["eat_"..conf.sparkleherb]()
      end
    },
  },
  healmana = {
    sip = {
      aspriority = 2,
      spriority = 9,

      isadvisable = function ()
        return ((stats.currentmana < sys.sipmana) and not doingaction ("healmana")) or false
      end,

      oncompleted = function ()
        sk.lostbal_sip()
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "mana",

      onstart = function ()
        send("sip mana", conf.commandecho)
      end
    },
    scroll = {
      aspriority = 2,
      spriority = 291,

      isadvisable = function ()
        return ((stats.currentmana < sys.scrollmana) and (not doingaction ("healmana") or (stats.currentmana < (sys.scrollmana-600)))) or false
      end,

      oncompleted = function ()
        bals.scroll = false
      end,

      noeffect = function()
        bals.scroll = false
      end,

      onstart = function ()
        if not conf.magictome then
          send("read ".. (conf.scrollid == 0 and 'healing' or conf.scrollid), conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge " .. (conf.scrollid == 0 and 'healing' or conf.scrollid) .. " from cube", conf.commandecho) end
        else
          send("read magictome healing", conf.commandecho) end
      end
    },
    sparkle = {
      aspriority = 2,
      spriority = 308,

      isadvisable = function ()
        return ((stats.currentmana < sys.sparklemana) and (not doingaction ("healmana") or (stats.currentmana < (sys.sparklemana-600)))) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        local vessel = previous_vessel()
        if vessel then
          removeaff(vessel)
        end
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return ((stats.currentmana < sys.sparklemana) and (not doingaction ("healmana") or (stats.currentmana < (sys.sparklemana-600)))) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        sk.lostbal_herb()
      end,

      sour = function()
        bals.sparkle = false
        sk.lostbal_herb()
      end,

      eatcure = conf.sparkleherb,
      onstart = function ()
        eat(conf.sparkleherb)
      end,

      empty = function()
        empty["eat_"..conf.sparkleherb]()
      end
    },
  },
  healego = {
    sip = {
      aspriority = 1,
      spriority = 7,

      isadvisable = function ()
        return (stats.currentego < sys.sipego and not doingaction ("healego")) or false
      end,

      oncompleted = function ()
        sk.lostbal_sip()
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "bromide",

      onstart = function ()
        send("sip bromide", conf.commandecho)
      end
    },
    scroll = {
      aspriority = 1,
      spriority = 290,

      isadvisable = function ()
        return (stats.currentego < sys.scrollego and (not doingaction ("healego") or (stats.currentego < (sys.scrollego-600)))) or false
      end,

      oncompleted = function ()
        bals.scroll = false
      end,

      noeffect = function()
        bals.scroll = false
      end,

      onstart = function ()
        if not conf.magictome then
          send("read " .. (conf.scrollid == 0 and 'healing' or conf.scrollid), conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge " .. (conf.scrollid == 0 and 'healing' or conf.scrollid) .. " from cube", conf.commandecho) end
        else
          send("read magictome healing", conf.commandecho) end
      end
    },
    sparkle = {
      aspriority = 1,
      spriority = 311,

      isadvisable = function ()
        return (stats.currentego < sys.sparkleego and (not doingaction ("healego") or (stats.currentego < (sys.sparkleego-600)))) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        local vessel = previous_vessel()
        if vessel then
          removeaff(vessel)
        end
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return ((stats.currentego < sys.sparkleego) and (not doingaction ("healego") or (stats.currentego < (sys.sparkleego-600)))) or false
      end,

      oncompleted = function ()
        bals.sparkle = false
        sk.lostbal_herb()
      end,

      sour = function()
        bals.sparkle = false
        sk.lostbal_herb()
      end,

      eatcure = conf.sparkleherb,
      onstart = function ()
        eat(conf.sparkleherb)
      end,

      empty = function()
        empty["eat_"..conf.sparkleherb]()
      end
    },
  },
-- #if skills.stag then
#if false then
  medicinebag = {
    sip = {
      -- set the priority to be above healhealth by default
      aspriority = function()
        debugf("current healhealth sip prio: "..tostring(dict.healhealth.sip.aspriority))
        debugf("returning: "..tostring(dict.healhealth.sip.aspriority+1))
        return dict.healhealth.sip.aspriority + 1
      end,
      spriority  = function() return dict.healhealth.sip.spriority  + 1 end,

      isadvisable = function ()
        return ((stats.currenthealth < sys.siphealth) and not doingaction ("healhealth"))
      end,

      oncompleted = function ()
        sk.lostbal_sip()
      end,

      all = function()
        sk.lostbal_sip()
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "medicinebag",

      onstart = function ()
        send("touch medicinebag", conf.commandecho)
      end
    }
  },
#end
  thirteenplusvessels = {
    count = 0,
    sip = {
      aspriority = 16,
      spriority = 187,

      isadvisable = function ()
        return (affs.thirteenplusvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        if affs.thirteenplusvessels and affs.thirteenplusvessels.p.count > 0 then
          affs.thirteenplusvessels.p.count = affs.thirteenplusvessels.p.count - 1
        else
          removeaff("thirteenplusvessels")
          addaff(dict.twelvevessels)
        end
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.thirteenplusvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        if affs.thirteenplusvessels.p.count > 0 then
          affs.thirteenplusvessels.p.count = affs.thirteenplusvessels.p.count - 1
        else
          removeaff("thirteenplusvessels")
          addaff(dict.twelvevessels)
        end
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        local count = dict.thirteenplusvessels.count
        codepaste.remove_vessels()
        addaff(dict.thirteenplusvessels)

        if count then affs.thirteenplusvessels.p.count = count end
        updateaffcount(dict.thirteenplusvessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thirteenplusvessels")
        dict.thirteenplusvessels.count = 0
      end
    }
  },
  twelvevessels = {
    sip = {
      aspriority = 15,
      spriority = 186,

      isadvisable = function ()
        return (affs.twelvevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("twelvevessels")
        addaff(dict.elevenvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.twelvevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("twelvevessels")
        addaff(dict.elevenvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.twelvevessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("twelvevessels")
      end
    }
  },
  elevenvessels = {
    sip = {
      aspriority = 14,
      spriority = 185,

      isadvisable = function ()
        return (affs.elevenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("elevenvessels")
        addaff(dict.tenvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.tenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("elevenvessels")
        addaff(dict.tenvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.elevenvessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("elevenvessels")
      end
    }
  },
  tenvessels = {
    sip = {
      aspriority = 13,
      spriority = 184,

      isadvisable = function ()
        return (affs.tenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("tenvessels")
        addaff(dict.ninevessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.tenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("tenvessels")
        addaff(dict.ninevessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.tenvessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("tenvessels")
      end
    }
  },
  ninevessels = {
    sip = {
      aspriority = 12,
      spriority = 183,

      isadvisable = function ()
        return (affs.ninevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("ninevessels")
        addaff(dict.eightvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.ninevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("ninevessels")
        addaff(dict.eightvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.ninevessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("ninevessels")
      end
    }
  },
  eightvessels = {
    sip = {
      aspriority = 11,
      spriority = 182,

      isadvisable = function ()
        return (affs.eightvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("eightvessels")
        addaff(dict.sevenvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.eightvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("eightvessels")
        addaff(dict.sevenvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.eightvessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("eightvessels")
      end
    }
  },
  sevenvessels = {
    sip = {
      aspriority = 10,
      spriority = 181,

      isadvisable = function ()
        return (affs.sevenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("sevenvessels")
        addaff(dict.sixvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.sevenvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("sevenvessels")
        addaff(dict.sixvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.sevenvessels)
        sk.warn("manyvessels")
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sevenvessels")
      end
    }
  },
  sixvessels = {
    sip = {
      aspriority = 9,
      spriority = 180,

      isadvisable = function ()
        return (affs.sixvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("sixvessels")
        addaff(dict.fivevessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.sixvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("sixvessels")
        addaff(dict.fivevessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.sixvessels)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sixvessels")
      end
    }
  },
  fivevessels = {
    sip = {
      aspriority = 8,
      spriority = 179,

      isadvisable = function ()
        return (affs.fivevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("fivevessels")
        addaff(dict.fourvessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.fivevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("fivevessels")
        addaff(dict.fourvessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.fivevessels)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fivevessels")
      end
    }
  },
  fourvessels = {
    sip = {
      aspriority = 7,
      spriority = 178,

      isadvisable = function ()
        return (affs.fourvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("fourvessels")
        addaff(dict.threevessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.fourvessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("fourvessels")
        addaff(dict.threevessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.fourvessels)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fourvessels")
      end
    }
  },
  threevessels = {
    sip = {
      aspriority = 6,
      spriority = 177,

      isadvisable = function ()
        return (affs.threevessels and codepaste.vessels_codepaste()) or false
      end,


      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("threevessels")
        addaff(dict.twovessels)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.threevessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("threevessels")
        addaff(dict.twovessels)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.threevessels)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("threevessels")
      end
    }
  },
  twovessels = {
    sip = {
      aspriority = 5,
      spriority = 176,

      isadvisable = function ()
        return (affs.twovessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()
        removeaff("twovessels")
        addaff(dict.onevessel)
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.twovessels and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false
        removeaff("twovessels")
        addaff(dict.onevessel)
      end,

      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.twovessels)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("twovessels")
      end
    }
  },
  onevessel = {
    sip = {
      aspriority = 4,
      spriority = 174,

      isadvisable = function ()
        return (affs.onevessel and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        sk.lostbal_sip()
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        sk.lostbal_sip()

        -- we should see 'all' for this one. If we didn't - then we still have some.
        -- removeaff("onevessel")
      end,

      noeffect = function()
        sk.lostbal_sip()
      end,

      sipcure = "health",

      onstart = function ()
        if conf.medicinebag and me.activeskills.stag then
          send("touch medicinebag", conf.commandecho)
        else
          send("sip health", conf.commandecho)
        end
      end
    },
    sparkle = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.onevessel and codepaste.vessels_codepaste()) or false
      end,

      all = function()
        bals.sparkle = false
        codepaste.remove_vessels()
      end,

      oncompleted = function ()
        bals.sparkle = false

        -- we should see 'all' for this one. If we didn't - then we still have some.
        -- removeaff("onevessel")
      end,


      sour = function()
        bals.sparkle = false
      end,

      onstart = function ()
        eat("sparkleberry")
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_vessels()
        addaff(dict.onevessel)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("onevessel")
      end
    }
  },
  powersink = {
    purgative = {
      aspriority = 14,
      spriority = 152,

      isadvisable = function ()
        return (affs.powersink) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("powersink")
      end,

      empty = function()
        sk.lostbal_purgative()
        empty.sip_phlegmatic()
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "phlegmatic",

      onstart = function ()
        send("sip phlegmatic", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.powersink)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("powersink")
      end,
    }
  },
  aeon = {
    purgative = {
      aspriority = 50,
      spriority = 350,

      isadvisable = function ()
        return (affs.aeon and not doingaction("aeon")) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("aeon")
      end,

      empty = function()
        sk.lostbal_purgative()
        empty.sip_phlegmatic()
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "phlegmatic",
      onstart = function ()
        send("sip phlegmatic", conf.commandecho)
      end
    },
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.aeon and not doingaction("aeon")) or false
      end,

      oncompleted = function ()
        removeaff("aeon")
        sk.lostbal_herb()
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.aeon and codepaste.smoke_steam_pipe() and not doingaction("aeon")) or false
      end,

      oncompleted = function ()
        removeaff("aeon")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    physical = {
      balanceful_act = true,
      aspriority = 38,
      spriority = 324,

      isadvisable = function ()
        return (affs.aeon and not affs.paralysis and not affs.severedspine and not doingaction("aeon") and mm.bals.balance and mm.bals.equilibrium and mm.me.activeskills.athletics) or false
      end,

      onstart = function ()
        send("adrenaline", conf.commandecho)
      end,

      oncompleted = function ()
        removeaff("aeon")
      end,

      already = function ()
        removeaff("aeon")
        defences.got("speed")
      end,

      quicksilver = function()
        removeaff("aeon")
        dict.quicksilver.misc.oncompleted()
      end,

    },
    aff = {
      oncompleted = function ()
        addaff(dict.aeon)
        defences.lost("quicksilver")
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        signals.aeony:emit()
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("aeon")
      end,
    },
    onremoved = function ()
      if affsp.aeon then
        affsp.aeon = nil end
      signals.aeony:emit()
    end,
  },
  crotamine = {
    purgative = {
      aspriority = 29,
      spriority = 64,

      isadvisable = function ()
        return (affs.crotamine) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("crotamine")
      end,

      sipcure = "antidote",
      onstart = function ()
        send("sip antidote", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        empty.sip_antidote()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crotamine)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("crotamine")
      end
    }
  },
  furrowedbrow = {
    purgative = {
      aspriority = 9,
      spriority = 198,

      isadvisable = function ()
        return (affs.furrowedbrow) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("furrowedbrow")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "sanguine",
      onstart = function ()
        send("sip sanguine", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("furrowedbrow")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.furrowedbrow)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("furrowedbrow")
      end
    }
  },
  healthleech = {
    purgative = {
      aspriority = 28,
      spriority = 62,

      isadvisable = function ()
        return (affs.healthleech and not doingaction ("healthleech")) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("healthleech")
      end,

      sipcure = "sanguine",
      onstart = function ()
        send("sip sanguine", conf.commandecho)
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("healthleech")
      end
    },
    herb = {
      aspriority = 40,
      spriority = 40,

      isadvisable = function ()
        return (affs.healthleech and not doingaction ("healthleech") and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("healthleech")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")

        if not conf.healthleech then return end
        enableTrigger("m&m healthleech")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.healthleech and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("healthleech")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("healthleech", "smoke "..pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.healthleech)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("healthleech")
      end
    }
  },
  powersap = {
    purgative = {
      aspriority = 27,
      spriority = 61,

      isadvisable = function ()
        return (affs.powersap) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("powersap")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "antidote",
      onstart = function ()
        send("sip antidote", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        empty.sip_antidote()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.powersap and not doingaction "powersap") or false
      end,

      oncompleted = function ()
        removeaff("powersap")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("powersap", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.powersap)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("powersap")
      end
    }
  },
  hypersomnia = {
    purgative = {
      aspriority = 32,
      spriority = 313,

      isadvisable = function ()
        return (affs.hypersomnia) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("hypersomnia")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("hypersomnia")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hypersomnia)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("hypersomnia")
      end
    }
  },
  lovepotion = {
    purgative = {
      aspriority = 7,
      spriority = 275,

      isadvisable = function ()
        return (affs.lovepotion and not (defdefup[defs.mode].lovedef or defkeepup[defs.mode].lovedef) and not usingbal "purgative") or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("lovepotion")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("lovepotion")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.lovepotion)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lovepotion")
      end
    }
  },
  vomitblood = {
    purgative = {
      aspriority = 21,
      spriority = 51,

      isadvisable = function ()
        return (affs.vomitblood) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("vomitblood")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
    removeaff("vomitblood")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vomitblood)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("vomitblood")
      end
    }
  },
  shivering = {
    purgative = {
      aspriority = 12,
      spriority = 169,

      isadvisable = function ()
        return (affs.shivering) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("shivering")
        defences.lost("fire")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "fire",
      onstart = function ()
        send("sip fire", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("shivering")
        removeaff("frozen")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shivering)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shivering")
      end,
    }
  },
  frozen = {
    purgative = {
      aspriority = 13,
      spriority = 168,

      isadvisable = function ()
        return (affs.frozen) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("frozen")
        addaff(dict.shivering)
        defences.lost("fire")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "fire",
      onstart = function ()
        send("sip fire", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("frozen")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.frozen)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("frozen")
      end
    }
  },
  disloyalty = {
    purgative = {
      aspriority = 18,
      spriority = 127,

      isadvisable = function ()
        return (affs.disloyalty) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("disloyalty")
      end,

      sipcure = "love",
      onstart = function ()
        send("sip love", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("disloyalty")
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.disloyalty and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("disloyalty")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("disloyalty", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.disloyalty)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("disloyalty")
      end
    }
  },
  worms = {
    purgative = {
      aspriority = 23,
      spriority = 23,

      isadvisable = function ()
        return (affs.worms) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("worms")
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("worms")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.worms)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("worms")
      end,
    }
  },
  dysentery = {
    purgative = {
      aspriority = 20,
      spriority = 82,

      isadvisable = function ()
        return (affs.dysentery) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("dysentery")
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("dysentery")
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.dysentery and not doingaction "dysentery") or false
      end,

      oncompleted = function ()
        removeaff("dysentery")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("dysentery", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dysentery)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("dysentery")
      end
    }
  },
  vomiting = {
    purgative = {
      aspriority = 26,
      spriority = 59,

      isadvisable = function ()
        return (affs.vomiting) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("vomiting")
      end,

      sipcure = "choleric",
      onstart = function ()
        send("sip choleric", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("vomiting")
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.vomiting and not doingaction "vomiting") or false
      end,

      oncompleted = function ()
        removeaff("vomiting")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("vomiting", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vomiting)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("vomiting")
      end
    }
  },
  scalped = {
    purgative = {
      aspriority = 19,
      spriority = 90,

      isadvisable = function ()
        return (affs.scalped) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("scalped")
        addaff(dict.slicedforehead)
      end,

      sipcure = "sanguine",
      onstart = function ()
        send("sip sanguine", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("scalped")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.scalped)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("scalped")
      end
    }
  },
  haemophilia = {
    purgative = {
      aspriority = 25,
      spriority = 58,

      isadvisable = function ()
        return (affs.haemophilia and not doingaction "haemophilia") or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("haemophilia")
      end,

      sipcure = "sanguine",
      onstart = function ()
        send("sip sanguine", conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("haemophilia")
      end
    },
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.haemophilia and not doingaction "haemophilia") or false
      end,

      oncompleted = function ()
        removeaff("haemophilia")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.haemophilia and not doingaction "haemophilia") or false
      end,

      oncompleted = function ()
        removeaff("haemophilia")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("haemophilia", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.haemophilia)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("haemophilia")
      end,
    }
  },
  ablaze = {
    purgative = {
      aspriority = 22,
      spriority = 57,

      isadvisable = function ()
        return (not conf.arena and affs.ablaze) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("ablaze")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "frost",

      onstart = function ()
        send("sip frost", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("ablaze")
      end
    },
    ice = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (conf.arena and affs.ablaze) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()
        removeaff("ablaze")
      end,

      noeffect = function()
        removeaff("ablaze")
        sk.lostbal_ice()
      end,

      nouse = function()
        sk.lostbal_ice()
      end,

      onstart = function ()
        send("apply ice to body", conf.commandecho)
      end,
    },
    aff = {
      oncompleted = function ()
        addaff(dict.ablaze)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("ablaze")
      end
    }
  },
  narcolepsy = {
    herb = {
      aspriority = 146,
      spriority = 316,

      isadvisable = function ()
        return (affs.narcolepsy) or false
      end,

      oncompleted = function ()
        removeaff("narcolepsy")
        sk.lostbal_herb()
      end,

      eatcure = "kafe",
      onstart = function ()
        eat("kafe")
      end,

      empty = function()
        empty.eat_kafe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.narcolepsy)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("narcolepsy")
      end,
    }
  },
  daydreaming = {
    herb = {
      aspriority = 145,
      spriority = 315,

      isadvisable = function ()
        return (affs.daydreaming) or false
      end,

      oncompleted = function ()
        removeaff("daydreaming")
        sk.lostbal_herb()
      end,

      eatcure = "kafe",
      onstart = function ()
        eat("kafe")
      end,

      empty = function()
        empty.eat_kafe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.daydreaming)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("daydreaming")
      end,
    }
  },
  weakness = {
    herb = {
      aspriority = 1,
      spriority = 201,

      isadvisable = function ()
        return (affs.weakness and
          not doingaction("weakness")) or false
      end,

      oncompleted = function ()
        removeaff("weakness")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    purgative = {
      aspriority = 24,
      spriority = 24,

      isadvisable = function ()
        return (affs.weakness and
          not doingaction("weakness")) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("weakness")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "phlegmatic",

      onstart = function ()
        send("sip phlegmatic", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("weakness")
      end
    },
    focus = {
      aspriority = 2,
      spriority = 47,

      isadvisable = function ()
        return (affs.weakness and
          not doingaction("weakness")) or false
      end,

      oncompleted = function ()
        removeaff("weakness")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.weakness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("weakness")
      end,
    }
  },
  lovers = {
    map = {},
    physical = {
      balanceful_act = true,
      aspriority = 62,
      spriority = 76,

      isadvisable = function ()
        return (affs.lovers and not doingaction("lovers")) or false
      end,

      oncompleted = function (whom)
        dict.lovers.map[whom] = nil
        if not next(dict.lovers.map) then
          removeaff("lovers")
        end
      end,

      nobody = function ()
        if dict.lovers.rejecting then
          dict.lovers.map[dict.lovers.rejecting] = nil
          dict.lovers.rejecting = nil
        end

        if not next(dict.lovers.map) then
          removeaff("lovers")
        end
      end,

      onstart = function ()
        dict.lovers.rejecting = next(dict.lovers.map)
        send("reject " .. dict.lovers.rejecting, conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (whom)
        if not whom then return end

        addaff(dict.lovers)
        dict.lovers.map[whom] = true
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lovers")
        dict.lovers.map = {}
      end,
    }
  },
  woundscheck = {
    autocheckcount = 0,
    physical = {
      balanceful_act = false,
      aspriority = 63,
      spriority = 351,

      isadvisable = function ()
        return (sys.manualwoundscheck and not doingaction("woundscheck") and not affs.inquisition) or false
      end,

      oncompleted = function ()
        sys.manualwoundscheck = false
        dict.woundscheck.autocheckcount = 0
      end,

      onstart = function ()
#if skills.healing then
        if conf.succor then
          send("succor wounds me simple"..((conf.autowounds > 0 and dict.woundscheck.autocheckcount >= conf.autowounds) and " autocheck" or ""), conf.commandecho)
        else
          send("wounds simple"..((conf.autowounds > 0 and dict.woundscheck.autocheckcount >= conf.autowounds) and " autocheck" or ""), conf.commandecho)
        end
#else
        send("wounds simple"..((conf.autowounds > 0 and dict.woundscheck.autocheckcount >= conf.autowounds) and " autocheck" or ""), conf.commandecho)
#end
      end
    },
  },
  defcheck = {
    physical = {
      balanceful_act = true,
      aspriority = 56,
      spriority = 266,

      isadvisable = function ()
        local bals = bals
        return (bals.balance and bals.equilibrium and sys.manualdefcheck and not doingaction("defcheck") and not affs.inquisition) or false
      end,

      oncompleted = function ()
        sys.manualdefcheck = false
        process_defs()
      end,

      ontimeout = function ()
        sys.manualdefcheck = false
      end,

      onstart = function ()
        send("def", conf.commandecho)
      end
    },
  },
  diag = {
    physical = {
      balanceful_act = true,
      aspriority = 29,
      spriority = 66,
      dontbatch = true,

      isadvisable = function ()
        return ((sys.manualdiag or (affs.unknownmental and affs.unknownmental.p.count >= conf.unknownfocus) or (affs.unknownany and affs.unknownany.p.count >= conf.unknownany)) and bals.balance and bals.equilibrium and not doingaction("diag")) or false
      end,

      oncompleted = function ()
        sys.manualdiag = false
        diag_list = {}
        removeaff("unknownmental")
        removeaff("unknownany")
        dict.unknownmental.count = 0
        dict.unknownany.count = 0
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,

      onstart = function ()
#if skills.healing then
        if conf.succor then
          send("succor me", conf.commandecho)
        else
          send("diag", conf.commandecho)
        end
#else
        send("diag", conf.commandecho)
#end
      end
    },
  },
#if skills.healing then
  deepheal = {
    currentlimb = false,
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (sys.manualdeepheal and not doingaction"deepheal" and not affs.paralysis) or false
      end,

      oncompleted = function (limb)
        completely_healed[limb]()
        sys.manualdeepheal = false
        dict.deepheal.currentlimb = nil
      end,

      partial = function (limb)
        partially_healed[limb]("deepheal")
        sys.manualdeepheal = false
        dict.deepheal.currentlimb = nil
      end,

      onstart = function ()
        send("deepheal me "..dict.deepheal.currentlimb, conf.commandecho)
      end
    },
  },
#end
#if skills.rituals then
  puer = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return false
      end,

      oncompleted = function (limb)
        completely_healed[limb]()
      end,

      partial = function (limb)
        partially_healed[limb]("puer")
      end,

      onstart = function ()

      end
    },
  },
#end
  healspring = {
    currentlimb = false,
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return false
      end,

      oncompleted = function (limb)
        completely_healed[limb]()
      end,

      fully = function (limb)
        completely_healed[limb]()
      end,

      partially = function (limb)
        partially_healed[limb]("healspring")
      end,

      onstart = function ()

      end
    },
  },
  prone = {
    misc = {
      aspriority = 28,
      spriority = 63,

      isadvisable = function ()
        return (affs.prone
#if skills.acrobatics then
         and (conf.springup or (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm))
#else
          and bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm
#end
          and not doingaction("prone")
          and not affs.crippledrightleg and not affs.crippledleftleg
          and not affs.damagedrightleg and not affs.damagedleftleg
          and not affs.unknowncrippledleg
          and not affs.mangledrightleg and not affs.mangledleftleg
          and not affs.missingrightleg and not affs.missingleftleg
          and not affs.tendonright and not affs.tendonleft and not affs.tendonunknown
          and not affs.shatteredrightankle and not affs.shatteredleftankle
          and not affs.paralysis and not affs.severedspine
          and not affs.truss and not affs.roped
          and not (affs.grapple and dict.grapple.fullbody)
          and not affs.hemiplegyleft and not affs.hemiplegyright
          and not affs.tangle and not affs.leglock
          and not affs.transfixed and not affs.crucified
          and not affs.inquisition
          and not affs.impale) or false
      end,

      oncompleted = function ()
        removeaff("prone")
      end,

      notprone = function ()
        removeaff("prone")
      end,

      webbed = function ()
        addaff(dict.tangle)
      end,

      roped = function ()
        addaff(dict.roped)
      end,

      shackled = function ()
        addaff(dict.shackled)
      end,

      onstart = function ()
#if skills.acrobatics then
        if conf.springup then
          send("springup", conf.commandecho)
        else
          send("stand", conf.commandecho) end
#else
        send("stand", conf.commandecho)
#end
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.prone then addaff(dict.prone) end

        -- restart sap if necessary
        if actions.sap_physical then
          killaction (dict.sap.physical)
        end

        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("prone")
      end
    },
    onremoved = function () donext() end
  },
  lightpipes = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      uncurable = true,
      lastlit = 0, -- holds the timestamp of when the action was last successfully executed:
                     -- used in catching an empty pipe light loop

      isadvisable = function ()
        return (
             (not pipes.coltsfoot.arty and not pipes.coltsfoot.lit and pipes.coltsfoot.puffs > 0 and not (pipes.coltsfoot.id == 0)
          or (not pipes.myrtle.arty and not pipes.myrtle.lit and pipes.myrtle.puffs > 0 and not (pipes.myrtle.id == 0))
          or (not pipes.faeleaf.arty and not pipes.faeleaf.lit and pipes.faeleaf.puffs > 0 and not (pipes.faeleaf.id == 0))
          or (not pipes.steam.arty and not pipes.steam.lit and pipes.steam.puffs > 0 and not (pipes.steam.id == 0))
          )
        and (conf.relight or sk.forcelight_coltsfoot or sk.forcelight_faeleaf or sk.forcelight_myrtle or sk.forcelight_steam)
        and not (doingaction("lightfaeleaf") or doingaction("lightmyrtle") or doingaction("lightcoltsfoot") or doingaction("lightsteam") or doingaction("lightpipes"))) or false
      end,

      oncompleted = function ()
        pipes.coltsfoot.lit     = true
        sk.forcelight_coltsfoot = false
        pipes.myrtle.lit        = true
        sk.forcelight_myrtle    = false
        pipes.faeleaf.lit       = true
        sk.forcelight_faeleaf   = false
        pipes.steam.lit         = true
        sk.forcelight_steam     = false

        dict.lightpipes.physical.lastlit = os.time()

        lastlit("coltsfoot")
      end,

      actions = {"light pipes"},
      onstart = function ()
        if conf.gagrelight then
          send("light pipes", false)
        else
          send("light pipes", conf.commandecho) end
      end
    }
  },
  lightcoltsfoot = {
    physical = {
      aspriority = 6,
      spriority = 6,
      balanceless_act = true,
      herb = "coltsfoot",

      isadvisable = function ()
        -- disabled, handled with lightpipes by the system - but left here in case of manual lighting
        return false
      end,

      oncompleted = function ()
        pipes.coltsfoot.lit = true
        sk.forcelight_coltsfoot = false
        lastlit("coltsfoot")
      end,

      all = function ()
        for name, pipe in pairs(pipes) do
          pipe.lit = true
          sk["forcelight_"..name] = false
        end
      end,

      onstart = function ()
        if conf.gagrelight then
          send("light " .. pipes.coltsfoot.id, false)
        else
          send("light " .. pipes.coltsfoot.id, conf.commandecho) end
      end
    }
  },
  lightmyrtle = {
    physical = {
      aspriority = 5,
      spriority = 5,
      balanceless_act = true,
      herb = "myrtle",

      isadvisable = function ()
        -- disabled, handled with lightpipes by the system - but left here in case of manual lighting
        return false
      end,

      oncompleted = function ()
        pipes.myrtle.lit = true
        sk.forcelight_myrtle = false
        lastlit("myrtle")
      end,

      all = function ()
        for name, pipe in pairs(pipes) do
          pipe.lit = true
          sk["forcelight_"..name] = false
        end
      end,

      onstart = function ()
        if conf.gagrelight then
          send("light " .. pipes.myrtle.id, false)
        else
          send("light " .. pipes.myrtle.id, conf.commandecho) end
      end
    }
  },
  lightfaeleaf = {
    physical = {
      aspriority = 4,
      spriority = 4,
      balanceless_act = true,
      herb = "faeleaf",

      isadvisable = function ()
        -- disabled, handled with lightpipes by the system - but left here in case of manual lighting
        return false
      end,

      oncompleted = function ()
        pipes.faeleaf.lit = true
        sk.forcelight_faeleaf = false
        lastlit("faeleaf")
      end,

      all = function ()
        for name, pipe in pairs(pipes) do
          pipe.lit = true
          sk["forcelight_"..name] = false
        end
      end,

      onstart = function ()
        if conf.gagrelight then
          send("light " .. pipes.faeleaf.id, false)
        else
          send("light " .. pipes.faeleaf.id, conf.commandecho) end
      end
    }
  },
  lightsteam = {
    physical = {
      aspriority = 4,
      spriority = 4,
      balanceless_act = true,
      herb = "steam",

      isadvisable = function ()
        -- disabled, handled with lightpipes by the system - but left here in case of manual lighting
        return false
      end,

      oncompleted = function ()
        pipes.steam.lit = true
        sk.forcelight_steam = false
        lastlit("steam")
      end,

      all = function ()
        for name, pipe in pairs(pipes) do
          pipe.lit = true
          sk["forcelight_"..name] = false
        end
      end,
      
      onstart = function ()
        if conf.gagrelight then
          send("light " .. pipes.steam.id, false)
        else
          send("light " .. pipes.steam.id, conf.commandecho) end
      end
    }
  },
  doparry = {
    misc = {
      aspriority = 41,
      spriority = 84,

      isadvisable = function ()
        return (not sys.sp_satisfied and not sys.blockparry
          and not doingaction "doparry" and conf.parry and not affs.crackedleftelbow and not affs.crackedrightelbow and not affs.inquisition) or false
      end,

      oncompleted = function (limb)
        sps.parry_currently[limb] = sp_config.parry_shouldbe[limb]
        check_sp_satisfied()

        if not sys.sp_satisfied then
          -- allow other limbs sent to parry to catch up, then re-check again
          if sys.blockparry then killTimer(sys.blockparry); sys.blockparry = nil end
          sys.blockparry = tempTimer(sys.wait + syncdelay(), function () sys.blockparry = nil;  make_gnomes_work() end)
        end
      end,

      onstart = function ()
        -- see if we need to unparry - this happens when a limb isn't what it should be.
        -- however, don't unparry if all shouldbe are 0

        for name, limb in pairs(sp_config.parry_shouldbe) do
          if limb ~= sps.parry_currently[name] and sps.parry_currently[name] ~= 0 then
            send("unparry", conf.commandecho); if not sys.sync then break else return end
          end
        end

        -- now parry!
        if sp_something_to_parry() then
          for name, limb in pairs(sp_config.parry_shouldbe) do
            if limb ~= sps.parry_currently[name] and limb ~= 0 then
#if skills.cavalier then
              send(string.format("parry %s %d%s", sp_limbs[name], limb, (conf.hook and " hook" or '')), conf.commandecho)
#else
              send(string.format("parry %s %d", sp_limbs[name], limb), conf.commandecho)
#end
              if sys.sync then return end
            end
          end
        elseif sp_config.priority[1] and sps.parry_currently[sp_config.priority[1]] ~= 100 then
#if skills.cavalier then
          send(string.format("parry %s %d%s", sp_limbs[sp_config.priority[1]], 100, (conf.hook and " hook" or '')), conf.commandecho)
#else
          send(string.format("parry %s %d", sp_limbs[sp_config.priority[1]], 100), conf.commandecho)
#end
        else -- got here? nothing to do...
          sys.sp_satisfied = true end
      end,

      none = function ()
        for limb, _ in pairs(sps.parry_currently) do
          sps.parry_currently[limb] = 0
        end

        check_sp_satisfied()

        if not sys.sp_satisfied then
          -- allow other limbs sent to parry to catch up, then re-check again
          if sys.blockparry then killTimer(sys.blockparry); sys.blockparry = nil end
          sys.blockparry = tempTimer(sys.wait + syncdelay(), function () sys.blockparry = nil;  make_gnomes_work() end)
        end
      end
    }
  },
  doprecache = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (rift.doprecache and not sys.blockoutr and not findbybal "herb" and not doingaction "doprecache" and sys.canoutr) or false
      end,

      oncompleted = function ()
        rift.checkprecache()

        if rift.doprecache then
          -- allow other outrs to catch up, then re-check again
          if sys.blockoutr then killTimer(sys.blockoutr); sys.blockoutr = nil end
          sys.blockoutr = tempTimer(sys.wait + syncdelay(), function () sys.blockoutr = nil;  make_gnomes_work() end)
        end
      end,

      ontimeout = function ()
        rift.checkprecache()
      end,

      onstart = function ()
        for herb, amount in pairs(rift.precache) do
          if rift.precache[herb] ~= 0 and (rift.invcontents[herb] < rift.precache[herb]) then
            send("outr " .. (rift.precache[herb] - rift.invcontents[herb]) .. " " .. herb, conf.commandecho)
            if sys.sync then return end
          end
        end
      end
    }
  },
  dostance = {
    misc = {
      aspriority = 42,
      spriority = 175,

      isadvisable = function ()
        return ((conf.queuing or (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and not affs.prone))
          and sp_config.stance_shouldbe ~= sps.stance_currently
          and sp_config.stance_shouldbe ~= ""
          and not doingaction "dostance" and not affs.crackedleftkneecap and not affs.crackedrightkneecap and not affs.crackedunknownkneecap and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function (which)
        sps.stance_currently = which
      end,

      onstart = function ()
        if bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and not affs.prone and not affs.paralysis and not affs.severedspine then
          send("stance " .. sp_config.stance_shouldbe, conf.commandecho)
        elseif conf.queuing then
          send("queuestance " .. sp_config.stance_shouldbe, conf.commandecho)
        end
      end,

      none = function ()
        sps.stance_currently = ""
      end
    },
    gone = {
      oncompleted = function ()
        sps.stance_currently = "none"
      end
    }
  },
#if skills.healing then
  usehealing = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        if not next(affs) or not bals.balance or not bals.equilibrium or conf.usehealing == "none" or not can_usemana() or doingaction "usehealing" or affs.tangle or affs.crucified then return false end

        -- we calculate here if we can use Healing on any of the affs we got; cache the result as well

        -- small func for getting the spriority of a thing
        local function getprio(what)
          for k,v in pairs(what) do
            if type(v) == "table" and v.spriority then
              return v.spriority
            end
          end
        end

        local t = {}
        for affname, aff in pairs(affs) do
          if sk.healingmap[affname] and not ignore[affname] and not doingaction (affname) and not doingaction ("curing"..affname) and not defc["true"..affname] and not defc["true"..affname] and (not affs.maestoso or not sk.cursesaffs[affname]) and not (affs.eyepeckleft and affs.eyepeckright and sk.sensesaffs[affname]) then
            t[affname] = getprio(dict[affname])
          end
        end

        if not next(t) then return false end
        dict.usehealing.afftocure = getHighestKey(t)
        return true
      end,

      oncompleted = function()
        dict.usehealing.curingaff = nil
      end,

      empty = function ()
        if not dict.usehealing.curingaff then return end

        -- special handling of regeneration affs, which still take a delayed 4s to cure
        if sk.regenaffs[dict.usehealing.curingaff] then
          doaction(dict["curing"..dict.usehealing.curingaff].waitingfor)
        -- if we get uncurable deafness, then we have truedeaf
        elseif dict.usehealing.curingaff == "deaf" then
          defences.got("truedeaf")
          removeaff("deaf")
        -- if we get uncurable deafness, then we have trueblind
        elseif dict.usehealing.curingaff == "blind" then
          defences.got("trueblind")
          removeaff("blind")
        else
          removeaff(dict.usehealing.curingaff) end

        dict.usehealing.curingaff = nil
      end,

      onstart = function ()
        local t = sk.healingmap[dict.usehealing.afftocure]
        send(string.format("cure me %s%s",
          (type(t) == "string" and t or t.aura),
          (type(t) == "string" and "" or (" ".. t.side))
        ), conf.commandecho)
        dict.usehealing.curingaff = dict.usehealing.afftocure
        dict.usehealing.afftocure = nil
      end
    }
  },
#end
  cleanse = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (cnrl.checkgreen and conf.cleanse and not doingaction "cleanse" and not doingaction "powercure" and not codepaste.cleanse_codepaste() and (cnrl.lockdata["cleanse a"]() or cnrl.lockdata["cleanse b"]() or cnrl.lockdata["cleanse c"]()) and not affs.paralysis and not affs.severedspine and not affs.prone and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function (aff)
        removeaff(aff)
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
  },
  powercure = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (cnrl.checkgreen and (conf.green or conf.gedulah) and not doingaction "powercure" and not doingaction "cleanse" and stats.currentpower >= 3
        and
#if skills.healing then
        not doingaction "usehealing" and
#end
        ((cnrl.lockdata["green a"]() and not doingaction "slickness") or (cnrl.lockdata["green b"]() and not doingaction "slickness") or (cnrl.lockdata["green c"]() and not doingaction "slickness") or cnrl.lockdata["slow"]())) or false
      end,

      oncompleted = function ()
      end,

      onstart = function ()
#if skills.highmagic then
        if conf.gedulah then
          send("evoke gedulah", conf.commandecho)
        else
#end
          send("invoke green", conf.commandecho)
#if skills.highmagic then
        end
#end
      end
    },
  },
  magicwrithe = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return ((conf.summer or conf.tipheret) and ((affs.vines and not ignore.vines) or (affs.roped and not ignore.roped) or (affs.shackled and not ignore.shackled) or (affs.truss and not ignore.truss) or (affs.tangle and not ignore.tangle)) and codepaste.writhe() and not affs.paralysis and not affs.severedspine) or false
      end,

      oncompleted = function ()
        removeaff{"vines", "roped", "shackled", "truss", "tangle"}
      end,

      onstart = function ()
#if skills.highmagic and skills.lowmagic then
        if conf.tipheret then
          send("evoke tipheret", conf.commandecho)
        else
          send("invoke summer", conf.commandecho)
        end
#elseif skills.highmagic then
        send("evoke tipheret", conf.commandecho)
#elseif skills.lowmagic then
        send("invoke summer", conf.commandecho)
#end
      end
    },
  },
#if skills.shamanism then
  sheatheclaw = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.bleeding and defc.claw and dict.bleeding.count >= (conf.clawamount or 700) and stats.currentpower >= 1 and not affs.paralysis and not affs.severedspine and not affs.shackled and not doingaction("sheatheclaw")) or false
      end,

      oncompleted = function (howmuch)
        if (howmuch and howmuch == "full") or dict.bleeding.count < 1000 then
          removeaff("bleeding")
          dict.bleeding.count = 0
        else
          dict.bleeding.count = dict.bleeding.count - 1000
        end
      end,

      onstart = function ()
        send("envision sheatheclaw", conf.commandecho)
      end
    },
  },
#end
  fillfaeleaf = {
    physical = {
      balanceless_act = true,
      aspriority = 1,
      spriority = 42,

      isadvisable = function ()
        return (pipes.faeleaf.puffs <= 0 and not doingaction("fillfaeleaf") and not (pipes.faeleaf.id == 0) and codepaste.can_refill()) or false
      end,

      oncompleted = function ()
        pipes.faeleaf.puffs = 10
      end,

      onstart = function ()
        fillpipe("faeleaf", pipes.faeleaf.id)
      end
    }
  },
  fillmyrtle = {
    physical = {
      balanceless_act = true,
      aspriority = 2,
      spriority = 11,

      isadvisable = function ()
        return (pipes.myrtle.puffs <= 0 and not doingaction("fillmyrtle") and not (pipes.myrtle.id == 0) and codepaste.can_refill()) or false
      end,

      oncompleted = function ()
        pipes.myrtle.puffs = 10
      end,

      onstart = function ()
        fillpipe("myrtle", pipes.myrtle.id)
      end
    }
  },
  fillcoltsfoot = {
    physical = {
      balanceless_act = true,
      aspriority = 3,
      spriority = 3,

      isadvisable = function ()
        return (pipes.coltsfoot.puffs <= 0 and not doingaction("fillcoltsfoot") and not (pipes.coltsfoot.id == 0) and codepaste.can_refill()) or false
      end,

      oncompleted = function ()
        pipes.coltsfoot.puffs = 10
      end,

      onstart = function ()
        fillpipe("coltsfoot", pipes.coltsfoot.id)
      end
    }
  },
  fillsteam = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (pipes.steam.puffs <= 0 and not doingaction("fillsteam") and not (pipes.steam.id == 0) and codepaste.can_refill()) or false
      end,

      oncompleted = function ()
        pipes.steam.puffs = 10
      end,

      onstart = function ()
        fillpipe("steam", pipes.steam.id)
      end
    }
  },
  rewield = {
    rewieldables = false,
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (conf.autorewield and dict.rewield.rewieldables and not doingaction"rewield" and not affs.impale and not affs.vines and not affs.transfixed and not affs.roped and not affs.shackled and not affs.truss and not affs.tangle and not affs.crucified and not affs.gore and sys.canoutr and not affs.hemiplegyright and not affs.hemiplegyleft) or false
      end,

      oncompleted = function (id)
        -- in case we wielded manually and weren't expecting it
        if type(dict.rewield.rewieldables) ~= "table" then return end

        for count, item in ipairs(dict.rewield.rewieldables) do
          if item.id == id then
            table.remove(dict.rewield.rewieldables, count)
            break
          end
        end

        if #dict.rewield.rewieldables == 0 then
          dict.rewield.rewieldables = false
        end
      end,

      failed = function ()
        dict.rewield.rewieldables = false
      end,

      onstart = function ()
        for _, t in pairs(dict.rewield.rewieldables) do
          send("wield "..(t.id or "?"), conf.commandecho)
        end
      end
    }
  },
  disrupt = {
    misc = {
      aspriority = 9,
      spriority = 2,

      isadvisable = function ()
        return (affs.disrupt and not doingaction("disrupt")
          and not affs.confusion and not affs.sleep) or false
      end,

      oncompleted = function ()
        removeaff("disrupt")
      end,

      oncured = function ()
        removeaff("disrupt")
      end,

      onstart = function ()
        send("concentrate", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.disrupt)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("disrupt")
      end
    }
  },
  fear = {
    misc = {
      aspriority = 11,
      spriority = 194,

      isadvisable = function ()
        return (affs.fear and not doingaction("fear")) or false
      end,

      oncompleted = function ()
        removeaff("fear")
      end,

      oncured = function ()
        removeaff("fear")
      end,

      onstart = function ()
        send("compose", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.fear)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("fear")
      end
    }
  },
  bleeding = {
    count = 0,
    herb = {
      aspriority = 98,
      spriority = 273,

      isadvisable = function ()
        return (affs.bleeding and not doingaction("bleeding") and not dict.bleeding.misc.isadvisable() and dict.bleeding.count >= (conf.bleedamount or 60)) or false
      end,

      oncompleted = function ()
        sk.lostbal_herb()
      end,

      empty = function()
        sk.lostbal_herb()
        removeaff("bleeding")
        dict.bleeding.count = 0
      end,

      eatcure = "chervil",
      onstart = function ()
        eat("chervil")
      end
    },
    misc = {
      aspriority = 10,
      spriority = 10,

      isadvisable = function ()
        return (affs.bleeding and not doingaction("bleeding") and not affs.haemophilia and not affs.sleep and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown and not affs.pinlegunknown and can_usemana() and conf.clot and dict.bleeding.count >= (conf.bleedamount or 60) and not affs.manabarbs and not doingaction("bruising")) or false
      end,

      -- by default, oncompleted means a clot went through okay
      oncompleted = function ()
      end,

      -- oncured in this case means that we actually cured it; don't have any more bleeding
      oncured = function ()
        removeaff("bleeding")
        dict.bleeding.count = 0
      end,

      onstart = function ()
        local needClot = math.floor(dict.bleeding.count/25)
        local maxClot = math.floor((mm.stats.currentmana - (mm.stats.maxmana*(mm.conf.manause/100)))/60)
        local toClot = math.min(needClot, maxClot)
        if conf.gagclot and not sys.sync then
          send("clot "..toClot, false)
        else
          send("clot "..toClot, conf.commandecho) end
        end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.bleeding)
        affs.bleeding.p.count = amount or (affs.bleeding.p.count + 200)
        updateaffcount(dict.bleeding)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("bleeding")
        dict.bleeding.count = 0
      end,
    }
  },
  bruising = {
    count = 0,
    misc = {
      aspriority = 10,
      spriority = 10,

      isadvisable = function ()
        return (affs.bruising and not doingaction("bruising") and not affs.haemophilia and not affs.sleep and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown and not affs.pinlegunknown and can_usemana() and conf.clot and dict.bruising.count >= (conf.bleedamount or 60) and not affs.manabarbs and not doingaction("bleeding")) or false
      end,

      -- by default, oncompleted means a clot went through okay
      oncompleted = function ()
      end,

      -- oncured in this case means that we actually cured it; don't have any more bleeding
      oncured = function ()
        removeaff("bruising")
        dict.bruising.count = 0
      end,

      onstart = function ()
        local needClot = math.floor(dict.bruising.count/12)
        local maxClot = math.floor((mm.stats.currentmana - (mm.stats.maxmana*(mm.conf.manause/100)))/60)
        local toClot = math.min(needClot, maxClot)
        if conf.gagclot and not sys.sync then
          send("clot "..toClot, false)
        else
          send("clot "..toClot, conf.commandecho) end
        end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.bruising)
        affs.bruising.p.count = amount or (affs.bruising.p.count + 200)
        updateaffcount(dict.bruising)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("bruising")
        dict.bruising.count = 0
      end,
    }
  },
  scabies = {
    salve = {
      aspriority = 36,
      spriority = 36,

      isadvisable = function ()
        return (affs.scabies) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("scabies")
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      onstart = function ()
        send("apply liniment", conf.commandecho)
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.scabies and not doingaction "scabies") or false
      end,

      oncompleted = function ()
        removeaff("scabies")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("scabies", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.scabies)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("scabies")
      end,
    }
  },
  pox = {
    salve = {
      aspriority = 35,
      spriority = 35,

      isadvisable = function ()
        return (affs.pox) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("pox")
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      onstart = function ()
        send("apply liniment", conf.commandecho)
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.pox and not doingaction "pox") or false
      end,

      oncompleted = function ()
        removeaff("pox")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("pox", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.pox)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pox")
      end,
    }
  },
  sunallergy = {
    salve = {
      aspriority = 6,
      spriority = 271,

      isadvisable = function ()
        return (affs.sunallergy) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("sunallergy")
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      onstart = function ()
        send("apply liniment to chest", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.sunallergy)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sunallergy")
      end,
    }
  },
  fourthdegreeburn = {
    salve = {
      aspriority = 28,
      spriority = 28,

      isadvisable = function ()
        --return (not conf.arena and affs.fourthdegreeburn) or false
        return (affs.fourthdegreeburn) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("fourthdegreeburn")
        addaff(dict.thirddegreeburn)
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      onstart = function ()
        send("apply liniment to chest", conf.commandecho)
      end,


      stillgot = function()
        sk.lostbal_salve()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --return (conf.arena and affs.fourthdegreeburn) or false
        return false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("fourthdegreeburn")
        addaff(dict.thirddegreeburn)
      end,

      noeffect = function ()
        valid.ice_noeffect()
      end,

      nouse = function()
        sk.lostbal_ice()
      end,

      onstart = function ()
        send("apply ice to body", conf.commandecho)
      end,


      stillgot = function()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_burns()
        addaff(dict.fourthdegreeburn)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fourthdegreeburn")
      end,
    }
  },
  thirddegreeburn = {
    salve = {
      aspriority = 27,
      spriority = 27,

      isadvisable = function ()
        --return (not conf.arena and affs.thirddegreeburn) or false
        return affs.thirddegreeburn or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("thirddegreeburn")
        addaff(dict.seconddegreeburn)
      end,

      onstart = function ()
        send("apply liniment to chest", conf.commandecho)
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect  = function ()
        empty.apply_liniment()
      end,

      stillgot = function()
        sk.lostbal_salve()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --return (conf.arena and affs.thirddegreeburn) or false
        return false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("thirddegreeburn")
        addaff(dict.seconddegreeburn)
      end,

      noeffect = function ()
        valid.ice_noeffect()
      end,

      nouse = function()
        sk.lostbal_ice()
      end,

      onstart = function ()
        send("apply ice to body", conf.commandecho)
      end,


      stillgot = function()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_burns()
        addaff(dict.thirddegreeburn)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thirddegreeburn")
      end,
    }
  },
  seconddegreeburn = {
    salve = {
      aspriority = 26,
      spriority = 26,

      isadvisable = function ()
        --return (not conf.arena and affs.seconddegreeburn) or false
        return affs.seconddegreeburn or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("seconddegreeburn")
        addaff(dict.firstdegreeburn)
      end,

      onstart = function ()
        send("apply liniment to chest", conf.commandecho)
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      stillgot = function()
        sk.lostbal_salve()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --return (conf.arena and affs.seconddegreeburn) or false
        return false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("seconddegreeburn")
        addaff(dict.firstdegreeburn)
      end,

      noeffect = function ()
        valid.ice_noeffect()
      end,

      nouse = function()
        sk.lostbal_ice()
      end,

      onstart = function ()
        send("apply ice to body", conf.commandecho)
      end,


      stillgot = function()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_burns()
        addaff(dict.seconddegreeburn)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("seconddegreeburn")
      end,
    }
  },
  firstdegreeburn = {
    salve = {
      aspriority = 25,
      spriority = 25,

      isadvisable = function ()
        --return (not conf.arena and affs.firstdegreeburn) or false
        return affs.firstdegreeburn or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("firstdegreeburn")
      end,

      onstart = function ()
        send("apply liniment to chest", conf.commandecho)
      end,

      empty = function ()
        empty.apply_liniment()
      end,

      noeffect = function ()
        empty.apply_liniment()
      end,

      stillgot = function()
        sk.lostbal_salve()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --return (conf.arena and affs.firstdegreeburn) or false
        return false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("firstdegreeburn")
      end,

      noeffect = function ()
        valid.ice_noeffect()
      end,

      nouse = function()
        sk.lostbal_ice()
      end,

      onstart = function ()
        send("apply ice to body", conf.commandecho)
      end,


      stillgot = function()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_burns()
        addaff(dict.firstdegreeburn)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("firstdegreeburn")
      end,
    }
  },
  shortbreath = {
    salve = {
      aspriority = 62,
      spriority = 295,

      isadvisable = function ()
        return (affs.shortbreath and
        not doingaction("curingcollapsedlungs")) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("shortbreath")
      end,

      onstart = function ()
        send("apply melancholic to chest", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shortbreath)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shortbreath")
      end,
    }
  },
  trembling = {
    salve = {
      aspriority = 16,
      spriority = 94,

      isadvisable = function ()
        return (affs.trembling) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("trembling")
      end,

      onstart = function ()
        send("apply melancholic to chest", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.trembling)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("trembling")
      end,
    }
  },
  puncturedlung = {
    salve = {
      aspriority = 61,
      spriority = 294,

      isadvisable = function ()
        return affs.puncturedlung and
        not doingaction("curingcollapsedlungs") or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("puncturedlung")
      end,

      onstart = function ()
        send("apply melancholic to chest", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.puncturedlung)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("puncturedlung")
      end,
    }
  },
  blacklung = {
    salve = {
      aspriority = 17,
      spriority = 81,

      isadvisable = function ()
        return (affs.blacklung) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("blacklung")
      end,

      onstart = function ()
        send("apply melancholic to chest", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.blacklung)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("blacklung")
      end,
    }
  },
  asthma = {
    salve = {
      aspriority = 34,
      spriority = 287,

      isadvisable = function ()
        return (affs.asthma) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("asthma")
      end,

      onstart = function ()
        send("apply melancholic to chest", conf.commandecho)
      end,

      empty = function ()
      end,

      noeffect = function ()
        empty.noeffect_melancholic_chest()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.asthma and not doingaction "asthma") or false
      end,

      oncompleted = function ()
        removeaff("asthma")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("asthma", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.asthma)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("asthma")
      end,
    }
  },
  crippledrightarm = {
    salve = {
      aspriority = 20,
      spriority = 20,

      isadvisable = function ()
        return (affs.crippledrightarm and not affs.mangledrightarm and not affs.missingrightarm) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("crippledrightarm")

        if dict.unknowncrippledarm.count <= 0 then return end
        dict.unknowncrippledarm.count = dict.unknowncrippledarm.count - 1
        if dict.unknowncrippledarm.count <= 0 then removeaff"unknowncrippledarm" end
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      oncuredleft = function ()
        sk.lostbal_salve()
        removeaff("crippledleftarm")
      end,

      oncuredleft = function ()
        sk.lostbal_salve()
        removeaff("crippledleftarm")

        if dict.unknowncrippledarm.count <= 0 then return end
        dict.unknowncrippledarm.count = dict.unknowncrippledarm.count - 1
        if dict.unknowncrippledarm.count <= 0 then removeaff"unknowncrippledarm" end
      end,

      -- mangled arms
      empty = function ()
        sk.lostbal_salve()
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.crippledrightarm)
        else
          addaff(dict.damagedrightarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crippledrightarm")
      end,
    }
  },
  crippledleftarm = {
    salve = {
      aspriority = 22,
      spriority = 22,

      isadvisable = function ()
        return (affs.crippledleftarm and not affs.mangledleftarm and not affs.mangledrightarm and not affs.missingleftarm and not affs.missingrightarm) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("crippledleftarm")

        if dict.unknowncrippledarm.count <= 0 then return end
        dict.unknowncrippledarm.count = dict.unknowncrippledarm.count - 1
        if dict.unknowncrippledarm.count <= 0 then removeaff"unknowncrippledarm" end
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      oncuredright = function ()
        sk.lostbal_salve()
        removeaff("crippledrightarm")

        if dict.unknowncrippledarm.count <= 0 then return end
        dict.unknowncrippledarm.count = dict.unknowncrippledarm.count - 1
        if dict.unknowncrippledarm.count <= 0 then removeaff"unknowncrippledarm" end
      end,

      -- mangled arms
      empty = function ()
        sk.lostbal_salve()
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.crippledleftarm)
        else
          addaff(dict.damagedleftarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crippledleftarm")
      end,
    }
  },
  brokenrightwrist = {
    salve = {
      aspriority = 57,
      spriority = 279,

      isadvisable = function ()
        return (affs.brokenrightwrist) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("brokenrightwrist")
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      oncuredleft = function ()
        sk.lostbal_salve()
        removeaff("brokenleftwrist")
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.brokenrightwrist)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("brokenrightwrist")
      end
    }
  },
  brokenleftwrist = {
    salve = {
      aspriority = 59,
      spriority = 282,

      isadvisable = function ()
        return (affs.brokenleftwrist) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("brokenleftwrist")
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      oncuredright = function ()
        sk.lostbal_salve()
        removeaff("brokenrightwrist")
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.brokenleftwrist)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("brokenleftwrist")
      end
    }
  },
  twistedrightarm = {
    salve = {
      aspriority = 58,
      spriority = 281,

      isadvisable = function ()
        return (affs.twistedrightarm) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("twistedrightarm")
        addaff (dict.numbedrightarm)
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.twistedrightarm)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("twistedrightarm")
      end
    }
  },
  twistedleftarm = {
    salve = {
      aspriority = 56,
      spriority = 280,

      isadvisable = function ()
        return (affs.twistedleftarm) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("twistedleftarm")
        addaff (dict.numbedleftarm)
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.twistedleftarm)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("twistedleftarm")
      end
    }
  },
  twistedrightleg = {
    salve = {
      aspriority = 54,
      spriority = 278,

      isadvisable = function ()
        return (affs.twistedrightleg) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("twistedrightleg")
        addaff (dict.numbedrightleg)
      end,

      onstart = function ()
        send("apply mending to legs", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_legs()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.twistedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("twistedrightleg")
      end,
    }
  },
  twistedleftleg = {
    salve = {
      aspriority = 55,
      spriority = 277,

      isadvisable = function ()
        return (affs.twistedleftleg) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("twistedleftleg")
        addaff (dict.numbedleftleg)
      end,

      onstart = function ()
        send("apply mending to legs", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_legs()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.twistedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("twistedleftleg")
      end,
    }
  },
  crippledrightleg = {
    salve = {
      aspriority = 19,
      spriority = 19,

      isadvisable = function ()
        -- can apply crippled while tendoned, but not crushed
        return (affs.crippledrightleg and not (affs.crushedleftfoot or affs.crushedrightfoot)) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("crippledrightleg")

        if dict.unknowncrippledleg.count <= 0 then return end
        dict.unknowncrippledleg.count = dict.unknowncrippledleg.count - 1
        if dict.unknowncrippledleg.count <= 0 then removeaff"unknowncrippledleg" end
      end,

      onstart = function ()
        send("apply mending to legs", conf.commandecho)
      end,

      oncuredleft = function ()
        sk.lostbal_salve()
        removeaff("crippledleftleg")

        if dict.unknowncrippledleg.count <= 0 then return end
        dict.unknowncrippledleg.count = dict.unknowncrippledleg.count - 1
        if dict.unknowncrippledleg.count <= 0 then removeaff"unknowncrippledleg" end
      end,

      noeffect = function ()
        empty.noeffect_mending_legs()
      end,

      empty = function () end,
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.crippledrightleg)
        else
          addaff(dict.damagedrightleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crippledrightleg")
      end,
    }
  },
  crippledleftleg = {
    salve = {
      aspriority = 21,
      spriority = 21,

      isadvisable = function ()
        -- can apply for cripples while tendoned, but not crushed
        return (affs.crippledleftleg and not (affs.crushedleftfoot or affs.crushedrightfoot)) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("crippledleftleg")

        if dict.unknowncrippledleg.count <= 0 then return end
        dict.unknowncrippledleg.count = dict.unknowncrippledleg.count - 1
        if dict.unknowncrippledleg.count <= 0 then removeaff"unknowncrippledleg" end
      end,

      onstart = function ()
        send("apply mending to legs", conf.commandecho)
      end,

      oncuredright = function ()
        sk.lostbal_salve()
        removeaff("crippledrightleg")

        if dict.unknowncrippledleg.count <= 0 then return end
        dict.unknowncrippledleg.count = dict.unknowncrippledleg.count - 1
        if dict.unknowncrippledleg.count <= 0 then removeaff"unknowncrippledleg" end
      end,

      noeffect = function ()
        empty.noeffect_mending_legs()
      end,

      empty = function () end,
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.crippledleftleg)
        else
          addaff(dict.damagedleftleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crippledleftleg")
      end,
    }
  },

  missingleftarm = {
    salve = {
      aspriority = 13,
      spriority = 203,

      isadvisable = function ()
        return (affs.missingleftarm and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "missingleftarm")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmissingleftarm.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.missingleftarm.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.missingleftarm)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        else
          addaff(dict.mutilatedleftarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingleftarm")
      end,
    }
  },
  missingrightarm = {
    salve = {
      aspriority = 12,
      spriority = 204,

      isadvisable = function ()
        return (affs.missingrightarm and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "missingrightarm")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmissingrightarm.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.missingrightarm.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.missingrightarm)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        else
          addaff(dict.mutilatedrightarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingrightarm")
      end,
    }
  },
  mangledleftarm = {
    salve = {
      aspriority = 11,
      spriority = 206,

      isadvisable = function ()
        return (affs.mangledleftarm and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "mangledleftarm")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmangledleftarm.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.mangledleftarm.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.mangledleftarm)
        else
          addaff(dict.mutilatedleftarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mangledleftarm")
      end,
    }
  },
  mangledrightarm = {
    salve = {
      aspriority = 10,
      spriority = 205,

      isadvisable = function ()
        return (affs.mangledrightarm and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "mangledrightarm")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmangledrightarm.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.mangledrightarm.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.mangledrightarm)
        else
          addaff(dict.mutilatedrightarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mangledrightarm")
      end,
    }
  },
  curingmissingrightarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("missingrightarm")
        addaff(dict.mangledrightarm)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure missingrightarm")
        end)
      end,

      oncuredleft = function()
        removeaff("missingleftarm")
        addaff(dict.mangledleftarm)
      end
    }
  },
  curingmangledrightarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("mangledrightarm")
        addaff(dict.crippledrightarm)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure mangledrightarm")
        end)
      end,

      oncuredleft = function()
        removeaff("mangledleftarm")
        addaff(dict.crippledleftarm)
      end
    }
  },
  curingmissingleftarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("missingleftarm")
        addaff(dict.mangledleftarm)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure missingleftarm")
        end)
      end,

      oncuredright = function()
        removeaff("missingrightarm")
        addaff(dict.mangledrightarm)
      end
    }
  },
  curingmangledleftarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("mangledleftarm")
        addaff(dict.crippledleftarm)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure mangledleftarm")
        end)
      end,

      oncuredright = function()
        removeaff("mangledrightarm")
        addaff(dict.crippledrightarm)
      end
    }
  },

  missingleftleg = {
    salve = {
      aspriority = 32,
      spriority = 32,

      isadvisable = function ()
        return (affs.missingleftleg and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "missingleftleg")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmissingleftleg.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.missingleftleg.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.missingleftleg)
          removeaff("tendonleft")
        else
          addaff(dict.mutilatedleftleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingleftleg")
      end,
    }
  },
  curingmissingleftleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      ontimeout = function()
        removeaff("missingleftleg")
      end,

      oncompleted = function ()
        removeaff("missingleftleg")
        removeaff("paregenlegs")
        addaff(dict.mangledleftleg)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure missingleftleg")
        end)
      end,

      oncuredright = function()
        removeaff("missingrightleg")
        addaff(dict.mangledrightleg)
      end
    }
  },
  missingrightleg = {
    salve = {
      aspriority = 33,
      spriority = 33,

      isadvisable = function ()
        return (affs.missingrightleg and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "missingrightleg")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmissingrightleg.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.missingrightleg.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.missingrightleg)
          removeaff("tendonright")
        else
          addaff(dict.mutilatedrightleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingrightleg")
      end,
    }
  },
  curingmissingrightleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      ontimeout = function()
        removeaff("missingrightleg")
      end,

      oncompleted = function ()
        removeaff("missingrightleg")
        removeaff("paregenlegs")
        addaff(dict.mangledrightleg)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure missingrightleg")
        end)
      end,

      oncuredleft = function()
        removeaff("missingleftleg")
        addaff(dict.mangledleftleg)
      end
    }
  },
  mangledrightleg = {
    salve = {
      aspriority = 31,
      spriority = 31,

      isadvisable = function ()
        return (affs.mangledrightleg and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "mangledrightleg")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmangledrightleg.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.mangledrightleg.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.mangledrightleg)
        else
          addaff(dict.mutilatedrightleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mangledrightleg")
      end,
    }
  },
  curingmangledrightleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("mangledrightleg")
        removeaff("paregenlegs")
        addaff(dict.crippledrightleg)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure mangledrightleg")
        end)
      end,

      oncuredleft = function()
        removeaff("mangledleftleg")
        addaff(dict.crippledleftleg)
      end,

      ontimeout = function()
        removeaff("mangledrightleg")
        removeaff("paregenlegs")
      end,
    }
  },
  mangledleftleg = {
    salve = {
      aspriority = 29,
      spriority = 29,

      isadvisable = function ()
        return (affs.mangledleftleg and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "mangledleftleg")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingmangledleftleg.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.mangledleftleg.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.mangledleftleg)
        else
          addaff(dict.mutilatedleftleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mangledleftleg")
        removeaff("paregenlegs")
      end,
    }
  },
  curingmangledleftleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("mangledleftleg")
        removeaff("paregenlegs")
        addaff(dict.crippledleftleg)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure mangledleftleg")
        end)
      end,

      oncuredright = function()
        removeaff("mangledrightleg")
        addaff(dict.crippledrightleg)
      end,

      ontimeout = function()
        removeaff("mangledleftleg")
        removeaff("paregenlegs")
      end,
    }
  },
  paregenlegs = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.paregenlegs and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "paregenlegs")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingparegenlegs.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.paregenlegs.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.paregenlegs)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("paregenlegs")
      end,
    }
  },
  curingparegenlegs = {
    waitingfor = {
      customwait = 4,

      oncompleted = function ()
        removeaff("paregenlegs")
      end,

      onstart = function ()
      end,

      ontimeout = function ()
        removeaff("paregenlegs")
      end
    }
  },

  collapsedleftnerve = {
    salve = {
      aspriority = 42,
      spriority = 111,

      isadvisable = function ()
        return (affs.collapsedleftnerve and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "collapsedleftnerve")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcollapsedleftnerve.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.collapsedleftnerve.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.collapsedleftnerve)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("collapsedleftnerve")
      end,
    }
  },
  curingcollapsedleftnerve = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("collapsedleftnerve")
        addaff(dict.hemiplegyleft)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure collapsedleftnerve")
        end)
      end
    }
  },
  collapsedrightnerve = {
    salve = {
      aspriority = 43,
      spriority = 109,

      isadvisable = function ()
        return (affs.collapsedrightnerve and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "collapsedrightnerve")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcollapsedrightnerve.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.collapsedrightnerve.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.collapsedrightnerve)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("collapsedrightnerve")
      end,
    }
  },
  curingcollapsedrightnerve = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("collapsedrightnerve")
        addaff(dict.hemiplegyright)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure collapsedrightnerve")
        end)
      end,

      oncuredright = function()
        removeaff("mangledrightleg")
        addaff(dict.crippledrightleg)
      end
    }
  },
  crackedleftelbow = {
    salve = {
      aspriority = 46,
      spriority = 118,

      isadvisable = function ()
        return (affs.crackedleftelbow and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crackedleftelbow")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrackedleftelbow.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crackedleftelbow.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crackedleftelbow)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crackedleftelbow")
      end,
    }
  },
  curingcrackedleftelbow = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("crackedleftelbow")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crackedleftelbow")
        end)
      end
    }
  },
  crackedrightelbow = {
    salve = {
      aspriority = 47,
      spriority = 119,

      isadvisable = function ()
        return (affs.crackedrightelbow and codepaste.regen_arms()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crackedrightelbow")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrackedrightelbow.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to arms", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crackedrightelbow.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crackedrightelbow)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crackedrightelbow")
      end,
    }
  },
  curingcrackedrightelbow = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("crackedrightelbow")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crackedrightelbow")
        end)
      end
    }
  },
  shatteredleftankle = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.shatteredleftankle and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "shatteredleftankle")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingshatteredleftankle.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.shatteredleftankle.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shatteredleftankle)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shatteredleftankle")
      end,
    }
  },
  curingshatteredleftankle = {
    spriority = 0,
    waitingfor = {
      customwait = 4,

      ontimeout = function()
        removeaff("shatteredleftankle")
      end,

      oncompleted = function ()
        removeaff("shatteredleftankle")
        removeaff("paregenlegs")
      end,

      oncuredright  = function ()
        removeaff("shatteredrightankle")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure shatteredleftankle")
        end)
      end
    }
  },
  shatteredrightankle = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.shatteredrightankle and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "shatteredrightankle")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingshatteredrightankle.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.shatteredrightankle.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shatteredrightankle)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shatteredrightankle")
      end,
    }
  },
  curingshatteredrightankle = {
    spriority = 0,
    waitingfor = {
      customwait = 4,

      ontimeout = function()
        removeaff("shatteredrightankle")
      end,

      oncompleted = function ()
        removeaff("shatteredrightankle")
        removeaff("paregenlegs")
      end,

      oncuredleft = function ()
        removeaff("shatteredleftankle")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure shatteredrightankle")
        end)
      end
    }
  },
  tendonleft = {
    salve = {
      aspriority = 49,
      spriority = 120,

      isadvisable = function ()
        return (affs.tendonleft and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "tendonleft")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingtendonleft.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.tendonleft.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tendonleft)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("tendonleft")
      end,
    }
  },
  curingtendonleft = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      ontimeout = function()
        removeaff("tendonleft")
      end,

      oncompleted = function ()
        removeaff("tendonleft")
        removeaff("paregenlegs")
      end,

      oncuredright  = function ()
        removeaff("tendonright")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure tendonleft")
        end)
      end
    }
  },
  tendonright = {
    salve = {
      aspriority = 48,
      spriority = 121,

      isadvisable = function ()
        return (affs.tendonright and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "tendonright")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingtendonright.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.tendonright.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tendonright)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("tendonright")
      end,
    }
  },
  curingtendonright = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("tendonright")
        removeaff("paregenlegs")
      end,

      ontimeout = function()
        removeaff("tendonright")
      end,

      oncuredleft = function ()
        removeaff("tendonleft")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure tendonright")
        end)
      end
    }
  },
  tendonunknown = {
    salve = {
      aspriority = 48,
      spriority = 121,

      isadvisable = function ()
        return (affs.tendonunknown and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "tendonunknown")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingtendonunknown.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.tendonunknown.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tendonunknown)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("tendonunknown")
      end,
    }
  },
  curingtendonunknown = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("tendonunknown")
        removeaff("paregenlegs")
      end,

      ontimeout = function()
        removeaff("tendonunknown")
      end,

      oncuredleft = function ()
        removeaff("tendonleft")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure tendonunknown")
        end)
      end
    }
  },
  crackedunknownkneecap = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.crackedunknownkneecap and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crackedunknownkneecap")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrackedunknownkneecap.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crackedunknownkneecap.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crackedunknownkneecap)

        -- internally in Lusternia, they remove your current stance to make it not work
        sps.stance_currently = ""
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crackedunknownkneecap")
      end,
    }
  },
  curingcrackedunknownkneecap = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("crackedunknownkneecap")
        removeaff("paregenlegs")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crackedunknownkneecap")
        end)
      end,

      ontimeout  = function ()
        removeaff("crackedunknownkneecap")
      end,
    }
  },
  crackedleftkneecap = {
    salve = {
      aspriority = 45,
      spriority = 112,

      isadvisable = function ()
        return (affs.crackedleftkneecap and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crackedleftkneecap")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrackedleftkneecap.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crackedleftkneecap.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crackedleftkneecap)

        -- internally in Lusternia, they remove your current stance to make it not work
        sps.stance_currently = ""
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crackedleftkneecap")
      end,
    }
  },
  curingcrackedleftkneecap = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        if not affs.crackedleftkneecap and affs.crackedunknownkneecap then
          removeaff("crackedunknownkneecap")
        else
          removeaff("crackedleftkneecap")
        end

        removeaff("paregenlegs")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crackedleftkneecap")
        end)
      end,

      ontimeout  = function ()
        removeaff("crackedleftkneecap")
      end,
    }
  },
  crackedrightkneecap = {
    salve = {
      aspriority = 44,
      spriority = 113,

      isadvisable = function ()
        return (affs.crackedrightkneecap and codepaste.regen_legs()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crackedrightkneecap")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrackedrightkneecap.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to legs", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crackedrightkneecap.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crackedrightkneecap)

        -- internally in Lusternia, they remove your current stance to make it not work
        sps.stance_currently = ""
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crackedrightkneecap")
      end,
    }
  },
  curingcrackedrightkneecap = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        if not affs.crackedrightkneecap and affs.crackedunknownkneecap then
          removeaff("crackedunknownkneecap")
        else
          removeaff("crackedrightkneecap")
        end

        removeaff("paregenlegs")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crackedrightkneecap")
        end)
      end,

      ontimeout  = function ()
        removeaff("crackedleftkneecap")
      end,
    }
  },
  chestpain = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.chestpain and codepaste.regen_chest()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "chestpain")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingchestpain.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to chest", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.chestpain.salve.oncompleted()
      end
    },
    allheale = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.chestpain and (affs.slickness or affs.prone)) or false
      end,

      oncompleted = function ()
        removeaff("chestpain")
        removeaff("paregenchest")
        bals.allheale = false
      end,

      sipcure = "allheale",

      onstart = function ()
        send("sip allheale", conf.commandecho)
      end,

      empty = function ()
        bals.allheale = false
        empty.sip_allheale()
      end,

      woreoff = function()
        removeaff("chestpain")
        removeaff("paregenchest")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.chestpain)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("chestpain")
        removeaff("paregenchest")
      end,
    }
  },
  curingchestpain = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("chestpain")
        removeaff("paregenchest")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure chestpain")
        end)
      end
    }
  },
  crushedchest = {
    salve = {
      aspriority = 50,
      spriority = 128,

      isadvisable = function ()
        return false --[[(affs.crushedchest and codepaste.regen_chest()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "crushedchest")
#end
          ) or false]]
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcrushedchest.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to chest", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.crushedchest.salve.oncompleted()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 17,

      isadvisable = function ()
        return (affs.crushedchest and codepaste.ice_chest()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("crushedchest")
      end,

      onstart = function ()
        send("apply ice to chest", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingcrushedchest.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_chest()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crushedchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crushedchest")
        if not conf.oldwarrior then
          removeaff("paregenchest")
        end
      end,
    }
  },
  curingcrushedchest = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("crushedchest")
        if not conf.oldwarrior then
          removeaff("paregenchest")
          addaff(dict.puncturedlung)
        end
      end,

      onstart = function ()
        if not conf.aillusion then return end
          enableTrigger("m&m cure crushedchest")
      end
    }
  },
  damagedskull = {
    ice = {
      aspriority = 0,
      spriority = 27,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.damagedskull and codepaste.ice_head()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()
        removeaff("damagedskull")
      end,

      onstart = function ()
        send("apply ice to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingdamagedskull.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_head()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedskull)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedskull")
      end,
    }
  },
  curingdamagedskull = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedskull")
      end,

      onstart = function ()
      end
    }
  },
  damagedthroat = {
    ice = {
      aspriority = 0,
      spriority = 35,

      isadvisable = function ()
        return (affs.damagedthroat and codepaste.ice_head()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()
        removeaff("damagedthroat")
      end,

      onstart = function ()
        send("apply ice to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()
        doaction(dict.curingdamagedthroat.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_head()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedthroat)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedthroat")
      end,
    }
  },
  curingdamagedthroat = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedthroat")
      end,

      onstart = function ()
      end
    }
  },
  damagedorgans = {
    ice = {
      aspriority = 0,
      spriority = 16,

      isadvisable = function ()
        return (affs.damagedorgans and codepaste.ice_gut()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("damagedorgans")
      end,

      onstart = function ()
        send("apply ice to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingdamagedorgans.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_gut()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedorgans)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedorgans")
      end,
    }
  },
  curingdamagedorgans = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedorgans")
      end,

      onstart = function ()
      end
    }
  },
  internalbleeding = {
    ice = {
      aspriority = 0,
      spriority = 15,

      isadvisable = function ()
        return (affs.internalbleeding and codepaste.ice_gut()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("internalbleeding")
      end,

      onstart = function ()
        send("apply ice to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curinginternalbleeding.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_gut()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.internalbleeding)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("internalbleeding")
      end,
    }
  },
  curinginternalbleeding = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("internalbleeding")
      end,

      onstart = function ()
      end
    }
  },
  damagedleftarm = {
    ice = {
      aspriority = 0,
      spriority = 20,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.damagedleftarm and codepaste.ice_leftarm()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("damagedleftarm")
      end,

      onstart = function ()
        send("apply ice to larm", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingdamagedleftarm.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_leftarm()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedleftarm")
      end,
    }
  },
  curingdamagedleftarm = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedleftarm")
      end,

      onstart = function ()
      end
    }
  },
  mutilatedleftarm = {
    ice = {
      aspriority = 0,
      spriority = 24,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.mutilatedleftarm and codepaste.ice_leftarm()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("mutilatedleftarm")
      end,

      onstart = function ()
        send("apply ice to larm", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingmutilatedleftarm.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_leftarm()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mutilatedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mutilatedleftarm")
      end,
    }
  },
  curingmutilatedleftarm = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("mutilatedleftarm")
      end,

      onstart = function ()
      end
    }
  },
  damagedrightarm = {
    ice = {
      aspriority = 0,
      spriority = 19,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.damagedrightarm and codepaste.ice_rightarm()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("damagedrightarm")
      end,

      onstart = function ()
        send("apply ice to rarm", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingdamagedrightarm.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_rightarm()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedrightarm")
      end,
    }
  },
  curingdamagedrightarm = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedrightarm")
      end,

      onstart = function ()
      end
    }
  },
  mutilatedrightarm = {
    ice = {
      aspriority = 0,
      spriority = 23,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.mutilatedrightarm and codepaste.ice_rightarm()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("mutilatedrightarm")
      end,

      onstart = function ()
        send("apply ice to rarm", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingmutilatedrightarm.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_rightarm()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mutilatedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mutilatedrightarm")
      end,
    }
  },
  curingmutilatedrightarm = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("mutilatedrightarm")
      end,

      onstart = function ()
      end
    }
  },
  damagedleftleg = {
    ice = {
      aspriority = 0,
      spriority = 22,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.damagedleftleg and codepaste.ice_leftleg()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("damagedleftleg")
      end,

      onstart = function ()
        send("apply ice to lleg", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingdamagedleftleg.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_leftleg()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedleftleg")
      end,
    }
  },
  curingdamagedleftleg = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedleftleg")
      end,

      onstart = function ()
      end
    }
  },
  mutilatedleftleg = {
    ice = {
      aspriority = 0,
      spriority = 26,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.mutilatedleftleg and codepaste.ice_leftleg()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("mutilatedleftleg")
      end,

      onstart = function ()
        send("apply ice to lleg", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingmutilatedleftleg.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_leftleg()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mutilatedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mutilatedleftleg")
      end,
    }
  },
  curingmutilatedleftleg = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("mutilatedleftleg")
      end,

      onstart = function ()
      end
    }
  },
  damagedrightleg = {
    ice = {
      aspriority = 0,
      spriority = 21,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.damagedrightleg and codepaste.ice_rightleg()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()
        removeaff("damagedrightleg")
      end,

      onstart = function ()
        send("apply ice to rleg", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()
        doaction(dict.curingdamagedrightleg.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_rightleg()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedrightleg")
      end,
    }
  },
  curingdamagedrightleg = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("damagedrightleg")
      end,

      onstart = function ()
      end
    }
  },
  mutilatedrightleg = {
    ice = {
      aspriority = 0,
      spriority = 25,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.mutilatedrightleg and codepaste.ice_rightleg()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("mutilatedrightleg")
      end,

      onstart = function ()
        send("apply ice to rleg", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingmutilatedrightleg.waitingfor)
      end,

      noeffect = function()
        sk.lostbal_ice()
        empty.noeffect_ice_rightleg()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mutilatedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("mutilatedrightleg")
      end,
    }
  },
  curingmutilatedrightleg = {
    spriority = 0,
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        removeaff("mutilatedrightleg")
      end,

      onstart = function ()
      end
    }
  },
  paregenchest = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.paregenchest and codepaste.regen_chest()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "paregenchest")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingparegenchest.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to chest", conf.commandecho)
      end,

      empty = function ()
        dict.paregenchest.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.paregenchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("paregenchest")
      end,
    }
  },
  curingparegenchest = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("paregenchest")
      end,

      ontimeout = function ()
        removeaff("paregenchest")
      end,

      onstart = function ()
      end
    }
  },
  collapsedlungs = {
    salve = {
      aspriority = 41,
      spriority = 108,

      isadvisable = function ()
        return --[[(affs.collapsedlungs and codepaste.regen_chest()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "collapsedlungs")
#end
          ) or]] false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingcollapsedlungs.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to chest", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.collapsedlungs.salve.oncompleted()
      end
    },
    ice = {
      aspriority = 0,
      spriority = 18,

      isadvisable = function ()
        return (affs.collapsedlungs and codepaste.ice_chest()) or false
      end,

      oncompleted = function ()
        sk.lostbal_ice()

        removeaff("collapsedlungs")
      end,

      onstart = function ()
        send("apply ice to chest", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        sk.lostbal_ice()

        doaction(dict.curingcollapsedlungs.waitingfor)
      end,

      noeffect = function()
        empty.noeffect_ice_chest()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.collapsedlungs)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("collapsedlungs")
        if not conf.oldwarrior then
          removeaff("paregenchest")
        end
      end,
    }
  },
  curingcollapsedlungs = {
    spriority = 0,
    waitingfor = {
      customwait = 3, -- real is 4

      ontimeout = function()
        removeaff("collapsedlungs")
        if not conf.oldwarrior then
          removeaff("paregenchest")
        end
      end,

      oncompleted = function ()
        removeaff("collapsedlungs")
        if not conf.oldwarrior then
          removeaff("paregenchest")
        end
      end,

      onstart = function ()
        if not conf.aillusion then return end
        enableTrigger("m&m cure collapsedlungs")
      end
    }
  },

  rupturedstomach = {
    salve = {
      aspriority = 51,
      spriority = 129,

      isadvisable = function ()
        return (affs.rupturedstomach and codepaste.regen_gut()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "rupturedstomach")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingrupturedstomach.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.rupturedstomach.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.rupturedstomach)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("rupturedstomach")
      end,
    }
  },
  curingrupturedstomach = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("rupturedstomach")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure rupturedstomach")
        end)
      end,
    }
  },
  burstorgans = {
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.burstorgans and codepaste.regen_gut()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "burstorgans")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingburstorgans.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.burstorgans.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.burstorgans)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("burstorgans")
      end,
    }
  },
  curingburstorgans = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("burstorgans")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure burstorgans")
        end)
      end,
    }
  },
  severedspine = {
    salve = {
      aspriority = 52,
      spriority = 226,

      isadvisable = function ()
        return (affs.severedspine and codepaste.regen_gut()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "severedspine")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingseveredspine.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.severedspine.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.severedspine)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("severedspine")
      end,
    }
  },
  curingseveredspine = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("severedspine")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure severedspine")
        end)
      end,
    }
  },
  disembowel = {
    salve = {
      aspriority = 15,
      spriority = 122,

      isadvisable = function ()
        return (affs.disembowel and codepaste.regen_gut()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "disembowel")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingdisembowel.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to gut", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.disembowel.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.disembowel)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("disembowel")
      end,
    }
  },
  curingdisembowel = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("disembowel")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure disembowel")
        end)
      end,
    }
  },

  damagedhead = {
    salve = {
      aspriority = 53,
      spriority = 255,

      isadvisable = function ()
        return (affs.damagedhead and codepaste.regen_head()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "damagedhead")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingdamagedhead.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.damagedhead.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.damagedhead)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("damagedhead")
      end,
    }
  },
  curingdamagedhead = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("damagedhead")
      end,

      partial = function ()
        -- nothing happens! We need to apply again, and other things will take care for us of that
      end,

      ontimeout  = function ()
        removeaff("damagedhead")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure damagedhead")
        end)
      end,
    }
  },
  eyepeckleft = {
    salve = {
      aspriority = 7,
      spriority = 269,

      isadvisable = function ()
        return (affs.eyepeckleft and codepaste.regen_head()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "eyepeckleft")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingeyepeckleft.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.eyepeckleft.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.eyepeckleft)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("eyepeckleft")
      end
    }
  },
  curingeyepeckleft = {
    spriority = 0,
    waitingfor = {
      customwait = 6, -- 4s to cure

      oncompleted = function ()
        removeaff("eyepeckleft")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure eyepeckleft")
        end)
      end
    }
  },
  eyepeckright = {
    salve = {
      aspriority = 8,
      spriority = 268,

      isadvisable = function ()
        return (affs.eyepeckright and codepaste.regen_head()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "eyepeckright")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingeyepeckright.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.eyepeckright.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.eyepeckright)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("eyepeckright")
      end
    }
  },
  curingeyepeckright = {
    spriority = 0,
    waitingfor = {
      customwait = 6, -- 4s to cure

      oncompleted = function ()
        removeaff("eyepeckright")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure eyepeckright")
        end)
      end
    }
  },
  shatteredjaw = {
    salve = {
      aspriority = 9,
      spriority = 267,

      isadvisable = function ()
        return (affs.shatteredjaw and codepaste.regen_head()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "shatteredjaw")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingshatteredjaw.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.shatteredjaw.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shatteredjaw)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("shatteredjaw")
      end
    }
  },
  curingshatteredjaw = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("shatteredjaw")
        addaff(dict.brokenjaw)
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure shatteredjaw")
        end)
      end
    }
  },
  concussion = {
    salve = {
      aspriority = 39,
      spriority = 39,

      isadvisable = function ()
        return (affs.concussion and codepaste.regen_head()
#if skills.healing then
        and not (actions.usehealing_misc and dict.usehealing.curingaff == "concussion")
#end
          ) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()

        doaction(dict.curingconcussion.waitingfor)
      end,

      onstart = function ()
        send("apply regeneration to head", conf.commandecho)
      end,

      -- we get no msg from an application of this
      empty = function ()
        dict.concussion.salve.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.concussion)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("concussion")
      end,
    }
  },
  curingconcussion = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- 3.5s to cure

      oncompleted = function ()
        removeaff("concussion")
        addaff(dict.damagedhead)
      end,

      ontimeout = function()
        removeaff("concussion")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure concussion")
        end)
      end,
    }
  },

  clotleftshoulder = {
    herb = {
      aspriority = 116,
      spriority = 170,

      isadvisable = function ()
        return (affs.clotleftshoulder) or false
      end,

      oncompleted = function ()
        removeaff("clotleftshoulder")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.clotleftshoulder) or false
      end,

      oncompleted = function ()
        removeaff("clotleftshoulder")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "wafer",
      onstart = function ()
        eat("wafer")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clotleftshoulder)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clotleftshoulder")
      end,
    }
  },
  clotrightshoulder = {
    herb = {
      aspriority = 117,
      spriority = 171,

      isadvisable = function ()
        return (affs.clotrightshoulder) or false
      end,

      oncompleted = function ()
        removeaff("clotrightshoulder")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.clotrightshoulder) or false
      end,

      oncompleted = function ()
        removeaff("clotrightshoulder")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "wafer",
      onstart = function ()
        eat("wafer")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clotrightshoulder)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clotrightshoulder")
      end,
    }
  },
  clotrighthip = {
    herb = {
      aspriority = 118,
      spriority = 172,

      isadvisable = function ()
        return (affs.clotrighthip) or false
      end,

      oncompleted = function ()
        removeaff("clotrighthip")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.clotrighthip) or false
      end,

      oncompleted = function ()
        removeaff("clotrighthip")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "wafer",
      onstart = function ()
        eat("wafer")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clotrighthip)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clotrighthip")
      end,
    }
  },
  clotlefthip = {
    herb = {
      aspriority = 119,
      spriority = 173,

      isadvisable = function ()
        return (affs.clotlefthip) or false
      end,

      oncompleted = function ()
        removeaff("clotlefthip")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.clotlefthip) or false
      end,

      oncompleted = function ()
        removeaff("clotlefthip")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "wafer",
      onstart = function ()
        eat("wafer")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clotlefthip)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clotlefthip")
      end,
    }
  },
  laceratedleftarm = {
    herb = {
      aspriority = 82,
      spriority = 130,

      isadvisable = function ()
        return (affs.laceratedleftarm) or false
      end,

      oncompleted = function ()
        removeaff("laceratedleftarm")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.laceratedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("laceratedleftarm")
      end,
    },
    onremoved = function()
      if affs.laceratedunknown then
        dict.laceratedunknown.count = dict.laceratedunknown.count - 1
        if dict.laceratedunknown.count <= 0 then removeaff"laceratedunknown" end
      end
    end,
  },
  laceratedrightarm = {
    herb = {
      aspriority = 83,
      spriority = 131,

      isadvisable = function ()
        return (affs.laceratedrightarm) or false
      end,

      oncompleted = function ()
        removeaff("laceratedrightarm")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.laceratedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("laceratedrightarm")
      end,
    },
    onremoved = function()
      if affs.laceratedunknown then
        dict.laceratedunknown.count = dict.laceratedunknown.count - 1
        if dict.laceratedunknown.count <= 0 then removeaff"laceratedunknown" end
      end
    end,
  },
  laceratedrightleg = {
    herb = {
      aspriority = 84,
      spriority = 132,

      isadvisable = function ()
        return (affs.laceratedrightleg) or false
      end,

      oncompleted = function ()
        removeaff("laceratedrightleg")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.laceratedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("laceratedrightleg")
      end,
    },
    onremoved = function()
      if affs.laceratedunknown then
        dict.laceratedunknown.count = dict.laceratedunknown.count - 1
        if dict.laceratedunknown.count <= 0 then removeaff"laceratedunknown" end
      end
    end,
  },
  laceratedleftleg = {
    herb = {
      aspriority = 85,
      spriority = 133,

      isadvisable = function ()
        return (affs.laceratedleftleg) or false
      end,

      oncompleted = function ()
        removeaff("laceratedleftleg")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.laceratedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("laceratedleftleg")
      end,
    },
    onremoved = function()
      if affs.laceratedunknown then
        dict.laceratedunknown.count = dict.laceratedunknown.count - 1
        if dict.laceratedunknown.count <= 0 then removeaff"laceratedunknown" end
      end
    end,
  },
  laceratedunknown = {
    count = 0,
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.laceratedunknown) or false
      end,

      oncompleted = function ()
        removeaff("laceratedunknown")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        dict.laceratedunknown.count = dict.laceratedunknown.count + 1
        addaff(dict.laceratedunknown)
      end,
    },
    gone = {
      oncompleted = function ()
        dict.laceratedunknown.count = 0
        removeaff("laceratedunknown")
      end,
    },
    onremoved = function()
      if dict.laceratedunknown.count <= 0 then return end

      dict.laceratedunknown.count = dict.laceratedunknown.count - 1
      addaff (dict.laceratedunknown)
    end
  },
  relapsing = {
    herb = {
      aspriority = 81,
      spriority = 125,

      isadvisable = function ()
        return (affs.relapsing) or false
      end,

      oncompleted = function ()
        removeaff("relapsing")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.relapsing)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("relapsing")
      end,
    }
  },
  slicedforehead = {
    herb = {
      aspriority = 12,
      spriority = 91,

      isadvisable = function ()
        return (affs.slicedforehead and not affs.scalped) or false
      end,

      oncompleted = function ()
        removeaff("slicedforehead")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedforehead)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedforehead")
      end,
    }
  },
  arteryleftleg = {
    herb = {
      aspriority = 45,
      spriority = 89,

      isadvisable = function ()
        return (affs.arteryleftleg) or false
      end,

      oncompleted = function ()
        removeaff("arteryleftleg")
        sk.lostbal_herb()
      end,

      oncuredright = function ()
        removeaff("arteryrightleg")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.arteryleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("arteryleftleg")
      end,
    }
  },
  arteryrightleg = {
    herb = {
      aspriority = 44,
      spriority = 88,

      isadvisable = function ()
        return (affs.arteryrightleg) or false
      end,

      oncompleted = function ()
        removeaff("arteryrightleg")
        sk.lostbal_herb()
      end,

      oncuredleft = function ()
        removeaff("arteryleftleg")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.arteryrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("arteryrightleg")
      end,
    }
  },
  arteryleftarm = {
    herb = {
      aspriority = 43,
      spriority = 87,

      isadvisable = function ()
        return (affs.arteryleftarm) or false
      end,

      oncompleted = function ()
        removeaff("arteryleftarm")
        sk.lostbal_herb()
      end,

      oncuredright = function ()
        removeaff("arteryrightarm")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.arteryleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("arteryleftarm")
      end,
    }
  },
  arteryrightarm = {
    herb = {
      aspriority = 42,
      spriority = 86,

      isadvisable = function ()
        return (affs.arteryrightarm) or false
      end,

      oncompleted = function ()
        removeaff("arteryrightarm")
        sk.lostbal_herb()
      end,

      oncuredleft = function ()
        removeaff("arteryleftarm")
        sk.lostbal_herb()
      end,

      eatcure = "yarrow",
      onstart = function ()
        eat("yarrow")
      end,

      empty = function()
        empty.eat_yarrow()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.arteryrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("arteryrightarm")
      end,
    }
  },

  openchest = {
    herb = {
      aspriority = 126,
      spriority = 202,

      isadvisable = function ()
        return (affs.openchest) or false
      end,

      oncompleted = function ()
        removeaff("openchest")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.openchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("openchest")
      end,
    }
  },
  rigormortis = {
    herb = {
      aspriority = 123,
      spriority = 193,

      isadvisable = function ()
        return (affs.rigormortis) or false
      end,

      oncompleted = function ()
        removeaff("rigormortis")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.rigormortis and not doingaction "rigormortis") or false
      end,

      oncompleted = function ()
        removeaff("rigormortis")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("rigormortis", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.rigormortis)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("rigormortis")
      end,
    }
  },
  gashedcheek = {
    herb = {
      aspriority = 122,
      spriority = 192,

      isadvisable = function ()
        return (affs.gashedcheek) or false
      end,

      oncompleted = function ()
        removeaff("gashedcheek")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.gashedcheek)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("gashedcheek")
      end,
    }
  },
  dislocatedleftarm = {
    herb = {
      aspriority = 114,
      spriority = 166,

      isadvisable = function ()
        return (affs.dislocatedleftarm) or false
      end,

      oncompleted = function ()
        removeaff("dislocatedleftarm")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dislocatedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dislocatedleftarm")
      end,
    }
  },
  dislocatedrightarm = {
    herb = {
      aspriority = 113,
      spriority = 165,

      isadvisable = function ()
        return (affs.dislocatedrightarm) or false
      end,

      oncompleted = function ()
        removeaff("dislocatedrightarm")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dislocatedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dislocatedrightarm")
      end,
    }
  },
  dislocatedrightleg = {
    herb = {
      aspriority = 112,
      spriority = 164,

      isadvisable = function ()
        return (affs.dislocatedrightleg) or false
      end,

      oncompleted = function ()
        removeaff("dislocatedrightleg")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dislocatedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dislocatedrightleg")
      end,
    }
  },
  dislocatedleftleg = {
    herb = {
      aspriority = 111,
      spriority = 163,

      isadvisable = function ()
        return (affs.dislocatedleftleg) or false
      end,

      oncompleted = function ()
        removeaff("dislocatedleftleg")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dislocatedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dislocatedleftleg")
      end,
    }
  },
  slicedtongue = {
    herb = {
      aspriority = 108,
      spriority = 160,

      isadvisable = function ()
        return (affs.slicedtongue) or false
      end,

      oncompleted = function ()
        removeaff("slicedtongue")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedtongue)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedtongue")
      end,
    }
  },
  puncturedchest = {
    herb = {
      aspriority = 3,
      spriority = 104,

      isadvisable = function ()
        return (affs.puncturedchest) or false
      end,

      oncompleted = function ()
        removeaff("puncturedchest")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.puncturedchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("puncturedchest")
      end,
    }
  },
  bicepright = {
    herb = {
      aspriority = 109,
      spriority = 161,

      isadvisable = function ()
        return (affs.bicepright) or false
      end,

      oncompleted = function ()
        removeaff("bicepright")
        sk.lostbal_herb()
      end,

      oncuredleft = function ()
        removeaff("bicepleft")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.bicepright)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("bicepright")
      end,
    }
  },
  bicepleft = {
    herb = {
      aspriority = 110,
      spriority = 162,

      isadvisable = function ()
        return (affs.bicepleft) or false
      end,

      oncompleted = function ()
        removeaff("bicepleft")
        sk.lostbal_herb()
      end,

      oncuredright = function ()
        removeaff("bicepright")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.bicepleft)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("bicepleft")
      end,
    }
  },
  missingrightear = {
    herb = {
      aspriority = 4,
      spriority = 102,

      isadvisable = function ()
        return (affs.missingrightear) or false
      end,

      oncompleted = function ()
        removeaff("missingrightear")
        sk.lostbal_herb()
      end,

      oncuredleft = function ()
        removeaff("missingleftear")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.missingrightear)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingrightear")
      end,
    }
  },
  missingleftear = {
    herb = {
      aspriority = 2,
      spriority = 103,

      isadvisable = function ()
        return (affs.missingleftear) or false
      end,

      oncompleted = function ()
        removeaff("missingleftear")
        sk.lostbal_herb()
      end,

      oncuredright = function ()
        removeaff("missingrightear")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.missingleftear)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("missingleftear")
      end,
    }
  },
  slicedrightbicep = {
    herb = {
      aspriority = 135,
      spriority = 260,

      isadvisable = function ()
        return (affs.slicedrightbicep) or false
      end,

      oncompleted = function ()
        removeaff("slicedrightbicep")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedrightbicep)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedrightbicep")
      end,
    }
  },
  slicedleftbicep = {
    herb = {
      aspriority = 136,
      spriority = 259,

      isadvisable = function ()
        return (affs.slicedleftbicep) or false
      end,

      oncompleted = function ()
        removeaff("slicedleftbicep")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedleftbicep)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedleftbicep")
      end,
    }
  },
  slicedrightthigh = {
    herb = {
      aspriority = 7,
      spriority = 99,

      isadvisable = function ()
        return (affs.slicedrightthigh) or false
      end,

      oncompleted = function ()
        removeaff("slicedrightthigh")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedrightthigh)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedrightthigh")
      end,
    }
  },
  slicedleftthigh = {
    herb = {
      aspriority = 8,
      spriority = 98,

      isadvisable = function ()
        return (affs.slicedleftthigh) or false
      end,

      oncompleted = function ()
        removeaff("slicedleftthigh")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slicedleftthigh)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slicedleftthigh")
      end,
    }
  },
  stiffleftarm = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.stiffleftarm) or false
      end,

      oncompleted = function ()
        removeaff("stiffleftarm")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stiffleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stiffleftarm")
      end,
    }
  },
  stiffrightarm = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.stiffrightarm) or false
      end,

      oncompleted = function ()
        removeaff("stiffrightarm")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stiffrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stiffrightarm")
      end,
    }
  },
  stiffgut = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.stiffgut) or false
      end,

      oncompleted = function ()
        removeaff("stiffgut")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stiffgut)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stiffgut")
      end,
    }
  },
  stiffchest = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.stiffchest) or false
      end,

      oncompleted = function ()
        removeaff("stiffchest")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stiffchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stiffchest")
      end,
    }
  },
  stiffhead = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.stiffhead) or false
      end,

      oncompleted = function ()
        removeaff("stiffhead")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stiffhead)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stiffhead")
      end,
    }
  },
  opengut = {
    herb = {
      aspriority = 13,
      spriority = 92,

      isadvisable = function ()
        return (affs.opengut) or false
      end,

      oncompleted = function ()
        removeaff("opengut")
        sk.lostbal_herb()
      end,

      eatcure = "marjoram",
      onstart = function ()
        eat("marjoram")
      end,

      empty = function()
        empty.eat_marjoram()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.opengut)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("opengut")
      end,
    }
  },
  omniphobia = {
    herb = {
      aspriority = 96,
      spriority = 147,

      isadvisable = function ()
        return (affs.omniphobia) or false
      end,

      oncompleted = function ()
        removeaff("omniphobia")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function()
          empty.eat_kombu()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.omniphobia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("omniphobia")
      end,
    }
  },
  deadening = {
    herb = {
      aspriority = 94,
      spriority = 144,

      isadvisable = function ()
        return (affs.deadening) or false
      end,

      oncompleted = function ()
        removeaff("deadening")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function()
          empty.eat_kombu()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.deadening)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("deadening")
      end,
    }
  },
  clumsiness = {
    herb = {
      aspriority = 60,
      spriority = 60,

      isadvisable = function ()
        return (affs.clumsiness) or false
      end,

      oncompleted = function ()
        removeaff("clumsiness")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function()
          empty.eat_kombu()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.clumsiness and not doingaction("clumsiness")) or false
      end,

      oncompleted = function ()
        removeaff("clumsiness")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("clumsiness", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clumsiness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clumsiness")
      end,
    }
  },
  slickness = {
    herb = {
      aspriority = 80,
      spriority = 80,

      isadvisable = function ()
        return (affs.slickness and not doingaction("slickness")) or false
      end,

      oncompleted = function ()
        removeaff("slickness")
        removeaff("unknownsteam")
        sk.lostbal_herb()
      end,

      eatcure = "calamus",
      onstart = function ()
        eat("calamus")
      end,

      empty = function()
        empty.eat_calamus()
      end
    },
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      -- should only be advised by the dict.cleanse
      isadvisable = function ()
        return (affs.slickness and affs.asthma and affs.anorexia and codepaste.havetempwarps())
      end,

      oncompleted = function ()
        removeaff("slickness")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.slickness and not doingaction("slickness")) or false
      end,

      oncompleted = function ()
        removeaff("slickness")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("slickness", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slickness)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slickness")
      end,
    }
  },
  confusion = {
    herb = {
      aspriority = 89,
      spriority = 139,

      isadvisable = function ()
        return (affs.confusion and
          not doingaction("confusion")) or false
      end,

      oncompleted = function ()
        removeaff("confusion")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    purgative = {
      aspriority = 16,
      spriority = 140,

      isadvisable = function ()
        return (affs.confusion and
          not doingaction("confusion")) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("confusion")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "sanguine",
      onstart = function ()
        send("sip sanguine", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        removeaff("confusion")
      end
    },
    focus = {
      aspriority = 17,
      spriority = 223,

      isadvisable = function ()
        return (affs.confusion and
          not doingaction("confusion")) or false
      end,

      oncompleted = function ()
        removeaff("confusion")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.confusion and not doingaction("confusion")) or false
      end,

      oncompleted = function ()
        removeaff("confusion")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("confusion", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.confusion)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("confusion")
      end,
    }
  },
  void = {
    herb = {
      aspriority = 93,
      spriority = 143,

      isadvisable = function ()
        return (affs.void and
          not doingaction("void")) or false
      end,

      oncompleted = function ()
        removeaff("void")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 3,
      spriority = 218,

      isadvisable = function ()
        return (affs.void and
          not doingaction("void")) or false
      end,

      oncompleted = function ()
        removeaff("void")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    purgative = {
      aspriority = 30,
      spriority = 300,

      isadvisable = function ()
        return (affs.void and not doingaction "void") or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("void")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function()
        sk.lostbal_purgative()
        empty.sip_phlegmatic()
      end,

      sipcure = "phlegmatic",

      onstart = function ()
        send("sip phlegmatic", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.void)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("void")
      end,
    }
  },
  scrambledbrain = {
    herb = {
      aspriority = 92,
      spriority = 142,

      isadvisable = function ()
        return (affs.scrambledbrain) or false
      end,

      oncompleted = function ()
        removeaff("scrambledbrain")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.scrambledbrain)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("scrambledbrain")
      end,
    }
  },
  hallucinating = {
    herb = {
      aspriority = 91,
      spriority = 141,

      isadvisable = function ()
        return (affs.hallucinating and
          not doingaction("hallucinating")) or false
      end,

      oncompleted = function ()
        removeaff("hallucinating")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 35,
      spriority = 309,

      isadvisable = function ()
        return (affs.hallucinating and
          not doingaction("hallucinating")) or false
      end,

      oncompleted = function ()
        removeaff("hallucinating")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.hallucinating and not doingaction("hallucinating")) or false
      end,

      oncompleted = function ()
        removeaff("hallucinating")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("hallucinating", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hallucinating)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hallucinating")
      end,
    }
  },
  paranoia = {
    herb = {
      aspriority = 47,
      spriority = 114,

      isadvisable = function ()
        return (affs.paranoia and
          not doingaction("paranoia")) or false
      end,

      oncompleted = function ()
        removeaff("paranoia")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 8,
      spriority = 212,

      isadvisable = function ()
        return (affs.paranoia and
          not doingaction("paranoia")) or false
      end,

      oncompleted = function ()
        removeaff("paranoia")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.paranoia and not doingaction("paranoia")) or false
      end,

      oncompleted = function ()
        removeaff("paranoia")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("paranoia", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.paranoia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("paranoia")
      end,
    }
  },
  fracturedleftarm = {
    herb = {
      aspriority = 125,
      spriority = 197,

      isadvisable = function ()
        return (affs.fracturedleftarm) or false
      end,

      oncompleted = function ()
        removeaff("fracturedleftarm")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("arms")
      end,

      empty = function()
          empty.applyarnica_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.fracturedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fracturedleftarm")
      end,
    }
  },
  fracturedrightarm = {
    herb = {
      aspriority = 124,
      spriority = 196,

      isadvisable = function ()
        return (affs.fracturedrightarm) or false
      end,

      oncompleted = function ()
        removeaff("fracturedrightarm")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("arms")
      end,

      empty = function()
          empty.applyarnica_arms()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.fracturedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fracturedrightarm")
      end,
    }
  },
  crushedleftfoot = {
    herb = {
      aspriority = 48,
      spriority = 116,

      isadvisable = function ()
        return (affs.crushedleftfoot) or false
      end,

      oncompleted = function ()
        removeaff("crushedleftfoot")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("legs")
      end,

      empty = function()
          empty.applyarnica_legs()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crushedleftfoot)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crushedleftfoot")
      end,
    }
  },
  crushedrightfoot = {
    herb = {
      aspriority = 49,
      spriority = 117,

      isadvisable = function ()
        return (affs.crushedrightfoot) or false
      end,

      oncompleted = function ()
        removeaff("crushedrightfoot")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("legs")
      end,

      empty = function()
          empty.applyarnica_legs()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crushedrightfoot)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crushedrightfoot")
      end,
    }
  },
  brokenchest = {
    herb = {
      aspriority = 144,
      spriority = 314,

      isadvisable = function ()
        return (affs.brokenchest) or false
      end,

      oncompleted = function ()
        removeaff("brokenchest")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("chest")
      end,

      empty = function()
          empty.applyarnica_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.brokenchest)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("brokenchest")
      end,
    }
  },
  snappedrib = {
    herb = {
      aspriority = 115,
      spriority = 167,

      isadvisable = function ()
        return (affs.snappedrib) or false
      end,

      oncompleted = function ()
        removeaff("snappedrib")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("chest")
      end,

      empty = function()
          empty.applyarnica_chest()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.snappedrib)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("snappedrib")
      end,
    }
  },
  brokennose = {
    herb = {
      aspriority = 11,
      spriority = 93,

      isadvisable = function ()
        return (affs.brokennose) or false
      end,

      oncompleted = function ()
        removeaff("brokennose")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("head")
      end,

      empty = function()
        empty.applyarnica_head()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.brokennose)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("brokennose")
      end,
    }
  },
  attraction = {
    eaten = false,
    herb = {
      aspriority = 132,
      spriority = 256,

      isadvisable = function ()
        return (affs.attraction and not affs.earache and
          not doingaction("attraction") and not dict.attraction.eaten) or false
      end,

      oncompleted = function ()
        dict.attraction.eaten = true
        sk.lostbal_herb()
        signals.newroom:unblock(sk.check_attraction)
      end,

      earache = function ()
        sk.lostbal_herb()
        if not affs.earache then addaff(dict.earache) end
      end,

      woreoff = function()
        removeaff("attraction")
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        empty.eat_earwort()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --[[return (affs.attraction and not affs.earache and
          not doingaction("attraction") and not dict.attraction.eaten) or false]]
          return false
      end,

      oncompleted = function ()
        dict.attraction.eaten = true
        sk.lostbal_wafer()
        signals.newroom:unblock(sk.check_attraction)
      end,

      earache = function ()
        sk.lostbal_wafer()
        if not affs.earache then addaff(dict.earache) end
      end,

      woreoff = function()
        removeaff("attraction")
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        empty["eat_earwort"]()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.attraction and not affs.earache and codepaste.smoke_steam_pipe() and not doingaction("attraction") and not dict.attraction.eaten) or false
      end,

      oncompleted = function (def)
        dict.attraction.eaten = true
        sk.lostbal_steam()
        signals.newroom:unblock(sk.check_attraction)
      end,

      earache = function ()
        sk.lostbal_steam()
        if not affs.earache then addaff(dict.earache) end
      end,

      woreoff = function()
        removeaff("attraction")
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        empty.smoke_steam()
        sk.lostbal_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.attraction)
        dict.attraction.eaten = false
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("attraction")
      end,
    }
  },
  vertigo = {
    herb = {
      aspriority = 18,
      spriority = 18,

      isadvisable = function ()
        return (affs.vertigo and
          not doingaction("vertigo")) or false
      end,

      oncompleted = function ()
        removeaff("vertigo")
        sk.lostbal_herb()
      end,

      eatcure = "myrtle",
      onstart = function ()
        eat("myrtle")
      end,

      empty = function()
          empty.eat_myrtle()
      end
    },
    focus = {
      aspriority = 4,
      spriority = 12,

      isadvisable = function ()
        return (affs.vertigo and
          not doingaction("vertigo")) or false
      end,

      oncompleted = function ()
        removeaff("vertigo")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vertigo)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("vertigo")
      end,
    }
  },

  massiveinsanity = {
    herb = {
      aspriority = 143,
      spriority = 299,

      isadvisable = function ()
        return (affs.massiveinsanity and
          not doingaction("massiveinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("massiveinsanity")
        addaff(dict.majorinsanity)
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 34,
      spriority = 304,

      isadvisable = function ()
        return (affs.massiveinsanity and
          not doingaction("massiveinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("massiveinsanity")
        addaff(dict.majorinsanity)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.massiveinsanity and
          not doingaction("massiveinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("massiveinsanity")
        addaff(dict.majorinsanity)
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        send("sip lucidity tempinsanity", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_lucidity()
        empty.sip_lucidity()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.massiveinsanity)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("massiveinsanity")
      end,
    }
  },
  majorinsanity = {
    herb = {
      aspriority = 142,
      spriority = 298,

      isadvisable = function ()
        return (affs.majorinsanity and
          not doingaction("majorinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("majorinsanity")
        addaff(dict.moderateinsanity)
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 33,
      spriority = 303,

      isadvisable = function ()
        return (affs.majorinsanity and
          not doingaction("majorinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("majorinsanity")
        addaff(dict.moderateinsanity)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.majorinsanity and
          not doingaction("majorinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("majorinsanity")
        addaff(dict.moderateinsanity)
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        send("sip lucidity tempinsanity", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_lucidity()
        empty.sip_lucidity()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.majorinsanity)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("majorinsanity")
      end,
    }
  },
  moderateinsanity = {
    herb = {
      aspriority = 141,
      spriority = 297,

      isadvisable = function ()
        return (affs.moderateinsanity and
          not doingaction("moderateinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("moderateinsanity")
        addaff(dict.slightinsanity)
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 32,
      spriority = 302,

      isadvisable = function ()
        return (affs.moderateinsanity and
          not doingaction("moderateinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("moderateinsanity")
        addaff(dict.slightinsanity)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.moderateinsanity and
          not doingaction("moderateinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("moderateinsanity")
        addaff(dict.slightinsanity)
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        send("sip lucidity tempinsanity", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_lucidity()

        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.moderateinsanity)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff "moderateinsanity"
      end
    }
  },
  slightinsanity = {
    herb = {
      aspriority = 140,
      spriority = 296,

      isadvisable = function ()
        return (affs.slightinsanity and
          not doingaction("slightinsanity")) or false
      end,

      oncompleted = function ()
        codepaste.remove_insanities()
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 31,
      spriority = 301,

      isadvisable = function ()
        return (affs.slightinsanity and
          not doingaction("slightinsanity")) or false
      end,

      oncompleted = function ()
        codepaste.remove_insanities()
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.slightinsanity and
          not doingaction("slightinsanity")) or false
      end,

      oncompleted = function ()
        removeaff("slightinsanity")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        send("sip lucidity", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_lucidity()
        empty.sip_lucidity()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.slightinsanity)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("slightinsanity")
      end,
    }
  },

-- salves
  fracturedskull = {
    salve = {
      aspriority = 14,
      spriority = 195,

      isadvisable = function ()
        return (affs.fracturedskull and not doingaction"fracturedskull") or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("fracturedskull")
      end,

      salvecure = "mending",
      onstart = function ()
        send("apply mending to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_head()
      end
    },
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.fracturedskull and not doingaction"fracturedskull") or false
      end,

      oncompleted = function ()
        removeaff("fracturedskull")
        sk.lostbal_herb()
      end,

      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        applyarnica("head")
      end,

      empty = function()
        empty.applyarnica_head()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          addaff(dict.fracturedskull)
        else
          addaff(dict.damagedskull)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("fracturedskull")
      end,
    }
  },
  slitthroat = {
    salve = {
      aspriority = 40,
      spriority = 83,

      isadvisable = function ()
        return (affs.slitthroat) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("slitthroat")
        affsp.slitthroat = nil
      end,

      salvecure = "mending",
      onstart = function ()
        send("apply mending to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_head()
        affsp.slitthroat = nil
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.slitthroat)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("slitthroat")
        affsp.slitthroat = nil
      end,
    }
  },
  brokenjaw = {
    salve = {
      aspriority = 18,
      spriority = 45,

      isadvisable = function ()
        return (affs.brokenjaw) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("brokenjaw")
      end,

      salvecure = "mending",
      onstart = function ()
        send("apply mending to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_head()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.brokenjaw)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("brokenjaw")
      end,
    }
  },

  unknowncrippledarm = {
    count = 0,
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.unknowncrippledarm) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("unknowncrippledarm")
      end,

      onstart = function ()
        send("apply mending to arms", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_arms()
      end,

      -- something else got cured that we did not expect. Happens in major lag.
      empty = function()
        sk.lostbal_salve()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          dict.unknowncrippledarm.count = dict.unknowncrippledarm.count + 1
          addaff(dict.unknowncrippledarm)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        dict.unknowncrippledarm.count = 0
        removeaff("unknowncrippledarm")
      end,
    },
    onremoved = function ()
      if dict.unknowncrippledarm.count <= 0 then return end

      dict.unknowncrippledarm.count = dict.unknowncrippledarm.count - 1
      addaff (dict.unknowncrippledarm)
    end,
  },
  unknowncrippledleg = {
    count = 0,
    salve = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.unknowncrippledleg) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("unknowncrippledleg")
      end,

      onstart = function ()
        send("apply mending to legs", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_mending_legs()
      end,

      -- something else got cured that we did not expect. Happens in major lag.
      empty = function()
        sk.lostbal_salve()
      end
    },
    aff = {
      oncompleted = function ()
        if conf.oldwarrior then
          dict.unknowncrippledleg.count = dict.unknowncrippledleg.count + 1
          addaff(dict.unknowncrippledleg)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        dict.unknowncrippledleg.count = 0
        removeaff("unknowncrippledleg")
      end,
    },
    onremoved = function ()
      if dict.unknowncrippledleg.count <= 0 then return end

      dict.unknowncrippledleg.count = dict.unknowncrippledleg.count - 1
      addaff (dict.unknowncrippledleg)
    end,
  },
  unknownany = {
    count = 0,
    reckhp = false, reckmana = false, reckego = false,
    waitingfor = {
      customwait = 999,

      focusmind = true,
      onstart = function ()
      end,

      empty = function ()
      end
    },
    aff = {
      oncompleted = function (number)

        if (dict.unknownany.reckhp and codepaste.reckstats()) or
          (dict.unknownany.reckmana and codepaste.reckstats()) or
          (dict.unknownany.reckego and codepaste.reckstats()) then
            addaff(dict.recklessness)

            if number and number > 1 then
              local count = dict.unknownany.count
              addaff(dict.unknownany)

              affs.unknownany.p.count = (count or 0) + (number - 1)
              updateaffcount(dict.unknownany)
            end
        else
          local count = dict.unknownany.count
          addaff(dict.unknownany)

          dict.unknownany.count = (count or 0) + (number or 1)
          updateaffcount(dict.unknownany)
        end

        dict.unknownany.reckhp = false; dict.unknownany.reckmana = false; dict.unknownany.reckego = false
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("unknownany")
        dict.unknownany.count = 0
      end,
    }
  },
  unknownlucidity = {
    lucidity = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function()
        return (affs.unknownlucidity) or false
      end,

      oncompleted = function ()
        if not affs.unknownlucidity then return end
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function()
        send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end,
    },
    aff = {
      oncompleted = function()
        addaff(dict.unknownlucidity)
      end,
    },
  },
  unknownsteam = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function()
        return (affs.unknownsteam) or false
      end,

      oncompleted = function ()
        if not affs.unknownsteam then return end
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function()
        empty.smoke_steam()
      end,
    },
    aff = {
      oncompleted = function()
        addaff(dict.unknownsteam)
      end,
    },
  },
  unknownwafer = {
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function()
        return (affs.unknownwafer) or false
      end,

      oncompleted = function ()
        if not affs.unknownwafer then return end
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,
      
      eatcure = "dust",
      onstart = function ()
        eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end,
    },
    aff = {
      oncompleted = function()
        addaff(dict.unknownwafer)
      end,
    },
  },
  unknownmental = {
    count = 0,
    reckhp = false, reckmana = false, reckego = false,
    focus = {
      aspriority = 22,
      spriority = 270,

      isadvisable = function ()
        return (affs.unknownmental) or false
      end,

      oncompleted = function ()
        -- special: gets called on each focus mind cure, but we most of
        -- the time don't have an unknown aff
        if not affs.unknownmental then return end
        affs.unknownmental.p.count = affs.unknownmental.p.count - 1
        if affs.unknownmental.p.count <= 0 then
          removeaff("unknownmental")
        end

        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        removeaff("unknownmental")
      end
    },
    aff = {
      oncompleted = function (number)
        if (dict.unknownmental.reckhp and stats.currenthealth == stats.maxhealth) or
          (dict.unknownmental.reckmana and stats.currentmana == stats.maxmana) or
          (dict.unknownmental.reckego and stats.currentego == stats.maxego) then
            addaff(dict.recklessness)

            if number and number > 1 then
              local count = dict.unknownany.count
              addaff(dict.unknownany)

              affs.unknownany.p.count = (count or 0) + (number - 1)
              updateaffcount(dict.unknownany)
            end
        else
          local count = dict.unknownmental.count
          addaff(dict.unknownmental)

          dict.unknownmental.count = (count or 0) + (number or 1)
          updateaffcount(dict.unknownmental)
        end

        dict.unknownmental.reckhp = false; dict.unknownmental.reckmana = false; dict.unknownmental.reckego = false
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("unknownmental")
        dict.unknownmental.count = 0
      end
    }
  },


  dementia = {
    herb = {
      aspriority = 14,
      spriority = 14,

      isadvisable = function ()
        return (affs.dementia) or false
      end,

      oncompleted = function ()
        removeaff("dementia")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dementia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dementia")
      end,
    }
  },
  bedevil = {
    blocked = true,
    herb = {
      aspriority = 103,
      spriority = 155,
      isadvisable = function ()
        return (affs.bedevil and not dict.bedevil.blocked) or false
      end,

      oncompleted = function ()
        removeaff("bedevil")
        sk.lostbal_herb()
        signals.newroom:block(sk.check_bedevil)
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      empty = function()
        empty.eat_horehound()
        dict.bedevil.blocked = true
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.bedevil then
          addaff(dict.bedevil)
          signals.newroom:unblock(sk.check_bedevil)
          dict.bedevil.blocked = true
          doaction(dict.bedevil.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("bedevil")
        signals.newroom:block(sk.check_bedevil)
        dict.bedevil.block = true
      end,
    },
    waitingfor = {
      customwait = 20,

      oncompleted = function ()
        removeaff("bedevil")
      end,

      onstart = function ()
      end
    }
  },
  aurawarp = {
    blocked = true,
    herb = {
      aspriority = 97,
      spriority = 148,
      isadvisable = function ()
        return (affs.aurawarp and not dict.aurawarp.blocked) or false
      end,

      oncompleted = function ()
        removeaff("aurawarp")
        sk.lostbal_herb()
        signals.newroom:block(sk.check_aurawarp)
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.aurawarp.blocked = true
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
        dict.aurawarp.blocked = true
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.aurawarp then
          addaff(dict.aurawarp)
          signals.newroom:unblock(sk.check_aurawarp)
          dict.aurawarp.blocked = true
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("aurawarp")
        signals.newroom:block(sk.check_aurawarp)
        dict.aurawarp.block = true
      end,
    }
  },
  jinx = {
    herb = {
      aspriority = 55,
      spriority = 55,

      isadvisable = function ()
        return (affs.jinx and not affs.addiction and
          not affs.anorexia and not affs.confusion and
          not affs.dementia and not affs.epilepsy and
          not affs.gluttony and not affs.hallucinating and
          not affs.hypersomnia and not affs.impatience and
          not affs.loneliness and not affs.inlove and
          not affs.masochism and not affs.paranoia and
          not affs.scrambledbrain and not affs.shyness and
          not affs.stupidity and not affs.void) or false
      end,

      oncompleted = function ()
        removeaff("jinx")
        sk.lostbal_herb()
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.jinx)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("jinx")
      end,
    }
  },
  pacifism = {
    herb = {
      aspriority = 100,
      spriority = 151,

      isadvisable = function ()
        return (affs.pacifism and not doingaction("pacifism")) or false
      end,

      oncompleted = function ()
        removeaff("pacifism")
        sk.lostbal_herb()
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
      end
    },
    focus = {
      aspriority = 7,
      spriority = 214,

      isadvisable = function ()
        return (affs.pacifism and not doingaction("pacifism")) or false
      end,

      oncompleted = function ()
        removeaff("pacifism")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.pacifism and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("pacifism")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("pacifism", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.pacifism)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pacifism")
      end,
    }
  },
  puncturedaura = {
    herb = {
      aspriority = 99,
      spriority = 150,
      customwait = 10, -- prevent too much blackout spam

      isadvisable = function ()
        return (affs.puncturedaura and not doingaction"puncturedaura") or false
      end,

      oncompleted = function ()
        sk.lostbal_herb()
        doaction(dict.puncturedaura.waitingfor)
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        dict.puncturedaura.herb.oncompleted()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.puncturedaura)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("puncturedaura")
      end,
    },
    waitingfor = {
      customwait = 60,

      oncompleted = function ()
        removeaff("puncturedaura")
      end,

      onstart = function ()
      end
    }
  },
  justice = {
    herb = {
      aspriority = 138,
      spriority = 149,

      isadvisable = function ()
        return (affs.justice) or false
      end,

      oncompleted = function ()
        removeaff("justice")
        sk.lostbal_herb()
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.justice)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("justice")
      end,
    }
  },
  succumb = {
    herb = {
      aspriority = 57,
      spriority = 79,

      isadvisable = function ()
        return false
      end,

      oncompleted = function ()
        sk.lostbal_herb()
        doaction (dict.succumb.waitingfor)
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        dict.succumb.herb.oncompleted()
      end
    },
    waitingfor = {
      customwait = 10,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("succumb")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.succumb)
        doaction(dict.succumb.waitingfor)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("succumb")
      end,
    }
  },
  anesthesia = {
    waitingfor = {
      customwait = 15,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("anesthesia")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.anesthesia)
        doaction(dict.anesthesia.waitingfor)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("anesthesia")
      end,
    }
  },
  bentaura = {
    waitingfor = {
      customwait = 150,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("bentaura")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.bentaura)
        doaction(dict.bentaura.waitingfor)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("bentaura")
      end,
    }
  },
  peace = {
    herb = {
      aspriority = 39,
      spriority = 71,

      isadvisable = function ()
        return (affs.peace) or false
      end,

      oncompleted = function ()
        removeaff("peace")
        sk.lostbal_herb()
      end,

      eatcure = "reishi",
      onstart = function ()
        eat("reishi")
      end,

      empty = function()
        empty.eat_reishi()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.peace)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("peace")
      end,
    }
  },
  hypochondria = {
    herb = {
      aspriority = 88,
      spriority = 137,

      isadvisable = function ()
        return (affs.hypochondria) or false
      end,

      oncompleted = function ()
        removeaff("hypochondria")
        sk.lostbal_herb()
      end,

      eatcure = "wormwood",
      onstart = function ()
        eat("wormwood")
      end,

      empty = function()
        empty.eat_wormwood()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hypochondria)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hypochondria")
      end,
    }
  },
  agoraphobia = {
    herb = {
      aspriority = 19,
      spriority = 46,

      isadvisable = function ()
        return (affs.agoraphobia and not doingaction("agoraphobia")) or false
      end,

      oncompleted = function ()
        removeaff("agoraphobia")
        sk.lostbal_herb()
      end,

      eatcure = "wormwood",
      onstart = function ()
        eat("wormwood")
      end,

      empty = function()
        empty.eat_wormwood()
      end
    },
    focus = {
      aspriority = 15,
      spriority = 221,

      isadvisable = function ()
        return (affs.agoraphobia and not doingaction("agoraphobia")) or false
      end,

      oncompleted = function ()
        removeaff("agoraphobia")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.agoraphobia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("agoraphobia")
      end,
    }
  },
  vestiphobia = {
    herb = {
      aspriority = 17,
      spriority = 43,

      isadvisable = function ()
        return (affs.vestiphobia and
          not doingaction("vestiphobia")) or false
      end,

      oncompleted = function ()
        removeaff("vestiphobia")
        sk.lostbal_herb()
      end,

      eatcure = "wormwood",
      onstart = function ()
        eat("wormwood")
      end,

      empty = function()
        empty.eat_wormwood()
      end
    },
    focus = {
      aspriority = 30,
      spriority = 286,

      isadvisable = function ()
        return (affs.vestiphobia and
          not doingaction("vestiphobia")) or false
      end,

      oncompleted = function ()
        removeaff("vestiphobia")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vestiphobia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("vestiphobia")
      end,
    }
  },
  claustrophobia = {
    herb = {
      aspriority = 15,
      spriority = 8,

      isadvisable = function ()
        return (affs.claustrophobia and
          not doingaction("claustrophobia")) or false
      end,

      oncompleted = function ()
        removeaff("claustrophobia")
        sk.lostbal_herb()
      end,

      eatcure = "wormwood",
      onstart = function ()
        eat("wormwood")
      end,

      empty = function()
        empty.eat_wormwood()
      end
    },
    focus = {
      aspriority = 29,
      spriority = 272,

      isadvisable = function ()
        return (affs.claustrophobia and
          not doingaction("claustrophobia")) or false
      end,

      oncompleted = function ()
        removeaff("claustrophobia")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.claustrophobia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("claustrophobia")
      end,
    }
  },
  vapors = {
    herb = {
      aspriority = 50,
      spriority = 50,

      isadvisable = function ()
        return (affs.vapors and not doingaction("vapors")) or false
      end,

      oncompleted = function ()
        removeaff("vapors")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function ()
          empty.eat_kombu()
      end
    },
    salve = {
      aspriority = 60,
      spriority = 293,

      isadvisable = function ()
        return (affs.vapors and not doingaction("vapors")) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("vapors")
      end,

      onstart = function ()
        send("apply melancholic to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_head()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vapors)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("vapors")
      end,
    }
  },
  inlove = {
    herb = {
      aspriority = 101,
      spriority = 153,

      isadvisable = function ()
        return (affs.inlove and not doingaction "inlove") or false
      end,

      oncompleted = function ()
        removeaff("inlove")
        sk.lostbal_herb()
      end,

      eatcure = "galingale",
      onstart = function ()
        eat("galingale")
      end,

      empty = function()
        empty.eat_galingale()
      end
    },
    focus = {
      aspriority = 40,
      spriority = 219,

      isadvisable = function ()
        return (affs.inlove and not doingaction("inlove")) or false
      end,

      oncompleted = function ()
        removeaff("inlove")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.inlove)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("inlove")
      end,
    }
  },
  addiction = {
    herb = {
      aspriority = 22,
      spriority = 72,

      isadvisable = function ()
        return (affs.addiction and not doingaction("addiction")) or false
      end,

      oncompleted = function ()
        removeaff("addiction")
        sk.lostbal_herb()
      end,

      eatcure = "galingale",
      onstart = function ()
        eat("galingale")
      end,

      empty = function()
        empty.eat_galingale()
      end
    },
    focus = {
      aspriority = 1,
      spriority = 220,

      isadvisable = function ()
        return (affs.addiction and not doingaction("addiction")) or false
      end,

      oncompleted = function ()
        removeaff("addiction")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.addiction and not doingaction("addiction")) or false
      end,

      oncompleted = function ()
        removeaff("addiction")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("addiction", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.addiction)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("addiction")
      end,
    }
  },
  gluttony = {
    herb = {
      aspriority = 21,
      spriority = 53,

      isadvisable = function ()
        return (affs.gluttony) or false
      end,

      oncompleted = function ()
        removeaff("gluttony")
        sk.lostbal_herb()
      end,

      eatcure = "galingale",
      onstart = function ()
        eat("galingale")
      end,

      empty = function()
        empty.eat_galingale()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.gluttony)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("gluttony")
      end,
    }
  },
  epilepsy = {
    herb = {
      aspriority = 38,
      spriority = 38,

      isadvisable = function ()
        return (affs.epilepsy and not doingaction("epilepsy")) or false
      end,

      oncompleted = function ()
        removeaff("epilepsy")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function()
        empty.eat_kombu()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.epilepsy and not doingaction("epilepsy")) or false
      end,

      oncompleted = function ()
        removeaff("epilepsy")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("addiction", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    focus = {
      aspriority = 19,
      spriority = 225,

      isadvisable = function ()
        return (affs.epilepsy and not doingaction("epilepsy")) or false
      end,

      oncompleted = function ()
        removeaff("epilepsy")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.epilepsy)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("epilepsy")
      end,
    }
  },
  dizziness = {
    herb = {
      aspriority = 35,
      spriority = 74,

      isadvisable = function ()
        return (affs.dizziness and not doingaction("dizziness")) or false
      end,

      oncompleted = function ()
        removeaff("dizziness")
        sk.lostbal_herb()
      end,

      eatcure = "kombu",
      onstart = function ()
        eat("kombu")
      end,

      empty = function()
          empty.eat_kombu()
      end
    },
    salve = {
      aspriority = 38,
      spriority = 69,

      isadvisable = function ()
        return (affs.dizziness and not doingaction("dizziness")) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("dizziness")
      end,

      onstart = function ()
        send("apply melancholic to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_head()
      end
    },
    focus = {
      aspriority = 18,
      spriority = 224,

      isadvisable = function ()
        return (affs.dizziness and not doingaction("dizziness")) or false
      end,

      oncompleted = function ()
        removeaff("dizziness")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dizziness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dizziness")
      end,
    }
  },
  achromaticaura = {
    herb = {
      aspriority = 102,
      spriority = 154,

      isadvisable = function ()
        return (affs.achromaticaura and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("achromaticaura")
        removeaff("unknownsteam")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.achromaticaura and not affs.maestoso and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("achromaticaura")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("achromaticaura", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.achromaticaura)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("achromaticaura")
      end,
    }
  },
  powerspikes = {
    herb = {
      aspriority = 107,
      spriority = 159,

      isadvisable = function ()
        -- can cure if no octave or in octave - if you're deaf
        return (affs.powerspikes and (not affs.maestoso or (defc.truedeaf or affs.deaf))) or false
      end,

      oncompleted = function ()
        removeaff("powerspikes")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.powerspikes and (not affs.maestoso or (defc.truedeaf or affs.deaf)) and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("powerspikes")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("powerspikes", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    allheale = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.powerspikes and not (defc.truedeaf or affs.deaf)) or false
      end,

      oncompleted = function ()
        removeaff("powerspikes")
        bals.allheale = false
      end,

      sipcure = "allheale",

      onstart = function ()
        send("sip allheale", conf.commandecho)
      end,

      empty = function ()
        bals.allheale = false
        empty.sip_allheale()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.powerspikes)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("powerspikes")
      end,
    }
  },
  manabarbs = {
    herb = {
      aspriority = 106,
      spriority = 158,

      isadvisable = function ()
        return (affs.manabarbs and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("manabarbs")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.manabarbs and not affs.maestoso and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("manabarbs")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("manabarbs", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    allheale = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.manabarbs and affs.maestoso and not defc.truedeaf and not affs.deaf) or false
      end,

      oncompleted = function ()
        removeaff("manabarbs")
        bals.allheale = false
      end,

      sipcure = "allheale",

      onstart = function ()
        send("sip allheale", conf.commandecho)
      end,

      empty = function ()
        bals.allheale = false
        empty.sip_allheale()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.manabarbs)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("manabarbs")
      end,
    }
  },
  egovice = {
    herb = {
      aspriority = 37,
      spriority = 157,

      isadvisable = function ()
        return (affs.egovice and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("egovice")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.egovice and not affs.maestoso and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("egovice")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("egovice", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    allheale = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.egovice and affs.maestoso and not defc.truedeaf and not affs.deaf) or false
      end,

      oncompleted = function ()
        removeaff("egovice")
        bals.allheale = false
      end,

      sipcure = "allheale",

      onstart = function ()
        send("sip allheale", conf.commandecho)
      end,

      empty = function ()
        bals.allheale = false
        empty.sip_allheale()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.egovice)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("egovice")
      end,
    }
  },
  dissonance = {
    herb = {
      aspriority = 104,
      spriority = 156,

      isadvisable = function ()
        return (affs.dissonance and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("dissonance")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dissonance)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("dissonance")
      end,
    }
  },
  recklessness = {
    herb = {
      aspriority = 105,
      spriority = 68,

      isadvisable = function ()
        return (affs.recklessness and not doingaction("recklessness") and not affs.maestoso) or false
      end,

      oncompleted = function ()
        removeaff("recklessness")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    focus = {
      aspriority = 14,
      spriority = 215,

      isadvisable = function ()
        return (affs.recklessness and not doingaction("recklessness")) or false
      end,

      oncompleted = function ()
        removeaff("recklessness")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.recklessness and not doingaction("recklessness")) or false
      end,

      oncompleted = function ()
        removeaff("recklessness")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("recklessness", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.recklessness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("recklessness")
      end,
    }
  },
  stupidity = {
    herb = {
      aspriority = 65,
      spriority = 65,

      isadvisable = function ()
        return (affs.stupidity and not doingaction("stupidity")) or false
      end,

      oncompleted = function ()
        removeaff("stupidity")
        sk.lostbal_herb()
      end,

      eatcure = "pennyroyal",
      onstart = function ()
        eat("pennyroyal")
      end,

      empty = function()
        empty.eat_pennyroyal()
      end
    },
    focus = {
      aspriority = 5,
      spriority = 216,

      isadvisable = function ()
        return (affs.stupidity and not doingaction("stupidity")) or false
      end,

      oncompleted = function ()
        removeaff("stupidity")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.stupidity and not doingaction("stupidity")) or false
      end,

      oncompleted = function ()
        removeaff("stupidity")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("stupidity", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.stupidity)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stupidity")
        sk.stupidity_count = 0
      end,
    }
  },
  piercedrightarm = {
    herb = {
      aspriority = 6,
      spriority = 100,

      isadvisable = function ()
        return (affs.piercedrightarm and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("piercedrightarm")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.piercedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("piercedrightarm")
      end,
    }
  },
  piercedleftarm = {
    herb = {
      aspriority = 5,
      spriority = 101,

      isadvisable = function ()
        return (affs.piercedleftarm and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("piercedleftarm")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.piercedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("piercedleftarm")
      end,
    }
  },
  piercedrightleg = {
    herb = {
      aspriority = 9,
      spriority = 97,

      isadvisable = function ()
        return (affs.piercedrightleg and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("piercedrightleg")
        sk.lostbal_herb()
      end,

      oncuredleft = function ()
        removeaff("piercedleftleg")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.piercedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("piercedrightleg")
      end,
    }
  },
  piercedleftleg = {
    herb = {
      aspriority = 10,
      spriority = 96,

      isadvisable = function ()
        return (affs.piercedleftleg and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncuredright = function ()
        removeaff("piercedrightleg")
        sk.lostbal_herb()
      end,

      oncompleted = function ()
        removeaff("piercedleftleg")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.piercedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("piercedleftleg")
      end,
    }
  },
  hemiplegyleft = {
    herb = {
      aspriority = 67,
      spriority = 107,

      isadvisable = function ()
        return (affs.hemiplegyleft and codepaste.smoke_myrtle_pipe() and
          not affs.collapsedleftnerve) or false
      end,

      oncompleted = function ()
        removeaff("hemiplegyleft")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hemiplegyleft)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hemiplegyleft")
      end,
    }
  },
  hemiplegyright = {
    herb = {
      aspriority = 68,
      spriority = 106,

      isadvisable = function ()
        return (affs.hemiplegyright and codepaste.smoke_myrtle_pipe() and
          not affs.collapsedrightnerve) or false
      end,

      oncompleted = function ()
        removeaff("hemiplegyright")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hemiplegyright)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hemiplegyright")
      end,
    }
  },
  hemiplegylower = {
    herb = {
      aspriority = 69,
      spriority = 105,

      isadvisable = function ()
        return (affs.hemiplegylower and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("hemiplegylower")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_myrtle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hemiplegylower)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hemiplegylower")
      end,
    }
  },
  severedphrenic = {
    failcount = 0,
    herb = {
      aspriority = 127,
      spriority = 209,

      isadvisable = function ()
        return (affs.severedphrenic and codepaste.smoke_myrtle_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("severedphrenic")
        dict.severedphrenic.failcount = 0
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      onstart = function ()
        send("smoke " .. pipes.myrtle.id, conf.commandecho)
      end,

      empty = function ()
        dict.severedphrenic.failcount = dict.severedphrenic.failcount - 1
        if dict.severedphrenic.failcount <= 0 then
          removeaff ("severedphrenic")
          dict.severedphrenic.failcount = 0
        end
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.severedphrenic then
          addaff(dict.severedphrenic)
          dict.severedphrenic.failcount = 3
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("severedphrenic")
        dict.severedphrenic.failcount = 0
      end,
    }
  },
  crushedwindpipe = {
    herb = {
      aspriority = 66,
      spriority = 73,
      last_action = "",

      isadvisable = function ()
        if (affs.crushedwindpipe and
            ((codepaste.smoke_myrtle_pipe() and not affs.asthma and not affs.collapsedlungs and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown and not affs.pinlegunknown) -- we can either smoke it, or...
          or
            (not affs.slickness))  -- ...eat it
          ) then
        return true
      else
        return false
      end
      end,

      oncompleted = function ()
        removeaff("crushedwindpipe")
        sk.lostbal_herb()
      end,

      smokecure = "myrtle",
      eatcure = "arnica",
      applyherb = "arnica",
      onstart = function ()
        if (codepaste.smoke_myrtle_pipe() and not affs.asthma and not affs.collapsedlungs and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown and not affs.pinlegunknown) then
          send("smoke " .. pipes.myrtle.id, conf.commandecho)
          dict.crushedwindpipe.herb.last_action = "smoke"
        else
          applyarnica("head")
          dict.crushedwindpipe.herb.last_action = "apply"
        end
      end,

      empty = function (how)
        if how == "smoked" then
          sk.lostbal_herb()
          empty.smoke_myrtle()
        else
          empty.applyarnica_head()
        end
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crushedwindpipe)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crushedwindpipe")
      end,
    }
  },
  impatience = {
    focus = {
      aspriority = 28,
      spriority = 274,

      isadvisable = function ()
        return (affs.impatience and
          not doingaction("impatience")) or false
      end,

      oncompleted = function ()
        removeaff("impatience")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    herb = {
      aspriority = 139,
      spriority = 70,

      isadvisable = function ()
        return (affs.impatience and
          not doingaction("impatience") and codepaste.smoke_coltsfoot_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("impatience")
        sk.lostbal_herb()
      end,

      smokecure = "coltsfoot",
      onstart = function ()
        send("smoke " .. pipes.coltsfoot.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_coltsfoot()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.impatience)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("impatience")
      end,
    }
  },
  cloudcoils = {
    count = 0,
    herb = {
      aspriority = 70,
      spriority = 276,

      isadvisable = function ()
        return (affs.cloudcoils and codepaste.smoke_faeleaf_pipe()) or false
      end,

      oncompleted = function ()
        sk.lostbal_herb()

        affs.cloudcoils.p.count = affs.cloudcoils.p.count - 1
        if affs.cloudcoils.p.count == 0 then
          removeaff("cloudcoils")
        end
      end,

      smokecure = "faeleaf",
      onstart = function ()
        send("smoke " .. pipes.faeleaf.id, conf.commandecho)
      end,

      empty = function ()
        empty.smoke_faeleaf()
        doaction(dict.waitingonrebounding.waitingfor)
      end
    },
    aff = {
      oncompleted = function ()
        local count = 0
        if affs.cloudcoils then count = affs.cloudcoils.p.count end
        addaff(dict.cloudcoils)
        affs.cloudcoils.p.count = count + 1
        updateaffcount(dict.cloudcoils)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("cloudcoils")
        dict.cloudcoils.count = 0
      end,
    }
  },
  shyness = {
    herb = {
      aspriority = 87,
      spriority = 135,

      isadvisable = function ()
        return (affs.shyness and codepaste.smoke_coltsfoot_pipe() and not doingaction("shyness")) or false
      end,

      oncompleted = function ()
        removeaff("shyness")
        sk.lostbal_herb()
      end,

      smokecure = "coltsfoot",
      onstart = function ()
        send("smoke " .. pipes.coltsfoot.id, conf.commandecho)
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_coltsfoot()
      end
    },
    purgative = {
      aspriority = 17,
      spriority = 136,

      isadvisable = function ()
        return (affs.shyness and not doingaction("shyness")) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        removeaff("shyness")
      end,

      empty = function()
        sk.lostbal_purgative()
        empty.sip_phlegmatic()
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "phlegmatic",

      onstart = function ()
        send("sip phlegmatic", conf.commandecho)
      end
    },
    focus = {
      aspriority = 9,
      spriority = 211,

      isadvisable = function ()
        return (affs.shyness and not doingaction("shyness")) or false
      end,

      oncompleted = function ()
        removeaff("shyness")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.shyness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shyness")
      end,
    }
  },
  loneliness = {
    herb = {
      aspriority = 86,
      spriority = 134,

      isadvisable = function ()
        return (affs.loneliness and codepaste.smoke_coltsfoot_pipe() and not doingaction("loneliness")) or false
      end,

      oncompleted = function ()
        removeaff("loneliness")
        sk.lostbal_herb()
      end,

      smokecure = "coltsfoot",
      onstart = function ()
        send("smoke " .. pipes.coltsfoot.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_coltsfoot()
      end
    },
    focus = {
      aspriority = 12,
      spriority = 210,

      isadvisable = function ()
        return (affs.loneliness and not doingaction("loneliness")) or false
      end,

      oncompleted = function ()
        removeaff("loneliness")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.loneliness)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("loneliness")
      end,
    }
  },
  anorexia = {
    herb = {
      aspriority = 77,
      spriority = 77,

      isadvisable = function ()
        return (affs.anorexia and codepaste.smoke_coltsfoot_pipe() and not doingaction("anorexia") and not usingbal "focus") or false
      end,

      oncompleted = function ()
        removeaff("anorexia")
        sk.lostbal_herb()
      end,

      smokecure = "coltsfoot",
      onstart = function ()
        send("smoke " .. pipes.coltsfoot.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_coltsfoot()
      end
    },
    focus = {
      aspriority = 16,
      spriority = 222,

      isadvisable = function ()
        return (affs.anorexia and not doingaction("anorexia")
        -- don't focus if we can smoke, because timewarps might mess up focus - or other affs
        and (not affs.aeon or (not dict.anorexia.herb.isadvisable() or affs.asthma or affs.collapsedlungs))) or false
      end,

      oncompleted = function ()
        removeaff("anorexia")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.anorexia and not doingaction("anorexia")) or false
      end,

      oncompleted = function ()
        removeaff("anorexia")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("anorexia", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.anorexia)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("anorexia")
      end,
    }
  },
  blackout = {
    allheale = {
      aspriority = 1,
      spriority = 310,

      isadvisable = function ()
        return (affs.blackout) or false
      end,

      oncompleted = function ()
        removeaff("blackout")
        bals.allheale = false
      end,

      sipcure = "allheale",

      onstart = function ()
        send("sip allheale", conf.commandecho)
      end,

      empty = function ()
        bals.allheale = false
        empty.sip_allheale()
      end,

      woreoff = function()
        removeaff("blackout")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.blackout)
        check_generics()
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("blackout")
      end,
    },
    onremoved = function () check_generics() end,
  },
  masochism = {
    herb = {
      aspriority = 36,
      spriority = 67,

      isadvisable = function ()
        return (affs.masochism and not doingaction("masochism") and codepaste.smoke_coltsfoot_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("masochism")
        sk.lostbal_herb()
      end,

      smokecure = "coltsfoot",
      onstart = function ()
        send("smoke " .. pipes.coltsfoot.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_herb()
        empty.smoke_coltsfoot()
      end
    },
    focus = {
      aspriority = 13,
      spriority = 213,

      isadvisable = function ()
        return (affs.masochism and not doingaction("masochism")) or false
      end,

      oncompleted = function ()
        removeaff("masochism")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.masochism)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("masochism")
      end,
    }
  },
  deaf = {
    herb = {
      aspriority = 134,
      spriority = 257,

      isadvisable = function ()
        return (affs.deaf and not defc.truedeaf and not doingaction "deaf" and not affs.earache) or false
      end,

      oncompleted = function ()
        removeaff("deaf")
        sk.lostbal_herb()
      end,

      earache = function ()
        sk.lostbal_herb()
        if not affs.earache then addaff(dict.earache) end
      end,

      eatcure = conf.deafherb,
      onstart = function ()
        eat(conf.deafherb)
      end,

      empty = function()
        empty["eat_"..conf.deafherb]()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        --[[return (affs.deaf and not defc.truedeaf and not doingaction "deaf" and not affs.earache) or false]]
        return false
      end,

      oncompleted = function ()
        removeaff("deaf")
        sk.lostbal_wafer()
      end,

      earache = function ()
        sk.lostbal_wafer()
        if not affs.earache then addaff(dict.earache) end
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        empty["eat_earwort"]()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deaf and not affs.earache and codepaste.smoke_steam_pipe() and not defc.truedeaf and not doingaction("deaf")) or false
      end,

      oncompleted = function (def)
        removeaff("deaf")
        sk.lostbal_steam()
      end,

      earache = function ()
        sk.lostbal_steam()
        if not affs.earache then addaff(dict.earache) end
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        empty.smoke_steam()
        sk.lostbal_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.deaf)
      end,
    },
    gone = {
      oncompleted  = function () removeaff("deaf") end
    }
  },
  blind = {
    herb = {
      aspriority = 133,
      spriority = 258,

      isadvisable = function ()
      -- took out and not doingaction "waitingontrueblind", so there isn't a short time between you getting trueblind up
        return (affs.blind and not doingaction "blind" and not defc.trueblind and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false
      end,

      oncompleted = function ()
        removeaff("blind")
        sk.lostbal_herb()
      end,

      gettingtrueblind = function ()
        removeaff("blind")
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_herb()
      end,

      afterimage = function ()
        sk.lostbal_herb()
        addaff (dict.afterimage)
      end,

      eatcure = conf.blindherb,
      onstart = function ()
        eat(conf.blindherb)
      end,

      empty = function()
        empty["eat_"..conf.blindherb]()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
      -- took out and not doingaction "waitingontrueblind", so there isn't a short time between you getting trueblind up
        return (affs.blind and not doingaction "blind" and not defc.trueblind and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false
      end,

      oncompleted = function ()
        removeaff("blind")
        sk.lostbal_wafer()
      end,

      gettingtrueblind = function ()
        removeaff("blind")
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_wafer()
      end,

      afterimage = function ()
        sk.lostbal_wafer()
        addaff (dict.afterimage)
      end,

      eatcure = "faeleaf",
      onstart = function ()
        eat("faeleaf")
      end,

      empty = function()
        empty["eat_faeleaf"]()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.blind)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("blind")
      end
    },
    onremoved = function () donext() end
  },
  sensitivity = {
    herb = {
      aspriority = 56,
      spriority = 56,

      isadvisable = function ()
        return (affs.sensitivity and not doingaction ("sensitivity")) or false
      end,

      oncompleted = function ()
        removeaff("sensitivity")
        sk.lostbal_herb()
      end,

      eatcure = "myrtle",
      onstart = function ()
        eat("myrtle")
      end,

      empty = function()
          empty.eat_myrtle()
      end
    },
    salve = {
      aspriority = 37,
      spriority = 37,

      isadvisable = function ()
        return (affs.sensitivity and not doingaction ("sensitivity")) or false
      end,

      oncompleted = function ()
        sk.lostbal_salve()
        removeaff("sensitivity")
      end,

      onstart = function ()
        send("apply melancholic to head", conf.commandecho)
      end,

      noeffect = function ()
        empty.noeffect_melancholic_head()
      end
    },
    lucidity = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.sensitivity and not doingaction("sensitivity")) or false
      end,

      oncompleted = function ()
        removeaff("sensitivity")
        removeaff("unknownlucidity")
        sk.lostbal_lucidity()
      end,

      onstart = function ()
        focus_aff("sensitivity", "sip lucidity")
        --send("sip lucidity", conf.commandecho)
      end,

      empty = function()
        empty.sip_lucidity()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.sensitivity)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sensitivity")
      end,
    }
  },

  criticalchest = {
    count = 0,
    sip = {
      aspriority = 38,
      spriority = 374,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalchest")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.chest()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply health to chest", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 31,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalchest")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.chest()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply ice to chest wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("chest", amount)
        addaff(dict.criticalchest)
        updateaffcount(dict.criticalchest)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalchest")
        update_wound_count("chest", 0)
      end
    }
  },
  heavychest = {
    count = 0,
    sip = {
      aspriority = 31,
      spriority = 367,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavychest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavychest")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.chest()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply health to chest", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 11,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavychest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavychest")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.chest()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply ice to chest wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("chest", amount)
        addaff(dict.heavychest)
        updateaffcount(dict.heavychest)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavychest")
        update_wound_count("chest", 0)
      end
    }
  },
  mediumchest = {
    count = 0,
    sip = {
      aspriority = 24,
      spriority = 360,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumchest")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.chest()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply health to chest", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("chest", amount)
        addaff(dict.mediumchest)
        updateaffcount(dict.mediumchest)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumchest")
        update_wound_count("chest", 0)
      end
    }
  },
  lightchest = {
    count = 0,
    sip = {
      aspriority = 17,
      spriority = 353,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightchest")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.chest()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply health to chest", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 4,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightchest")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.chest()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.chest()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.chest()
      end,

      onstart = function ()
        send("apply ice to chest wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("chest", amount)
        addaff(dict.lightchest)
        updateaffcount(dict.lightchest)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightchest")
        update_wound_count("chest", 0)
      end
    }
  },
  criticalgut = {
    count = 0,
    sip = {
      aspriority = 39,
      spriority = 375,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalgut")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.gut()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply health to gut", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 30,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalgut")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.gut()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply ice to gut wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("gut", amount)
        addaff(dict.criticalgut)
        updateaffcount(dict.criticalgut)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalgut")
        update_wound_count("gut", 0)
      end
    }
  },
  heavygut = {
    count = 0,
    sip = {
      aspriority = 32,
      spriority = 368,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavygut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavygut")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.gut()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply health to gut", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 10,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavygut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavygut")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.gut()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply ice to gut wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("gut", amount)
        addaff(dict.heavygut)
        updateaffcount(dict.heavygut)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavygut")
        update_wound_count("gut", 0)
      end
    }
  },
  mediumgut = {
    count = 0,
    sip = {
      aspriority = 25,
      spriority = 361,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumgut")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.gut()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply health to gut", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("gut", amount)
        addaff(dict.mediumgut)
        updateaffcount(dict.mediumgut)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumgut")
        update_wound_count("gut", 0)
      end
    }
  },
  lightgut = {
    count = 0,
    sip = {
      aspriority = 18,
      spriority = 354,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightgut")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.gut()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply health to gut", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 3,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightgut")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.gut()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.gut()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.gut()
      end,

      onstart = function ()
        send("apply ice to gut wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("gut", amount)
        addaff(dict.lightgut)
        updateaffcount(dict.lightgut)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightgut")
        update_wound_count("gut", 0)
      end
    }
  },
  criticalrightarm = {
    count = 0,
    sip = {
      aspriority = 40,
      spriority = 376,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalrightarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 28,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalrightarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply ice to rarm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightarm", amount)
        addaff(dict.criticalrightarm)
        updateaffcount(dict.criticalrightarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalrightarm")
        update_wound_count("rightarm", 0)
      end
    }
  },
  heavyrightarm = {
    count = 0,
    sip = {
      aspriority = 33,
      spriority = 369,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavyrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyrightarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 8,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavyrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyrightarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply ice to rarm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightarm", amount)
        addaff(dict.heavyrightarm)
        updateaffcount(dict.heavyrightarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavyrightarm")
        update_wound_count("rightarm", 0)
      end
    }
  },
  mediumrightarm = {
    count = 0,
    sip = {
      aspriority = 26,
      spriority = 362,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumrightarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightarm", amount)
        addaff(dict.mediumrightarm)
        updateaffcount(dict.mediumrightarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumrightarm")
        update_wound_count("rightarm", 0)
      end
    }
  },
  lightrightarm = {
    count = 0,
    sip = {
      aspriority = 19,
      spriority = 355,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightrightarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 1,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightrightarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightarm()
      end,

      onstart = function ()
        send("apply ice to rarm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightarm", amount)
        addaff(dict.lightrightarm)
        updateaffcount(dict.lightrightarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightrightarm")
        update_wound_count("rightarm", 0)
      end
    }
  },
  criticalleftarm = {
    count = 0,
    sip = {
      aspriority = 41,
      spriority = 377,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalleftarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 29,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalleftarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply ice to larm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftarm", amount)
        addaff(dict.criticalleftarm)
        updateaffcount(dict.criticalleftarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalleftarm")
        update_wound_count("leftarm", 0)
      end
    }
  },
  heavyleftarm = {
    count = 0,
    sip = {
      aspriority = 34,
      spriority = 370,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavyleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyleftarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 9,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavyleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyleftarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply ice to larm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftarm", amount)
        addaff(dict.heavyleftarm)
        updateaffcount(dict.heavyleftarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavyleftarm")
        update_wound_count("leftarm", 0)
      end
    }
  },
  mediumleftarm = {
    count = 0,
    sip = {
      aspriority = 27,
      spriority = 363,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumleftarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftarm", amount)
        addaff(dict.mediumleftarm)
        updateaffcount(dict.mediumleftarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumleftarm")
        update_wound_count("leftarm", 0)
      end
    }
  },
  lightleftarm = {
    count = 0,
    sip = {
      aspriority = 20,
      spriority = 356,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightleftarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 2,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightleftarm")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftarm()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftarm()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftarm()
      end,

      onstart = function ()
        send("apply ice to larm wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftarm", amount)
        addaff(dict.lightleftarm)
        updateaffcount(dict.lightleftarm)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightleftarm")
        update_wound_count("leftarm", 0)
      end
    }
  },
  criticalleftleg = {
    count = 0,
    sip = {
      aspriority = 42,
      spriority = 378,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalleftleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 33,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalleftleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply ice to lleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftleg", amount)
        addaff(dict.criticalleftleg)
        updateaffcount(dict.criticalleftleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalleftleg")
        update_wound_count("leftleg", 0)
      end
    }
  },
  heavyleftleg = {
    count = 0,
    sip = {
      aspriority = 35,
      spriority = 371,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavyleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyleftleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 13,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavyleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyleftleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply ice to lleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftleg", amount)
        addaff(dict.heavyleftleg)
        updateaffcount(dict.heavyleftleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavyleftleg")
        update_wound_count("leftleg", 0)
      end
    }
  },
  mediumleftleg = {
    count = 0,
    sip = {
      aspriority = 28,
      spriority = 364,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumleftleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftleg", amount)
        addaff(dict.mediumleftleg)
        updateaffcount(dict.mediumleftleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumleftleg")
        update_wound_count("leftleg", 0)
      end
    }
  },
  lightleftleg = {
    count = 0,
    sip = {
      aspriority = 21,
      spriority = 357,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightleftleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 6,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightleftleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.leftleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.leftleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.leftleg()
      end,

      onstart = function ()
        send("apply ice to lleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("leftleg", amount)
        addaff(dict.lightleftleg)
        updateaffcount(dict.lightleftleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightleftleg")
        update_wound_count("leftleg", 0)
      end
    }
  },
  criticalrightleg = {
    count = 0,
    sip = {
      aspriority = 43,
      spriority = 379,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalrightleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 32,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalrightleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply ice to rleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightleg", amount)
        addaff(dict.criticalrightleg)
        updateaffcount(dict.criticalrightleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalrightleg")
        update_wound_count("rightleg", 0)
      end
    }
  },
  heavyrightleg = {
    count = 0,
    sip = {
      aspriority = 36,
      spriority = 372,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavyrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyrightleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 12,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavyrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyrightleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply ice to rleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightleg", amount)
        addaff(dict.heavyrightleg)
        updateaffcount(dict.heavyrightleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavyrightleg")
        update_wound_count("rightleg", 0)
      end
    }
  },
  mediumrightleg = {
    count = 0,
    sip = {
      aspriority = 29,
      spriority = 365,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumrightleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightleg", amount)
        addaff(dict.mediumrightleg)
        updateaffcount(dict.mediumrightleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumrightleg")
        update_wound_count("rightleg", 0)
      end
    }
  },
  lightrightleg = {
    count = 0,
    sip = {
      aspriority = 22,
      spriority = 358,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lightrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightrightleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 5,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lightrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lightrightleg")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.rightleg()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.rightleg()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.rightleg()
      end,

      onstart = function ()
        send("apply ice to rleg wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("rightleg", amount)
        addaff(dict.lightrightleg)
        updateaffcount(dict.lightrightleg)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lightrightleg")
        update_wound_count("rightleg", 0)
      end
    }
  },
  criticalhead = {
    count = 0,
    sip = {
      aspriority = 44,
      spriority = 330,

      isadvisable = function ()
        return (conf.oldwarrior and affs.criticalhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalhead")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.head()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.head()

        if dict.criticalhead.count >= 3600 then sk.warn("behead") end
      end,

      onstart = function ()
        send("apply health to head", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 34,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.criticalhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("criticalhead")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.head()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply ice to head wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("head", amount)
        addaff(dict.criticalhead)
        updateaffcount(dict.criticalhead)
        signals.after_lifevision_processing:unblock(sp_checksp)

        if dict.criticalhead.count >= 3600 then sk.warn("behead") end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("criticalhead")
        update_wound_count("head", 0)
      end
    }
  },
  heavyhead = {
    count = 0,
    sip = {
      aspriority = 37,
      spriority = 373,

      isadvisable = function ()
        return (conf.oldwarrior and affs.heavyhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyhead")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.head()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply health to head", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 14,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.heavyhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("heavyhead")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.head()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply ice to head wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("head", amount)
        addaff(dict.heavyhead)
        updateaffcount(dict.heavyhead)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heavyhead")
        update_wound_count("head", 0)
      end
    }
  },
  mediumhead = {
    count = 0,
    sip = {
      aspriority = 3,
      spriority = 366,

      isadvisable = function ()
        return (conf.oldwarrior and affs.mediumhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("mediumhead")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.head()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply health to head", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("head", amount)
        addaff(dict.mediumhead)
        updateaffcount(dict.mediumhead)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mediumhead")
        update_wound_count("head", 0)
      end
    }
  },
  lighthead = {
    count = 0,
    sip = {
      aspriority = 23,
      spriority = 359,

      isadvisable = function ()
        return (conf.oldwarrior and affs.lighthead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lighthead")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.head()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_sip()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_sip()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply health to head", conf.commandecho)
      end
    },
    ice = {
      aspriority = 0,
      spriority = 7,

      isadvisable = function ()
        return (not conf.oldwarrior and affs.lighthead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("lighthead")
        sk.lostbal_ice()
      end,

      noeffect = function()
        completely_healed.head()
        sk.lostbal_ice()
      end,

      nouse = function ()
        sk.lostbal_ice()
      end,

      ninshi = function ()
        sk.lostbal_ice()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      completely = function ()
        sk.lostbal_ice()
        completely_healed.head()
      end,

      partially = function ()
        sk.lostbal_ice()
        partially_healed.head()
      end,

      onstart = function ()
        send("apply ice to head wounds", conf.commandecho)
      end
    },
    onremoved = function () signals.after_lifevision_processing:unblock(sp_checksp) end,
    aff = {
      oncompleted = function (amount)
        update_wound_count("head", amount)
        addaff(dict.lighthead)
        updateaffcount(dict.lighthead)
        signals.after_lifevision_processing:unblock(sp_checksp)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("lighthead")
        update_wound_count("head", 0)
      end
    }
  },

  numbedrightleg = {
    sip = {
      aspriority = 45,
      spriority = 208,

      isadvisable = function ()
        return (affs.numbedrightleg and dict.grapple.ninshilimb ~= "rightleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedrightleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightleg" then
          dict.grapple.ninshi = "rightleg" end
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedrightleg)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedrightleg")
      end
    }
  },
  numbedleftleg = {
    sip = {
      aspriority = 46,
      spriority = 251,

      isadvisable = function ()
        return (affs.numbedleftleg and dict.grapple.ninshilimb ~= "leftleg" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedleftleg")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftleg()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftleg" then
          dict.grapple.ninshi = "leftleg" end
      end,

      onstart = function ()
        send("apply health to legs", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedleftleg)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedleftleg")
      end
    }
  },
  numbedleftarm = {
    sip = {
      aspriority = 47,
      spriority = 0,

      isadvisable = function ()
        return (affs.numbedleftarm and dict.grapple.ninshilimb ~= "leftarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedleftarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.leftarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "leftarm" then
          dict.grapple.ninshi = "leftarm" end
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedleftarm)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedleftarm")
      end
    }
  },
  numbedrightarm = {
    sip = {
      aspriority = 48,
      spriority = 85,

      isadvisable = function ()
        return (affs.numbedrightarm and dict.grapple.ninshilimb ~= "rightarm" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedrightarm")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.rightarm()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "rightarm" then
          dict.grapple.ninshi = "rightarm" end
      end,

      onstart = function ()
        send("apply health to arms", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedrightarm)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedrightarm")
      end
    }
  },
  numbedchest = {
    sip = {
      aspriority = 49,
      spriority = 188,

      isadvisable = function ()
        return (affs.numbedchest and dict.grapple.ninshilimb ~= "chest" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedchest")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.chest()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "chest" then
          dict.grapple.ninshi = "chest" end
      end,

      onstart = function ()
        send("apply health to chest", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedchest)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedchest")
      end
    }
  },
  numbedgut = {
    sip = {
      aspriority = 50,
      spriority = 115,

      isadvisable = function ()
        return (affs.numbedgut and dict.grapple.ninshilimb ~= "gut" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedgut")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.gut()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "gut" then
          dict.grapple.ninshi = "gut" end
      end,

      onstart = function ()
        send("apply health to gut", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedgut)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedgut")
      end
    }
  },
  numbedhead = {
    sip = {
      aspriority = 51,
      spriority = 207,

      isadvisable = function ()
        return (affs.numbedhead and dict.grapple.ninshilimb ~= "head" and not affs.slickness) or false
      end,

      oncompleted = function ()
        removeaff("numbedhead")
        sk.lostbal_sip()
      end,

      noeffect = function()
        completely_healed.head()
      end,

      nouse = function ()
        sk.lostbal_sip()
      end,

      ninshi = function ()
        sk.lostbal_sip()
        if not affs.grapple then addaff(dict.grapple) end
        if dict.grapple.ninshilimb ~= "head" then
          dict.grapple.ninshi = "head" end
      end,

      onstart = function ()
        send("apply health to head", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function (amount)
        addaff(dict.numbedhead)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("numbedhead")
      end
    }
  },

  pitted = {
    ignorediag = true, -- this aff does not show up on diagnose, so don't remove it when we do diagnose.. or ah, this is superceded by a whitelist for now
    physical = {
      balanceful_act = true,
      aspriority = 32,
      spriority = 126,

      isadvisable = function ()
        return (affs.pitted and
          not doingaction("curingpitted") and not doingaction("pitted") and
          ((conf.rockclimbing and stats.currentpower >= 3) or
            (not affs.prone and not affs.paralysis and not affs.severedspine and not affs.crippledleftleg and not affs.crippledrightleg and not affs.mangledleftleg and not affs.mangledrightleg and not affs.missingrightleg and not affs.missingleftleg and not affs.impale and not affs.vines and not affs.transfixed and not affs.clampedleft and not affs.clampedright and not affs.hoisted and not affs.roped and not affs.shackled and not affs.grapple and not affs.truss and not affs.tangle and not affs.crucified and not affs.gore))) or false
      end,

      oncompleted = function ()
        doaction(dict.curingpitted.waitingfor)
      end,

      onstart = function ()
        if ((not conf.alwaysrockclimb or not conf.rockclimbing) and not affs.prone and not affs.paralysis and not affs.severedspine and not affs.crippledleftleg and not affs.crippledrightleg and not affs.mangledleftleg and not affs.mangledrightleg and not affs.missingrightleg and not affs.missingleftleg and not affs.impale and not affs.vines and not affs.transfixed and not affs.clampedleft and not affs.clampedright and not affs.hoisted and not affs.roped and not affs.shackled and not affs.grapple and not affs.truss and not affs.tangle and not affs.crucified and not affs.gore and not affs.unknowncrippledleg) then
            send("climb up", conf.commandecho)
        elseif (conf.rockclimbing and stats.currentpower >= 3) then
            send("climb rocks", conf.commandecho)
        end
      end,

      notpitted = function ()
        removeaff("pitted")
        signals.anyroom:block(sk.waiting_on_pit)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.pitted)
        signals.anyroom:unblock(sk.waiting_on_pit) -- we might get out via many means we don't track...
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pitted")
      end,
    }
  },
  curingpitted = {
    spriority = 0,
    waitingfor = {
      customwait = 4,

      oncompleted = function ()
        removeaff("pitted")
        signals.anyroom:block(sk.waiting_on_pit)
      end,

      onstart = function ()
      end,
    }
  },
  throatlock = {
    focus = {
      aspriority = 11,
      spriority = 200,

      isadvisable = function ()
        return (affs.throatlock and
          not doingaction("curingthroatlock") and not doingaction("throatlock")) or false
      end,

      oncompleted = function ()
        sk.lostbal_focus()

        doaction(dict.curingthroatlock.waitingfor)
      end,

      focusbody = true,
      onstart = function ()
        send("focus body", conf.commandecho)
      end,

      empty = function ()
        empty.focus_body()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.throatlock)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("throatlock")
      end,
    }
  },
  curingthroatlock = {
    waitingfor = {
      customwait = 4,

      oncompleted = function ()
        removeaff("throatlock")
        bals.focus = true
      end,

      ontimeout = function ()
        removeaff("throatlock")
        bals.focus = true
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m focus body throatlock")
        end)
      end,
    }
  },
  leglock = {
    focus = {
      aspriority = 6,
      spriority = 199,

      isadvisable = function ()
        return (affs.leglock and
          not doingaction("curingleglock") and not doingaction("leglock")) or false
      end,

      oncompleted = function ()
        sk.lostbal_focus()

        doaction(dict.curingleglock.waitingfor)
      end,

      focusbody = true,
      onstart = function ()
        send("focus body", conf.commandecho)
      end,

      empty = function ()
        empty.focus_body()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.leglock)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("leglock")
      end,
    }
  },
  curingleglock = {
    waitingfor = {
      customwait = 4,

      oncompleted = function ()
        removeaff("leglock")
        bals.focus = true
      end,

      ontimeout = function ()
        removeaff("leglock")
        bals.focus = true
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m focus body leglock")
        end)
      end,
    }
  },
  paralysis = {
    focus = {
      aspriority = 27,
      spriority = 78,

      isadvisable = function ()
        return (affs.paralysis and
          not doingaction("curingparalysis") and not doingaction("paralysis")) or false
      end,

      oncompleted = function ()
        sk.lostbal_focus()
        doaction(dict.curingparalysis.waitingfor)
      end,

      focusbody = true,
      onstart = function ()
        send("focus body", conf.commandecho)
      end,

      empty = function ()
        empty.focus_body()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.paralysis and
          not doingaction("curingparalysis") and not doingaction("paralysis")) or false
      end,

      oncompleted = function ()
        sk.lostbal_wafer()
        removeaff("unknownwafer")
        doaction(dict.curingparalysis.waitingfor)
      end,

      notprone = function ()
        removeaff("paralysis")
      end,

      instantcure = function()
        sk.lostbal_wafer()
        removeaff("unknownwafer")
        removeaff("paralysis")
        end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("paralysis", "dust")
        --eat("dust")
      end,

      empty = function ()
        empty.eat_wafer()
      end
    },
    waitingfor = {
      customwait = 30,
      oncompleted = function()
        removeaff("paralysis")
      end,

    },
    aff = {
      oncompleted = function ()
        addaff(dict.paralysis)

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("paralysis")
      end,
    },
    onremoved = function () donext() end
  },
  curingparalysis = {
    spriority = 0,
    waitingfor = {
      customwait = 4,

      oncompleted = function ()
        removeaff("paralysis")
        bals.focus = true
      end,

      ontimeout = function ()
        removeaff("paralysis")
        bals.focus = true
      end,

      notprone = function()
        removeaff("paralysis")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m focus body paralysis")
        end)
      end,
    }
  },
  sleep = {
    misc = {
      aspriority = 27,
      spriority = 227,

      isadvisable = function ()
        return (affs.sleep and
          not doingaction("curingsleep") and not doingaction("sleep")) or false
      end,

      oncompleted = function ()
        doaction(dict.curingsleep.waitingfor)
      end,

      onstart = function ()
        send("wake up", conf.commandecho)
      end,

      -- ???
      empty = function ()
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.sleep then addaff(dict.sleep) end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sleep")
      end,
    }
  },
  curingsleep = {
    spriority = 0,
    waitingfor = {
      customwait = 999,

      oncompleted = function ()
        removeaff("sleep")
        defences.lost("insomnia")
      end,

      onstart = function () end
    }
  },

  binah = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("binah")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.binah)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("binah")
      end,
    }
  },
  omen = {
    focus = {
      aspriority = 39,
      spriority = 425,

      isadvisable = function ()
        return (affs.omen) or false
      end,

      oncompleted = function ()
        removeaff("omen")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("omen")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.omen)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("omen")
      end
    }
  },
  papaxiego = {
    focus = {
      aspriority = 38,
      spriority = 319,

      isadvisable = function ()
        return (affs.papaxiego) or false
      end,

      oncompleted = function ()
        removeaff("papaxiego")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("papaxiego")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.papaxiego)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("papaxiego")
      end
    }
  },
  papaximana = {
    focus = {
      aspriority = 37,
      spriority = 318,

      isadvisable = function ()
        return (affs.papaximana) or false
      end,

      oncompleted = function ()
        removeaff("papaximana")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("papaximana")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.papaximana)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("papaximana")
      end
    }
  },
  papaxihealth = {
    focus = {
      aspriority = 36,
      spriority = 317,

      isadvisable = function ()
        return (affs.papaxihealth) or false
      end,

      oncompleted = function ()
        removeaff("papaxihealth")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("papaxihealth")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.papaxihealth)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("papaxihealth")
      end
    }
  },
  taintsick = {
    focus = {
      aspriority = 41,
      spriority = 30,

      isadvisable = function ()
        return (affs.taintsick and not doingaction "taintsick") or false
      end,

      oncompleted = function ()
        removeaff("taintsick")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("taintsick")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.taintsick and not doingaction "taintsick") or false
      end,

      oncompleted = function ()
        removeaff("taintsick")
        removeaff("unknownwafer")
        sk.lostbal_wafer()
      end,

      eatcure = "dust",
      onstart = function ()
        focus_aff("sickening", "dust")
        --eat("dust")
      end,

      empty = function()
        empty.eat_wafer()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.taintsick)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("taintsick")
      end,
    }
  },
  illuminated = {
    focus = {
      aspriority = 21,
      spriority = 1,

      isadvisable = function ()
        return (affs.illuminated) or false
      end,

      oncompleted = function ()
        removeaff("illuminated")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("illuminated")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      focus = true,

      isadvisable = function ()
        return (affs.illuminated and codepaste.smoke_steam_pipe()) or false
      end,

      oncompleted = function ()
        removeaff("illuminated")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      smokecure = "steam",
      onstart = function ()
        focus_aff("illuminated", "smoke " .. pipes.steam.id)
        --send("smoke " .. pipes.steam.id, conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.illuminated)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("illuminated")
      end,
    }
  },
  treebane = {
    focus = {
      aspriority = 20,
      spriority = 228,

      isadvisable = function ()
        return (affs.treebane) or false
      end,

      oncompleted = function ()
        removeaff("treebane")
        sk.lostbal_focus()
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.treebane)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("treebane")
      end,
    }
  },

  octave = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("octave")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.octave)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("octave")
      end,
    }
  },

  completelyaurawarped = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.completelyaurawarped and
          not doingaction("completelyaurawarped")) or false
      end,

      oncompleted = function ()
        removeaff("completelyaurawarped")
        removeaff("unknownsteam")
        addaff (dict.massivelyaurawarped)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam warpedaura", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_aurawarps()
        addaff(dict.completelyaurawarped)
      end,
    },
    gone = {
	  oncompleted = function ()
	    removeaff("completelyaurawarped")
	  end,
	  }
  },
  massivelyaurawarped = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.massivelyaurawarped and
          not doingaction("massivelyaurawarped")) or false
      end,

      oncompleted = function ()
        removeaff("completelyaurawarped")
        removeaff("massivelyaurawarped")
        removeaff("unknownsteam")
        addaff (dict.aurawarped)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam warpedaura", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_aurawarps()
        addaff(dict.massivelyaurawarped)
      end,
    },
    gone = {
	  oncompleted = function ()
	    removeaff("massivelyaurawarped")
	  end,
	}
  },

  aurawarped = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.aurawarped and
          not doingaction("aurawarped")) or false
      end,

      oncompleted = function ()
        removeaff("completelyaurawarped")
        removeaff("massivelyaurawarped")
        removeaff("aurawarped")
        removeaff("unknownsteam")
        addaff (dict.moderatelyaurawarped)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_aurawarps()
        addaff(dict.aurawarped)
      end,
    },
    gone = {
	  oncompleted = function ()
	    removeaff("aurawarped")
	  end,
	}
  },
  moderatelyaurawarped = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.moderatelyaurawarped and
          not doingaction("moderatelyaurawarped")) or false
      end,

      oncompleted = function ()
        removeaff("completelyaurawarped")
        removeaff("massivelyaurawarped")
        removeaff("aurawarped")
        removeaff("moderatelyaurawarped")
        removeaff("unknownsteam")
        addaff (dict.slightlyaurawarped)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_aurawarps()
        addaff(dict.moderatelyaurawarped)
      end,
    },
    gone = {
	  oncompleted = function ()
	    removeaff("moderatelyaurawarped")
	  end,
	}
  },
  slightlyaurawarped = {
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.slightlyaurawarped and
          not doingaction("slightlyaurawarped")) or false
      end,

      oncompleted = function ()
        removeaff("completelyaurawarped")
        removeaff("massivelyaurawarped")
        removeaff("aurawarped")
        removeaff("moderatelyaurawarped")
        removeaff("slightlyaurawarped")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_aurawarps()
        addaff(dict.slightlyaurawarped)
      end,
    },
    gone = {
	  oncompleted = function ()
	    removeaff("slightlyaurawarped")
	  end,
	}
  },
  massivetimewarp = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.massivetimewarp and not doingaction "massivetimewarp") or false
      end,

      oncompleted = function ()
        removeaff("massivetimewarp")
        addaff (dict.majortimewarp)
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end

    },
    focus = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.massivetimewarp and
          not doingaction("massivetimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("massivetimewarp")
        addaff (dict.majortimewarp)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.massivetimewarp and
          not doingaction("massivetimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("massivetimewarp")
        removeaff("unknownsteam")
        addaff (dict.majortimewarp)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam timewarp", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_timewarps()
        addaff(dict.massivetimewarp)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("massivetimewarp")
      end,
    }
  },
  majortimewarp = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.majortimewarp and not doingaction "majortimewarp") or false
      end,

      oncompleted = function ()
        removeaff("majortimewarp")
        addaff (dict.moderatetimewarp)
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    focus = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.majortimewarp and
          not doingaction("majortimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("majortimewarp")
        addaff (dict.moderatetimewarp)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.majortimewarp and
          not doingaction("majortimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("majortimewarp")
        removeaff("massivetimewarp")
        removeaff("unknownsteam")
        addaff (dict.moderatetimewarp)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam timewarp", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_timewarps()
        addaff(dict.majortimewarp)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("majortimewarp")
      end,
    }
  },
  moderatetimewarp = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.moderatetimewarp and not doingaction "moderatetimewarp") or false
      end,

      oncompleted = function ()
        removeaff("moderatetimewarp")
        addaff (dict.minortimewarp)
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    focus = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.moderatetimewarp and
          not doingaction("moderatetimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("moderatetimewarp")
        addaff (dict.minortimewarp)
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.moderatetimewarp and
          not doingaction("moderatetimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("moderatetimewarp")
        removeaff("majortimewarp")
        removeaff("massivetimewarp")
        removeaff("unknownsteam")
        addaff (dict.minortimewarp)
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam timewarp", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()

      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_timewarps()
        addaff(dict.moderatetimewarp)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("moderatetimewarp")
      end,
    }
  },
  minortimewarp = {
    herb = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.minortimewarp and not doingaction "minortimewarp") or false
      end,

      oncompleted = function ()
        removeaff("minortimewarp")
        sk.lostbal_herb()
      end,

      eatcure = "horehound",
      onstart = function ()
        eat("horehound")
      end,

      failed = function ()
        sk.lostbal_herb ()
        dict.bedevil.blocked = true
      end,

      empty = function()
        empty.eat_horehound()
      end
    },
    focus = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.minortimewarp and
          not doingaction("minortimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("minortimewarp")
        sk.lostbal_focus()
      end,

      focusmind = true,
      onstart = function ()
        send("focus mind", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_mind()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.minortimewarp and
          not doingaction("minortimewarp")) or false
      end,

      oncompleted = function ()
        removeaff("minortimewarp")
        removeaff("moderatetimewarp")
        removeaff("majortimewarp")
        removeaff("massivetimewarp")
        removeaff("unknownsteam")
        sk.lostbal_steam()
      end,

      onstart = function ()
        send("smoke steam", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_steam()
        empty.smoke_steam()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_timewarps()
        addaff(dict.minortimewarp)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("minortimewarp")
      end,
    }
  },

-- uncurable
  herbbane = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("herbbane")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.herbbane)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("herbbane")
      end,
    }
  },
  snakebane = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("snakebane")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.snakebane)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("snakebane")
      end,
    }
  },
  batbane = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("batbane")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.batbane)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("batbane")
      end,
    }
  },
  darkmoon = {
    focus = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.darkmoon) or false
      end,

      oncompleted = function ()
        removeaff("darkmoon")
        sk.lostbal_focus()
      end,

      woreoff = function ()
        removeaff("darkmoon")
      end,

      focusspirit = true,
      onstart = function ()
        send("focus spirit", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_focus()

        empty.focus_spirit()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.darkmoon)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("darkmoon")
      end
    }
  },
  darkfate = {
    waitingfor = {
      customwait = 2,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("darkfate")
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.darkfate then
          addaff(dict.darkfate)
          doaction(dict.darkfate.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("darkfate")
      end,
    }
  },
  illusorywounds = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("illusorywounds")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.illusorywounds)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("illusorywounds")
      end,
    }
  },
  sightstealer = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("sightstealer")
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.sightstealer then
          addaff(dict.sightstealer)
          doaction(dict.sightstealer.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("sightstealer")
      end,
    }
  },
  thoughtstealer = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("thoughtstealer")
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.thoughtstealer then
          addaff(dict.thoughtstealer)
          doaction(dict.thoughtstealer.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thoughtstealer")
      end,
    }
  },
  stars = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("stars")
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.stars then
          addaff(dict.stars)
          doaction(dict.stars.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("stars")
      end,
    }
  },
  avengingangel = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("avengingangel")
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.avengingangel then
          addaff(dict.avengingangel)
          doaction(dict.avengingangel.waitingfor)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("avengingangel")
      end,
    }
  },
  phantom = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("phantom")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.phantom)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("phantom")
      end,
    }
  },

  earache = {
    waitingfor = {
      customwait = 15,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      ontimeout = function()
        removeaff("earache")
      end,

      oncompleted = function ()
        removeaff("earache")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.earache)
        doaction(dict.earache.waitingfor) -- self-timeout
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("earache")
        killaction (dict.earache.waitingfor)
      end,
    }
  },
  scarab = {
    waitingfor = {
      customwait = 3,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("scarab")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.scarab)
        doaction(dict.scarab.waitingfor)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("scarab")
      end
    }
  },
  echoes = {
    waitingfor = {
      customwait = 12,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("echoes")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.echoes)
        doaction(dict.echoes.waitingfor)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("echoes")
      end
    }
  },
  ectoplasm = {
    physical = {
      balanceful_act = true,
      aspriority = 57,
      spriority = 283,

      isadvisable = function ()
        return (affs.ectoplasm and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("ectoplasm")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.ectoplasm)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("ectoplasm")
      end
    }
  },
  incapacitatingallergy = {
    waitingfor = {
      aspriority = 0,
      spriority = 0,

      oncompleted = function ()
        removeaff("incapacitatingallergy")
        addaff(dict.severeallergy)
      end,

    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.incapacitatingallergy)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("incapacitatingallergy")
      end,
    }
  },
  severeallergy = {
    waitingfor = {
      aspriority = 0,
      spriority = 0,

      oncompleted = function ()
        removeaff("severeallergy")
        addaff(dict.strongallergy)
      end,

    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.severeallergy)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("severeallergy")
      end,
    }
  },
  strongallergy = {
    waitingfor = {
      aspriority = 0,
      spriority = 0,

      oncompleted = function ()
        removeaff("strongallergy")
        addaff(dict.mildallergy)
      end,

    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.strongallergy)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff "strongallergy"
      end
    }
  },
  mildallergy = {
    waitingfor = {
      aspriority = 0,
      spriority = 0,

      oncompleted = function ()
        codepaste.remove_insanities()
      end,

    },
    aff = {
      oncompleted = function ()
        codepaste.remove_insanities()
        addaff(dict.mildallergy)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mildallergy")
      end,
    }
  },
  deathmarkfive = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deathmarkfive and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("deathmarkfive")
        addaff(dict.deathmarkfour)
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_deathmarks()
        addaff(dict.deathmarkfive)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("deathmarkfive")
      end
    }
  },
  deathmarkfour = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deathmarkfour and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("deathmarkfour")
        addaff (dict.deathmarkthree)
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_deathmarks()
        addaff(dict.deathmarkfour)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("deathmarkfour")
      end
    }
  },
  deathmarkthree = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deathmarkthree and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("deathmarkthree")
        addaff (dict.deathmarktwo)
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_deathmarks()
        addaff(dict.deathmarkthree)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("deathmarkthree")
      end
    }
  },
  deathmarktwo = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deathmarktwo and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("deathmarktwo")
        addaff (dict.deathmarktwo)
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_deathmarks()
        addaff(dict.deathmarktwo)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("deathmarktwo")
      end
    }
  },
  deathmarkone = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.deathmarkone and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("deathmarkone")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        codepaste.remove_deathmarks()
        addaff(dict.deathmarkone)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("deathmarkone")
      end
    }
  },
  gunk = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.gunk and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("gunk")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.gunk)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("gunk")
      end
    }
  },
  mucous = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.mucous and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed and not affs.shackled) or false
      end,

      oncompleted = function ()
        removeaff("mucous")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mucous)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mucous")
      end
    }
  },
  mud = {
    physical = {
      balanceful_act = true,
      aspriority = 37,
      spriority = 234,

      isadvisable = function ()
        return (affs.mud and conf.cleanse and not affs.prone and not codepaste.cleanse_codepaste() and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed) or false
      end,

      oncompleted = function ()
        removeaff("mud")
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.mud)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("mud")
      end
    }
  },
  sap = {
    physical = {
      balanceful_act = true,
      aspriority = 38,
      spriority = 324,

      isadvisable = function ()
        -- debugf("sap_physical getting checked...")
        -- debugf("affs.sap %s and conf.cleanse %s and not codepaste.cleanse_codepaste() %s and not affs.prone %s and not affs.paralysis %s and not affs.severedspine %s and not affs.tangle %s and not affs.transfixed %s", tostring(affs.sap), tostring(conf.cleanse), tostring(codepaste.cleanse_codepaste() or 'no value'), tostring(affs.prone), tostring(affs.paralysis), tostring(affs.severedspine), tostring(affs.tangle), tostring(affs.transfixed))
        return (affs.sap and conf.cleanse and not codepaste.cleanse_codepaste() and not affs.prone and not affs.paralysis and not affs.severedspine and not affs.tangle and not affs.transfixed) or false
      end,

      oncompleted = function ()
        removeaff("sap")
        signals.sapcured:emit()
      end,

      empty = function () empty.cleanse() end,

      cleanse = true,
      onstart = function ()
        rub_cleanse()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.sap)
        signals.aeony:emit()
        signals.sapafflicted:emit()
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("sap")
        killaction (dict.earache.waitingfor)
        signals.sapcured:emit()
      end,
    },
    onremoved = function ()
      if affsp.sap then
        affsp.sap = nil end
      signals.aeony:emit()
      signals.sapcured:emit()
    end,
  },
  choke = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("choke")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.choke)
        signals.aeony:emit()
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("choke")
      end,
    },
    onremoved = function ()
      if affsp.choke then
        affsp.choke = nil end
      signals.aeony:emit()
    end
  },
  retardation = {
    waitingfor = {
      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("retardation")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.retardation)
        signals.aeony:emit()
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("retardation")
      end,
    },
    onremoved = function ()
      if affsp.retardation then
        affsp.retardation = nil end
      signals.aeony:emit()
    end
  },
  maestoso = {
    waitingfor = {
      customwait = 6,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,
      ontimeout = function ()
        echof("Okay, I think maestoso went away.")
        dict.maestoso.waitingfor.oncompleted()
      end,

      oncompleted = function ()
        removeaff("maestoso")

        make_gnomes_work()
        signals.newroom:block(sk.check_maestoso)
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.maestoso)
        doaction(dict.maestoso.waitingfor)
        signals.newroom:unblock(sk.check_maestoso)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("maestoso")
        killaction (dict.maestoso.waitingfor)
        signals.newroom:block(sk.check_maestoso)
      end,
    }
  },
  rainbowpattern = {
    waitingfor = {
      customwait = 180,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,
      ontimeout = function ()
        removeaff("rainbowpattern")
      end,

      oncompleted = function ()
        removeaff("rainbowpattern")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.rainbowpattern)
        doaction(dict.rainbowpattern.waitingfor)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("rainbowpattern")
        killaction (dict.rainbowpattern.waitingfor)
      end,
    }
  },

  dreamer = {
    waitingfor = {
      customwait = 60,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("dreamer")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.dreamer)
        if not doingaction ("dreamer") then doaction(dict.dreamer.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("dreamer")
        killaction (dict.dreamer.waitingfor)
      end,
    }
  },
  afterimage = {
    waitingfor = {
      customwait = 24, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("afterimage")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.afterimage)
        if not doingaction ("afterimage") then doaction(dict.afterimage.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("afterimage")
        killaction (dict.afterimage.waitingfor)
      end,
    }
  },
  infidel = {
    waitingfor = {
      customwait = 30, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("infidel")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.infidel)
        if not doingaction ("infidel") then doaction(dict.infidel.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("infidel")
        killaction (dict.infidel.waitingfor)
      end,
    }
  },

  hypnoticpattern = {
    waitingfor = {
      customwait = 60,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("hypnoticpattern")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hypnoticpattern)
        if not doingaction ("hypnoticpattern") then doaction(dict.hypnoticpattern.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("hypnoticpattern")
        killaction (dict.hypnoticpattern.waitingfor)
      end,
    }
  },

  darkseed = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("darkseed")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.darkseed)
        if not doingaction ("darkseed") then doaction(dict.darkseed.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("darkseed")
        killaction (dict.darkseed.waitingfor)
      end,
    }
  },
  greywhispers = {
    waitingfor = {
      customwait = 38, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("greywhispers")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.greywhispers)
        if not doingaction ("greywhispers") then doaction(dict.greywhispers.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("greywhispers")
        killaction (dict.greywhispers.waitingfor)
      end,
    }
  },
  sluggish = {
    waitingfor = {
      customwait = 38, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("sluggish")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.sluggish)
        if not doingaction ("sluggish") then doaction(dict.sluggish.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("sluggish")
        killaction (dict.sluggish.waitingfor)
      end,
    }
  },
  homeostasis = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("homeostasis")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.homeostasis)
        if not doingaction ("homeostasis") then doaction(dict.homeostasis.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("homeostasis")
        killaction (dict.homeostasis.waitingfor)
      end,
    }
  },
  enfeeble = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("enfeeble")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.enfeeble)
        if not doingaction ("enfeeble") then doaction(dict.enfeeble.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("enfeeble")
        killaction (dict.enfeeble.waitingfor)
      end,
    }
  },
  rubycrystal = {
    count = 0,
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("rubycrystal")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function (count)
        dict.rubycrystal.count = count or (dict.rubycrystal.count+1)
        addaff(dict.rubycrystal)
        updateaffcount(dict.rubycrystal)
        if not doingaction ("rubycrystal") then doaction(dict.rubycrystal.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("rubycrystal")
        dict.rubycrystal.count = 0
        killaction (dict.rubycrystal.waitingfor)
      end,
    }
  },
  oracle = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("oracle")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.oracle)
        if not doingaction ("oracle") then doaction(dict.oracle.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("oracle")
        killaction (dict.oracle.waitingfor)
      end,
    }
  },
  timeechoes = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("timeechoes")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.timeechoes)
        if not doingaction ("timeechoes") then doaction(dict.timeechoes.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("timeechoes")
        killaction (dict.timeechoes.waitingfor)
      end,
    }
  },
  bubble = {
    waitingfor = {
      customwait = 999, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("bubble")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.bubble)
        if not doingaction ("bubble") then doaction(dict.bubble.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("bubble")
        killaction (dict.bubble.waitingfor)
      end,
    }
  },

  inquisition = {
    waitingfor = {
      customwait = 11,

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("inquisition")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.inquisition)
        if not doingaction ("inquisition") then doaction(dict.inquisition.waitingfor) end
        sys.manualdefcheck = true

        --[[o Sacraments Inquisition now clears parry weights and you cannot
            naturally dodge attacks while under it. Only the person who brands the
            target a heretic may brand them an infidel or inquisition them. Report 1270.
        ]]
        for limb, _ in pairs(sps.parry_currently) do
          sps.parry_currently[limb] = 0
        end
        check_sp_satisfied()
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("inquisition")
        killaction (dict.inquisition.waitingfor)
      end,
    }
  },
  badluck = {
    waitingfor = {
      customwait = 30, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("badluck")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.badluck)
        if not doingaction ("badluck") then doaction(dict.badluck.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("badluck")
        killaction (dict.badluck.waitingfor)
      end,
    }
  },
  drunk = {
    waitingfor = {
      customwait = 30, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("drunk")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.drunk)
        if not doingaction ("drunk") then doaction(dict.drunk.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("drunk")
        killaction (dict.drunk.waitingfor)
      end,
    }
  },
  heretic = {
    waitingfor = {
      customwait = 30, -- ??

      isadvisable = function ()
        return false
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("heretic")
        make_gnomes_work()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.heretic)
        if not doingaction ("heretic") then doaction(dict.heretic.waitingfor) end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("heretic")
        killaction (dict.heretic.waitingfor)
      end,
    }
  },
  stun = {
    waitingfor = {
      customwait = 1,

      isadvisable = function ()
        return false
      end,

      ontimeout = function ()
        removeaff("stun")
        make_gnomes_work()
      end,

      onstart = function () end,

      oncompleted = function ()
        removeaff("stun")
      end
    },
    aff = {
      oncompleted = function (time)
        addaff(dict.stun)
        if time == 0 then time = nil end
        dict.stun.waitingfor.customwait = time or 1
        doaction(dict.stun.waitingfor)
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("stun")
        killaction (dict.stun.waitingfor)
      end,
    }
  },

-- balanceful things
  thornlashedhead = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affs.thornlashedhead and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingthornlashedhead.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.thornlashedhead)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thornlashedhead")
      end,
    }
  },
  curingthornlashedhead = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("thornlashedhead")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure thornlashedhead")
        end)
      end
    }
  },
  thornlashedleftleg = {
    misc = {
      aspriority = 36,
      spriority = 229,

      isadvisable = function ()
        return (affs.thornlashedleftleg and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingthornlashedleftleg.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.thornlashedleftleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thornlashedleftleg")
      end,
    }
  },
  curingthornlashedleftleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("thornlashedleftleg")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure thornlashedleftleg")
        end)
      end
    }
  },
  thornlashedleftarm = {
    misc = {
      aspriority = 35,
      spriority = 230,

      isadvisable = function ()
        return (affs.thornlashedleftarm and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingthornlashedleftarm.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.thornlashedleftarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thornlashedleftarm")
      end,
    }
  },
  curingthornlashedleftarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("thornlashedleftarm")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure thornlashedleftarm")
        end)
      end
    }
  },
  thornlashedrightarm = {
    misc = {
      aspriority = 34,
      spriority = 231,

      isadvisable = function ()
        return (affs.thornlashedrightarm and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingthornlashedrightarm.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.thornlashedrightarm)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thornlashedrightarm")
      end,
    }
  },
  curingthornlashedrightarm = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("thornlashedrightarm")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure thornlashedrightarm")
        end)
      end
    }
  },
  thornlashedrightleg = {
    misc = {
      aspriority = 33,
      spriority = 232,

      isadvisable = function ()
        return (affs.thornlashedrightleg and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingthornlashedrightleg.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.thornlashedrightleg)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("thornlashedrightleg")
      end,
    }
  },
  curingthornlashedrightleg = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("thornlashedrightleg")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure thornlashedrightleg")
        end)
      end
    }
  },
  pinlegright2 = {
    misc = {
      aspriority = 0,
      spriority = 0,
      dontbatch = true,

      isadvisable = function ()
        return (bals.balance and affs.pinlegright2 and codepaste.basicpinwrithe() and not doingaction"pinlegright2" and not doingaction"curingpinlegright2" and not sk.addingpinright) or false
      end,

      oncompleted = function ()
        doaction(dict.curingpinlegright2.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("rightpin")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        sk.addingpinright = true
        addaff(dict.pinlegright2)
        tempTimer(conf.pindelay or 0.050, function() sk.addingpinright = nil; make_gnomes_work() end)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pinlegright2")
      end,
    }
  },
  curingpinlegright2 = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("pinlegright2")
        addaff(dict.pinlegright)
      end,

      secondary = function ()
        removeaff("pinlegright2")
        addaff(dict.pinlegright)
      end,

      withdrew = function ()
        removeaff("pinlegright2")
        addaff(dict.pinlegright)
        doaction(dict.curingpinlegright.waitingfor)
      end,

      onstart = function ()
        addaff(dict.pinlegright2) -- for unknowns
        removeaff("pinlegunknown")
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure pinlegright2")
        end)
      end
    }
  },
  pinlegright = {
    misc = {
      aspriority = 62,
      spriority = 322,
      dontbatch = true,

      isadvisable = function ()
        return (bals.balance and affs.pinlegright and codepaste.basicpinwrithe() and not doingaction"pinlegright" and not doingaction"curingpinlegright" and not sk.addingpinright and not doingaction"pinlegleft" and (not affs.pinlegright2 or doingaction"curingpinlegright2")) or false
        -- not the 2nd so the priorities don't do the first one, because the game only allows from 2nd when you have both
      end,

      oncompleted = function ()
        doaction(dict.curingpinlegright.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("rightpin")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        if affs.pinlegright or sk.addingpinright then
          sk.addingpinright = true
          addaff(dict.pinlegright2)
          tempTimer(conf.pindelay or 0.050, function() sk.addingpinright = nil; make_gnomes_work() end)
        else
          sk.addingpinright = true
          addaff(dict.pinlegright)
          tempTimer(conf.pindelay or 0.050, function() sk.addingpinright = nil; make_gnomes_work() end)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pinlegright")
      end,
    }
  },
  curingpinlegright = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("pinlegright")
        removeaff("pinlegright2")
      end,

      secondary = function()
        removeaff("pinlegright2")
      end,

      -- this method can get called when we have pinlegright2, so we need to handle both cases
      withdrew = function ()
        if affs.pinlegright2 then
          removeaff("pinlegright2")
        else
          removeaff("pinlegright")
        end

        -- if we were writhing... let the writhe continue.
        if affs.pinlegright then
          tempTimer(0, function() doaction(dict.curingpinlegright.waitingfor) end)
        elseif affs.pinlegleft2 then
          tempTimer(0, function() doaction(dict.curingpinlegleft2.waitingfor) end)
        elseif affs.pinlegleft then
          tempTimer(0, function() doaction(dict.curingpinlegleft.waitingfor) end)
        end
      end,

      onstart = function ()
        addaff(dict.pinlegright) -- for unknowns
        removeaff("pinlegunknown")
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure pinlegright")
        end)
      end
    }
  },
  pinlegleft2 = {
    misc = {
      aspriority = 0,
      spriority = 0,
      dontbatch = true,

      isadvisable = function ()
        return (bals.balance and affs.pinlegleft2 and codepaste.basicpinwrithe() and not doingaction"pinlegleft2" and not doingaction"curingpinlegleft2" and not sk.addingpinleft) or false
      end,

      oncompleted = function ()
        doaction(dict.curingpinlegleft2.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("leftpin")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        sk.addingpinleft = true
        addaff(dict.pinlegleft2)
        tempTimer(conf.pindelay or 0.050, function() sk.addingpinleft = nil; make_gnomes_work() end)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pinlegleft2")
      end,
    }
  },
  curingpinlegleft2 = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("pinlegleft2")
        addaff(dict.pinlegleft)
      end,

      secondary = function()
        removeaff("pinlegleft2")
        addaff(dict.pinlegleft)
      end,

      withdrew = function ()
        removeaff("pinlegleft2")
        addaff(dict.pinlegleft)
        doaction(dict.curingpinlegleft.waitingfor)
      end,

      onstart = function ()
        addaff(dict.pinlegleft2) -- for unknowns
        removeaff("pinlegunknown")
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure pinlegleft2")
        end)
      end
    }
  },
  pinlegleft = {
    misc = {
      aspriority = 63,
      spriority = 75,
      dontbatch = true, -- used to prevent both pinlegs at once - since isadvisable doens't know if another action is going to be done

      isadvisable = function ()
        return (bals.balance and affs.pinlegleft and codepaste.basicpinwrithe() and not doingaction"pinlegleft" and not doingaction"curingpinlegleft" and not sk.addingpinleft and not doingaction"pinlegright" and (not affs.pinlegleft2 or doingaction"curingpinlegleft2")) or false
      end,

      oncompleted = function ()
        doaction(dict.curingpinlegleft.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("leftpin")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        if affs.pinlegleft or sk.addingpinleft then
          sk.addingpinleft = true
          addaff(dict.pinlegleft2)
          tempTimer(conf.pindelay or 0.050, function() sk.addingpinleft = nil; make_gnomes_work() end)
        else
          sk.addingpinleft = true
          addaff(dict.pinlegleft)
          tempTimer(conf.pindelay or 0.050, function() sk.addingpinleft = nil; make_gnomes_work() end)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pinlegleft")
      end,
    }
  },
  curingpinlegleft = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("pinlegleft")
        removeaff("pinlegleft2")
      end,

      secondary = function()
        removeaff("pinlegleft2")
      end,

      withdrew = function ()
        if affs.pinlegleft2 then
          removeaff("pinlegleft2")
        else
          removeaff("pinlegleft")
        end

        -- if we were writhing... let the writhe continue. Possible trouble if we weren't writhing, though?
        if affs.pinlegleft then
          tempTimer(0, function() doaction(dict.curingpinlegleft.waitingfor) end)
        elseif affs.pinlegright2 then
          tempTimer(0, function() doaction(dict.curingpinlegright2.waitingfor) end)
        elseif affs.pinlegright then
          tempTimer(0, function() doaction(dict.curingpinlegright.waitingfor) end)
        end
      end,

      onstart = function ()
        addaff(dict.pinlegleft) -- for unknowns
        removeaff("pinlegunknown")
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure pinlegleft")
        end)
      end
    }
  },
  pinlegunknown = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (bals.balance and affs.pinlegunknown and codepaste.writhe()) or false
      end,

      oncompleted = function(which)
        if which == "left" or which == "right" then
          doaction(dict["curingpinleg"..which].waitingfor)
        elseif which == "impale" then
          doaction(dict.curingimpale.waitingfor)
        end
      end,

      onstart = function ()
        codepaste.dowrithe()
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.pinlegunknown)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("pinlegunknown")
      end,
    }
  },
  crucified = {
    misc = {
      aspriority = 40,
      spriority = 48,

      isadvisable = function ()
        return (affs.crucified and codepaste.writhe() and bals.balance) or false
      end,

      oncompleted = function ()
        doaction(dict.curingcrucified.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("crucifix")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.crucified)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("crucified")
      end,
    }
  },
  curingcrucified = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("crucified")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure crucified")
        end)
      end
    }
  },
  gore = {
    misc = {
      aspriority = 0,
      spriority = 0,
      dontbatch = true,

      isadvisable = function ()
        return (affs.gore and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curinggore.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("antlers")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.gore)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("gore")
      end,
    }
  },
  curinggore = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("gore")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure gore")
        end)
      end
    }
  },
  impale = {
    misc = {
      aspriority = 22,
      spriority = 54,

      isadvisable = function ()
        return (affs.impale and codepaste.writhe() and bals.balance) or false
      end,

      oncompleted = function ()
        doaction(dict.curingimpale.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("impale")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.impale)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("impale")
      end,
    }
  },
  curingimpale = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("impale")
      end,

      withdrew = function ()
        removeaff("impale")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure impale")
        end)
      end
    }
  },
  vines = {
    misc = {
      aspriority = 21,
      spriority = 52,

      isadvisable = function ()
        return (affs.vines and codepaste.writhe() and not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and dict.magicwrithe.physical.isadvisable())) or false
      end,

      oncompleted = function ()
        doaction(dict.curingvines.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("entangle")
      end,

      helpless = function ()
        empty.writhe_entangle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.vines)

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("vines")
      end,
    }
  },
  curingvines = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("vines")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure vines")
        end)
      end
    }
  },
  transfixed = {
    misc = {
      aspriority = 20,
      spriority = 49,

      isadvisable = function ()
        return (affs.transfixed and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingtransfixed.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("transfix")
      end,

      helpless  = function ()
        removeaff("transfixed")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.transfixed)

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("transfixed")
      end,
    },
    onremoved = function () donext() end
  },
  curingtransfixed = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("transfixed")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure transfixed")
        end)
      end
    }
  },
  clampedleft = {
    misc = {
      aspriority = 31,
      spriority = 123,

      isadvisable = function ()
        return (affs.clampedleft and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingclampedleft.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("clamp")
      end,

      helpless = function ()
        removeaff({"clampedright", "clampedleft"})
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clampedleft)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clampedleft")
      end,
    }
  },
  curingclampedleft = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("clampedleft")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure clampedleft")
        end)
      end
    }
  },
  clampedright = {
    misc = {
      aspriority = 30,
      spriority = 124,

      isadvisable = function ()
        return (affs.clampedright and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curingclampedright.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("clamp")
      end,

      helpless = function ()
        removeaff({"clampedright", "clampedleft"})
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.clampedright)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("clampedright")
      end,
    }
  },
  curingclampedright = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("clampedright")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure clampedright")
        end)
      end
    }
  },
  hoisted = {
    misc = {
      aspriority = 18,
      spriority = 44,

      isadvisable = function ()
        return (affs.hoisted and codepaste.writhe()) or false
      end,

      oncompleted = function ()
        doaction(dict.curinghoisted.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("hoist")
      end,

      helpless  = function ()
        removeaff("hoisted")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.hoisted)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("hoisted")
      end,
    }
  },
  curinghoisted = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("hoisted")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure hoisted")
        end)
      end
    }
  },
  roped = {
    misc = {
      aspriority = 17,
      spriority = 17,

      isadvisable = function ()
        return (affs.roped and codepaste.writhe() and not affs.crucified and not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and dict.magicwrithe.physical.isadvisable())) or false
      end,

      oncompleted = function ()
        doaction(dict.curingroped.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("ropes")
      end,

      helpless = function ()
        removeaff("roped")

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tangle)
        --addaff(dict.roped)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("roped")
      end,
    }
  },
  curingroped = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("roped")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure roped")
        end)
      end
    }
  },
  shackled = {
    misc = {
      aspriority = 16,
      spriority = 16,

      isadvisable = function ()
        return (affs.shackled and codepaste.writhe() and not affs.crucified and not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and dict.magicwrithe.physical.isadvisable())) or false
      end,

      oncompleted = function ()
        doaction(dict.curingshackled.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("shackles")
      end,

      helpless = function ()
        removeaff("shackled")
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tangle)
        --[[addaff(dict.shackled)

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end]]
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("shackled")
      end,
    }
  },
  curingshackled = {
    spriority = 0,
    waitingfor = {
      customwait = 3,

      oncompleted = function ()
        removeaff("shackled")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure shackled")
        end)
      end
    }
  },
  grapple = {
  --  ninshilimb = "",
  --  fullbody = true,
    misc = {
      aspriority = 15,
      spriority = 15,

      isadvisable = function ()
        return (affs.grapple and codepaste.writhe() and not doingaction "grapple" and not affs.crucified) or false
      end,

      oncompleted = function ()
        doaction(dict.curinggrapple.waitingfor)
      end,

      lost = function ()
        removeaff("grapple")
        if not actions.grapple_aff then killaction(dict.curinggrapple.waitingfor) end
        dict.grapple.ninshilimb = nil

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      onstart = function ()
        codepaste.dowrithe("grapple")
      end,

      helpless = function ()
        removeaff("grapple")
        dict.grapple.ninshilimb = nil
      end
    },
    aff = {
      oncompleted = function (which)
        if not actions.curinggrapple_misc then addaff(dict.grapple) end
        dict.grapple.ninshilimb = nil
        if which then dict.grapple[which] = true end
      end,

      ninshi = function (limb)
        if not actions.curinggrapple_misc then addaff(dict.grapple) end
        dict.grapple.ninshilimb = limb
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("grapple")
        dict.grapple.ninshilimb = nil
        dict.grapple.fullbody = false
      end,
    },
    onremoved = function ()
      dict.grapple.ninshilimb = nil
      dict.grapple.fullbody = false
    end
  },
  curinggrapple = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("grapple")
        dict.grapple.ninshilimb = nil
      end,

      kathrow = function ()
        removeaff("grapple")
        addaff(dict.prone)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      kadisarm = function ()
        removeaff("grapple")
        addaff(dict.crippledrightarm)
        addaff(dict.crippledleftarm)

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      tomati = function ()
        removeaff("grapple")

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      amihai = function ()
        removeaff("grapple")

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      yank = function ()
        removeaff("grapple")

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      shred = function ()
        removeaff("grapple")
        addaff (dict.laceratedleftleg)
        addaff (dict.laceratedrightleg)

        if affs.tangle then
          doaction (dict.curingtangle.waitingfor) end
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure grapple")
        end)
      end
    }
  },
  truss = {
    misc = {
      aspriority = 14,
      spriority = 41,

      isadvisable = function ()
        return (affs.truss and codepaste.writhe() and not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and dict.magicwrithe.physical.isadvisable())) or false
      end,

      oncompleted = function ()
        doaction(dict.curingtruss.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("truss")
      end,

      helpless = function ()
        empty.writhe()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tangle)
        --addaff(dict.truss)
      end,
    },
    gone = {
      oncompleted = function ()
        removeaff("truss")
      end,
    }
  },
  curingtruss = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("truss")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure truss")
        end)
      end
    }
  },
  tangle = {
    misc = {
      aspriority = 13,
      spriority = 13,

      isadvisable = function ()
        return (affs.tangle and codepaste.writhe() and not (bals.balance and bals.equilibrium and bals.rightarm and bals.leftarm and dict.magicwrithe.physical.isadvisable())) or false
      end,

      oncompleted = function ()
        doaction(dict.curingtangle.waitingfor)
      end,

      onstart = function ()
        codepaste.dowrithe("entangle")
      end,

      notprone = function ()
        removeaff("tangle")
      end,

      helpless = function ()
        empty.writhe_entangle()
      end
    },
    aff = {
      oncompleted = function ()
        addaff(dict.tangle)

        if actions.sap_physical then
          killaction (dict.sap.physical)
        end
      end
    },
    gone = {
      oncompleted = function ()
        removeaff("tangle")
      end
    },
    onremoved = function () donext() end
  },
  curingtangle = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        removeaff("tangle")
      end,

      notprone = function ()
        removeaff("tangle")
      end,

      onstart = function ()
        if not conf.aillusion then return end
        tempTimer(3, function ()
          enableTrigger("m&m cure tangle")
        end)
      end
    }
  },

  -- anti-illusion checks, grouped by symptom similarity
  checkslows = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (next(affsp) and (affsp.choke or affsp.aeon or affsp.sap or affsp.retardation)) or false
      end,

      oncompleted = function () end,

      sluggish = function ()
        if affsp.choke then
          affsp.choke = nil
          addaff (dict.choke)
        elseif affsp.aeon then
          affsp.aeon = nil
          addaff (dict.aeon)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        elseif affsp.sap then
          affsp.sap = nil
          addaff (dict.sap)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        elseif affsp.retardation then
          affsp.retardation = nil
          addaff (dict.retardation) end
        signals.aeony:emit()
      end,

      onclear = function ()
        affsp = {}
      end,

      onstart = function ()
        send("say", false)
      end
    },
    aff = {
      oncompleted = function (which)
        if not affs[which] then affsp[which] = true end
      end
    },
  },
  checkparalysis = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (next(affsp) and affsp.paralysis) or false
      end,

      oncompleted = function () end,

      paralyzed = function ()
        if affsp.paralysis then
          affsp.paralysis = nil
          addaff (dict.paralysis)
        end
      end,

      onclear = function ()
        if affsp.paralysis then
          affsp.paralysis = nil end
      end,

      notprone = function ()
        dict.checkparalysis.onclear()
      end,

      onstart = function ()
          enableTrigger("m&m check paralysis")
          send("touch balls", false)
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.paralysis then affsp.paralysis = true end
      end
    },
  },
  checkslitthroat = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (next(affsp) and (affsp.slitthroat)) or false
      end,

      oncompleted = function () end,

      holythroat = function ()
        if affsp.slitthroat then
          affsp.slitthroat = nil
          addaff (dict.slitthroat)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        end
      end,

      onclear = function ()
        if affsp.slitthroat then
          affsp.slitthroat = nil end
      end,

      onstart = function ()
        send("say", false)
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.slitthroat then affsp.slitthroat = true end
      end
    },
  },
  checkdamagedthroat = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (next(affsp) and (affsp.damagedthroat)) or false
      end,

      oncompleted = function () end,

      has = function ()
        if affsp.damagedthroat then
          affsp.damagedthroat = nil
          addaff (dict.damagedthroat)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        end
      end,

      onclear = function ()
        if affsp.damagedthroat then
          affsp.damagedthroat = nil end
      end,

      onstart = function ()
        send("sip", false)
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.damagedthroat then affsp.damagedthroat = true end
      end
    },
  },
  checkslickness = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (affsp.slickness and not affs.crucified) or false
      end,

      oncompleted = function () end,

      slicky = function ()
        addaff(dict.slickness)
        signals.after_lifevision_processing:unblock(cnrl.checkwarning)
        affsp.slickness = nil
      end,

      onclear = function ()
        affsp.slickness = nil
      end,

      onstart = function ()
        send("apply liniment", conf.commandecho)
      end
    },
    aff = {
      oncompleted = function ()
        if paragraph_length > 2 then
          addaff(dict.slickness)
          signals.after_lifevision_processing:unblock(cnrl.checkwarning)
          killaction (dict.checkslickness.misc)
        elseif not affs.slickness then
          affsp.slickness = true
        end
      end
    },
  },
  checkthroatlock = {
    misc = {
      aspriority = 0,
      spriority = 0,

      isadvisable = function ()
        return (next(affsp) and (affsp.throatlock)) or false
      end,

      oncompleted = function () end,

      canttalk = function ()
        if affsp.throatlock then
          affsp.throatlock = nil
          addaff (dict.throatlock) end
      end,

      onclear = function ()
        if affsp.throatlock then
          affsp.throatlock = nil end
      end,

      onstart = function ()
        send("say", false)
      end
    },
    aff = {
      oncompleted = function ()
        if not affs.throatlock then affsp.throatlock = true end
      end
    },
  },

-- random actions that should be protected by AI
  givewarning = {
    happened = {
      onstart = function()
      end,

      oncompleted = function (tbl)
        if tbl.initialmsg then
          echo"\n\n"
          echof("Careful: %s", tbl.initialmsg)
          echo"\n"
        end

        if tbl.prefixwarning then
          local duration = tbl.duration or 4
          local startin = tbl.startin or 0
          cnrl.warning = tbl.prefixwarning

          -- timer for starting
          if not conf.warningtype then return end

          tempTimer(startin, function ()

            if cnrl.warnids[tbl.prefixwarning] then killTrigger(cnrl.warnids[tbl.prefixwarning]) end

              cnrl.warnids[tbl.prefixwarning] = tempRegexTrigger('.+', [[
                if (($(sys).conf.warningtype == "prompt" and isPrompt()) or $(sys).conf.warningtype == "all") and getCurrentLine() ~= "" and not $(sys).gagline then
                  $(sys).prefixwarning()
                end
              ]])
            end)

          -- timer for ending
          tempTimer(startin+duration, function () killTrigger(cnrl.warnids[tbl.prefixwarning]) end)
        end
      end
    }
  },
  stolebalance = {
    happened = {
      oncompleted = function (balance)
        $(sys)["lostbal_"..balance]()
      end
    }
  },
  gotbalance = {
    tempmap = {},
    happened = {
      oncompleted = function ()
        for _, balance in ipairs(dict.gotbalance.tempmap) do
          bals[balance] = true
          raiseEvent("m&m got balance", balance)

          if watch["bal_"..balance] then
            local s = stopStopWatch(watch["bal_"..balance])
            stats["last"..balance] = s
            if conf.showbaltimes then echotime(s) end
          end

          -- update balance reset failsafe
          sys[balance.."tick"] = (sys[balance.."tick"] or 0) + 1

          -- see if we need to cancel anything
          if sys.sync and affs.crucified and bals.balance and not doingaction"crucified" and not doingaction"curingcrucified" then
            local result
            for balance,actions in pairs(bals_in_use) do
              if balance ~= "waitingfor" and balance ~= "gone" and balance ~= "aff" and next(actions) then result = select(2, next(actions)) break end
            end

            if result then
              killaction(dict[result.action_name][result.balance])
              echo'\n' echof("Cancelled %s so we can writhe from crucify right now.", result.action_name)
            end
          end
        end
        dict.gotbalance.tempmap = {}
      end
    }
  },

  -- general defences
  --herbs
  kafe = {
    herb = {
      aspriority = 148,
      spriority = 323,
      def = true,

      isadvisable = function ()
        return ((sys.deffing and defdefup[defs.mode].kafe and not defc.kafe) or (conf.keepup and defkeepup[defs.mode].kafe and not defc.kafe)) or false
      end,

      oncompleted = function ()
        defences.got("kafe")
        sk.lostbal_herb()
      end,

      eatcure = "kafe",
      onstart = function ()
        eat("kafe")
      end,

      empty = function()
        defences.got("kafe")
        sk.lostbal_herb()
      end
    },
    aff = {
      oncompleted = function ()
        defences.got("kafe")
      end
    }
  },
  lovedef = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (bals.purgative and not usingbal("purgative") and not doingaction("lovedef") and not affs.pinlegleft and not affs.pinlegright and not affs.pinlegunknown and ((sys.deffing and defdefup[defs.mode].lovedef and not defc.lovedef) or (conf.keepup and defkeepup[defs.mode].lovedef and not defc.lovedef))) or false
      end,

      oncompleted = function ()
        defences.got("lovedef")
        bals.purgative = true
      end,

      empty = function ()
        defences.got("lovedef")
        bals.purgative = false
      end,

      onstart = function ()
        send("sip love", conf.commandecho)
      end
    }
  },
  insomnia = {
    herb = {
      aspriority = 131,
      spriority = 252,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].insomnia and not defc.insomnia) or (conf.keepup and defkeepup[defs.mode].insomnia and not defc.insomnia)) and not doingaction("insomnia") and not affs.narcolepsy and not (conf.insomnia and can_usemana()) and not affs.hypersomnia) or false
      end,

      oncompleted = function ()
        defences.got("insomnia")
        sk.lostbal_herb()
      end,

      narcolepsy = function ()
        addaff (dict.narcolepsy)
      end,

      hypersomnia = function ()
        addaff (dict.hypersomnia)
      end,

      eatcure = "merbloom",
      onstart = function ()
        eat("merbloom")
      end,

      empty = function()
        defences.got("insomnia")
        sk.lostbal_herb()
      end
    },
    misc = {
      aspriority = 1,
      spriority = 253,
      def = true,

      isadvisable = function ()
        return (conf.insomnia and can_usemana() and not doingaction("insomnia") and not affs.narcolepsy and not affs.hypersomnia and not affs.pinlegleft and not affs.pinlegright and not affs.pinlegunknown and ((sys.deffing and defdefup[defs.mode].insomnia and not defc.insomnia) or (conf.keepup and defkeepup[defs.mode].insomnia and not defc.insomnia))) or false
      end,

      -- by default, oncompleted means a clot went through okay
      oncompleted = function ()
        defences.got("insomnia")
      end,

      narcolepsy = function ()
        addaff (dict.narcolepsy)
      end,

      hypersomnia = function ()
        addaff (dict.hypersomnia)
      end,

      onstart = function ()
        send("insomnia", conf.commandecho)
      end
    },
    -- small cheat for insomnia being on diagnose
    aff = {
      oncompleted = function ()
        defences.got("insomnia")
      end
    }
  },

  truedeaf = {
    herb = {
      aspriority = 129,
      spriority = 250,
      def = true,

      isadvisable = function ()
        return (not affs.earache and ((sys.deffing and defdefup[defs.mode].truedeaf and not defc.truedeaf) or (conf.keepup and defkeepup[defs.mode].truedeaf and not defc.truedeaf))) or false
      end,

      oncompleted = function (def)
        if def then defences.got("truedeaf")
        else
          defences.got("truedeaf")
          sk.lostbal_herb()
        end
      end,

      earache = function ()
        sk.lostbal_herb()
        if not affs.earache then addaff(dict.earache) end
      end,

      cureddeaf = function()
        defences.lost("deaf")
        sk.lostbal_herb()

        if not conf.aillusion then defences.lost("truedeaf") end
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        defences.got("truedeaf")
        sk.lostbal_herb()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        --[[return (not affs.earache and ((sys.deffing and defdefup[defs.mode].truedeaf and not defc.truedeaf) or (conf.keepup and defkeepup[defs.mode].truedeaf and not defc.truedeaf))) or false]]
        return false
      end,

      oncompleted = function (def)
        if def then defences.got("truedeaf")
        else
          defences.got("truedeaf")
          sk.lostbal_wafer()
        end
      end,

      earache = function ()
        sk.lostbal_wafer()
        if not affs.earache then addaff(dict.earache) end
      end,

      cureddeaf = function()
        defences.lost("deaf")
        sk.lostbal_wafer()

        if not conf.aillusion then defences.lost("truedeaf") end
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        defences.got("truedeaf")
        sk.lostbal_wafer()
      end
    },
    steam = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (not affs.earache and codepaste.smoke_steam_pipe() and ((sys.deffing and defdefup[defs.mode].truedeaf and not defc.truedeaf) or (conf.keepup and defkeepup[defs.mode].truedeaf and not defc.truedeaf))) or false
      end,

      oncompleted = function (def)
        if def then defences.got("truedeaf")
        else
          defences.got("truedeaf")
          sk.lostbal_steam()
        end
      end,

      earache = function ()
        sk.lostbal_steam()
        if not affs.earache then addaff(dict.earache) end
      end,

      cureddeaf = function()
        defences.lost("deaf")
        sk.lostbal_steam()

        if not conf.aillusion then defences.lost("truedeaf") end
      end,

      eatcure = "earwort",
      onstart = function ()
        eat("earwort")
      end,

      empty = function()
        defences.got("truedeaf")
        sk.lostbal_steam()
      end
    },
  },
  trueblind = {

    wafer = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].trueblind and not defc.trueblind) or (conf.keepup and defkeepup[defs.mode].trueblind and not defc.trueblind)) and not doingaction("waitingontrueblind") and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false
      end,

      oncompleted = function (fromdef)
        if fromdef then
          defences.got("trueblind")
        else
          doaction(dict.waitingontrueblind.waitingfor)
          sk.lostbal_wafer()
        end
      end,

      gettingtrueblind = function ()
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_wafer()
      end,

      alreadygot = function ()
        defences.got("trueblind")
        sk.lostbal_wafer()
      end,

      afterimage = function ()
        sk.lostbal_wafer()
        addaff (dict.afterimage)
      end,

      curedblind = function()
        defences.lost("blind")
        sk.lostbal_wafer()

        if not conf.aillusion then defences.lost("trueblind") end
      end,

      eatcure = "faeleaf",
      onstart = function ()
        eat("faeleaf")
      end,

      empty = function()
        if affs.blind then
          removeaff("blind")
          defences.got("trueblind")
        end
      end
    },
    herb = {
      aspriority = 128,
      spriority = 248,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].trueblind and not defc.trueblind) or (conf.keepup and defkeepup[defs.mode].trueblind and not defc.trueblind)) and not doingaction("waitingontrueblind") and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false
      end,

      oncompleted = function (fromdef)
        if fromdef then
          defences.got("trueblind")
        else
          doaction(dict.waitingontrueblind.waitingfor)
          sk.lostbal_herb()
        end
      end,

      gettingtrueblind = function ()
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_herb()
      end,

      alreadygot = function ()
        defences.got("trueblind")
        sk.lostbal_herb()
      end,

      afterimage = function ()
        sk.lostbal_herb()
        addaff (dict.afterimage)
      end,

      curedblind = function()
        defences.lost("blind")
        sk.lostbal_herb()

        if not conf.aillusion then defences.lost("trueblind") end
      end,

      eatcure = "faeleaf",
      onstart = function ()
        eat("faeleaf")
      end,

      empty = function()
        if affs.blind then
          removeaff("blind")
          defences.got("trueblind")
        end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("trueblind")
      end,

      blindednow = function ()
        defences.lost("trueblind")
        addaff(dict.blind)
      end
    },
  },
  waitingontrueblind = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        defences.got("trueblind")
      end,

      onstart = function ()
      end
    }
  },

  --candies
  mint = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].mint and not defc.mint) or (conf.keepup and defkeepup[defs.mode].mint  and not defc.mint)) and not doingaction("mint") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("mint")
      end,

      eatcure = "mint",

      onstart = function ()
        send("eat mint", conf.commandecho)
      end
    }
  },
  gumball = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].gumball and not defc.gumball) or (conf.keepup and defkeepup[defs.mode].gumball  and not defc.gumball)) and not doingaction("gumball") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("gumball")
      end,

      eatcure = "bubblegum",

      onstart = function ()
        send("eat bubblegum", conf.commandecho)
      end
    }
  },
  fireball = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].fireball and not defc.fireball) or (conf.keepup and defkeepup[defs.mode].fireball  and not defc.fireball)) and not doingaction("fireball") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("fireball")
      end,

      eatcure = "fireball",

      onstart = function ()
        send("eat fireball", conf.commandecho)
      end
    }
  },
  rockcandy = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].rockcandy and not defc.rockcandy) or (conf.keepup and defkeepup[defs.mode].rockcandy  and not defc.rockcandy)) and not doingaction("rockcandy") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("rockcandy")
      end,

      eatcure = "rockcandy",

      onstart = function ()
        send("eat rockcandy", conf.commandecho)
      end
    }
  },
  licorice = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].licorice and not defc.licorice) or (conf.keepup and defkeepup[defs.mode].licorice  and not defc.licorice)) and not doingaction("licorice") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("licorice")
      end,

      eatcure = "licorice",

      onstart = function ()
        send("eat licorice", conf.commandecho)
      end
    }
  },
  jellybaby = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].jellybaby and not defc.jellybaby) or (conf.keepup and defkeepup[defs.mode].jellybaby  and not defc.jellybaby)) and not doingaction("jellybaby") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("jellybaby")
      end,

      eatcure = "jellybaby",

      onstart = function ()
        send("eat jellybaby", conf.commandecho)
      end
    }
  },
  creamchew = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].creamchew and not defc.creamchew) or (conf.keepup and defkeepup[defs.mode].creamchew  and not defc.creamchew)) and not doingaction("creamchew") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("creamchew")
      end,

      eatcure = "creamchews",

      onstart = function ()
        send("eat creamchews", conf.commandecho)
      end
    }
  },
  waxlips = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].waxlips and not defc.waxlips) or (conf.keepup and defkeepup[defs.mode].waxlips  and not defc.waxlips)) and not doingaction("waxlips") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("waxlips")
      end,

      eatcure = "waxlips",

      onstart = function ()
        send("eat waxlips", conf.commandecho)
      end
    }
  },
  redlollipop = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].redlollipop and not defc.redlollipop) or (conf.keepup and defkeepup[defs.mode].redlollipop  and not defc.redlollipop)) and not doingaction("redlollipop") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("redlollipop")
      end,

      eatcure = "redlollipop",

      onstart = function ()
        send("eat redlollipop", conf.commandecho)
      end
    }
  },
  bluelollipop = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bluelollipop and not defc.bluelollipop) or (conf.keepup and defkeepup[defs.mode].bluelollipop  and not defc.bluelollipop)) and not doingaction("bluelollipop") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("bluelollipop")
      end,

      eatcure = "bluelollipop",

      onstart = function ()
        send("eat bluelollipop", conf.commandecho)
      end
    }
  },


  --purgative
  galvanism = {
    purgative = {
      aspriority = 8,
      spriority = 305,
      def = true,

      isadvisable = function ()
        return ((sys.deffing and defdefup[defs.mode].galvanism and not defc.galvanism) or (conf.keepup and defkeepup[defs.mode].galvanism and not defc.galvanism)) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        defences.got("galvanism")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "galvanism",

      onstart = function ()
        send("sip galvanism", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        defences.got("galvanism")
      end
    }
  },
  fire = {
    purgative = {
      aspriority = 33,
      spriority = 233,
      def = true,

      isadvisable = function ()
        return ((sys.deffing and defdefup[defs.mode].fire and not defc.fire) or (conf.keepup and defkeepup[defs.mode].fire and not defc.fire)) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        defences.got("fire")
      end,

      empty = function ()
        sk.lostbal_purgative()
        defences.got("fire")

        removeaff("shivering")
        removeaff("frozen")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "fire",

      onstart = function ()
        send("sip fire", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("fire")
      end,
    }
  },
  frost = {
    purgative = {
      aspriority = 31,
      spriority = 235,
      def = true,

      isadvisable = function ()
        return ((sys.deffing and defdefup[defs.mode].frost and not defc.frost) or (conf.keepup and defkeepup[defs.mode].frost and not defc.frost)) or false
      end,

      oncompleted = function ()
        sk.lostbal_purgative()
        defences.got("frost")
      end,

      noeffect = function()
        sk.lostbal_purgative()
      end,

      sipcure = "frost",

      onstart = function ()
        send("sip frost", conf.commandecho)
      end,

      empty = function ()
        sk.lostbal_purgative()
        defences.got("frost")
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("frost")
      end,
    }
  },

  --misc
  greentea = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].greentea and not defc.greentea) or (conf.keepup and defkeepup[defs.mode].greentea  and not defc.greentea)) and not doingaction("greentea") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and bals.tea and not (affs.sleep or affs.anorexia or affs.throatlock or affs.scarab or affs.slitthroat or affs.inquisition or    affs.slickness or affs.crushedwindpipe or affs.crucified)) or false
      end,

      oncompleted = function ()
        defences.got("greentea")
      end,

      fail = function ()
        sk.lostbal_tea()
      end,

      sipcure = "green",
      onstart = function ()
        send("sip greentea", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function (aff)
        defences.lost("greentea")
        sk.lostbal_tea()
        if aff and (aff ~= "unknownany" and aff ~= "unknownmental") then
          removeaff (aff)
        elseif aff == "unknownany" then
          dict.unknownany.count = dict.unknownany.count - 1
          if dict.unknownany.count <= 0 then
            removeaff("unknownany")
            dict.unknownany.count = 0
          end
        elseif aff == "unknownmental" then
          dict.unknownmental.count = dict.unknownmental.count - 1
          if dict.unknownmental.count <= 0 then
            removeaff("unknownmental")
            dict.unknownmental.count = 0
          end
        end
      end
    }
  },
  blacktea = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].blacktea and not defc.blacktea) or (conf.keepup and defkeepup[defs.mode].blacktea  and not defc.blacktea)) and not doingaction("blacktea") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and bals.tea and not (affs.sleep or affs.anorexia or affs.throatlock or affs.scarab or affs.slitthroat or affs.inquisition or affs.slickness or affs.crushedwindpipe or affs.crucified)) or false
      end,

      oncompleted = function ()
        defences.got("blacktea")
      end,

      fail = function ()
        sk.lostbal_tea()
      end,

      sipcure = "black",
      onstart = function ()
        send("sip blacktea", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function (aff)
        defences.lost("blacktea")
        sk.lostbal_tea()
        if aff and (aff ~= "unknownany" and aff ~= "unknownmental") then
          removeaff (aff)
        elseif aff == "unknownany" then
          dict.unknownany.count = dict.unknownany.count - 1
          if dict.unknownany.count <= 0 then
            removeaff("unknownany")
            dict.unknownany.count = 0
          end
        elseif aff == "unknownmental" then
          dict.unknownmental.count = dict.unknownmental.count - 1
          if dict.unknownmental.count <= 0 then
            removeaff("unknownmental")
            dict.unknownmental.count = 0
          end
        end
      end
    }
  },
  oolongtea = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].oolongtea and not defc.oolongtea) or (conf.keepup and defkeepup[defs.mode].oolongtea  and not defc.oolongtea)) and not doingaction("oolongtea") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and bals.tea and not (affs.sleep or affs.anorexia or affs.throatlock or     affs.scarab or affs.slitthroat or affs.inquisition or    affs.slickness or affs.crushedwindpipe or affs.crucified)) or false
      end,

      oncompleted = function ()
        defences.got("oolongtea")
      end,

      fail = function ()
        sk.lostbal_tea()
      end,

      sipcure = "oolong",
      onstart = function ()
        send("sip oolongtea", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function (aff)
        defences.lost("oolongtea")
        sk.lostbal_tea()
        if aff and (aff ~= "unknownany" and aff ~= "unknownmental") then
          removeaff (aff)
        elseif aff == "unknownany" then
          dict.unknownany.count = dict.unknownany.count - 1
          if dict.unknownany.count <= 0 then
            removeaff("unknownany")
            dict.unknownany.count = 0
          end
        elseif aff == "unknownmental" then
          dict.unknownmental.count = dict.unknownmental.count - 1
          if dict.unknownmental.count <= 0 then
            removeaff("unknownmental")
            dict.unknownmental.count = 0
          end
        end
      end
    }
  },
  whitetea = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].whitetea and not defc.whitetea) or (conf.keepup and defkeepup[defs.mode].whitetea  and not defc.whitetea)) and not doingaction("whitetea") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and bals.tea and not (affs.sleep or affs.anorexia or affs.throatlock or     affs.scarab or affs.slitthroat or affs.inquisition or affs.slickness or affs.crushedwindpipe or affs.crucified)) or false
      end,

      oncompleted = function ()
        defences.got("whitetea")
      end,

      fail = function ()
        sk.lostbal_tea()
      end,

      sipcure = "white",
      onstart = function ()
        send("sip whitetea", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function (aff)
        defences.lost("whitetea")
        sk.lostbal_tea()
        if aff and (aff ~= "unknownany" and aff ~= "unknownmental") then
          removeaff (aff)
        elseif aff == "unknownany" then
          dict.unknownany.count = dict.unknownany.count - 1
          if dict.unknownany.count <= 0 then
            removeaff("unknownany")
            dict.unknownany.count = 0
          end
        elseif aff == "unknownmental" then
          dict.unknownmental.count = dict.unknownmental.count - 1
          if dict.unknownmental.count <= 0 then
            removeaff("unknownmental")
            dict.unknownmental.count = 0
          end
        end
      end
    }
  },
  protection = {
    physical = {
      aspriority = 0,
      spriority = 0,
      balanceful_act = true,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].protection and not defc.protection) or (conf.keepup and defkeepup[defs.mode].protection  and not defc.protection)) and not doingaction("waitingforprotection") and not doingaction("protection") and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function (def)
        if def then defences.got("protection")
        else
          doaction(dict.waitingforprotection.waitingfor)
        end
      end,


      onstart = function ()
        if not conf.magictome then
          send("read protection", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge protection from cube", conf.commandecho) end
        else
          send("read magictome protection", conf.commandecho) end
      end,

      empty = function ()
        dict.protection.misc.oncompleted ()
      end
    },
  },
  waitingforprotection = {
    waitingfor = {
      customwait = 5,

      oncompleted = function ()
        defences.got("protection")
      end,

      ontimeout = function ()
        defences.got("protection")
      end,

      onstart = function () end
    }
  },
  darkbeer = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].darkbeer and not defc.darkbeer) or (conf.keepup and defkeepup[defs.mode].darkbeer  and not defc.darkbeer)) and not doingaction("darkbeer") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("darkbeer")
      end,

      sipcure = "darkbeer",

      onstart = function ()
        send("sip darkbeer", conf.commandecho)
      end
    },
  },
  amberbeer = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].amberbeer and not defc.amberbeer) or (conf.keepup and defkeepup[defs.mode].amberbeer  and not defc.amberbeer)) and not doingaction("amberbeer") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat) or false
      end,

      oncompleted = function ()
        defences.got("amberbeer")
      end,

      sipcure = "amberbeer",

      onstart = function ()
        send("sip amberbeer", conf.commandecho)
      end
    },
  },
  quicksilver = {
    blocked = false, -- we need to block off in blackout, because otherwise we waste sips
    misc = {
      aspriority = 8,
      spriority = 265,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].quicksilver and not defc.quicksilver) or (conf.keepup and defkeepup[defs.mode].quicksilver  and not defc.quicksilver)) and not doingaction("curingquicksilver") and not doingaction("quicksilver") and not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and not affs.crushedwindpipe and not affs.crucified and not dict.quicksilver.blocked and not sys.manualdefcheck and not conf.adrenaline) or false
      end,

      oncompleted = function (def)
        if def then defences.got("quicksilver")
        else
          -- update quicksilver delay appropriately
          if affs.minortimewarp then
            dict.curingquicksilver.waitingfor.customwait = 5.6
          elseif affs.moderatetimewarp then
            dict.curingquicksilver.waitingfor.customwait = 6
          elseif affs.majortimewarp then
            dict.curingquicksilver.waitingfor.customwait = 6.7
          elseif affs.massivetimewarp then
            dict.curingquicksilver.waitingfor.customwait = 7.6
          else
            dict.curingquicksilver.waitingfor.customwait = 5
          end

          doaction(dict.curingquicksilver.waitingfor)
        end
      end,

      ontimeout = function ()
        if not affs.blackout then return end

        dict.quicksilver.blocked = true
        tempTimer(3, function () dict.quicksilver.blocked = false; make_gnomes_work() end)
      end,

      sipcure = "quicksilver",

      onstart = function ()
        send("sip quicksilver", conf.commandecho)
      end,

      empty = function ()
        dict.quicksilver.misc.oncompleted ()
      end
    },
    physical = {
      aspriority = 0,
      spriority = 0,
      def = true,
      balanceful_act = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].quicksilver and not defc.quicksilver) or (conf.keepup and defkeepup[defs.mode].quicksilver  and not defc.quicksilver)) and conf.adrenaline and not doingaction("curingquicksilver") and not doingaction("quicksilver") and not affs.paralysis and not dict.quicksilver.blocked and not sys.manualdefcheck and mm.me.activeskills.athletics and mm.bals.balance and mm.bals.equilibrium) or false
      end,

      onstart = function ()
        send("adrenaline", conf.commandecho)
      end,

      oncompleted = function (def)
        if def then defences.got("quicksilver")
        else
          -- update quicksilver delay appropriately
          if affs.minortimewarp then
            dict.curingquicksilver.waitingfor.customwait = 5.6
          elseif affs.moderatetimewarp then
            dict.curingquicksilver.waitingfor.customwait = 6
          elseif affs.majortimewarp then
            dict.curingquicksilver.waitingfor.customwait = 6.7
          elseif affs.massivetimewarp then
            dict.curingquicksilver.waitingfor.customwait = 7.6
          else
            dict.curingquicksilver.waitingfor.customwait = 5
          end

          doaction(dict.curingquicksilver.waitingfor)
        end
      end,

      ontimeout = function ()
        if not affs.blackout then return end

        dict.quicksilver.blocked = true
        tempTimer(3, function () dict.quicksilver.blocked = false; make_gnomes_work() end)
      end,

    },
    gone = {
      oncompleted = function ()
        defences.lost("quicksilver")
      end,
    }
  },
  curingquicksilver = {
    spriority = 0,
    waitingfor = {
      customwait = 5, -- this value is updated depending on timewarp level affs

      oncompleted = function ()
        defences.got("quicksilver")
        dict.curingquicksilver.waitingfor.customwait = 5
      end,

      ontimeout = function ()
        dict.curingquicksilver.waitingfor.customwait = 5
        if (sys.deffing and defdefup[defs.mode].quicksilver and not defc.quicksilver) or (conf.keepup and defkeepup[defs.mode].quicksilver  and not defc.quicksilver) then

          echof("Warning - quicksilver didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end
      end,

      onstart = function () end
    }
  },

  sacrifice = {
    happened = {
      oncompleted = function ()
        if not conf.aillusion or (stats.currenthealth == stats.maxhealth and stats.currentmana == stats.maxmana and stats.currentego == stats.maxego) then
          reset.affs()
        end
      end
    }
  },

  --balanceless
  breath = {
    blocked = false,
    physical = {
      balanceless_act = true,
      aspriority = 48,
      spriority = 245,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].breath and not defc.breath) or (conf.keepup and defkeepup[defs.mode].breath and not defc.breath))) or (conf.keepup and defkeepup[defs.mode].breath and not defc.breath)) and not doingaction("breath") and not dict.breath.blocked and not affs.asthma) or false
      end,

      oncompleted = function ()
        defences.got("breath")
      end,

      woreoff = function()
        defences.lost("breath")
        dict.breath.blocked = tempTimer(60*5.5, function()
          if stats.currenthealth > 0 then -- don't annoy while dead
            echof("I think we should've recovered breath by now, but I didn't see it happen...")
          end
          dict.breath.blocked = nil
        end)
      end,

      recovered = function()
        if dict.breath.blocked then killTimer(dict.breath.blocked) end
        dict.breath.blocked = nil
      end,

      recovering = function()
        if dict.breath.blocked then return end

        dict.breath.blocked = tempTimer(60*5.5, function()
          if stats.currenthealth > 0 then -- don't annoy while dead
            echof("I think we should've recovered breath by now, but I didn't see it happen...")
          end
          dict.breath.blocked = nil
        end)
      end,

      onstart = function ()
        if conf.gagbreath then
          send("hold breath", false)
        else
          send("hold breath", conf.commandecho) end
      end
    }
  },
  metawake = {
    physical = {
      balanceless_act = true,
      aspriority = 51,
      spriority = 249,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].metawake and not defc.metawake) or (conf.keepup and defkeepup[defs.mode].metawake and not defc.metawake)) and not doingaction("metawake")) or false
      end,

      oncompleted = function ()
        defences.got("metawake")
      end,

      onstart = function ()
        send("metawake on", conf.commandecho)
      end
    }
  },
  thirdeye = {
    misc = {
      aspriority = 45,
      spriority = 242,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].thirdeye and not defc.thirdeye) or (conf.keepup and defkeepup[defs.mode].thirdeye and not defc.thirdeye)) and not doingaction("thirdeye")) or false
      end,

      oncompleted = function ()
        defences.got("thirdeye")
      end,

      onstart = function ()
        send("thirdeye", conf.commandecho)
      end
    }
  },
  nightsight = {
    misc = {
      aspriority = 39,
      spriority = 236,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].nightsight and not defc.nightsight) or (conf.keepup and defkeepup[defs.mode].nightsight and not defc.nightsight)) and not doingaction("nightsight")) or false
      end,

      oncompleted = function ()
        defences.got("nightsight")
      end,

      onstart = function ()
        send("nightsight", conf.commandecho)
      end
    }
  },

  --balanceful
  performance = {
    physical = {
      balanceful_act = true,
      aspriority = 50,
      spriority = 247,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].performance and not defc.performance) or (conf.keepup and defkeepup[defs.mode].performance and not defc.performance)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("performance")
      end,

      onstart = function ()
        send("performance on", conf.commandecho)
      end
    }
  },
  selfishness = {
    physical = {
      balanceful_act = true,
      aspriority = 49,
      spriority = 246,
      def = true,

      isadvisable = function ()
        return (
          ((sys.deffing and defdefup[defs.mode].selfishness and not defc.selfishness)
            or (not sys.deffing and conf.keepup and ((defkeepup[defs.mode].selfishness and not defc.selfishness) or (not defkeepup[defs.mode].selfishness and defc.selfishness))))
          and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        if (not sys.deffing and conf.keepup and not defkeepup[defs.mode].selfishness and (defc.selfishness == true or defc.selfishness == nil)) then
          defences.lost("selfishness")
        else
          defences.got("selfishness")
        end
      end,

      onstart = function ()
        if (sys.deffing and defdefup[defs.mode].selfishness and not defc.selfishness) or (not sys.deffing and conf.keepup and defkeepup[defs.mode].selfishness and not defc.selfishness) then
          send("selfishness", conf.commandecho)
        else
          send("generosity", conf.commandecho)
        end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("selfishness")

        -- if we've done sl off, _gone gets added, so _physical gets readded by action clear - kill physical here for that not to happen
        if actions.selfishness_physical then
          killaction(dict.selfishness.physical)
        end
      end,
    }
  },
  lipread = {
    physical = {
      balanceful_act = true,
      aspriority = 46,
      spriority = 243,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].lipread and not defc.lipread) or (conf.keepup and defkeepup[defs.mode].lipread and not defc.lipread)) and (not affs.blind or defc.trueblind) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("lipread")
      end,

      onstart = function ()
        send("lipread", conf.commandecho)
      end
    }
  },
  obliviousness = {
    physical = {
      balanceful_act = true,
      aspriority = 47,
      spriority = 244,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].obliviousness and not defc.obliviousness) or (conf.keepup and defkeepup[defs.mode].obliviousness and not defc.obliviousness)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("obliviousness")
      end,

      onstart = function ()
        send("obliviousness on", conf.commandecho)
      end
    }
  },
  truetime = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].truetime and not defc.truetime) or (conf.keepup and defkeepup[defs.mode].truetime and not defc.truetime)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("truetime")
        startStopWatch(dict.truetime.stopwatch)
      end,

      onstart = function ()
        send("wind truetime", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge truetime from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("truetime")
        stopStopWatch(dict.truetime.stopwatch)
        resetStopWatch(dict.truetime.stopwatch)
      end,
    }
  },
  hardsmoke = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].hardsmoke and not defc.hardsmoke) or (conf.keepup and defkeepup[defs.mode].hardsmoke and not defc.hardsmoke)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("hardsmoke")
      end,

      onstart = function ()
        send("wonderpipe activate hardsmoke", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("hardsmoke")
      end,
    }
  },
  smokeweb = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].smokeweb and not defc.smokeweb) or (conf.keepup and defkeepup[defs.mode].smokeweb and not defc.smokeweb)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("smokeweb")
      end,

      onstart = function ()
        send("wonderpipe activate smokeweb", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("smokeweb")
      end,
    }
  },
#if skills.lowmagic then
  yellow = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (stats.currentpower >= 3 and ((sys.deffing and defdefup[defs.mode].yellow and not defc.yellow) or (conf.keepup and defkeepup[defs.mode].yellow and not defc.yellow)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("yellow")
        startStopWatch(dict.yellow.stopwatch)
      end,

      onstart = function ()
        send("invoke yellow", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("yellow")
        stopStopWatch(dict.yellow.stopwatch)
        resetStopWatch(dict.yellow.stopwatch)
      end,
    }
  },
  blue = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].blue and not defc.blue) or (conf.keepup and defkeepup[defs.mode].blue and not defc.blue)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("blue")
      end,

      onstart = function ()
        send("invoke blue", conf.commandecho)
      end
    }
  },
  orange = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].orange and not defc.orange) or (conf.keepup and defkeepup[defs.mode].orange and not defc.orange)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("orange")
      end,

      onstart = function ()
        send("invoke orange", conf.commandecho)
      end
    }
  },
  autumn = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].autumn and not defc.autumn) or (conf.keepup and defkeepup[defs.mode].autumn and not defc.autumn)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("autumn")
      end,

      onstart = function ()
        send("invoke autumn", conf.commandecho)
      end
    }
  },
  red = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].red and not defc.red) or (conf.keepup and defkeepup[defs.mode].red and not defc.red)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("red")
      end,

      onstart = function ()
        send("invoke red", conf.commandecho)
      end
    }
  },
#end
  yoyo = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].yoyo and not defc.yoyo) or (conf.keepup and defkeepup[defs.mode].yoyo and not defc.yoyo)) and not codepaste.balanceful_defs_codepaste() and not doingaction("yoyo")) or false
      end,

      oncompleted = function ()
        defences.got("yoyo")
      end,

      onstart = function ()
        send("yoyo spin", conf.commandecho)
      end
    }
  },
  mercy = {
    physical = {
      balanceless_act = true,
      aspriority = 61,
      spriority = 312,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].mercy and not defc.mercy) or (conf.keepup and defkeepup[defs.mode].mercy and not defc.mercy)) and not codepaste.balanceful_defs_codepaste() and not doingaction("mercy")) or false
      end,

      oncompleted = function ()
        defences.got("mercy")
      end,

      onstart = function ()
        send("rub mercy", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge mercy from cube", conf.commandecho) end
      end
    }
  },
#if not skills.elementalism then
  levitation = {
    physical = {
      balanceful_act = true,
      aspriority = 60,
      spriority = 307,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].levitation and not defc.levitation) or (conf.keepup and defkeepup[defs.mode].levitation and not defc.levitation)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("levitation")
      end,

      onstart = function ()
        send("rub levitate", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge levitate from cube", conf.commandecho) end
      end
    }
  },
#end
#if not skills.cosmic then
  nimbus = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].nimbus and not defc.nimbus) or (conf.keepup and defkeepup[defs.mode].nimbus and not defc.nimbus)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("nimbus")
      end,

      onstart = function ()
        send("rub nimbus", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge nimbus from cube", conf.commandecho) end
      end
    }
  },
#end
  kingdom = {
    physical = {
      balanceless_act = true,
      aspriority = 59,
      spriority = 306,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].kingdom and not defc.kingdom) or (conf.keepup and defkeepup[defs.mode].kingdom and not defc.kingdom)) and not codepaste.balanceful_defs_codepaste() and not doingaction("kingdom")) or false
      end,

      oncompleted = function ()
        defences.got("kingdom")
      end,

      onstart = function ()
        send("rub kingdom", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge kingdom from cube", conf.commandecho) end
      end
    }
  },
  avaricehorn = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].avaricehorn and not defc.avaricehorn) or (conf.keepup and defkeepup[defs.mode].avaricehorn and not defc.avaricehorn)) and not codepaste.balanceful_defs_codepaste() and not doingaction("avaricehorn")) or false
      end,

      oncompleted = function ()
        defences.got("avaricehorn")
      end,

      onstart = function ()
        send("blow avaricehorn", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge avaricehorn from cube", conf.commandecho) end
      end
    }
  },
  azurebox = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].azurebox and not defc.azurebox) or (conf.keepup and defkeepup[defs.mode].azurebox and not defc.azurebox)) and not codepaste.balanceful_defs_codepaste() and not doingaction("azurebox")) or false
      end,

      oncompleted = function ()
        defences.got("azurebox")
      end,

      onstart = function ()
        send("crank azurebox", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge azurebox from cube", conf.commandecho) end
      end
    }
  },
  goldenbox = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].goldenbox and not defc.goldenbox) or (conf.keepup and defkeepup[defs.mode].goldenbox and not defc.goldenbox)) and not codepaste.balanceful_defs_codepaste() and not doingaction("goldenbox")) or false
      end,

      oncompleted = function ()
        defences.got("goldenbox")
      end,

      onstart = function ()
        send("crank goldenbox", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge goldenbox from cube", conf.commandecho) end
      end
    }
  },
  emeraldbox = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].emeraldbox and not defc.emeraldbox) or (conf.keepup and defkeepup[defs.mode].emeraldbox and not defc.emeraldbox)) and not codepaste.balanceful_defs_codepaste() and not doingaction("emeraldbox")) or false
      end,

      oncompleted = function ()
        defences.got("emeraldbox")
      end,

      onstart = function ()
        send("crank emeraldbox", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge emeraldbox from cube", conf.commandecho) end
      end
    }
  },
  aethersight = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (stats.currentpower >= 3 and ((sys.deffing and defdefup[defs.mode].aethersight and not defc.aethersight) or (conf.keepup and defkeepup[defs.mode].aethersight and not defc.aethersight)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("aethersight")
      end,

      onstart = function ()
        send("aethersight on", conf.commandecho)
      end
    }
  },
  perfection = {
    physical = {
      aspriority = 0,
      spriority = 0,
      balanceless_act = true,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].perfection and not defc.perfection) or (conf.keepup and defkeepup[defs.mode].perfection and not defc.perfection)) and not codepaste.balanceful_defs_codepaste() and not doingaction"perfection") or false
      end,

      oncompleted = function ()
        defences.got("perfection")
      end,

      onstart = function ()
        send("rub perfection", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge perfection from cube", conf.commandecho) end
      end
    }
  },
  acquisitio = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].acquisitio and not defc.acquisitio) or (conf.keepup and defkeepup[defs.mode].acquisitio and not defc.acquisitio)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("acquisitio")
      end,

      onstart = function ()
        send("rub acquisitio", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge acquisitio from cube", conf.commandecho) end
      end
    }
  },
  beauty = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].beauty and not defc.beauty) or (conf.keepup and defkeepup[defs.mode].beauty and not defc.beauty)) and not codepaste.balanceful_defs_codepaste() and not doingaction("beauty")) or false
      end,

      oncompleted = function ()
        defences.got("beauty")
      end,

      onstart = function ()
        send("rub beauty", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge beauty from cube", conf.commandecho) end
      end
    }
  },
  waterwalk = {
    physical = {
      balanceful_act = true,
      aspriority = 52,
      spriority = 254,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].waterwalk and not defc.waterwalk) or (conf.keepup and defkeepup[defs.mode].waterwalk and not defc.waterwalk)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("waterwalk")
      end,

      onstart = function ()
        send("rub waterwalk", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge waterwalk from cube", conf.commandecho) end
      end
    }
  },
  charismaticaura = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].charismaticaura and not defc.charismaticaura) or (conf.keepup and defkeepup[defs.mode].charismaticaura and not defc.charismaticaura)) and not codepaste.balanceful_defs_codepaste() and not doingaction("charismaticaura")) or false
      end,

      oncompleted = function ()
        defences.got("charismaticaura")
      end,

      onstart = function ()
        send("charismaticaura on", conf.commandecho)
      end
    }
  },
  kirigami = {
    stopwatch = createStopWatch(),
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].kirigami and not defc.kirigami) or (conf.keepup and defkeepup[defs.mode].kirigami and not defc.kirigami)) and not codepaste.balanceful_defs_codepaste() and not doingaction("kirigami") and not doingaction"wetfold" and not defc.wetfold) or false
      end,

      oncompleted = function ()
        defences.got("kirigami")
        startStopWatch(dict.kirigami.stopwatch)
      end,

      onstart = function ()
        send("release kirigami", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("kirigami")
        stopStopWatch(dict.kirigami.stopwatch)
        resetStopWatch(dict.kirigami.stopwatch)
      end,
    }
  },
  wetfold = {
    stopwatch = createStopWatch(),
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].wetfold and not defc.wetfold) or (conf.keepup and defkeepup[defs.mode].wetfold and not defc.wetfold)) and not codepaste.balanceful_defs_codepaste() and not doingaction("wetfold") and not doingaction"kirigami" and not defc.kirigami) or false
      end,

      oncompleted = function (def)
        defences.got("wetfold")
        if not def then startStopWatch(dict.wetfold.stopwatch) end
      end,

      onstart = function ()
        send("release wetfold", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("wetfold")
        stopStopWatch(dict.wetfold.stopwatch)
        resetStopWatch(dict.wetfold.stopwatch)
      end,
    }
  },
  waterbreathing = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].waterbreathing and not defc.waterbreathing) or (conf.keepup and defkeepup[defs.mode].waterbreathing and not defc.waterbreathing)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("waterbreathing")
      end,

      onstart = function ()
        if not conf.enchantments and mm.me.activeskills.elementalism then
          send("cast waterbreathe", conf.commandecho)
        else
          send("rub waterbreathe", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge waterbreathe from cube", conf.commandecho)
          end
        end
      end
    }
  },
  riding = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (
          ((sys.deffing and defdefup[defs.mode].riding and not defc.riding)
            or (not sys.deffing and conf.keepup and ((defkeepup[defs.mode].riding and not defc.riding) or (not defkeepup[defs.mode].riding and defc.riding))))
          and not codepaste.balanceful_defs_codepaste() and not defc.dragonform and not affs.hamstring and (not affs.prone or doingaction"prone") and not affs.crippledleftarm and not affs.crippledrightarm and not affs.mangledleftarm and not affs.mangledrightarm and not affs.missingleftarm and not affs.missingrightarm) or false
      end,

      oncompleted = function ()
        if (not sys.deffing and conf.keepup and not defkeepup[defs.mode].riding and (defc.riding == true or defc.riding == nil)) then
          dict.riding.gone.oncompleted()
        else
          defences.got("riding")
        end
      end,

      onstart = function ()
        if (sys.deffing and defdefup[defs.mode].riding and not defc.riding) or (not sys.deffing and conf.keepup and defkeepup[defs.mode].riding and not defc.riding) then
          send(string.format("%s %s", tostring(conf.ridingskill), tostring(conf.ridingsteed)), conf.commandecho)
        else
          send("dismount", conf.commandecho)
          if sys.sync then return end
          send(string.format("order %s follow me", tostring(conf.ridingsteed), conf.commandecho))
        end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("riding")
      end,
    }
  },

  rebounding = {
    misc = {
      aspriority = 137,
      spriority = 261,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].rebounding and not defc.rebounding) or (conf.keepup and defkeepup[defs.mode].rebounding and not defc.rebounding)) and codepaste.smoke_faeleaf_pipe() and not doingaction("waitingonrebounding") and not (affs.sleep or affs.stun or sacid or affs.inquisition or affs.crucified or (affs.missingleftarm and affs.missingrightarm)) and not affs.asthma and not affs.collapsedlungs and not affs.pinlegright and not affs.pinlegleft and not affs.pinlegunknown and not affs.pinlegunknown) or false
      end,

      oncompleted = function (def)
        if def then defences.got("rebounding")
        else
          doaction(dict.waitingonrebounding.waitingfor)
        end
      end,

      smokecure = "faeleaf",
      onstart = function ()
        send("smoke " .. pipes.faeleaf.id, conf.commandecho)
      end,

      empty = function ()
        dict.rebounding.misc.oncompleted()
      end
    }
  },
  waitingonrebounding = {
    spriority = 0,
    waitingfor = {
      customwait = 9, -- takes 6s

      onstart = function() end,

      ontimeout = function()
        defences.got("rebounding")
      end,

      oncompleted = function ()
        defences.got("rebounding")
      end
    }
  },

  deathsight = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].deathsight and not defc.deathsight) or (conf.keepup and defkeepup[defs.mode].deathsight and not defc.deathsight)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("deathsight")
      end,

      onstart = function ()
        if conf.deathsight then
          send("deathsight", conf.commandecho)
        else
          send("rub deathsight", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge deathsight from cube", conf.commandecho)
          end
        end
      end
    }
  },

#basicdef("keeneye", "keeneye on")

#if skills.athletics then
  consciousness = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].consciousness and not defc.consciousness) or (conf.keepup and defkeepup[defs.mode].consciousness and not defc.consciousness)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("consciousness")
      end,

      onstart = function ()
        send("consciousness on", conf.commandecho)
      end
    }
  },
  constitution = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].constitution and not defc.constitution) or (conf.keepup and defkeepup[defs.mode].constitution and not defc.constitution)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("constitution")
      end,

      onstart = function ()
        send("constitution", conf.commandecho)
      end
    }
  },
  regeneration = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].regeneration and not defc.regeneration) or (conf.keepup and defkeepup[defs.mode].regeneration and not defc.regeneration)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not doingaction("regeneration")) or false
      end,

      oncompleted = function ()
        defences.got("regeneration")
      end,

      onstart = function ()
        send("regeneration on", conf.commandecho)
      end
    }
  },
  boosting = {
    physical = {
      balanceless_act    = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].boosting and not defc.boosting and defc.regeneration) or (conf.keepup and defkeepup[defs.mode].boosting and not defc.boosting and defc.regeneration)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not doingaction("boosting")) or false
      end,

      oncompleted = function ()
        defences.got("boosting")
      end,

      onstart = function ()
        send("boost regeneration", conf.commandecho)
      end
    }
  },
  surge = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].surge and not defc.surge) or (conf.keepup and defkeepup[defs.mode].surge and not defc.surge)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and mm.stats.currentpower >= 8) or false
      end,

      oncompleted = function ()
        defences.got("surge")
      end,

      onstart = function ()
        send("surge on", conf.commandecho)
      end
    }
  },
  weathering = {
    misc = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].weathering and not defc.weathering) or (conf.keepup and defkeepup[defs.mode].weathering and not defc.weathering)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not doingaction("weathering")) or false
      end,

      oncompleted = function ()
        defences.got("weathering")
      end,

      onstart = function ()
        send("weathering", conf.commandecho)
      end
    }
  },
  vitality = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].vitality and not defc.vitality) or (conf.keepup and defkeepup[defs.mode].vitality and not defc.vitality)) and (mm.me.activeskills.athletics or mm.me.artifacts.vitality) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("vitality")
      end,

      onstart = function ()
        send("vitality", conf.commandecho)
      end
    }
  },
  resistance = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].resistance and not defc.resistance) or (conf.keepup and defkeepup[defs.mode].resistance and not defc.resistance)) and not codepaste.balanceful_defs_codepaste() and not affs.prone  and not doingaction("resistance")) or false
      end,

      oncompleted = function ()
        defences.got("resistance")
      end,

      onstart = function ()
        send("resistance", conf.commandecho)
      end
    }
  },
  grip = {
    physical = {
      balanceless_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].grip and not defc.grip) or (conf.keepup and defkeepup[defs.mode].grip and not defc.grip)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and next(me.wielded)) or false
      end,

      oncompleted = function ()
        defences.got("grip")
      end,

      onstart = function ()
        send("grip", conf.commandecho)
      end
    }
  },
  breathing = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].breathing and not defc.breathing) or (conf.keepup and defkeepup[defs.mode].breathing and not defc.breathing)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("breathing")
      end,

      onstart = function ()
        send("breathe deep", conf.commandecho)
      end
    }
  },
  immunity = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].immunity and not defc.immunity) or (conf.keepup and defkeepup[defs.mode].immunity and not defc.immunity)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and stats.currentpower >= 4) or false
      end,

      oncompleted = function ()
        defences.got("immunity")
      end,

      onstart = function ()
        send("immunity", conf.commandecho)
      end
    }
  },
  flex = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].flex and not defc.flex) or (conf.keepup and defkeepup[defs.mode].flex and not defc.flex)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("flex")
      end,

      onstart = function ()
        send("flex", conf.commandecho)
      end
    }
  },
  constituion = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].constituion and not defc.constituion) or (conf.keepup and defkeepup[defs.mode].constituion and not defc.constituion)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("constituion")
      end,

      onstart = function ()
        send("constituion", conf.commandecho)
      end
    }
  },
  conciousness = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].conciousness and not defc.conciousness) or (conf.keepup and defkeepup[defs.mode].conciousness and not defc.conciousness)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("conciousness")
      end,

      onstart = function ()
        send("conciousness on", conf.commandecho)
      end
    }
  },
  adrenaline = {
    physical = {
      aspriority = 0,
      spriority = 0,
      balanceful_act = true,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].adrenaline and not defc.quicksilver) or (conf.keepup and defkeepup[defs.mode].adrenaline and not defc.quicksilver)) and not doingaction("curingquicksilver") and not doingaction("adrenaline") and not doingaction ("quicksilver") and not affs.paralysis and not affs.severedspine and not sys.manualdefcheck) or false
      end,

      oncompleted = function ()
        defences.got("quicksilver")
      end,

      alreadygot = function ()
        defences.got("quicksilver")
      end,

      onstart = function ()
        send("adrenaline", conf.commandecho)
      end
    },
  },
#elseif not skills.athletics then
  vitality = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].vitality and not defc.vitality) or (conf.keepup and defkeepup[defs.mode].vitality and not defc.vitality)) and mm.me.artifacts.vitality and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("vitality")
      end,

      onstart = function ()
        send("vitality", conf.commandecho)
      end
    }
  },
#end
  

#basicdef("respect", "manifest respect")
  catsluck = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].catsluck and not defc.catsluck) or (conf.keepup and defkeepup[defs.mode].catsluck and not defc.catsluck)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) and conf.catsluck or false
      end,

      oncompleted = function ()
        defences.got("catsluck")
      end,

      onstart = function ()
        send("jewel cast "..conf.catsluck, conf.commandecho)
      end
    }
  },

#if skills.highmagic then
  yesod = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].yesod and not defc.yesod) or (conf.keepup and defkeepup[defs.mode].yesod and not defc.yesod)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("yesod")
      end,

      onstart = function ()
        send("evoke yesod", conf.commandecho)
      end
    }
  },
  hod = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].hod and not defc.hod) or (conf.keepup and defkeepup[defs.mode].hod and not defc.hod)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and stats.currentmana == stats.maxmana) or false
      end,

      oncompleted = function ()
        defences.got("hod")
      end,

      onstart = function ()
        send("evoke hod", conf.commandecho)
      end
    }
  },
  netzach = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].netzach and not defc.netzach) or (conf.keepup and defkeepup[defs.mode].netzach and not defc.netzach)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("netzach")
        startStopWatch(dict.netzach.stopwatch)
      end,

      onstart = function ()
        send("evoke netzach", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("netzach")

        stopStopWatch(dict.netzach.stopwatch)
        resetStopWatch(dict.netzach.stopwatch)
      end,
    }
  },
  malkuth = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].malkuth and not defc.malkuth) or (conf.keepup and defkeepup[defs.mode].malkuth and not defc.malkuth)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("malkuth")
      end,

      onstart = function ()
        send("evoke malkuth", conf.commandecho)
      end
    }
  },
  geburah = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (stats.currentpower >= 3 and ((sys.deffing and defdefup[defs.mode].geburah and not defc.geburah) or (conf.keepup and defkeepup[defs.mode].geburah and not defc.geburah)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("geburah")
      end,

      onstart = function ()
        send("evoke geburah", conf.commandecho)
      end
    }
  },

#end

#if skills.sacraments then
  numen = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].numen and not defc.numen) or (conf.keepup and defkeepup[defs.mode].numen and not defc.numen)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("numen")
      end,

      onstart = function ()
        send("starchant numen", conf.commandecho)
      end
    }
  },
  fervor = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((stats.currentpower >= 3 and sys.deffing and defdefup[defs.mode].fervor and not defc.fervor) or (conf.keepup and defkeepup[defs.mode].fervor and not defc.fervor)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("fervor")
      end,

      onstart = function ()
        send("starchant fervor", conf.commandecho)
      end
    }
  },
  lustration = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].lustration and not defc.lustration) or (conf.keepup and defkeepup[defs.mode].lustration and not defc.lustration)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("lustration")
      end,

      onstart = function ()
        send("starchant lustration", conf.commandecho)
      end
    }
  },
  ablution = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].ablution and not defc.ablution) or (conf.keepup and defkeepup[defs.mode].ablution and not defc.ablution)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("ablution")
      end,

      onstart = function ()
        send("starchant ablution", conf.commandecho)
      end
    }
  },
#end

#if skills.rituals then
  rubeus = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].rubeus and not defc.rubeus) or (conf.keepup and defkeepup[defs.mode].rubeus and not defc.rubeus)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("rubeus")
      end,

      onstart = function ()
        send("chant rubeus", conf.commandecho)
      end
    }
  },
  populus = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].populus and not defc.populus) or (conf.keepup and defkeepup[defs.mode].populus and not defc.populus)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("populus")
      end,

      onstart = function ()
        send("chant populus", conf.commandecho)
      end
    }
  },
  fortuna = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].fortuna and not defc.fortuna) or (conf.keepup and defkeepup[defs.mode].fortuna and not defc.fortuna)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("fortuna")
      end,

      onstart = function ()
        send("chant fortuna", conf.commandecho)
      end
    }
  },
  draconis = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].draconis and not defc.draconis) or (conf.keepup and defkeepup[defs.mode].draconis and not defc.draconis)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("draconis")
      end,

      onstart = function ()
        send("chant draconis", conf.commandecho)
      end
    }
  },
  acquisitio = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].acquisitio and not defc.acquisitio) or (conf.keepup and defkeepup[defs.mode].acquisitio and not defc.acquisitio)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("acquisitio")
      end,

      onstart = function ()
        if not conf.enchantments and mm.me.activeskills.rituals then
          send("chant acquisitio on", conf.commandecho)
        else
          send("rub acquisitio", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge acquisitio from cube", conf.commandecho) end
        end
      end
    }
  },
#end

#if skills.nature then
  torc = {
    physical = {
      balanceful_act = true,
      aspriority = 44,
      spriority = 241,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].torc and not defc.torc) or (conf.keepup and defkeepup[defs.mode].torc and not defc.torc)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("torc")
      end,

      onstart = function ()
        send("nature torc", conf.commandecho)
      end
    }
  },
  rooting = {
    physical = {
      balanceful_act = true,
      aspriority = 43,
      spriority = 240,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].rooting and not defc.rooting) or (conf.keepup and defkeepup[defs.mode].rooting and not defc.rooting)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("rooting")
      end,

      onstart = function ()
        if sys.enabledgmcp and gmcp.Room and gmcp.Room.Info and (gmcp.Room.Info.name:find("In the nest",1, true) or gmcp.Room.Info.name:find("In the trees", 1, true)) then
          send("climb down", conf.commandecho)
        elseif sys.enabledgmcp and gmcp.Room and gmcp.Room.Info and (gmcp.Room.Info.name:find("Flying above", a, true)) then
          send("land", conf.commandecho)
        end

        send("nature rooting", conf.commandecho)
      end
    }
  },
  barkskin = {
    physical = {
      balanceful_act = true,
      aspriority = 42,
      spriority = 239,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].barkskin and not defc.barkskin) or (conf.keepup and defkeepup[defs.mode].barkskin and not defc.barkskin)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("barkskin")
      end,

      onstart = function ()
        send("nature barkskin", conf.commandecho)
      end
    }
  },
  blend = {
    physical = {
      balanceful_act = true,
      aspriority = 41,
      spriority = 238,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].blend and not defc.blend) or (conf.keepup and defkeepup[defs.mode].blend and not defc.blend)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("blend")
      end,

      onstart = function ()
        send("nature blend on", conf.commandecho)
      end
    }
  },
#end

--wondercorn defs - they don't require balance, but consume it
wondercornbal = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercornbal and not defc.wondercornbal) or (conf.keepup and defkeepup[defs.mode].wondercornbal and not defc.wondercornbal)) and codepaste.wonderitems("wondercornbal") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercornbal")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate balance", conf.commandecho)
          end
        end
      }
    },
wondercornhp = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercornhp and not defc.wondercornhp) or (conf.keepup and defkeepup[defs.mode].wondercornhp and not defc.wondercornhp)) and codepaste.wonderitems("wondercornhp") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercornhp")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate health", conf.commandecho)
          end
        end
      }
    },
wondercornmp = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercornmp and not defc.wondercornmp) or (conf.keepup and defkeepup[defs.mode].wondercornmp and not defc.wondercornmp)) and codepaste.wonderitems("wondercornmp") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercornmp")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate mana", conf.commandecho)
          end
        end
      }
    },
wondercornego = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercornego and not defc.wondercornego) or (conf.keepup and defkeepup[defs.mode].wondercornego and not defc.wondercornego)) and codepaste.wonderitems("wondercornego") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercornego")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate ego", conf.commandecho)
          end
        end
      }
    },
wondercornres = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercornres and not defc.wondercornres) or (conf.keepup and defkeepup[defs.mode].wondercornres and not defc.wondercornres)) and codepaste.wonderitems("wondercornres") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercornres")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate resistance", conf.commandecho)
          end
        end
      }
    },
wondercorndam = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercorndam and not defc.wondercorndam) or (conf.keepup and defkeepup[defs.mode].wondercorndam and not defc.wondercorndam)) and codepaste.wonderitems("wondercorndam") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercorndam")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate damage", conf.commandecho)
          end
        end
      }
    },
wondercorneq = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].wondercorneq and not defc.wondercorneq) or (conf.keepup and defkeepup[defs.mode].wondercorneq and not defc.wondercorneq)) and codepaste.wonderitems("wondercorneq") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("wondercornbal")
            defences.got("wondercorneq")
            defences.got("wondercornhp")
            defences.got("wondercornmp")
            defences.got("wondercornego")
            defences.got("wondercorndam")
            defences.got("wondercornres")
          else
            defences.got("wondercorneq")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("wondercorn activate all", conf.commandecho)
          else
            send("wondercorn activate equilibrium", conf.commandecho)
          end
        end
      }
    },
redgenies = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].redgenies and not defc.redgenies) or (conf.keepup and defkeepup[defs.mode].redgenies and not defc.redgenies)) and codepaste.geniedefs("redgenies") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("redgenies")
            defences.got("bluegenies")
            defences.got("yellowgenies")
          else
            defences.got("redgenies")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("curio collection activate genies", conf.commandecho)
          else
            send("curio collection activate redgenies", conf.commandecho)
          end
        end
      }
    },
bluegenies = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].bluegenies and not defc.bluegenies) or (conf.keepup and defkeepup[defs.mode].bluegenies and not defc.bluegenies)) and codepaste.geniedefs("bluegenies") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("redgenies")
            defences.got("bluegenies")
            defences.got("yellowgenies")
          else
            defences.got("bluegenies")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("curio collection activate genies", conf.commandecho)
          else
            send("curio collection activate bluegenies", conf.commandecho)
          end
        end
      }
    },
yellowgenies = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].yellowgenies and not defc.yellowgenies) or (conf.keepup and defkeepup[defs.mode].yellowgenies and not defc.yellowgenies)) and codepaste.geniedefs("yellowgenies") and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone) or false
        end,

        oncompleted = function ()
          if conf.wonderall then
            defences.got("redgenies")
            defences.got("bluegenies")
            defences.got("yellowgenies")
          else
            defences.got("yellowgenies")
          end
        end,

        onstart = function ()
          if conf.wonderall then
            send("curio collection activate genies", conf.commandecho)
          else
            send("curio collection activate yellowgenies", conf.commandecho)
          end
        end
      }
    },

#if skills.astrology then
#basicdef("volcano", "astrocast volcano sphere at me")
#basicdef("dragon", "astrocast dragon sphere at me")
#basicdef("dolphin", "astrocast dolphin sphere at me")
#basicdef("glacier", "astrocast glacier sphere at me")
#basicdef("lion", "astrocast lion sphere at me")
#basicdef("antlers", "astrocast antlers sphere at me")
#basicdef("bumblebee", "astrocast bumblebee sphere at me")
#basicdef("volcano", "astrocast volcano sphere at me")
#basicdef("skull", "astrocast skull sphere at me")
#basicdef("twincrystals", "astrocast twin crystals sphere at me")
#basicdef("burningcenser", "astrocast burning censer sphere at me")
#basicdef("spider", "astrocast spider sphere at me")
#basicdef("crocodile", "astrocast crocodile sphere at me")
#end

#if skills.acrobatics then
#basicdef("limber", "limber")
#basicdef("balancing", "balancing on")
#basicdef("falling", "falling", true)
#basicdef("elasticity", "elasticity", true)
#basicdef("androitness", "androitness", true)
#basicdef("handstand", "handstand")
#basicdef("avoid", "avoid")
#basicdef("hyperventilate", "hyperventilate")
#basicdef("tripleflash", "tripleflash")
#basicdef("adroitness", "adroitness")
#end

#if skills.glamours then
#basicdef_withpower("illusoryself", "weave illusoryself", 5)
#end

#if skills.hexes then
#basicdef("hexcontrol", "hexcontrol on", true)
#basicdef_withpower("hexaura", "hexaura on", 10)
#basicdef_withpower("hexsense", "hexsense on", 3)
#end

#if skills.knighthood then
#basicdef("aggressive", "combatstyle aggressive", true)
#basicdef("concentrated", "combatstyle concentrated", true)
#basicdef("defensive", "combatstyle defensive", true)
#basicdef("lightning", "combatstyle lightning", true)
#basicdef("bleeder", "combatstyle bleeder", true)
#basicdef("bludgeoner", "combatstyle bludgeoner", true)
#basicdef("berserker", "combatstyle berserker", true)
#basicdef("pulverizer", "combatstyle pulverizer", true)
#basicdef("mutilator", "combatstyle mutilator", true)
#basicdef("poisonist", "combatstyle poisonist", true)
#end

#if skills.cavalier then
#basicdef("strikes", "recover strikes")
#basicdef("guarding", "guard self")
#end

#if skills.telekinesis then
  psychiclift = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].psychiclift and not defc.psychiclift) or (conf.keepup and defkeepup[defs.mode].psychiclift and not defc.psychiclift)) and not codepaste.balanceful_defs_codepaste() and (bals.id and bals.id ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("psychiclift")
      end,

      onstart = function ()
        send("psi id psychiclift on", conf.commandecho)
      end
    }
  },
  forcefield = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].forcefield and not defc.forcefield) or (conf.keepup and defkeepup[defs.mode].forcefield and not defc.forcefield)) and not codepaste.balanceful_defs_codepaste() and (bals.super and bals.super ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("forcefield")
      end,

      onstart = function ()
        send("psi super forcefield", conf.commandecho)
      end
    }
  },
#end

#if skills.psionics then
  psisense = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].psisense and not defc.psisense) or (conf.keepup and defkeepup[defs.mode].psisense and not defc.psisense)) and not codepaste.balanceful_defs_codepaste() and (bals.sub and bals.sub ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("psisense")
      end,

      onstart = function ()
        send("psi sub psisense on", conf.commandecho)
      end
    }
  },
  psiarmour = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].psiarmour and not defc.psiarmour) or (conf.keepup and defkeepup[defs.mode].psiarmour and not defc.psiarmour)) and not codepaste.balanceful_defs_codepaste() and ((bals.sub and bals.sub ~= "locked") or (bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("psiarmour")
      end,

      onstart = function ()
        if (bals.sub and bals.sub ~= "locked") then
          send("psi sub psiarmour on", conf.commandecho)
        elseif (bals.super and bals.super ~= "locked") then
          send("psi super psiarmour on", conf.commandecho)
        elseif (bals.id and bals.id ~= "locked") then
          send("psi id psiarmour on", conf.commandecho)
        end
      end
    }
  },
  bodydensity = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bodydensity and not defc.bodydensity) or (conf.keepup and defkeepup[defs.mode].bodydensity and not defc.bodydensity)) and not codepaste.balanceful_defs_codepaste() and (bals.super and bals.super ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("bodydensity")
      end,

      onstart = function ()
        send("psi super bodydensity on", conf.commandecho)
      end
    }
  },
  mindbar = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].mindbar and not defc.mindbar) or (conf.keepup and defkeepup[defs.mode].mindbar and not defc.mindbar)) and not codepaste.balanceful_defs_codepaste() and (bals.id and bals.id ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("mindbar")
      end,

      onstart = function ()
        send("psi id mindbar on", conf.commandecho)
      end
    }
  },
  ironwill = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].ironwill and not defc.ironwill) or (conf.keepup and defkeepup[defs.mode].ironwill and not defc.ironwill)) and not codepaste.balanceful_defs_codepaste() and ((bals.sub and bals.sub ~= "locked") or (bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("ironwill")
      end,

      onstart = function ()
        if (bals.sub and bals.sub ~= "locked") then
          send("psi sub ironwill on", conf.commandecho)
        elseif (bals.super and bals.super ~= "locked") then
          send("psi super ironwill on", conf.commandecho)
        elseif (bals.id and bals.id ~= "locked") then
          send("psi id ironwill on", conf.commandecho)
        end
      end
    }
  },

 trueblind = {
    herb = {
      aspriority = 128,
      spriority = 248,
      def = true,

      isadvisable = function ()
        return false --[[(((sys.deffing and defdefup[defs.mode].trueblind and not defdefup[defs.mode].secondsight and not defc.trueblind) or (conf.keepup and defkeepup[defs.mode].trueblind and not defkeepup[defs.mode].secondsight and not defc.trueblind)) and not doingaction("waitingontrueblind") and not doingaction ("waitingonsecondsight") and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false]]
      end,

      oncompleted = function (def)
        if def then defences.got("trueblind")
        else
          doaction(dict.waitingontrueblind.waitingfor)
          sk.lostbal_herb()
        end
      end,

      gettingtrueblind = function ()
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_herb()
      end,

      alreadygot = function ()
        defences.got("trueblind")
        sk.lostbal_herb()
      end,

      afterimage = function ()
        sk.lostbal_herb()
        addaff (dict.afterimage)
      end,

      curedblind = function()
        defences.lost("blind")
        sk.lostbal_herb()

        if not conf.aillusion then defences.lost("trueblind") end
      end,

      eatcure = "faeleaf",
      onstart = function ()
        eat("faeleaf")
      end,

      empty = function()
      end
    },
    wafer = {
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].trueblind and not defdefup[defs.mode].secondsight and not defc.trueblind) or (conf.keepup and defkeepup[defs.mode].trueblind and not defkeepup[defs.mode].secondsight and not defc.trueblind)) and not doingaction("waitingontrueblind") and not doingaction ("waitingonsecondsight") and not affs.afterimage and not (affs.eyepeckleft and affs.eyepeckright)) or false
      end,

      oncompleted = function (def)
        if def then defences.got("trueblind")
        else
          doaction(dict.waitingontrueblind.waitingfor)
          sk.lostbal_wafer()
        end
      end,

      gettingtrueblind = function ()
        doaction(dict.waitingontrueblind.waitingfor)
        sk.lostbal_wafer()
      end,

      alreadygot = function ()
        defences.got("trueblind")
        sk.lostbal_wafer()
      end,

      afterimage = function ()
        sk.lostbal_wafer()
        addaff (dict.afterimage)
      end,

      curedblind = function()
        defences.lost("blind")
        sk.lostbal_wafer()

        if not conf.aillusion then defences.lost("trueblind") end
      end,

      eatcure = "faeleaf",
      onstart = function ()
        eat("faeleaf")
      end,

      empty = function()
      end
    },

  },
  waitingontrueblind = {
    spriority = 0,
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        defences.got("trueblind")
      end,

      onstart = function ()
      end
    }
  },
  secondsight = {
    physical = {
      aspriority = 0,
      spriority = 0,
      balanceful_act = true,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].secondsight and not defc.trueblind) or (conf.keepup and defkeepup[defs.mode].secondsight and not defc.trueblind)) and not doingaction("waitingonsecondsight") and not doingaction ("waitingontrueblind") and not doingaction "secondsight") or false
      end,

      oncompleted = function (def)
        if def then defences.got("secondsight")
        else
          doaction(dict.waitingonsecondsight.waitingfor)
        end
      end,

      alreadygot = function ()
        defences.got("trueblind")
      end,

      onstart = function ()
        send("psi sub secondsight", conf.commandecho)
      end
    },

  },
  waitingonsecondsight = {
    waitingfor = {
      customwait = 6,

      oncompleted = function ()
        defences.got("trueblind")
      end,

      onstart = function ()
      end
    }
  },

#end

#if skills.stealth then
#basicdef("sneak", "sneak")
#basicdef("bracing", "stealth bracing")
#basicdef("awareness", "stealth awareness on")
#basicdef("agility", "stealth agility")
#basicdef("whisper", "stealth whisper")
#basicdef("screen", "stealth screen")
#end

#if skills.cosmic then
#basicdef("soulguard", "abjure soulguard")
#end

#if skills.aquamancy then
#basicdef("watershield", "raise staff")
#basicdef("whirlpool", "aquacast whirlpool")
#basicdef("liquidform", "aquacast liquidform")
#basicdef("deluge", "aquacast deluge")
#end

#if skills.aquachemantics then
#basicdef("novamist", "mist expel novamist")
#basicdef("chilled", "waterwork chilled globe")
#basicdef("buoyancy", "waterwork buoyancy globe")
#basicdef("boiling", "waterwork boiling globe")
#basicdef("surging", "waterwork surging globe")
#basicdef("peaceful", "waterwork peaceful sheen")
#basicdef("fervid", "waterwork fervid sheen")
#basicdef("virtuous", "waterwork virtuous sheen")
#basicdef("ardent", "waterwork ardent sheen")
#end

#if skills.druidry then
#basicdef("twirlcudgel", "twirl cudgel")
#end

#if skills.shamanism then
  weatherguard = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].weatherguard and not defc.weatherguard) or (conf.keepup and defkeepup[defs.mode].weatherguard and not defc.weatherguard)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone and not (gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.details and table.contains(gmcp.Room.Info.details, "indoors"))) or false
        end,

        oncompleted = function ()
          defences.got("weatherguard")
        end,

        onstart = function ()
          send("manipulate weatherguard", conf.commandecho)
        end
      }
  },
#basicdef("walkingtrance", "walkingtrance on")
#basicdef("death", "trances death")
  claw = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].claw and not defc.claw) or (conf.keepup and defkeepup[defs.mode].claw and not defc.claw)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldclaw = defc.claw
        defc.claw = type(what) == "string" and what:match("(%w+)") or true
        if oldclaw ~= defc.claw then
          raiseEvent("m&m got def", "claw")
        end
      end,

      onstart = function ()
        send("trance claw past", conf.commandecho)
      end
    }
  },
  bloom = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bloom and not defc.bloom) or (conf.keepup and defkeepup[defs.mode].bloom and not defc.bloom)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldbloom = defc.bloom
        defc.bloom = type(what) == "string" and what:match("(%w+)") or true
        if oldbloom ~= defc.bloom then
          raiseEvent("m&m got def", "bloom")
        end
      end,

      onstart = function ()
        send("trance bloom past", conf.commandecho)
      end
    }
  },
  bone = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bone and not defc.bone) or (conf.keepup and defkeepup[defs.mode].bone and not defc.bone)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldbone = defc.bone
        defc.bone = type(what) == "string" and what:match("(%w+)") or true
        if oldbone ~= defc.bone then
          raiseEvent("m&m got def", "bone")
        end
      end,

      onstart = function ()
        send("trance bone past", conf.commandecho)
      end
    }
  },
  root = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].root and not defc.root) or (conf.keepup and defkeepup[defs.mode].root and not defc.root)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldroot = defc.root
        defc.root = type(what) == "string" and what:match("(%w+)") or true
        if oldroot ~= defc.root then
          raiseEvent("m&m got def", "root")
        end
      end,

      onstart = function ()
        send("trance root past", conf.commandecho)
      end
    }
  },
  sky = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].sky and not defc.sky) or (conf.keepup and defkeepup[defs.mode].sky and not defc.sky)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldsky = defc.sky
        defc.sky = type(what) == "string" and what:match("(%w+)") or true
        if oldsky ~= defc.sky then
          raiseEvent("m&m got def", "sky")
        end
      end,

      onstart = function ()
        send("trance sky past", conf.commandecho)
      end
    }
  },
  land = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].land and not defc.land) or (conf.keepup and defkeepup[defs.mode].land and not defc.land)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
      end,

      oncompleted = function (what)
        local oldland = defc.land
        defc.land = type(what) == "string" and what:match("(%w+)") or true
        if oldland ~= defc.land then
          raiseEvent("m&m got def", "land")
        end
      end,

      onstart = function ()
        send("trance land past", conf.commandecho)
      end
    }
  },
#end

#if skills.moon then
#basicdef_withpower("drawdown", "moondance drawdown", 10)
#basicdef_withpower("shine", "moondance shine", 10)
#basicdef("aura", "moondance aura")
#basicdef("waxing", "moondance waxing")
#end

#if skills.aeromancy then
#basicdef("mancywalk", "aerocast windwalk")
#basicdef("twirlstaff", "twirl staff")
#end

#if skills.aerochemantics then
#basicdef("chemwalk", "aerowork windwalk")
#end

#if skills.pyromancy then
#basicdef("mancyproof", "pyrocast fireproof")
#basicdef("flamering", "pyrocast flamering")
#basicdef_withpower("cauterize", "raise staff", 10)
#end

#if skills.pyrochemantics then
#basicdef("chemproof", "pyrowork fireproof")
#basicdef("doping", "pyrowork doping on")
#end


#if skills.phantasms then
#basicdef("phantomarmour", "weave phantomarmour")
#basicdef("burningeye", "weave burningeye")
#end

#if skills.paradigmatics then
#basicdef("gnosis", "shift gnosis")
#basicdef("goodluck", "shift goodluck")
#basicdef("fusion", "shift fusion on")
#basicdef("polarity", "shift polarity on")
#basicdef("enthrall", "shift enthrall")
#basicdef_withpower("chaotesign", "shift chaotesign", 2)
#basicdef_withpower("chaosaura", "shift chaosaura on", 10)
#end

#if skills.transmology then
#basicdef("fleshwork", {"outskin lovashi", "fleshcall fleshwork"})
#basicdef_withpower("channels", "open channels", 10)
#end

#if skills.tracking then
#basicdef_withpower("poisonexpert", "focus poisons", 10)
#end

#if skills.tarot then
#basicdef_withpower("fool", {"outd fool", "fling fool at ground"}, 3)
#basicdef_withpower("enigma", {"outd enigma", "fling enigma at ground"}, 5)
#basicdef_withpower("world", {"outd world", "fling world at ground"}, 5)
#basicdef_withpower("warrior", {"outd warrior", "fling warrior at ground"}, 2)
#basicdef_withpower("starleaper", {"outd starleaper", "fling starleaper at ground"}, 2)
#basicdef("princess", {"outd princess", "fling princess at ground"})
#basicdef("teacher", {"outd teacher", "fling teacher at ground"})
#end

#if skills.wicca then
#basicdef_withpower("channels", "open channels", 10)
#end

#if skills.dreamweaving then
#basicdef("dreamweavecontrol", "dreamweave control")
#end

$(if skills.healing then
for _, aura in ipairs({"temperature", "auric", "fractures", "glandular", "senses", "neurosis", "breaks", "choleric", "curses", "muscles", "sanguine", "blood", "melancholic", "phobias", "phlegmatic", "nervous", "mania", "skin"}) do
  basicdef(aura, "radiate ".. aura)
end

basicdef("aurasense", "aurasense on")
basicdef("healingaura", "radiate health")
basicdef("quickeningaura", "radiate speed")
basicdef("depressionaura", "radiate depression")
end)

#if skills.elementalism then
#basicdef("elementshield", "cast elementshield")
#basicdef("waterbreathe", "cast waterbreathe")
#basicdef("stoneskin", "cast stoneskin")
  levitate = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].levitate and not defc.levitate) or (conf.keepup and defkeepup[defs.mode].levitate and not defc.levitate)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone ) or false
      end,

      oncompleted = function ()
        defences.got("levitate")
      end,

      onstart = function ()
        if not conf.enchantments and mm.me.activeskills.elementalism then
          send("cast levitate", conf.commandecho)
        else
          send("rub levitate", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge levitate from cube", conf.commandecho) end
        end
      end
    }
  },
#end

#if skills.illusions then
#basicdef("reflection", "weave reflection at me")
#basicdef("invisibility", "weave invisibility")
#basicdef("blur", "weave blur")
  changeself = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].changeself and not defc.changeself) or (conf.keepup and defkeepup[defs.mode].changeself and not defc.changeself)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("changeself")
      end,

      onstart = function ()
        send("weave changeself "..(conf.changerace and conf.changerace or "human"), conf.commandecho)
      end
    }
  },
#end

#if skills.hunting then
#basicdef("camouflage", "camouflage on")
#end

#if skills.music then
#basicdef("bardicpresence", "bardicpresence", true)
#end

#if skills.dramaturgy then
#basicdef("etiquette", "drama etiquette")
#basicdef("foppery", "drama foppery")
#basicdef("jealousy", "drama jealousy on")
#basicdef("rebuff", "drama rebuff on")
#end

#if skills.crow then
  spiderweb = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].spiderweb and not defc.spiderweb) or (conf.keepup and defkeepup[defs.mode].spiderweb and not defc.spiderweb)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not defc.crowsfeet) or false
      end,

      oncompleted = function ()
        defences.got("spiderweb")
      end,

      onstart = function ()
        send("outr 2 bluetint", conf.commandecho)
        send("paint face spiderweb", conf.commandecho)
      end
    }
  },
  crowsfeet = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].crowsfeet and not defc.crowsfeet) or (conf.keepup and defkeepup[defs.mode].crowsfeet and not defc.crowsfeet)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not defc.spiderweb) or false
      end,

      oncompleted = function ()
        defences.got("crowsfeet")
      end,

      onstart = function ()
        send("outr 2 yellowtint", conf.commandecho)
        send("paint face crowsfeet", conf.commandecho)
      end
    }
  },
  deathmask = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].deathmask and not defc.deathmask) or (conf.keepup and defkeepup[defs.mode].deathmask and not defc.deathmask)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not defc.bonenose) or false
      end,

      oncompleted = function ()
        defences.got("deathmask")
      end,

      onstart = function ()
        send("outr 2 goldtint", conf.commandecho)
        send("paint face deathmask", conf.commandecho)
      end
    }
  },
  bonenose = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bonenose and not defc.bonenose) or (conf.keepup and defkeepup[defs.mode].bonenose and not defc.bonenose)) and not codepaste.balanceful_defs_codepaste() and not affs.prone and not defc.deathmask) or false
      end,

      oncompleted = function ()
        defences.got("bonenose")
      end,

      onstart = function ()
        send("outr 2 purpletint", conf.commandecho)
        send("paint face bonenose", conf.commandecho)
      end
    }
  },


  perch = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].perch and not defc.perch) or (conf.keepup and defkeepup[defs.mode].perch and not defc.perch)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone and gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.name:starts("In the trees above")) or false
      end,

      oncompleted = function ()
        defences.got("perch")
      end,

      onstart = function ()
        send("crow perch", conf.commandecho)
      end
    }
  },
#basicdef("carrionstench", "crow belch on")
#basicdef_withpower("crowform", "crowform", 10)
#basicdef("spy", "crowsnest listen")
#end

#if skills.ascendance then
#basicdef("deathaura", {"manifest death aura", "manifest death aura on"})
#basicdef("puresoul", "manifest pure soul")
#end

#if skills.stag then
#basicdef_withpower("stagform", "stagform", 10)
#basicdef("staghide", "staghide")
#basicdef("bolding", "bolting on")
#basicdef("greenman", {"outr 2 greentint", "paint face greenman"})
#basicdef("trueheart", {"outr 2 yellowtint", "paint face trueheart"})
#basicdef("swiftstripes", {"outr 2 redtint", "paint face swiftstripes"})
#basicdef("lightningmask", {"outr 2 bluetint", "paint face lightning"})
#end

#if skills.runes then
#basicdef("benignprophesy", {"outrb ur", "outrb nyd", "outrb cen", "foretell benign prophesy"})
#end

#if skills.tahtetso then
#basicdef("grip", "grip")
#basicdef("deflectright", "ka deflect right")
#basicdef("deflectleft", "ka deflect left")
#end

#if skills.shofangi then
#basicdef("grip", "grip")
#basicdef("deflectright", "ka deflect right")
#basicdef("deflectleft", "ka deflect left")
#end

#if skills.ninjakari then
#basicdef("grip", "grip")
#basicdef("deflectright", "ka deflect right")
#basicdef("deflectleft", "ka deflect left")
#end

#if skills.nekotai then
#basicdef("grip", "grip")
#basicdef("deflectright", "ka deflect right")
#basicdef("deflectleft", "ka deflect left")
#basicdef("blur", "weave blur")
#basicdef("scorpiontail", "ka scorpiontail")

  screeright = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].screeright and not defc.screeright) or (conf.keepup and defkeepup[defs.mode].screeright and not defc.screeright)) and not codepaste.balanceful_defs_codepaste() and conf.screeright) or false
      end,

      oncompleted = function ()
        defences.got("screeright")
      end,

      onstart = function ()
        send("place "..conf.screeright.. " right", conf.commandecho)
      end
    }
  },

  screeleft = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].screeleft and not defc.screeleft) or (conf.keepup and defkeepup[defs.mode].screeleft and not defc.screeleft)) and not codepaste.balanceful_defs_codepaste() and conf.screeleft) or false
      end,

      oncompleted = function ()
        defences.got("screeleft")
      end,

      onstart = function ()
        send("place "..conf.screeleft.. " left", conf.commandecho)
      end
    }
  },

#end

#if skills.cosmic then
#basicdef("cloak", "abjure cloak")
#basicdef("timeslip", "abjure timeslip")
  nimbus = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].nimbus and not defc.nimbus) or (conf.keepup and defkeepup[defs.mode].nimbus and not defc.nimbus)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone ) or false
      end,

      oncompleted = function ()
        defences.got("nimbus")
      end,

      onstart = function ()
        if not conf.enchantments and mm.me.activeskills.cosmic then
          send("abjure nimbus", conf.commandecho)
        else
          send("rub nimbus", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge nimbus from cube", conf.commandecho) end
        end
      end
    }
  },
  deathsight = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].deathsight and not defc.deathsight) or (conf.keepup and defkeepup[defs.mode].deathsight and not defc.deathsight)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone ) or false
      end,

      oncompleted = function ()
        defences.got("deathsight")
      end,

      onstart = function ()
        if conf.deathsight then
          send("deathsight", conf.commandecho)
        elseif not conf.enchantments then
          send("abjure deathsight", conf.commandecho)
        else
          send("rub deathsight", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge deathsight from cube", conf.commandecho) end
        end
      end
    }
  },
  waterwalk = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].waterwalk and not defc.waterwalk) or (conf.keepup and defkeepup[defs.mode].waterwalk and not defc.waterwalk)) and not codepaste.balanceful_defs_codepaste() and not affs.paralysis and not affs.prone ) or false
      end,

      oncompleted = function ()
        defences.got("waterwalk")
      end,

      onstart = function ()
        if not conf.enchantments and mm.me.activeskills.cosmic then
          send("abjure waterwalk", conf.commandecho)
        else
          send("rub waterwalk", conf.commandecho)
          if conf.autorecharge and not sys.sync then
            send("recharge waterwalk from cube", conf.commandecho) end
        end
      end
    }
  },
#end

#if skills.aeonics then
#basicdef("mindclock", "timechant mindclock")
#basicdef("insight", "timechant insight")
#basicdef("timelessbody", "timechant timelessbody")
#basicdef("futureglimpse", "timechant futureglimpse")
#basicdef("foresight", "timechant foresight")
#basicdef("paradox", "timechant paradox")
#basicdef("alacrity", "timechant alacrity")
#basicdef("switchfate", "timechant switchfate")
#basicdef("aeonfield", "timechant aeonfield")
#end

#if skills.nihilism then
#basicdef("wings", "darkcall wings")
#basicdef("demonscales", "darkcall demonscales")
#basicdef("barbedtail", "darkcall barbedtail")
#basicdef_withpower("channels", "open channels", 10)
#end

#if skills.celestialism then
#basicdef("wings", "starcall wings")
#basicdef("halo", "starcall halo")
#basicdef_withpower("channels", "open channels", 10)
#basicdef("stigmata", "starcall stigmata on")
#end

#if skills.psychometabolism then
#basicdef("introspection", "introspection")
  bloodboil = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].bloodboil and not defc.bloodboil) or (conf.keepup and defkeepup[defs.mode].bloodboil and not defc.bloodboil)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.sub and bals.sub ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("bloodboil")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super bloodboil", conf.commandecho)
        else
          send("psi sub bloodboil", conf.commandecho)
        end
      end
    }
  },
  mindfield = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].mindfield and not defc.mindfield) or (conf.keepup and defkeepup[defs.mode].mindfield and not defc.mindfield)) and not codepaste.balanceful_defs_codepaste() and (bals.sub and bals.sub ~= "locked")) or false
      end,

      oncompleted = function ()
        defences.got("mindfield")
      end,

      onstart = function ()
        send("psi sub mindfield on", conf.commandecho)
      end
    }
  },
  energycontainment = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].energycontainment and not defc.energycontainment) or (conf.keepup and defkeepup[defs.mode].energycontainment and not defc.energycontainment)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("energycontainment")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super energycontainment", conf.commandecho)
        else
          send("psi id energycontainment", conf.commandecho)
        end
      end
    }
  },
  psiregeneration = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].psiregeneration and not defc.psiregeneration) or (conf.keepup and defkeepup[defs.mode].psiregeneration and not defc.psiregeneration)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("psiregeneration")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super regeneration", conf.commandecho)
        else
          send("psi id regeneration", conf.commandecho)
        end
      end
    }
  },
  lifedrain = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].lifedrain and not defc.lifedrain) or (conf.keepup and defkeepup[defs.mode].lifedrain and not defc.lifedrain)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("lifedrain")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super lifedrain", conf.commandecho)
        else
          send("psi id lifedrain", conf.commandecho)
        end
      end
    }
  },
  ironskin = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].ironskin and not defc.ironskin) or (conf.keepup and defkeepup[defs.mode].ironskin and not defc.ironskin)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("ironskin")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super ironskin", conf.commandecho)
        else
          send("psi id ironskin", conf.commandecho)
        end
      end
    }
  },
  gliding = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].gliding and not defc.gliding) or (conf.keepup and defkeepup[defs.mode].gliding and not defc.gliding)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("gliding")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super gliding", conf.commandecho)
        else
          send("psi id gliding", conf.commandecho)
        end
      end
    }
  },
  enhancementspread = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].enhancementspread and not defc.enhancementspread) or (conf.keepup and defkeepup[defs.mode].enhancementspread and not defc.enhancementspread)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("enhancementspread")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super enhancement spread", conf.commandecho)
        else
          send("psi id enhancement spread", conf.commandecho)
        end
      end
    }
  },
  enhancementdexterity = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].enhancementdexterity and not defc.enhancementdexterity) or (conf.keepup and defkeepup[defs.mode].enhancementdexterity and not defc.enhancementdexterity)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("enhancementdexterity")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super enhancement speed", conf.commandecho)
        else
          send("psi id enhancement speed", conf.commandecho)
        end
      end
    }
  },
  enhancementstrength = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].enhancementstrength and not defc.enhancementstrength) or (conf.keepup and defkeepup[defs.mode].enhancementstrength and not defc.enhancementstrength)) and not codepaste.balanceful_defs_codepaste() and ((bals.super and bals.super ~= "locked") or (bals.id and bals.id ~= "locked"))) or false
      end,

      oncompleted = function ()
        defences.got("enhancementstrength")
      end,

      onstart = function ()
        if (bals.super and bals.super ~= "locked") then
          send("psi super enhancement damage", conf.commandecho)
        else
          send("psi id enhancement damage", conf.commandecho)
        end
      end
    }
  },

#end

#if skills.geomancy then
#basicdef("earthpulse", "raise staff")
#end

#if skills.necromancy then
#basicdef("putrefaction", "darkchant putrefaction")
#basicdef("ghost", "darkchant ghost")
#basicdef("coldaura", "coldaura on")
#end

#if skills.necroscream then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge tempo from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end

#if skills.shadowbeat then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge tempo from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end

#if skills.minstrelry then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end


#if skills.loralaria then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge tempo from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end

#if skills.starhymn then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge tempo from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end

#if skills.wildarrane then
#basicdef_withpower("encore", "encore performance", 5)
  tempo = {
    stopwatch = createStopWatch(),
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].tempo and not defc.tempo) or (conf.keepup and defkeepup[defs.mode].tempo and not defc.tempo)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tempo")
        startStopWatch(dict.tempo.stopwatch)
      end,

      onstart = function ()
        send("wind tempo", conf.commandecho)
        if conf.autorecharge and not sys.sync then
          send("recharge tempo from cube", conf.commandecho) end
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tempo")
        stopStopWatch(dict.tempo.stopwatch)
        resetStopWatch(dict.tempo.stopwatch)
      end,
    }
  },
#end

#if skills.totems then
  nature = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      allnaturedefences = function ()
        return defc.bear and defc.crow and defc.groundhog and defc.horse and defc.monkey and defc.moon and defc.night and defc.river and defc.rock and defc.skunk and defc.snake and defc.squirrel and defc.stag and defc.sun and defc.tree and defc.trout and defc.wolf
      end,

      isadvisable = function ()
        return (stats.currentpower >= 5 and ((((sys.deffing and defdefup[defs.mode].nature and not dict.nature.physical.allnaturedefences()) or (conf.keepup and defkeepup[defs.mode].nature and not dict.nature.physical.allnaturedefences()))) or (conf.keepup and defkeepup[defs.mode].nature and not dict.nature.physical.allnaturedefences())) and not doingaction("nature") and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("nature")
        defences.got("squirrel")
        defences.got("night")
        defences.got("skunk")
        defences.got("sun")
        defences.got("rock")
        defences.got("moon")
        defences.got("crow")
        defences.got("tree")
        defences.got("groundhog")
        defences.got("trout")
        defences.got("wolf")
        defences.got("bear")
        defences.got("stag")
        defences.got("monkey")
        defences.got("horse")
        defences.got("river")
        defences.got("snake")
      end,

      onstart = function ()
        send("spiritbond nature", conf.commandecho)
      end
    }
  },
  monkey = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].monkey and not defc.monkey) or (conf.keepup and defkeepup[defs.mode].monkey and not defc.monkey))) or (conf.keepup and defkeepup[defs.mode].monkey and not defc.monkey)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("monkey")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond monkey", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("monkey")
        defences.lost("nature")
      end,
    }
  },
  squirrel = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].squirrel and not defc.squirrel) or (conf.keepup and defkeepup[defs.mode].squirrel and not defc.squirrel))) or (conf.keepup and defkeepup[defs.mode].squirrel and not defc.squirrel)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("squirrel")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond squirrel", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("squirrel")
        defences.lost("nature")
      end,
    }
  },
  night = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].night and not defc.night) or (conf.keepup and defkeepup[defs.mode].night and not defc.night))) or (conf.keepup and defkeepup[defs.mode].night and not defc.night)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("night")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond night", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("night")
        defences.lost("nature")
      end,
    }
  },
  skunk = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].skunk and not defc.skunk) or (conf.keepup and defkeepup[defs.mode].skunk and not defc.skunk))) or (conf.keepup and defkeepup[defs.mode].skunk and not defc.skunk)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("skunk")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond skunk", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("skunk")
        defences.lost("nature")
      end,
    }
  },
  sun = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].sun and not defc.sun) or (conf.keepup and defkeepup[defs.mode].sun and not defc.sun))) or (conf.keepup and defkeepup[defs.mode].sun and not defc.sun)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("sun")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond sun", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("sun")
        defences.lost("nature")
      end,
    }
  },
  rock = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].rock and not defc.rock) or (conf.keepup and defkeepup[defs.mode].rock and not defc.rock))) or (conf.keepup and defkeepup[defs.mode].rock and not defc.rock)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("rock")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond rock", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("rock")
        defences.lost("nature")
      end,
    }
  },
  moon = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].moon and not defc.moon) or (conf.keepup and defkeepup[defs.mode].moon and not defc.moon))) or (conf.keepup and defkeepup[defs.mode].moon and not defc.moon)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("moon")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond moon", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("moon")
        defences.lost("nature")
      end,
    }
  },
  crow = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].crow and not defc.crow) or (conf.keepup and defkeepup[defs.mode].crow and not defc.crow))) or (conf.keepup and defkeepup[defs.mode].crow and not defc.crow)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("crow")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond crow", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("crow")
        defences.lost("nature")
      end,
    }
  },
  tree = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].tree and not defc.tree) or (conf.keepup and defkeepup[defs.mode].tree and not defc.tree))) or (conf.keepup and defkeepup[defs.mode].tree and not defc.tree)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("tree")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond tree", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("tree")
        defences.lost("nature")
      end,
    }
  },
  groundhog = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].groundhog and not defc.groundhog) or (conf.keepup and defkeepup[defs.mode].groundhog and not defc.groundhog))) or (conf.keepup and defkeepup[defs.mode].groundhog and not defc.groundhog)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("groundhog")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond groundhog", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("groundhog")
        defences.lost("nature")
      end,
    }
  },
  trout = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].trout and not defc.trout) or (conf.keepup and defkeepup[defs.mode].trout and not defc.trout))) or (conf.keepup and defkeepup[defs.mode].trout and not defc.trout)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("trout")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond trout", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("trout")
        defences.lost("nature")
      end,
    }
  },
  wolf = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].wolf and not defc.wolf) or (conf.keepup and defkeepup[defs.mode].wolf and not defc.wolf))) or (conf.keepup and defkeepup[defs.mode].wolf and not defc.wolf)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("wolf")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond wolf", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("wolf")
        defences.lost("nature")
      end,
    }
  },
  bear = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].bear and not defc.bear) or (conf.keepup and defkeepup[defs.mode].bear and not defc.bear))) or (conf.keepup and defkeepup[defs.mode].bear and not defc.bear)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("bear")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond bear", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("bear")
        defences.lost("nature")
      end,
    }
  },
  stag = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].stag and not defc.stag) or (conf.keepup and defkeepup[defs.mode].stag and not defc.stag))) or (conf.keepup and defkeepup[defs.mode].stag and not defc.stag)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("stag")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond stag", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("stag")
        defences.lost("nature")
      end,
    }
  },
  horse = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].horse and not defc.horse) or (conf.keepup and defkeepup[defs.mode].horse and not defc.horse))) or (conf.keepup and defkeepup[defs.mode].horse and not defc.horse)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("horse")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond horse", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("horse")
        defences.lost("nature")
      end,
    }
  },
  river = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].river and not defc.river) or (conf.keepup and defkeepup[defs.mode].river and not defc.river))) or (conf.keepup and defkeepup[defs.mode].river and not defc.river)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("river")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond river", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("river")
        defences.lost("nature")
      end,
    }
  },
  snake = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((((sys.deffing and defdefup[defs.mode].snake and not defc.snake) or (conf.keepup and defkeepup[defs.mode].snake and not defc.snake))) or (conf.keepup and defkeepup[defs.mode].snake and not defc.snake)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("snake")

        if (defc.squirrel and defc.night and defc.skunk and defc.sun and defc.rock and defc.moon and defc.crow and defc.tree and defc.groundhog and defc.trout and defc.wolf and defc.bear and defc.stag and defc.monkey and defc.horse and defc.river and defc.snake) then
          defences.got("nature")
        end
      end,

      onstart = function ()
        send("spiritbond snake", conf.commandecho)
      end
    },
    gone = {
      oncompleted = function ()
        defences.lost("snake")
        defences.lost("nature")
      end,
    }
  },
#end

#if skills.night then
  drink = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (stats.currentpower >= 4 and ((sys.deffing and defdefup[defs.mode].drink and not defc.drink) or (conf.keepup and defkeepup[defs.mode].drink and not defc.drink)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("drink")
      end,

      onstart = function ()
        if not sys.sync then
          send("cauldron release", conf.commandecho)
        end

        send("shadowdance drink", conf.commandecho)
      end
    }
  },
  nightkiss = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (stats.currentpower == 10 and ((sys.deffing and defdefup[defs.mode].nightkiss and not defc.nightkiss) or (conf.keepup and defkeepup[defs.mode].nightkiss and not defc.nightkiss)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("nightkiss")
      end,

      onstart = function ()
        send("shadowdance nightkiss", conf.commandecho)
      end
    }
  },
  garb = {
    physical = {
      balanceful_act = true,
      aspriority = 64,
      spriority = 352,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].garb and not defc.garb) or (conf.keepup and defkeepup[defs.mode].garb and not defc.garb)) and not codepaste.balanceful_defs_codepaste()) or false
      end,

      oncompleted = function ()
        defences.got("garb")
      end,

      onstart = function ()
        send("shadowdance garb", conf.commandecho)
      end
    }
  },

#end
}

-- enable org-specific defs if any
signals.systemstart:connect(function ()

  if not conf.org or conf.org == "none" then return end

  if conf.org == "Glomdoring" then
    dict.nightsweats = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].nightsweats and not defc.nightsweats) or (conf.keepup and defkeepup[defs.mode].nightsweats  and not defc.nightsweats)) and
            not doingaction("waitingfornightsweats") and not doingaction("nightsweats") and
            not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.slitthroat and not affs.crushedwindpipe and not sys.manualdefcheck and not affs.stun and not affs.crucified) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("nightsweats")
          else doaction(dict.waitingfornightsweats.waitingfor) end
        end,

        sipcure = "nightsweats",

        onstart = function ()
          send("sip nightsweats", conf.commandecho)
        end,

        empty = function ()
          dict.nightsweats.misc.oncompleted ()
        end
      },
      gone = {
        oncompleted = function ()
          defences.lost("nightsweats")
        end,
      }
    }
    dict.waitingfornightsweats = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("nightsweats")
        end,

        ontimeout = function ()
          if defc.nightsweats then return end
          echof("Warning - nightsweats didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }

#if not skills.night then
  dict.garb = {
    physical = {
      balanceful_act = true,
      aspriority = 0,
      spriority = 0,
      def = true,

      isadvisable = function ()
        return (((sys.deffing and defdefup[defs.mode].garb and not defc.garb) or (conf.keepup and defkeepup[defs.mode].garb and not defc.garb)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
      end,

      oncompleted = function ()
        defences.got("garb")
      end,

      onstart = function ()
        send("shadowdance garb", conf.commandecho)
      end
    }
  }
#end
  elseif conf.org == "Gaudiguch" then
#if not skills.paradigmatics then
    dict.chaotesign = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].chaotesign and not defc.chaotesign) or (conf.keepup and defkeepup[defs.mode].chaotesign and not defc.chaotesign)) and not codepaste.balanceful_defs_codepaste() and not affs.prone) or false
        end,

        oncompleted = function ()
          defences.got("chaotesign")
        end,

        onstart = function ()
          send("shift chaotesign", conf.commandecho)
        end
      }
    }
#end

    dict.firemead = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].firemead and not defc.firemead) or (conf.keepup and defkeepup[defs.mode].firemead  and not defc.firemead)) and
            not doingaction("waitingforfiremead") and not doingaction("firemead") and
            not affs.anorexia and not affs.throatlock and not affs.crushedwindpipe and not affs.scarab and not affs.slitthroat and not affs.crucified) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("firemead")
          else doaction(dict.waitingforfiremead.waitingfor) end
        end,

        sipcure = "firemead",

        onstart = function ()
          send("sip firemead", conf.commandecho)
        end,

        empty = function ()
          dict.firemead.misc.oncompleted ()
        end
      },
    }
    dict.waitingforfiremead = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("firemead")
        end,

        ontimeout = function ()
          echof("Warning - firemead didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }

  elseif conf.org == "Serenwilde" then
    dict.moonwater = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].moonwater and not defc.moonwater) or (conf.keepup and defkeepup[defs.mode].moonwater  and not defc.moonwater)) and
            not doingaction("waitingformoonwater") and not doingaction("moonwater") and
            not affs.anorexia and not affs.throatlock and not affs.scarab and not affs.crushedwindpipe and not affs.slitthroat and not affs.crucified) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("moonwater")
          else doaction(dict.waitingformoonwater.waitingfor) end
        end,

        sipcure = "moonwater",

        onstart = function ()
          send("sip moonwater", conf.commandecho)
        end,

        empty = function ()
          dict.moonwater.misc.oncompleted ()
        end
      },
    }
    dict.waitingformoonwater = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("moonwater")
        end,

        ontimeout = function ()
          echof("Warning - moonwater didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }
  elseif conf.org == "Celest" then
    dict.holywater = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].holywater and not defc.holywater) or (conf.keepup and defkeepup[defs.mode].holywater  and not defc.holywater)) and
            not doingaction("waitingforholywater") and not doingaction("holywater") and
            not affs.anorexia and not affs.throatlock and not affs.crushedwindpipe and not affs.scarab and not affs.slitthroat and not affs.crucified) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("holywater")
          else doaction(dict.waitingforholywater.waitingfor) end
        end,

        sipcure = "holywater",

        onstart = function ()
          send("sip holywater", conf.commandecho)
        end,

        empty = function ()
          dict.holywater.misc.oncompleted ()
        end
      },
    }
    dict.waitingforholywater = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("holywater")
        end,

        ontimeout = function ()
          echof("Warning - holywater didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }

  elseif conf.org == "Hallifax" then
#if not skills.aeonics then
    dict.mindclock = {
      physical = {
        balanceful_act = true,
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].mindclock and not defc.mindclock) or (conf.keepup and defkeepup[defs.mode].mindclock and not defc.mindclock)) and not codepaste.balanceful_defs_codepaste() and not affs.prone ) or false
        end,

        oncompleted = function ()
          defences.got("mindclock")
        end,

        onstart = function ()
          send("timechant mindclock", conf.commandecho)
        end
      }
    }
#end
    dict.cloudberry = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].cloudberry and not defc.cloudberry) or (conf.keepup and defkeepup[defs.mode].cloudberry  and not defc.cloudberry)) and
            not doingaction("waitingforcloudberry") and not doingaction("cloudberry") and
            not affs.anorexia and not affs.throatlock and not affs.crushedwindpipe and not affs.scarab and not affs.slitthroat) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("cloudberry")
          else doaction(dict.waitingforcloudberry.waitingfor) end
        end,

        sipcure = "cloudberry",

        onstart = function ()
          send("sip cloudberry", conf.commandecho)
        end,

        empty = function ()
          dict.cloudberry.misc.oncompleted ()
        end
      },
    }
    dict.waitingforcloudberry = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("cloudberry")
        end,

        ontimeout = function ()
          echof("Warning - cloudberry didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }

  elseif conf.org == "Magnagora" then
    dict.unholywater = {
      misc = {
        aspriority = 0,
        spriority = 0,
        def = true,

        isadvisable = function ()
          return (((sys.deffing and defdefup[defs.mode].unholywater and not defc.unholywater) or (conf.keepup and defkeepup[defs.mode].unholywater  and not defc.unholywater)) and
            not doingaction("waitingforunholywater") and not doingaction("unholywater") and
            not affs.anorexia and not affs.throatlock and not affs.crushedwindpipe and not affs.scarab and not affs.slitthroat and not affs.crucified) or false
        end,

        oncompleted = function (fromdef)
          if fromdef then defences.got("unholywater")
          else doaction(dict.waitingforunholywater.waitingfor) end
        end,

        sipcure = "unholywater",

        onstart = function ()
          send("sip unholywater", conf.commandecho)
        end,

        empty = function ()
          dict.unholywater.misc.oncompleted ()
        end
      },
      gone = {
        oncompleted = function ()
          defences.lost("unholywater")
        end,
      }
    }
    dict.waitingforunholywater = {
      waitingfor = {
        customwait = 60,

        oncompleted = function ()
          defences.got("unholywater")
        end,

        ontimeout = function ()
          echof("Warning - unholywater didn't come up in time, checking 'def'.")
          sys.manualdefcheck = true
        end,

        onstart = function () end
      }
    }

  end
end)

-- finds the lowest missing priority num for given balance
local function find_lowest_async(balance)
  local data = make_prio_table(balance)
  local t = {}

  for k,v in pairs(data) do
    t[#t+1] = k
  end

  table.sort(t)

  local function contains(value)
    for _, v in ipairs(t) do
      if v == value then return true end
    end
    return false
  end

  for i = 1, table.maxn(t) do
    if not contains(i) then return i end
  end

  return table.maxn(t)+1
end

local function find_lowest_sync()
  local data = make_sync_prio_table("%s%s")
  local t = {}

  for k,v in pairs(data) do
    t[#t+1] = k
  end

  table.sort(t)
  local function contains(value)
    for _, v in ipairs(t) do
      if v == value then return true end
    end
    return false
  end

  for i = 1, table.maxn(t) do
    if not contains(i) then return i end
  end

  return table.maxn(t)+1
end

local function dict_setup()
  dict_balanceful  = {}
  dict_balanceless = {}

  dict_cleanse = {}

  -- defence shortlists
  dict_balanceful_def  = {}
  dict_balanceless_def = {}
  dict_herb            = {}
  dict_misc            = {}
  dict_misc_def        = {}
  dict_purgative       = {}
  dict_sparkleaffs     = {}
  dict_wafer           = {}
  dict_steam           = {}

  local unassigned_actions      = {}
  local unassigned_sync_actions = {}

  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" then
        if not l.name then l.name = string.format("%s_%s", i, k) end
        if not l.balance then l.balance = k end
        if not l.action_name then l.action_name = i end
        if l.aspriority == 0 then
          unassigned_actions[k] = unassigned_actions[k] or {}
          unassigned_actions[k][#unassigned_actions[k]+1] = i
        end
        if l.spriority == 0 then
          unassigned_sync_actions[k] = unassigned_sync_actions[k] or {}
          unassigned_sync_actions[k][#unassigned_sync_actions[k]+1] = i
        end
      end
    end

    if not j.name then j.name = i end
    if j.physical and j.physical.balanceless_act and not j.physical.def then dict_balanceless[i] = {p = dict[i]} end
    if j.physical and j.physical.balanceful_act and not j.physical.def then dict_balanceful[i] = {p = dict[i]} end
    if j.purgative and j.purgative.def then
      dict_purgative[i] = {p = dict[i]} end

    if j.physical and j.physical.balanceful_act and j.physical.def then
      dict_balanceful_def[i] = {p = dict[i]} end

    if j.physical and j.physical.balanceless_act and j.physical.def then
      dict_balanceless_def[i] = {p = dict[i]} end

    if j.misc and j.misc.def then
      dict_misc_def[i] = {p = dict[i]} end

    if j.misc and not j.misc.def then
      dict_misc[i] = {p = dict[i]} end

    if j.herb and j.herb.def then
      dict_herb[i] = {p = dict[i]} end

    if j.wafer and j.wafer.def then
      dict_wafer[i] = {p = dict[i]} end

    if j.steam and j.steam.def then
      dict_steam[i] = {p = dict[i]} end

    if j.sparkle then
      dict_sparkleaffs[i] = {p = dict[i]} end

    if j.herb and not j.herb.maestoso then
      j.herb.maestoso = codepaste.maestoso_ruined end

    if j.herb and not j.herb.darkfate then
      j.herb.darkfate = codepaste.darkfate_ruined end

    if j.focus and not j.focus.insane then
      j.focus.insane = codepaste.insane_ruined end

    if j.physical and j.physical.cleanse then
      dict_cleanse[i] = {p = dict[i]} end

    if j.herb and not j.herb.noeffect then
      j.herb.noeffect = function () sk.lostbal_herb() end end

    if not j.sw then j.sw = createStopWatch() end
  end

  for balancename, list in pairs(unassigned_actions) do
    if #list > 0 then
      -- shift up by # all actions for that balance to make room @ bottom
      for i,j in pairs(dict) do
        for balance,l in pairs(j) do
          if balance == balancename and type(l) == "table" and l.aspriority and l.aspriority ~= 0 then
            l.aspriority = l.aspriority + #list
          end
        end
      end

      -- now setup the low id's
      for i, actionname in ipairs(list) do
        dict[actionname][balancename].aspriority = i
      end
    end
  end

  local totalcount = 0
  for _, list in pairs(unassigned_sync_actions) do
    totalcount = totalcount + #list
  end

  local function assign_sync_actions()
    for balancename, list in pairs(unassigned_sync_actions) do
      if totalcount > 0 then
        -- shift up by # all actions for that balance to make room @ bottom
        for i,j in pairs(dict) do
          for balance,l in pairs(j) do
            if type(l) == "table" and type(l.spriority) == "number" and l.spriority ~= 0 then
              l.spriority = l.spriority + totalcount
            end
          end
        end

        -- now setup the low id's
        for i, actionname in ipairs(list) do
          dict[actionname][balancename].spriority = i
        end
      end
    end
  end
  assign_sync_actions()
  unassigned_sync_actions = nil

  -- loop again to set priorities that were scripted with functions, replacing the function with the priority in the process
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" then
        -- handle async actions and sync actions in one loop go
        if type(l.aspriority) == "function" then
          debugf(k.."'s aspriority is a function!")
          local s, desiredid = pcall(l.aspriority)
          debugf("desiredid after pcall: %s", tostring(desiredid))

          -- default to highest priority of the function fails - as it's safer to add to the top than add to the bottom (0) all tht time; I don't think prio.insert would be pushing things up the stack
          if not desiredid then
            desiredid = prio.gethighest(l.balance) + 1
            debugf("pcall failed. defaulting to %s", desiredid)
          end

          l.aspriority = desiredid
          debugf("we want to insert %s at %s in async - doing so...", l.name, tostring(l.aspriority))
          prio.insert(l.action_name, l.balance, l.aspriority)
        end

        if type(l.spriority) == "function" then
          local s, desiredid = pcall(l.aspriority)

          -- default to 0 if it fails and shuffle the priorities after
          if not desiredid then
            unassigned_sync_actions[k] = unassigned_sync_actions[k] or {}
            unassigned_sync_actions[k][#unassigned_sync_actions[k]+1] = i
            debugf("%s's function failed - we'll shuffle it in later.", l.name)
          else
            l.spriority = desiredid
            debugf("we want to insert %s at %s in async - doing so...", l.name, tostring(l.spriority))
            prio.insert(l.action_name, "slowcuring", l.aspriority)
          end
        end
      end
    end
  end

  -- assign any sync actions we couldn't due to functions failing
  if unassigned_sync_actions then assign_sync_actions() end


  -- we don't want stuff in dict.lovers.map!
  dict.lovers.map = {}
end

local function dict_validate()
  -- basic theory is to create table keys for each table within dict.#,
  -- store the dupe aspriority values inside in key-pair as well, and report
  -- what we got.
  local data = {}
  local dupes = {}
  local sync_dupes = {}
  local key = false

  -- check async ones first
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" and l.aspriority then
        local balance = k:split("_")[1]
        if not data[balance] then data[balance] = {} dupes[balance] = {} end
        key = containsbyname(data[balance], l.aspriority)
          if key then
          -- store the new dupe that we found
          dupes[balance][(k:split("_")[2] and k:split("_")[2] .. " for " or "") .. i] = l.aspriority
          -- and store the previous one that we had already!
          dupes[balance][(key.balance:split("_")[2] and key.balance:split("_")[2] .. " for " or "") .. key.action_name] = l.aspriority
        end
        data[balance][l] = l.aspriority

      end
    end
  end

  -- if we got something, complain
  for i,j in pairs(dupes) do
    if next(j) then
        echof("Meh, problem. The following actions in %s balance have the same priorities: %s", i, oneconcatwithval(j))
    end
  end

  -- clear table for next use, don't re-make to not force rehashes
  for k in pairs(data) do
    data[k] = nil
  end
  for k in pairs(dupes) do
    dupes[k] = nil
  end

  -- check sync ones
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" and l.spriority then
        local balance = l.name
        local key = containsbyname(data, l.spriority)
        if key then
          dupes[balance] = l.spriority
          dupes[key] = l.spriority
        end
        data[balance] = l.spriority

      end
    end
  end

  -- if we got something, complain
  if not next(dupes) then return end

  -- sort them first before complaining
  local sorted_dupes = {}
    -- stuff into table
  for i,j in pairs(dupes) do
    sorted_dupes[#sorted_dupes+1] = {name = i, prio = j}
  end

    -- sort table
  table.sort(sorted_dupes, function(a,b) return a.prio < b.prio end)

  local function a(tbl)
    assert(type(tbl) == "table")
    local result = {}
    for i,j in pairs(tbl) do
      result[#result+1] = j.name .. "(" .. j.prio .. ")"
    end

    return table.concat(result, ", ")
  end

    -- complaining time
  echof("Meh, problem. The following actions in sync mode have the same priorities: %s", a(sorted_dupes))
end

make_prio_table = function (balance)
  local data = {}

  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if k:sub(1, #balance) == balance and type(l) == "table" and l.aspriority then
        if #k ~= #balance then
          data[l.aspriority] = k:sub(#balance+2) .. " for " .. i
        else
          data[l.aspriority] = i
        end
      end
    end
  end

  return data
end

make_sync_prio_table = function(format)
  local data = {}
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" and l.spriority then
        data[l.spriority] = string.format(format, i, k)
      end
    end
  end

  return data
end

clear_balance_prios = function(balance)
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if k == balance and type(l) == "table" and l.aspriority and type(l.aspriority) ~= "function" then
        l.aspriority = 0
      end
    end
  end
end

clear_sync_prios = function()
  for i,j in pairs(dict) do
    for k,l in pairs(j) do
      if type(l) == "table" and l.spriority and type(l.spriority) ~= "function" then
        l.spriority = 0
      end
    end
  end
end

sk.check_attraction = function ()
  if affs.attraction and dict.attraction.eaten then
    dict.attraction.eaten = true
    removeaff("attraction")
    signals.newroom:block(sk.check_attraction)
  end
end
signals.newroom:connect(sk.check_attraction)
signals.newroom:block(sk.check_attraction)

sk.check_maestoso = function ()
  if actions.maestoso_waitingfor then
    lifevision.add(actions.maestoso_waitingfor.p)
  end
end
signals.newroom:connect(sk.check_maestoso)
signals.newroom:block(sk.check_maestoso)

sk.waiting_on_pit = function (roomname)
  if not string.find(roomname, "^In a pit.+") then
    checkaction (dict.curingpitted.waitingfor, true)
    lifevision.add(actions.curingpitted_waitingfor.p)
  end
end
signals.anyroom:connect(sk.waiting_on_pit)
signals.anyroom:block(sk.waiting_on_pit)

sk.check_bedevil = function (...)
  if affs.bedevil then
    dict.bedevil.blocked = false
  end
end

signals.newroom:connect(sk.check_bedevil)
signals.newroom:block(sk.check_bedevil)

sk.check_aurawarp = function (...)
  if affs.aurawarp then
    dict.aurawarp.blocked = false
  end
end

signals.newroom:connect(sk.check_aurawarp)
signals.newroom:block(sk.check_aurawarp)

-- reset grapples/pinlegs/impales
signals.newroom:connect(function()
  if not next(affs) then return end

  local removables = {"pinlegright2", "pinlegright", "pinlegleft2", "pinlegleft", "pinlegunknown", "gore", "impale", "shackled", "grapple", "truss"}
  local escaped = {}
  for i = 1, #removables do
    if affs[removables[i]] then
      escaped[#escaped+1] = removables[i]
      removeaff(removables[i])
    end
  end

  if #escaped > 0 then
    tempTimer(0, function()
      if stats.currenthealth > 0 then echof("Woo! We escaped from %s.", concatand(escaped)) end
    end)
  end
end)

signals.curedwith_focusmind:connect(function (what)
  dict.unknownmental.focus[what] ()
end)

signals.systemstart:connect(function ()
  dict.blind.herb.eatcure = conf.blindherb
  dict.deaf.herb.eatcure = conf.deafherb
  dict.healhealth.herb.eatcure = conf.sparkleherb
end)
