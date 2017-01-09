-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.


#local function encode (what)
#  return "dict." .. what .. ".herb"
#end

#local function encodes (what)
#  return "dict." .. what .. ".salve"
#end

#local function encodef (what)
#  return "dict." .. what .. ".focus"
#end

#local function encodep (what)
#  return "dict." .. what .. ".purgative"
#end

#local function encodel (what)
#  return "dict." .. what .. ".lucidity"
#end

#local function encodea (what)
#  return "dict." .. what .. ".allheale"
#end

#local function encodew (what)
#  return "dict." .. what .. ".waitingfor"
#end

#local function encodewafer (what)
#  return "dict." .. what .. ".wafer"
#end

#local function encodeice (what)
#  return "dict." .. what .. ".ice"
#end

#local function encodem (what)
#  return "dict." .. what .. ".misc"
#end

#local function encodess (what)
#  return "dict." .. what .. ".steam"
#end

function valid.caught_illusion()
  sys.flawedillusion = true
end

ignore_illusion = valid.caught_illusion

function vm.last_line_was_prompt()
  return (paragraph_length == 0) and true or false
  -- unreliable
  -- return (lastpromptnumber+1 == getLineNumber("main")) and true or false
end

function rebounding_off()
  sk.last_rebounding = {name = matches[2]}
end

function valid.knighthood_line()
  -- below voodoo doesn't work quite right yet :(
  if not conf.aillusion then return end

  -- check if the previous line is empty... why?
  --

  -- if paragraph_length ~= 1 and not (paragraph_length == 2 and sk.last_rebounding and line:find(sk.last_rebounding.name, 1, true)) and not find_until_last_paragraph("razes your", true) then
  --   disableTrigger("m&m knight ailments")
  --   disableTrigger("Poisons + Generic lines")

  --   sk.onprompt_beforeaction_add("knighthood", function ()
  --     enableTrigger("m&m knight ailments")
  --     enableTrigger("Poisons + Generic lines")
  --     moveCursor("main", 1, getLineCount("main") - 1)
  --     echo(" (i)")
  --     ignore_illusion()
  --   end)
  -- end
end

function valid.water_cured_fire()
  checkaction(dict.ablaze.gone, true)
  lifevision.add(actions.ablaze_gone.p)
end

function valid.bone_cured(side, limb)
  checkaction(dict["crippled"..side..limb].gone, true)
  lifevision.add(actions["crippled"..side..limb.."_gone"].p)
end

function valid.sheatheclaw(howmuch)
  checkaction(dict.sheatheclaw.physical, true)
  lifevision.add(actions.sheatheclaw_physical.p, nil, howmuch)
end

function defs.breath_finished()
  checkaction(dict.breath.physical, true)
  lifevision.add(actions.breath_physical.p, "woreoff")
end

function defs.breath_recovered()
  checkaction(dict.breath.physical, true)
  lifevision.add(actions.breath_physical.p, "recovered")
end

function defs.breath_recovering()
  checkaction(dict.breath.physical, true)
  lifevision.add(actions.breath_physical.p, "recovering")
end

function valid.symp_asleep()
  if not affs.sleep and not actions.sleep_aff then
    defs.lost_insomnia()
    valid.simplesleep()
    valid.simpleprone()
  end

  -- reset non-wait things we were doing, because they got cancelled by the stun
  if affs.sleep or actions.sleep_aff then
    for k,v in actions:iter() do
      if v.p.balance ~= "waitingfor" and v.p.balance ~= "aff" and v.p.name ~= "sleep_misc" then
        killaction(dict[v.p.action_name][v.p.balance])
      end
    end
  end
end

function valid.symp_tangle()
  if not sys.sync then
    checkaction(dict.prone.misc)
    if actions.prone_misc then
      lifevision.add(actions.prone_misc.p, "webbed")
    else
      sk.tangle_symptom()
    end
  else
    valid.simpletangle()
  end
end

function valid.symp_roped()
  if not sys.sync then
    checkaction(dict.prone.misc)
    if actions.prone_misc then
      lifevision.add(actions.prone_misc.p, "roped")
    else
      sk.roped_symptom()
    end
  else
    valid.simpleroped()
  end
end

function valid.symp_crucified()
  sk.crucified_symptom()
end

function valid.symp_shackled()
    checkaction(dict.prone.misc)
    if actions.prone_misc then
      lifevision.add(actions.prone_misc.p, "shackled")
    else
      sk.shackled_symptom()
    end
end

function valid.symp_stupidity()
  sk.stupidity_symptom()
end

function valid.symp_stun()
  if not conf.aillusion then
    valid.simplestun()
  elseif actions.checkstun_misc then
    lifevision.add(actions.checkstun_misc.p)
  else
    sk.stun_symptom()
  end

  -- reset non-wait things we were doing, because they got cancelled by the stun
  if affs.stun or actions.stun_aff then
    for k,v in actions:iter() do
      if v and v.p.balance ~= "waitingfor" and v.p.balance ~= "aff" then
        killaction(dict[v.p.action_name][v.p.balance])
      end
    end
  end
end

-- specials
function valid.woundstart()
  checkaction(dict.woundscheck.physical)
  if actions.woundscheck_physical then
    lifevision.add(actions.woundscheck_physical.p)
  else
    setTriggerStayOpen("Wounds start", 0)
  end
end

function valid.eachwound()
  local name = matches[2]
  name = string.gsub(name, " ", "")
  name = string.lower(name)
  local amount = tonumber(matches[3])
  if amount == 0 then
    local limb = checkanyaffs(dict["light"..name], dict["medium"..name], dict["heavy"..name], dict["critical"..name])
    if limb then
      checkaction(dict[limb.name].gone, true)
      lifevision.add(actions[limb.name.."_gone"].p)
    end
  else
    valid["simple"..sk.get_wound_level(amount)..name](amount)
  end
end

for _,k in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
  valid["wounds"..k.."_add"] = function (howmuch)
    assert(type(howmuch) == "number", "mm.valid.wounds"..k.."_add: how much damage do you want to add?")

    local amount = dict["light"..k].count + howmuch
    if conf.gmcpvitals then
      amount = howmuch
    end
    valid["simple"..sk.get_wound_level(amount)..k](amount)
  end
end

function valid.cured_lovers()
  checkaction(dict.lovers.physical)
  if actions.lovers_physical then
    lifevision.add(actions.lovers_physical.p, nil, multimatches[2][2])
  end
end

function valid.cured_lovers_nobody()
  checkaction(dict.lovers.physical)
  if actions.lovers_physical then
    lifevision.add(actions.lovers_physical.p, "nobody")
  end
end

function valid.water_cured_fire()
  checkaction(dict.ablaze.gone, true)
  lifevision.add(actions.ablaze_gone.p)
end

-- hallucinations symptoms
function valid.swandive()
  local have_pflag = pflags.p
  sk.onprompt_beforeaction_add("swandive", function ()
    if not have_pflag and pflags.p then
      valid.proper_prone()
      valid.simplehallucinating()
    end
  end)
end

function valid.spiders_all_overme()
  valid.proper_fear()
  valid.simplehallucinating()
end

function valid.stun_hallucination()
  valid.simplestun()
  valid.simplehallucinating()
end

function valid.proper_masochism()
  valid.simplemasochism()

  -- workaround for the awoke msg not showing up and masochism hitting us
  local oldhealth = stats.currenthealth
  sk.onprompt_beforeaction_add("asleep_masochism", function ()
    if affs.sleep and oldhealth > stats.currenthealth then valid.wake_done() end
  end)
end

function valid.sluggish()
  sk.aeon_symptom()
end

function valid.impaled()
  if affs.sap then -- it is difficult to check this in sap, so just do it as-is, because impale hinders sap curing
    valid.simpleimpale()
  else
    sk.impale_symptom()
  end
end

function valid.symp_choke()
  sk.choke_symptom()
end

function valid.symp_retardation()
  sk.sawsluggish = true -- for retardation going away auto-detection
  sk.retardation_symptom()
end

function valid.unbearably_slow()
  sk.sap_symptom()
end

function valid.saidnothing()
  if actions.checkslows_misc or actions.checkthroatlock_misc or actions.checkslitthroat_misc then
    deleteLineP()
    lifevision.add((actions.checkslows_misc and actions.checkslows_misc.p) or (actions.checkthroatlock_misc and actions.checkthroatlock_misc.p) or (actions.checkslitthroat_misc and actions.checkslitthroat_misc.p), "onclear")
  elseif affs.aeon or affs.sap or affs.choke or affs.retardation or affs.throatlock or affs.slitthroat then
    deleteLineP()
  end
end

function valid.webeslow()
  if actions.checkslows_misc then
    deleteLineP()
    lifevision.add(actions.checkslows_misc.p, "sluggish")
  end
end

function valid.canttalk()
  if actions.checkthroatlock_misc then
    lifevision.add(actions.checkthroatlock_misc.p, "canttalk")
  end
end

function valid.holythroat()
  if actions.checkslitthroat_misc then
    lifevision.add(actions.checkslitthroat_misc.p, "holythroat")
  end
end

function valid.hasdamagedthroat()
  if actions.checkdamagedthroat_misc then
    lifevision.add(actions.checkdamagedthroat_misc.p, "has")
    return
  end

  local r = findbybals("lucidity", "health")
  if not r then return end
  lifevision.add(actions.damagedthroat_aff.p)
end

function valid.proper_collapsedlungs()
  -- only blademasters have this requirement, not pureblades.
  --if conf.aillusion and not affs.puncturedlung then return end

  checkaction(dict.collapsedlungs.aff, true)
  if actions.collapsedlungs_aff then
    lifevision.add(actions.collapsedlungs_aff.p)
  end
end

function valid.proper_sleep()
  checkaction(dict.sleep.aff, true)
  checkaction(dict.prone.aff, true)

  lifevision.add(actions.sleep_aff.p)
  lifevision.add(actions.prone_aff.p)
  defs.lost_insomnia()
end

function valid.proper_fear()
#if skills.totems then
  tempLineTrigger(1,1,[[
    if getCurrentLine() ~= "The courage of the wolf swells within you, driving fear from your heart." then
      mm.valid.simplefear()
    end]])
#else
  valid.simplefear()
#end
end

-- prone
sk.acrobatics_pronecheckf = function ()
  if not find_until_last_paragraph("Your expert balance allows you to remain standing.") and pflags.p then
    valid.simpleprone()
  end

  -- clear other afflictions we might have been faked when we weren't really proned
  if not pflags.p then ignore_illusion("We didn't actually get proned.") end

   signals.before_prompt_processing:disconnect(sk.acrobatics_pronecheckf)
end

function valid.proper_prone()
  if affs.blackout then
    valid.simpleprone()
  else
    signals.before_prompt_processing:connect(sk.acrobatics_pronecheckf)
  end
end

-- tangle
#if skills.crow then
  sk.crow_tanglecheckf = function ()
  -- if we had p before, it's ok. just need it now is what matters
    if (conf.aillusion and pflags.p and crow_nospiderweb) or (not conf.aillusion and crow_nospiderweb) then
      valid.simpletangle()
      if crow_nospiderweb then killTrigger(crow_nospiderweb) end
      crow_nospiderweb = nil
    end

     signals.before_prompt_processing:disconnect(sk.crow_tanglecheckf)
  end

#else
  sk.normal_tanglecheckf = function ()
    if (conf.aillusion and pflags.p) or not conf.aillusion then
      valid.simpletangle()
    end

     signals.before_prompt_processing:disconnect(sk.normal_tanglecheckf)
  end
#end

function valid.proper_tangle()
#if skills.crow then

  crow_nospiderweb = tempLineTrigger(1,2,[[
    if getCurrentLine() == "The webbing around you disintegrates into ash." then
      mm.crow_nospiderweb = nil
      selectCurrentLine()
      setBgColor(0,0,0)
      setFgColor(0,170,255)
      resetFormat()
    end
  ]])
  signals.before_prompt_processing:connect(sk.crow_tanglecheckf)

#else

  signals.before_prompt_processing:connect(sk.normal_tanglecheckf)
#end
end

-- roped
#if skills.crow then
  sk.crow_ropedcheckf = function ()
    if (conf.aillusion and pflags.p) or (not conf.aillusion and crow_ropedcheck) then
      valid.simpleroped()
      if crow_ropedcheck then killTrigger(crow_ropedcheck) end
      crow_ropedcheck = nil
    end

     signals.before_prompt_processing:disconnect(sk.crow_ropedcheckf)
  end

#else
  sk.normal_ropedcheckf = function ()
    if (conf.aillusion and pflags.p) or not conf.aillusion then
      valid.simpleroped()
    end

     signals.before_prompt_processing:disconnect(sk.normal_ropedcheckf)
  end
#end

function valid.proper_roped()
#if skills.crow then

  crow_ropedcheck = tempLineTrigger(1,2,[[
    if getCurrentLine() == "The webbing around you disintegrates into ash." then
      mm.crow_ropedcheck = nil
      selectCurrentLine()
      setBgColor(0,0,0)
      setFgColor(0,170,255)
      resetFormat()
    end
  ]])
  signals.before_prompt_processing:connect(sk.crow_ropedcheckf)

#else

  signals.before_prompt_processing:connect(sk.normal_ropedcheckf)
#end
end

sk.normal_checktrussf = function ()
  if (conf.aillusion and pflags.p) or not conf.aillusion then
    valid.simpletruss()
  end

   signals.before_prompt_processing:disconnect(sk.normal_checktrussf)
end

function valid.proper_truss()
  signals.before_prompt_processing:connect(sk.normal_checktrussf)
end

function valid.disruptingshiver()
  -- if conf.aillusion and not affs.shivering and not affs.unknownany and not affs.unknownmental then return end

  checkaction(dict.shivering.aff, true)
  checkaction(dict.disrupt.aff, true)
  if actions.shivering_aff then
    lifevision.add(actions.shivering_aff.p)
  end
  if actions.disrupt_aff then
    lifevision.add(actions.disrupt_aff.p)
  end
end

function valid.proper_aeon()
#if skills.aeonics then
  tempLineTrigger(1,1,[[
    if getCurrentLine() ~= "Your mind's inner clock resists going out of sync." then
      mm.valid.proper_aeon2()
    end]])
#else
  valid.proper_aeon2()
#end
end

function valid.proper_ablaze()
#if skills.pyromancy then
  tempLineTrigger(1,1,[[
    if getCurrentLine() ~= "The burning fails to take and quickly subsides." then
      mm.valid.simpleablaze()
    end]])
#else
  valid.simpleablaze()
#end
end

function valid.proper_aeon2()
  if defc.quicksilver and not actions.quicksilver_gone then
    defs.lost_quicksilver()
  else
    if not conf.aillusion then
      valid.simpleaeon()
    else
      checkaction(dict.checkslows.aff, true)
      lifevision.add(actions.checkslows_aff.p, nil, "aeon")
    end
  end
end

function valid.maybe_aeon()
  checkaction(dict.checkslows.aff, true)
  lifevision.add(actions.checkslows_aff.p, nil, "aeon")
end

function valid.proper_chill()
  local aff

  if defc.fire and not actions.fire_gone then defs.lost_fire() return end

  if not affs.shivering then aff = "shivering" else aff = "frozen" end

  checkaction(dict[aff].aff, true)
  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

function valid.chilled()
  if defc.fire then defs.lost_fire() end
  valid.simpleshivering()
end

function valid.bashing_chill()
  local aff

  if defc.fire then defs.lost_fire() end

  if not affs.shivering then aff = "shivering" else aff = "frozen" end

  checkaction(dict[aff].aff, true)
  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

function valid.proper_rigomortis()
  valid.simplerigormortis()
  valid["simplecrippled" .. multimatches[2][2]..multimatches[2][3]]()
end

function valid.proper_transfix()
  if not conf.aillusion then
    valid.simpletransfixed()
    checkaction(dict.blind.gone, true)
    lifevision.add(actions.blind_gone.p)
  elseif not affs.blind then
    valid.simpletransfixed()
  end
end

function valid.proper_sap()
  if not conf.aillusion then
    valid.simplesap()
  else
    checkaction(dict.checkslows.aff, true)
    lifevision.add(actions.checkslows_aff.p, nil, "sap")
  end
end

function valid.proper_slitthroat()
  if not conf.aillusion then
    valid.simpleslitthroat()
  else
    checkaction(dict.checkslitthroat.aff, true)
    lifevision.add(actions.checkslitthroat_aff.p)
  end
end

function valid.proper_damagedthroat()
  if not conf.aillusion then
    valid.simpledamagedthroat()
  else
    echo("CHECKING DAMAGED THROAT")
    checkaction(dict.checkdamagedthroat.aff, true)
    lifevision.add(actions.checkdamagedthroat_aff.p)
  end
end

function valid.proper_throatlock()
  -- only TK's can throatlock, and they typically do it in a stun combo - so if we're stunned, then assume yes
  -- to cure out asap instead of checking
  if not conf.aillusion or affs.stun then
    valid.simplethroatlock()
  else
    checkaction(dict.checkthroatlock.aff, true)
    lifevision.add(actions.checkthroatlock_aff.p)
  end
end

function valid.proper_choke()
  if not conf.aillusion then
    valid.simplechoke()
  else
    checkaction(dict.checkslows.aff, true)
    lifevision.add(actions.checkslows_aff.p, nil, "choke")
  end
end

function valid.lost_stance()
  checkaction(dict.dostance.gone, true)
  lifevision.add(actions.dostance_gone.p)
end

function valid.lost_blind()
  defs.lost_trueblind()
  checkaction(dict.blind.gone, true)
  lifevision.add(actions.blind_gone.p)
end

#for _, k in pairs{"legs", "left", "right", "arms", "gut", "chest", "head", "lower", "middle", "upper", "vitals"} do
function valid.stance_$(k)()
  checkaction(dict.dostance.misc)
  if actions.dostance_misc then
    lifevision.add(actions.dostance_misc.p, nil, "$(k)")
  end
end
#end

function valid.parry_limb()
  if sys.blockparry then
    checkaction(dict.doparry.misc, true)
  else
    checkaction(dict.doparry.misc) end
  if actions.doparry_misc then
    local limb = string.gsub(multimatches[2][2], " ", "")
    lifevision.add(actions.doparry_misc.p, nil, limb)
  end
end

function valid.parry_none()
  checkaction(dict.doparry.misc)
  if actions.doparry_misc then
    lifevision.add(actions.doparry_misc.p, "none")
  end
end

vm.aurawarps = {"slightlyaurawarped", "moderatelyaurawarped", "aurawarped", "massivelyaurawarped", "completelyaurawarped"}

vm.next_aurawarp = function()
  for i,v in ipairs(vm.aurawarps) do
    if affs[v] then return vm.aurawarps[i+1] or "completelyaurawarped" end
  end
end

vm.previous_aurawarp = function()
  for i,v in ipairs(vm.aurawarps) do
    if affs[v] then return vm.aurawarps[i-1] or nil end
  end
end

function valid.aurawarp_added()
  local aff = vm.next_aurawarp()

  if not aff then aff = "slightlyaurawarped" end
  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

valid.affmsg_warpedaura = valid.aurawarp_added

vm.timewarps = {"minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"}

vm.next_timewarp = function()
  for i,v in ipairs(vm.timewarps) do
    if affs[v] then return vm.timewarps[i+1] or "massivetimewarp" end
  end
end

vm.previous_timewarp = function()
  for i,v in ipairs(vm.timewarps) do
    if affs[v] then return vm.timewarps[i-1] or nil end
  end
end

function valid.timewarp_balefire()
  local aff = vm.next_timewarp()

  -- balefire adds 1/4th level each time, but one if we don't have any
  if not aff then aff = "minortimewarp"
    elseif math.random(1,4) ~= 1 then return end

  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

valid.timewarp_quarter = valid.timewarp_balefire

function valid.aeonics_timewarp()
  local aff = vm.next_timewarp()

  -- timewarp adds 1/2 level each time, but one if we don't have any
  if not aff then aff = "minortimewarp"
    elseif math.random(1,2) ~= 1 then return end

  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

valid.affmsg_timewarp = valid.aeonics_timewarp

vm.insanities = {"slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity"}

vm.next_insanity = function()
  for i,v in ipairs(vm.insanities) do
    if affs[v] then return vm.insanities[i+1] or "massiveinsanity" end
  end
end

vm.previous_insanity = function()
  for i,v in ipairs(vm.insanities) do
    if affs[v] then return vm.insanities[i-1] or nil end
  end
end

function valid.insanity_added()
  local aff = vm.next_insanity()

  if not aff then aff = "slightinsanity" end
  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

valid.affmsg_insanity = valid.insanity_added

local deathmarks = {"deathmarkone", "deathmarktwo", "deathmarkthree", "deathmarkfour", "deathmarkfive"}

next_deathmark = function()
  for i,v in ipairs(deathmarks) do
    if affs[v] then return deathmarks[i+1] or "deathmarkfive" end
  end
end

previous_deathmark = function()
  for i,v in ipairs(deathmarks) do
    if affs[v] then return deathmarks[i-1] or nil end
  end
end

function valid.deathmark_added()
  local aff = next_deathmark()

  if not aff then aff = "deathmarkone" end
  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

local vessels = {"onevessel", "twovessels", "threevessels", "fourvessels", "fivevessels",
  "sixvessels", "sevenvessels", "eightvessels", "ninevessels", "tenvessels",
  "elevenvessels", "twelvevessels", "thirteenplusvessels"}

next_vessel = function()
  for i,v in ipairs(vessels) do
    if affs[v] then return vessels[i+1] or "thirteenplusvessels" end
  end
end

-- as telek give 1, 2 or 3 vessels randomly
next_random_vessel = function(min, max)
  local r = math.random(min, max)
  for i,v in ipairs(vessels) do
    if affs[v] then return vessels[i+r] or "thirteenplusvessels" end
  end

  -- if we have no current
  return vessels[r]
end

previous_vessel = function()
  for i,v in ipairs(vessels) do
    if affs[v] then return vessels[i-1] or nil end
  end
end

-- add up the vessel count
function valid.proper_vessel()
  local aff = next_vessel()

  if not aff then aff = "onevessel" end
  checkaction(dict[aff].aff, true)

  if actions[aff .. "_aff"] then
    lifevision.add(actions[aff .. "_aff"].p)
  end
end

-- set explicitly
function valid.proper_setvessel()
  local num = tonumber(matches[2])
  if not num then return end

  local aff

  if num >= 13 then aff = "thirteenplusvessels" else aff = vessels[num] end
-- fixme: work for more than 13 (if this ever happens)
  valid["diag_"..aff]()
end

function valid.symp_badluck()
  if affs.badluck then return end
  if not conf.aillusion then
    valid.simplebadluck()
  else
    local r = findbybal("focus")
    if r and r.p.focus.focusmind then
      valid.simplebadluck()
    end
  end
end

function valid.bad_legs()
  if affs.crippledrightleg or affs.crippledleftleg or affs.mangledleftleg or affs.mangledrightleg or affs.missingrightleg or affs.missingleftleg or affs.hemiplegyright or affs.hemiplegyleft then return end

  valid.simpleunknownany()
end

function valid.symp_damagedleftleg()
  valid.simpledamagedleftleg()
end

function valid.symp_damagedrightleg()
  valid.simpledamagedrightleg()
end

function valid.symp_damagedleftarm()
  valid.simpledamagedleftarm()
end

function valid.symp_damagedrightarm()
  valid.simpledamagedrightarm()
end

function valid.symp_crushedwindpipe()
  if affs.crushedwindpipe then return end
  if not conf.aillusion then
    valid.simplecrushedwindpipe()
    local r = findbybals({"sip", "purgative", "allheale", "herb", "sparkle"})
    if r and not (table.size(r) == 1 and select(2, next(r)).smokecure) then
      killaction(dict[r.action_name][r.balance])
      return
    end

    -- nothing in the balances above? Check for teas
    r = checkany(dict.whitetea.misc, dict.oolongtea.misc, dict.greentea.misc, dict.blacktea.misc)
    if r then
      killaction(dict[r.action_name][r.balance])
      return
    end

  else
    local r = findbybals({"sip", "purgative", "allheale", "herb", "sparkle"})
    if actions.quicksilver_misc then r = true end
    if r then
      valid.simplecrushedwindpipe()
    end

    if r and type(r) == "table" and not (table.size(r) == 1 and select(2, next(r)).smokecure) then
      killaction(dict[r.action_name][r.balance])
    end

    if r then return end

    -- nothing in the balances above? Check for teas
    r = checkany(dict.whitetea.misc, dict.oolongtea.misc, dict.greentea.misc, dict.blacktea.misc)
    if r then
      valid.simplecrushedwindpipe()
      killaction(dict[r.action_name][r.balance])
      return
    end
  end
end

function valid.symp_paralysis()
  if not affs.severedspine then
    valid.simpleparalysis()
  end
  if actions.checkparalysis_misc then
    killaction(dict.paralysis.misc)
  end
end

function valid.checkparalysis_paralysis()
  if actions.checkparalysis_misc then
    lifevision.add(actions.checkparalysis_misc.p, "paralyzed")
  end
  disableTrigger("m&m check paralysis")
end

function valid.checkparalysis_tangled()
  if actions.checkparalysis_misc then
    lifevision.add(actions.checkparalysis_misc.p, "onclear")
    valid.simpletangle()
  end
  disableTrigger("m&m check paralysis")
end

function valid.checkparalysis_noballs()
  if actions.checkparalysis_misc then
    lifevision.add(actions.checkparalysis_misc.p, "onclear")
  end
  disableTrigger("m&m check paralysis")
end

function valid.checkparalysis_impale()
  if actions.checkparalysis_misc then
    lifevision.add(actions.checkparalysis_misc.p, "onclear")
  end
  disableTrigger("m&m check paralysis")
end



function valid.symp_shatteredankle()
  if not conf.aillusion or doingaction "prone" then
    valid["simpleshattered"..multimatches[2][2].."ankle"]()

    if actions.prone_misc then
      killaction(dict.prone.misc)
    end
  end
end

function valid.symp_slitthroat()
  if affs.slitthroat then return end
  if not conf.aillusion then
    valid.simpleslitthroat()
  else
    -- failed for aeon_purgative!
    local r = findbybals({"sip", "purgative", "allheale", "herb", "sparkle"})
    if r and not (table.size(r) == 1 and select(2, next(r)).smokecure) then
      valid.simpleslitthroat()
    end
  end
end

function valid.symp_crucified()
  if not conf.aillusion then
    if not affs.crucified then valid.simplecrucified() end
    valid.simpleunknowncrippledleg()
  elseif affs.crucified then
    valid.simpleunknowncrippledleg()
  end
end

function valid.earache_woreoff()
  checkaction(dict.earache.waitingfor, true)
  if actions.earache_waitingfor then
    lifevision.add(actions.earache_waitingfor.p)
  end
end

function valid.illuminated_woreoff()
  checkaction(dict.illuminated.focus, true)
  if actions.illuminated_focus then
    lifevision.add(actions.illuminated_focus.p, "woreoff")
  end
end

#for _, aff in ipairs({"darkseed", "enfeeble", "timeechoes", "oracle", "succumb", "phantom", "bedevil", "avengingangel", "puncturedaura", "mildallergy", "darkfate", "sightstealer", "illusorywounds", "anesthesia","bentaura"}) do
function valid.$(aff)_woreoff()
  checkaction(dict.$(aff).waitingfor, true)
  if actions.$(aff)_waitingfor then
    lifevision.add(actions.$(aff)_waitingfor.p)
  end
end
#end

function valid.attraction_woreoff()
  checkaction(dict.attraction.wafer, true)
  lifevision.add(actions.attraction_wafer.p, "woreoff")
end

function valid.choke_woreoff()
  checkaction(dict.choke.waitingfor, true)
  if actions.choke_waitingfor then
    lifevision.add(actions.choke_waitingfor.p)
  end
end

function valid.hypnoticpattern_woreoff()
  checkaction(dict.hypnoticpattern.waitingfor)
  if actions.hypnoticpattern_waitingfor then
    lifevision.add(actions.hypnoticpattern_waitingfor.p)
  end
end

function valid.scarab_woreoff()
  checkaction(dict.scarab.waitingfor)
  if actions.scarab_waitingfor then
    lifevision.add(actions.scarab_waitingfor.p)
  end
end

function valid.echoes_woreoff()
  checkaction(dict.echoes.waitingfor)
  if actions.echoes_waitingfor then
    lifevision.add(actions.echoes_waitingfor.p)
  end
end

function valid.stun_woreoff()
  checkaction(dict.stun.waitingfor)
  if actions.stun_waitingfor then
    lifevision.add(actions.stun_waitingfor.p)
  end
end

function valid.dreamer_woreoff()
  checkaction(dict.dreamer.waitingfor)
  if actions.dreamer_waitingfor then
    lifevision.add(actions.dreamer_waitingfor.p)
  end
end

function valid.afterimage_woreoff()
  checkaction(dict.afterimage.waitingfor)
  if actions.afterimage_waitingfor then
    lifevision.add(actions.afterimage_waitingfor.p)
  end
end

function valid.badluck_woreoff()
  checkaction(dict.badluck.waitingfor)
  if actions.badluck_waitingfor then
    lifevision.add(actions.badluck_waitingfor.p)
  end
end

function valid.inquisition_woreoff()
  checkaction(dict.inquisition.waitingfor)
  if actions.inquisition_waitingfor then
    lifevision.add(actions.inquisition_waitingfor.p)
  end
end

function valid.rainbowpattern_woreoff()
  checkaction(dict.rainbowpattern.waitingfor)
  if actions.rainbowpattern_waitingfor then
    lifevision.add(actions.rainbowpattern_waitingfor.p)
  end
end

function valid.aeon_woreoff()
  local result = checkany(dict.aeon.purgative, dict.aeon.herb, dict.aeon.steam, dict.aeon.physical)

  if not result then
    checkaction(dict.aeon.gone, true)
    lifevision.add(actions.aeon_gone.p)
  else
    sip_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.adrenaline_cured_aeon()
  checkaction(dict.aeon.physical, true)
  if actions.aeon_physical then 
    lifevision.add(actions.aeon_physical.p)
  end
end

function valid.adrenaline_already()
  checkaction(dict.quicksilver.physical, true)
  if actions.quicksilver_physical then
    lifevision.add(actions.quicksilver_physical.p, "oncompleted", true)
  end

  checkaction(dict.aeon.physical, true)
  if actions.aeon_physical then
    lifevision.add(actions.aeon_physical.p, "already")
  end
end

function valid.adrenaline_quicksilver()
  checkaction(dict.quicksilver.physical, true)
  if actions.quicksilver_physical then
    lifevision.add(actions.quicksilver_physical.p)
    return
  end

  checkaction(dict.aeon.physical, true)
  if actions.aeon_physical then
    lifevision.add(actions.aeon_physical.p, "quicksilver")
    return
  end
end

function valid.wake_start()
  checkaction(dict.sleep.misc)
  if actions.sleep_misc then
    lifevision.add(actions.sleep_misc.p)
  end
end

function valid.climb_start()
  checkaction(dict.pitted.physical)
  if actions.pitted_physical then
    lifevision.add(actions.pitted_physical.p)
  end
end

function valid.not_pitted()
  checkaction(dict.pitted.physical)
  if actions.pitted_physical then
    lifevision.add(actions.pitted_physical.p, "notpitted")
  end
end

function valid.sipped_quicksilver()
  checkaction(dict.quicksilver.misc)
  if actions.quicksilver_misc then
    lifevision.add(actions.quicksilver_misc.p)
  end
end

function valid.wake_done()
  checkaction(dict.curingsleep.waitingfor, true)
  lifevision.add(actions.curingsleep_waitingfor.p)

  if actions.sleep_misc then
    killaction(dict.sleep.misc)
  end
end

function defs.read_protection()
  if actions.protection_physical then
    lifevision.add(actions.protection_physical.p)
  end
end

function defs.got_protection()
  checkaction(dict.waitingforprotection.waitingfor)
  if actions.waitingforprotection_waitingfor then
    lifevision.add(actions.waitingforprotection_waitingfor.p)
  end
end

function defs.sipped_unholywater()
  if not dict.unholywater then return end
  checkaction(dict.unholywater.misc)
  if actions.unholywater_misc then
    lifevision.add(actions.unholywater_misc.p)
    sip_cure = true
  end
end

function defs.got_unholywater()
  if not dict.waitingforunholywater then return end
  checkaction(dict.waitingforunholywater.waitingfor)
  if actions.waitingforunholywater_waitingfor then
    lifevision.add(actions.waitingforunholywater_waitingfor.p)
  end
end

function defs.sipped_moonwater()
  if not dict.moonwater then return end
  checkaction(dict.moonwater.misc)
  if actions.moonwater_misc then
    lifevision.add(actions.moonwater_misc.p)
    sip_cure = true
  end
end

function defs.got_moonwater()
  if not dict.waitingformoonwater then return end
  checkaction(dict.waitingformoonwater.waitingfor)
  if actions.waitingformoonwater_waitingfor then
    lifevision.add(actions.waitingformoonwater_waitingfor.p)
  end
end

function defs.sipped_firemead()
  if not dict.firemead then return end
  checkaction(dict.firemead.misc)
  if actions.firemead_misc then
    lifevision.add(actions.firemead_misc.p)
    sip_cure = true
  end
end

function defs.got_firemead()
  if not dict.waitingforfiremead then return end
  checkaction(dict.waitingforfiremead.waitingfor)
  if actions.waitingforfiremead_waitingfor then
    lifevision.add(actions.waitingforfiremead_waitingfor.p)
  end
end

function defs.sipped_cloudberry()
  if not dict.cloudberry then return end
  checkaction(dict.cloudberry.misc)
  if actions.cloudberry_misc then
    lifevision.add(actions.cloudberry_misc.p)
    sip_cure = true
  end
end

function defs.got_cloudberry()
  if not dict.waitingforcloudberry then return end
  checkaction(dict.waitingforcloudberry.waitingfor)
  if actions.waitingforcloudberry_waitingfor then
    lifevision.add(actions.waitingforcloudberry_waitingfor.p)
  end
end

function defs.sipped_holywater()
  if not dict.holywater then return end
  checkaction(dict.holywater.misc)
  if actions.holywater_misc then
    lifevision.add(actions.holywater_misc.p)
    sip_cure = true
  end
end

function defs.got_holywater()
  if not dict.waitingforholywater then return end
  checkaction(dict.waitingforholywater.waitingfor)
  if actions.waitingforholywater_waitingfor then
    lifevision.add(actions.waitingforholywater_waitingfor.p)
  end
end

function defs.sipped_nightsweats()
  if not dict.nightsweats then return end
  checkaction(dict.nightsweats.misc)
  if actions.nightsweats_misc then
    lifevision.add(actions.nightsweats_misc.p)
    sip_cure = true
  end
end

function defs.got_nightsweats()
  if not dict.waitingfornightsweats then return end
  checkaction(dict.waitingfornightsweats.waitingfor)
  if actions.waitingfornightsweats_waitingfor then
    lifevision.add(actions.waitingfornightsweats_waitingfor.p)
  end
end

function defs.got_quicksilver()
  checkaction(dict.curingquicksilver.waitingfor)
  if actions.curingquicksilver_waitingfor then
    lifevision.add(actions.curingquicksilver_waitingfor.p)
  end
end

function defs.got_adrenaline()
#if skills.athletics then
  checkaction(dict.adrenaline.physical)
  if actions.adrenaline_physical then
    lifevision.add(actions.adrenaline_physical.p)
  end
#end
end

function valid.cured_illusorywounds()
  checkaction(dict.illusorywounds.waitingfor)
  if actions.illusorywounds_waitingfor then
    lifevision.add(actions.illusorywounds_waitingfor.p)
  end
end

function valid.cured_sightstealer()
  checkaction(dict.sightstealer.waitingfor) -- this can be dispelt
  if actions.sightstealer_waitingfor then
    lifevision.add(actions.sightstealer_waitingfor.p)
  end
end

function valid.symp_dizziness()
  if not conf.aillusion then
    valid.simpledizziness()
    valid.proper_prone()
  elseif affs.dizziness then
    valid.simpledizziness()
    valid.proper_prone()
  end
end

function valid.cured_thoughtstealer()
  checkaction(dict.thoughtstealer.waitingfor) -- this can be dispelt
  if actions.thoughtstealer_waitingfor then
    lifevision.add(actions.thoughtstealer_waitingfor.p)
  end
end

function valid.cured_stars()
  checkaction(dict.stars.waitingfor) -- this can be dispelt
  if actions.stars_waitingfor then
    lifevision.add(actions.stars_waitingfor.p)
  end
end

function valid.cured_fear()
  checkaction(dict.fear.misc)
  if actions.fear_misc then
    lifevision.add(actions.fear_misc.p)
  end
end

function valid.stoodup()
  checkaction(dict.prone.misc)
  if actions.prone_misc then
    lifevision.add(actions.prone_misc.p)
  end
end

function valid.sippedmana()
  checkaction(dict.healmana.sip)
  if actions.healmana_sip then
    sip_cure = true
    lifevision.add(actions.healmana_sip.p)
  end
end

function valid.sippedbromide()
  checkaction(dict.healego.sip)
  if actions.healego_sip then
    sip_cure = true
    lifevision.add(actions.healego_sip.p)
  end
end

#for _, balance in ipairs{"herb", "scroll", "sparkle", "focus", "allheale", "tea", "sip", "salve", "purgative", "lucidity", "steam", "wafer", "ice"} do
  function valid.got$(balance)()
    checkaction(dict.gotbalance.happened, true)
    dict.gotbalance.tempmap[#dict.gotbalance.tempmap+1] = "$(balance)" -- hack to allow multiple balances at once
    lifevision.add(actions.gotbalance_happened.p)
  end
#end

function valid.got_rebounding()
  checkaction(dict.waitingonrebounding.waitingfor)
  if actions.waitingonrebounding_waitingfor then
    lifevision.add(actions.waitingonrebounding_waitingfor.p)
  end
end

function valid.got_crotamine()
  addaff(dict.crotamine)
end

function valid.bled()
  local amount = tonumber(multimatches[2][2])
  if not (amount >= conf.bleedamount) then return end

  checkaction(dict.bleeding.aff, true)
  if actions.bleeding_aff then
    lifevision.add(actions.bleeding_aff.p, nil, amount)
  end
end

function valid.clot1()
  checkaction(dict.bleeding.misc)
  if actions.bleeding_misc then
    lifevision.add(actions.bleeding_misc.p)
  end


  checkaction(dict.bruising.misc)
  if actions.bruising_misc then
    lifevision.add(actions.bruising_misc.p)
  end

  if conf.gagclot and not sys.sync then deleteLineP() end
end

function valid.symp_haemophilia()
  checkaction(dict.bleeding.misc)
  if actions.bleeding_misc then
    killaction(dict.bleeding.misc)
    valid.simplehaemophilia()
  end
end


function valid.symp_slicedforehead()
  if not conf.aillusion then
    valid.simpleslicedforehead()
    valid.simpleblind()
  elseif affs.slicedforehead then
    valid.simpleblind()
  end
end

function valid.symp_sunallergy()
  valid.simplesunallergy()
end

function valid.symp_relapsing()
  valid.simplerelapsing()
end

function valid.symp_heretic()
--  if conf.aillusion and not affs.heretic then return end

  if not affs.heretic then valid.simpleheretic() end
  valid.simpleunknownany()
end

function valid.symp_infidel()
  if not affs.infidel then valid.simpleinfidel() end
  valid.simpleunknownany()
end

function valid.tarot_speedstripped()
  defs.lost_quicksilver()
end

function valid.symp_truss()
  if not affs.truss then
    valid.simpletruss()
  end
end

function valid.tarot_aeon()
  if conf.aillusion and defc.quicksilver then return end

  defs.lost_quicksilver()
  if not conf.aillusion then
    valid.simpleaeon()
  else
    checkaction(dict.checkslows.aff, true)
    lifevision.add(actions.checkslows_aff.p, nil, "aeon")
  end
end

function valid.symp_mucous()
  if not conf.aillusion then
    valid.proper_prone()
    valid.simplemucous()
  elseif affs.mucous then
    valid.proper_prone()
  end
end

function valid.proper_inquisition()
  if conf.aillusion and not affs.infidel then return end
  valid.simpleinfidel()
  valid.simpleinquisition()
end

function valid.symp_throatlock()
  if conf.aillusion then
    local eating = findbybals({"herb", "sip", "sparkle", "purgative"})
    if not eating and not actions.quicksilver_misc then
      return
    end
  end

  valid.simplethroatlock()
  if actions.quicksilver_misc then killaction(dict.quicksilver.misc) end
end

-- use charges that built up over time / reduce

function valid.nothing_to_sip()
  local drinking
  drinking = findbybal("purgative")
  if not drinking then
    drinking = findbybal("sip")
    if not drinking then
      return
    else
      sk.got_nothing_to_sip(drinking)
    end
  end

  sk.got_nothing_to_sip(drinking)
end

function valid.missing_herb()
  if not sys.sync then return end

  local r = findbybals{"herb", "wafer"}
  r = select(2, next(r))
  if r and r.eatcure then
    rift.invcontents[r.eatcure] = 0
    killaction(dict[r.action_name][r.balance])
  end
end

-- a function to stop any light* actions and put all current non-artefact pipes on ignore
function missing_tinderbox()
  -- find which pipes were we lighting and kill those actions. We we were lighting at least one, figure out which pipes are non-arty, get a list, put them on ignore and say which ones we've added to ignore now

  local gotaction
  if actions.lightvalerian_physical then
    killaction(dict.lightvalerian.physical); gotaction = true
  end
  if actions.lightelm_physical then
    killaction(dict.lightelm.physical); gotaction = true
  end
  if actions.lightskullcap_physical then
    killaction(dict.lightskullcap.physical); gotaction = true
  end

  -- if we weren't lighting - then... this might not be real!
  if not gotaction then return end

  -- find out which pipes are not artefact & ignore
  local realthing, assumedname = {}, {}
  for id = 1, #pipes.pnames do
    local herb, pipe = pipes.pnames[id], pipes[pipes.pnames[id]]
    if not pipe.arty and not ignore["light"..herb] then
      realthing[#realthing+1] = "light"..herb
      assumedname[#assumedname+1] = pipe.filledwith
      setignore("light"..herb, { because = "you were missing a tinderbox" })
    end
  end

  if realthing[1] then
    echo"\n" echof("Looks like you don't have a tinderbox! I've put non-artefact pipes - %s on the ignore list (under the names of %s). To unignore them, check vshow ignore.", concatand(assumedname), concatand(realthing))
  end
end

function valid.symp_anorexia()
  local doingthings = findbybals({"sip", "purgative", "allheale", "herb", "sparkle", "lucidity","wafer"})

  if conf.aillusion and not (doingthings or actions.quicksilver_misc) then return end

  valid.simpleanorexia()
  if actions.quicksilver_misc then killaction(dict.quicksilver.misc) end
#if DEBUG then
  if doingthings and not (doingthings.action_name or doingthings.balance) then
    debugf("doingthings %s", pl.pretty.write(doingthings))
  end
#end

  if doingthings then
    for _, action in pairs(doingthings) do
      killaction(dict[action.action_name][action.balance])
    end
  end
end

function valid.symp_crushedwindpipe_smoke()
  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  if r then
    killaction(dict[r.action_name][r.balance])
    valid.simplecrushedwindpipe()
  end
end

function valid.clot2()
  checkaction(dict.bleeding.misc)
  if actions.bleeding_misc then
    lifevision.add(actions.bleeding_misc.p, "oncured")
  end


  checkaction(dict.bruising.misc)
  if actions.bruising_misc then
    lifevision.add(actions.bruising_misc.p, "oncured")
  end

  if conf.gagclot and not sys.sync then deleteLine() end
end

function valid.failed_teasip()
  local result = checkany(dict.whitetea.misc, dict.oolongtea.misc, dict.greentea.misc, dict.blacktea.misc)

  if not result then return end

  sip_cure = true
  lifevision.add(actions[result.name].p, "fail")
end

function valid.sip_nocure_antidote()
  local result = checkany(dict.powersap.purgative, dict.crotamine.purgative)

  if not result then return end

  sip_cure = true
  lifevision.add(actions[result.name].p, "empty")
end

function valid.salve_cured_pox()
  local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve, dict.firstdegreeburn.salve, dict.seconddegreeburn.salve, dict.thirddegreeburn.salve, dict.fourthdegreeburn.salve)

  if not result then return end

  apply_cure = true
  if result.name == "pox_salve" then
    lifevision.add(actions.pox_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.pox.salve, true)
    lifevision.add(dict.pox.salve)
  end
end

function valid.salve_cured_scabies()
  local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve, dict.firstdegreeburn.salve, dict.seconddegreeburn.salve, dict.thirddegreeburn.salve, dict.fourthdegreeburn.salve)

  if not result then return end

  apply_cure = true
  if result.name == "scabies_salve" then
    lifevision.add(actions.scabies_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.scabies.salve, true)
    lifevision.add(dict.scabies.salve)
  end
end

function valid.force_aeon()
  dict.aeon.aff.oncompleted ()
  make_gnomes_work()
end

function valid.salve_cured_sunallergy()
  local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve, dict.firstdegreeburn.salve, dict.seconddegreeburn.salve, dict.thirddegreeburn.salve, dict.fourthdegreeburn.salve)

  if not result then return end

  apply_cure = true
  if result.name == "sunallergy_salve" then
    lifevision.add(actions.sunallergy_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.sunallergy.salve, true)
    lifevision.add(dict.sunallergy.salve)
  end
end

function valid.salve_cured_firstdegreeburn()
  checkaction(dict.firstdegreeburn.salve)
  if actions.firstdegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.firstdegreeburn_salve.p)
  else
    local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve)
    if not result then return end
    apply_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.salve_still_firstdegreeburn()
  if actions.firstdegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.firstdegreeburn_salve.p, "stillgot")
  elseif actions.seconddegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.seconddegreeburn_salve.p)
  else
    local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve)
    if not result then return end
    apply_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.salve_still_seconddegreeburn()
  if actions.seconddegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.seconddegreeburn_salve.p, "stillgot")
  elseif actions.thirddegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.thirddegreeburn_salve.p)
  else
    local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve)
    if not result then return end
    apply_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.salve_still_thirddegreeburn()
  if actions.thirddegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.thirddegreeburn_salve.p, "stillgot")
  elseif actions.fourthdegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.fourthdegreeburn_salve.p)
  else
    local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve)
    if not result then return end
    apply_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.salve_still_fourthdegreeburn()
  if actions.fourthdegreeburn_salve then
    apply_cure = true
    lifevision.add(actions.fourthdegreeburn_salve.p, "stillgot")
  else
    local result = checkany(dict.pox.salve, dict.scabies.salve, dict.sunallergy.salve)
    if not result then return end
    apply_cure = true
    lifevision.add(actions[result.name].p)
  end
end

function valid.ice_cured_ablaze()
  local result = checkany(dict.ablaze.ice, dict.firstdegreeburn.ice, dict.seconddegreeburn.ice, dict.thirddegreeburn.ice, dict.fourthdegreeburn.ice)
  if not result then return end

  apply_ice = true
  lifevision.add(actions.ablaze_ice.p)
end

function valid.ice_cured_firstdegreeburn()
  if actions.firstdegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.firstdegreeburn_ice.p)
  end
end

function valid.ice_still_firstdegreeburn()
  if actions.firstdegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.firstdegreeburn_ice.p, "stillgot")
  elseif actions.seconddegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.seconddegreeburn_ice.p)
  end
end

function valid.ice_still_seconddegreeburn()
  if actions.seconddegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.seconddegreeburn_ice.p, "stillgot")
  elseif actions.thirddegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.thirddegreeburn_ice.p)
  end
end

function valid.ice_still_thirddegreeburn()
  if actions.thirddegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.thirddegreeburn_ice.p, "stillgot")
  elseif actions.fourthdegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.fourthdegreeburn_ice.p)
  end
end

function valid.ice_still_fourthdegreeburn()
  if actions.fourthdegreeburn_ice then
    apply_ice = true
    lifevision.add(actions.fourthdegreeburn_ice.p, "stillgot")
  end
end

function valid.steam_still_massivetimewarp()
  local result = checkany(dict.achromaticaura.steam, dict.aeon.steam, dict.disloyalty.steam, dict.healthleech.steam, dict.luminosity.steam, dict.manabarbs.steam, dict.pacifism.steam, dict.egovice.steam, dict.slickness.steam, dict.powerspikes.steam, dict.massivetimewarp.steam, dict.majortimewarp.steam, dict.moderatetimewarp.steam, dict.minortimewarp.steam, dict.slightlyaurawarped.steam, dict.moderatelyaurawarped.steam, dict.aurawarped.steam, dict.massivelyaurawarped.steam, dict.completelyaurawarped.steam)

    if not result then return end

    lifevision.add(actions.massivetimewarp.p, "stillgot")
end

function valid.steam_still_completelyaurawarped()
  local result = checkany(dict.achromaticaura.steam, dict.aeon.steam, dict.disloyalty.steam, dict.healthleech.steam, dict.luminosity.steam, dict.manabarbs.steam, dict.pacifism.steam, dict.egovice.steam, dict.slickness.steam, dict.powerspikes.steam, dict.massivetimewarp.steam, dict.majortimewarp.steam, dict.moderatetimewarp.steam, dict.minortimewarp.steam, dict.slightlyaurawarped.steam, dict.moderatelyaurawarped.steam, dict.aurawarped.steam, dict.massivelyaurawarped.steam, dict.completelyaurawarped.steam)

    if not result then return end

    lifevision.add(actions.completelyaurawarped.p, "stillgot")
end

#for _, item in ipairs{"faeleaf", "myrtle", "coltsfoot", "steam"} do
function valid.fill$(item)()
  checkaction(dict.fill$(item).physical)
  if actions.fill$(item)_physical then
    lifevision.add(actions.fill$(item)_physical.p)
  end
end

#end

function valid.alreadyfull()
  local result = checkany(dict.fillfaeleaf.physical, dict.fillmyrtle.physical, dict.fillcoltsfoot.physical, dict.fillsteam.physical)

  if not result then return end

  lifevision.add(actions[result.name].p)
end

function valid.litpipe()
  if conf.gagrelight then deleteLineP() end

  local result = checkany(
    dict.lightmyrtle.physical, dict.lightfaeleaf.physical, dict.lightcoltsfoot.physical, dict.lightsteam.physical)

  if not result then return end
  lifevision.add(actions[result.name].p)
end

function valid.litallpipes()
  if not sys.sync and conf.gagrelight then deleteLineP() end

  checkaction(dict.lightpipes.physical)
  if actions.lightpipes_physical then
    lifevision.add(actions.lightpipes_physical.p)
  end
end

local function isFocusLine(line)
  local t = {
    "You have no beast here.",
    "A nimbus of light surrounds",
    "You focus on curing",
    "You call upon your aetheric power to focus on curing",
    "You are not afflicted with",
  }

  for _,str in ipairs(t) do
    if string.starts(line, str) then
      return true
    end
  end
  return false
end


herb_cure = false

function valid.ate1()
  if paragraph_length == 1 then
    herb_cure = false
  end

  -- see if we need to enable arena mode for some reason
  if conf.autoarena then
    local t = sk.arena_areas
    local area = atcp.RoomArea or (gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.area)
    if area and t[area] and not conf.arena then
      conf.arena = true
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're actually in the arena - enabled arena mode.\n") showprompt()
      end)
    elseif area and not t[area] and conf.arena then
      conf.arena = false
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're not actually in the arena - disabled arena mode.\n") showprompt()
      end)
    end
  end
end

function valid.ate2()
  if not isPrompt() then
    setTriggerStayOpen("Ate", 1)
    return
  end
  --account for new focus line
  --[[if isFocusLine(line) then
    setTriggerStayOpen("Ate", 1)
    return
  end]]

  if not herb_cure then
    if find_until_last_paragraph("You eat a wafer of purity dust.") and findbybal("wafer") then
      lifevision.add(actions[findbybal("wafer").name].p, "empty")
    else
      local eating = findbybal("herb")
      if eating then
        lifevision.add(actions[eating.name].p, "empty", "eaten")
      else
        eating = findbybal("sparkle")
        if eating then lifevision.add(actions[eating.name].p, "all") end
      end
    end
  end

  herb_cure = false
end

local sip_cure = false
local multiple_sip_lines = false

function valid.sip1()
  local has_sip = pl.tablex.find_if(lifevision.l._keys, function(what) return what:find("_sip", 1, true) end) and true or false

  -- don't re-set it in the same 'sipping'. sip1 can go off multiple times now
  if not has_sip and not multiple_sip_lines then
    sip_cure = false
  end
end

function valid.sip2()
  --account for any line that until the prompt
  if not isPrompt() then
    multiple_sip_lines = true
    setTriggerStayOpen("Sip", 1)
    return
  end
  --[[if isFocusLine(line) then
    setTriggerStayOpen("Sip", 1)
    return
  end

  if insanitycheck and isPrompt() then return end]]
  multiple_sip_lines = false
  if sip_cure then 
    sip_cure = false
    return
  end

  if find_until_last_paragraph("lucidity slush", true) and findbybal("lucidity") then
    lifevision.add(actions[findbybal("lucidity").name].p, "empty")
  else
    local sipping = findbybal("purgative")

    if sipping then
      lifevision.add(actions[sipping.name].p, "empty")
    else

      -- special case for quicksilver, and love, which is a sip but balanceless
      if doingaction"lovedef" then
        lifevision.add(actions.lovedef_misc.p, "empty")
      else
        local result = checkany(dict.healhealth.sip, dict.onevessel.sip, dict.twovessels.sip, dict.threevessels.sip, dict.fourvessels.sip, dict.fivevessels.sip, dict.sixvessels.sip,dict.sevenvessels.sip, dict.eightvessels.sip, dict.ninevessels.sip, dict.tenvessels.sip, dict.elevenvessels.sip, dict.twelvevessels.sip, dict.thirteenplusvessels.sip)

        if not result then return end

        if actions[result.name] then
          lifevision.add(actions[result.name].p, "all")
        end
      end
    end
  end
end

local allheale_cure = false

function valid.allheale1()
  sip_cure = true
  allheale_cure = false
end

function valid.allheale2()
  disableTrigger("Allheale cures")

  if not allheale_cure then
    local sipping = findbybal("allheale")

    if not sipping then return end

    lifevision.add(actions[sipping.name].p, "empty")
  end
  allheale_cure = false
end

arnica_cure = false

function valid.arnica1()
  arnica_cure = false

  -- see if we need to enable arena mode for some reason
  if conf.autoarena then
    local t = sk.arena_areas
    local area = atcp.RoomArea or (gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.area)
    if area and t[area] and not conf.arena then
      conf.arena = true
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're actually in the arena - enabled arena mode.\n") showprompt()
      end)
    elseif area and not t[area] and conf.arena then
      conf.arena = false
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're not actually in the arena - disabled arena mode.\n") showprompt()
      end)
    end
  end
end

function valid.arnica2()
  if not arnica_cure then
  local eating = findbybal("herb")
  if not eating then return end

    lifevision.add(actions[eating.name].p, "empty")
  end

  arnica_cure = false
end

apply_cure = false

function valid.apply1()
  apply_cure = false
end

function valid.apply2()
  if not apply_cure then
  local r = findbybal("salve")
  if not r then return end

    lifevision.add(actions[r.name].p, "empty")
  end

  apply_cure = false
end

apply_ice = false

function valid.applyice1()
  if ice_gmcp then
    ice_gmcp = nil
  else
    apply_ice = false
  end
end

function valid.applyice2()
  if string.find(line, "curing your afflictions") then
    return
  end

  if not apply_ice then
    local r = findbybal("ice")
    if not r then return end

    lifevision.add(actions[r.name].p, "empty")
  end

  apply_ice = false
end

smoke_cure = false
multiple_smoke_lines = false

function valid.smoke1()
  if not multiple_smoke_lines then
    smoke_cure = false
  end

  -- see if we need to enable arena mode for some reason
  if conf.autoarena then
    local t = sk.arena_areas
    local area = atcp.RoomArea or (gmcp.Room and gmcp.Room.Info and gmcp.Room.Info.area)
    if area and t[area] and not conf.arena then
      conf.arena = true
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're actually in the arena - enabled arena mode.\n") showprompt()
      end)
    elseif area and not t[area] and conf.arena then
      conf.arena = false
      raiseEvent("m&m config changed", "arena")
      prompttrigger("arena echo", function()
        echo'\n'echof("Looks like you're not actually in the arena - disabled arena mode.\n") showprompt()
      end)
    end
  end
end


function valid.smoke2()
  -- prevent extra lines from setting off empty cures
  if not isPrompt() then
    multiple_smoke_lines = true
    setTriggerStayOpen("Smoke", 1)
    return
  end
  multiple_smoke_lines = false
  --account for new focus line
  --[[if isFocusLine(line) or line == "A strange vibration prevents you from healing auric ailments."
   then
    setTriggerStayOpen("Smoke", 1)
    return
  end

  if timewarpcheck and isPrompt() then
    timewarpcheck = nil
    return
  end]]
  if smoke_cure then
    smoke_cure = false
    return
  end
  if not smoke_cure then
    if actions.rebounding_misc then -- smoked rebounding?  No special line comes from it
      lifevision.add(actions.rebounding_misc.p)
      return
    end

    local r = findbybals{"steam", "herb"}
    if not r then 
      return 
    end
    -- take in the first action, as it is most likely to be the steam smoke one with overhaul
    lifevision.add(actions[select(2, next(r)).name].p, "empty", "smoked")
  end
end

function valid.pipe_ran_out()
  -- check rebounding
  if actions.rebounding_misc then
    pipes[dict.rebounding.misc.smokecure].puffs = 0
    if not pipes[dict.rebounding.misc.smokecure].arty then
      pipes[dict.rebounding.misc.smokecure].lit = false
    end
    smoke_cure = true
    return
  end

  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  -- take in the first action, as it is most likely to be the steam smoke one with overhaul
  if not r or (r.balance == "herb" and not dict[r.action_name].herb.smokecure) then return end
  pipes[dict[r.action_name][r.balance].smokecure].puffs = 0
  if not pipes[dict[r.action_name][r.balance].smokecure].arty then
    pipes[dict[r.action_name][r.balance].smokecure].lit = false
  end
  smoke_cure = true
end

focusmind_cure = false

function valid.focusmind1()
  focusmind_cure = false
end

function valid.focusmind2()
  if not focusmind_cure then
  local r = findbybal("focus")
  if not r then return end

  lifevision.add(actions[r.name].p, "empty")
  end

  focusmind_cure = false
end

focusspirit_cure = false

function valid.focusspirit1()
  focusspirit_cure = false
end

function valid.focusspirit2()
  if not focusspirit_cure then
    local r = findbybal("focus")
    if not r then return end

    lifevision.add(actions[r.name].p, "empty")
  end

  focusspirit_cure = false
end

function valid.salve_had_no_effect()
  if actions.checkslickness_misc then
    lifevision.add(actions.checkslickness_misc.p, "onclear")
  end

  local r = findbybal("salve")
  if not r then return end

  apply_cure = true
  lifevision.add(actions[r.name].p, "noeffect")
end

function valid.no_allheale_bal()
  local sipping = findbybal("allheale")
  if not sipping then return end

  bals.allheale = false
  killaction(dict[sipping.action_name].allheale)
end

function valid.plant_had_no_effect()
  local r = findbybal("herb")
  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "noeffect")
end

function valid.wafer_had_no_effect()
  local r = findbybal("wafer")
  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "noeffect")
end

function valid.salve_slickness()
  if actions.checkslickness_misc then
    lifevision.add(actions.checkslickness_misc.p, "slicky")
  end

  local r = findbybal("salve")
  if not r then return end

  apply_cure = true
  valid.simpleslickness()
  killaction(dict[r.action_name].salve)
end

function valid.potion_slickness()
  local r = findbybal("salve")
  if r then
    apply_cure = true
    valid.simpleslickness()
    killaction(dict[r.action_name].salve)
  elseif findbybal("sip") then
    local r = findbybal("sip") -- applying for wounds
    valid.simpleslickness()
    killaction(dict[r.action_name].sip)
  end
end

function valid.ice_slickness()
  local r = findbybal("ice")
  if r then
    apply_ice = true
    valid.simpleslickness()
    killaction(dict[r.action_name].ice)
  end
end

function valid.arnica_slickness()
  if actions.checkslickness_misc then
    lifevision.add(actions.checkslickness_misc.p, "slicky")
  end

  local r = findbybal("herb")
  if not r then return end

  arnica_cure = true
  valid.simpleslickness()
  killaction(dict[r.action_name].herb)
end

function valid.smoke_blacklung()
  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  if r then
    killaction(dict[r.action_name][r.balance])
    valid.simpleblackung()
  end
end

function valid.sip_had_no_effect()
  if findbybal("sip") then
    sip_cure = true
    lifevision.add(actions[findbybal("sip").name].p, "noeffect")
  elseif findbybal("purgative") then
    sip_cure = true
    lifevision.add(actions[findbybal("purgative").name].p, "noeffect")
  elseif doingaction("lovedef") then
    killaction("lovedef")
  end
end

function valid.removed_from_rift(...)
  -- we're only interested in this while in sync mode
  if not sys.sync then return end

  local eating = findbybal("herb")
  if not eating then return end

  killaction(dict[eating.action_name].herb)
end
signals.removed_from_rift:connect(valid.removed_from_rift)

function valid.no_refill_herb()
  for _, herb in ipairs{"faeleaf", "myrtle", "coltsfoot", "steam"} do
    if actions["fill"..herb.."_physical"] then
      rift.invcontents[herb] = 0
      killaction(dict["fill"..herb].physical)
    end
  end
end

function valid.cureddisrupt()
  checkaction(dict.disrupt.misc)
  if actions.disrupt_misc then
    lifevision.add(actions.disrupt_misc.p)
  end
end

-- focus body's
function valid.focusbody()
  local result = checkany(dict.paralysis.focus, dict.leglock.focus, dict.throatlock.focus)

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p)
  end
end

function valid.focusbody_empty()
  local result = checkany(dict.paralysis.focus, dict.leglock.focus, dict.throatlock.focus)

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "empty")
  end
end

#for _,aff in ipairs{"paralysis", "leglock", "throatlock"} do
function valid.cured$(aff)()
  local result = checkany(dict.curingparalysis.waitingfor, dict.curingleglock.waitingfor, dict.curingthroatlock.waitingfor)

  if not result then return end
  if result.name == "curing$(aff)_waitingfor" then
    lifevision.add(actions[result.name].p)
  else
    killaction(dict[result.action_name].waitingfor)
    checkaction(dict.curing$(aff).waitingfor, true)
    lifevision.add(dict.curing$(aff).waitingfor)
  end
end
#end

function valid.curing_paralysis()
  herb_cure = true

  checkaction(dict.paralysis.wafer, true)
  lifevision.add(actions.paralysis_wafer.p)
end

function valid.tootired_focus()
  local r = findbybal("focus")
  if not r then return end

  bals.focus = false
  killaction(dict[r.action_name].focus)
end

function valid.focus_cured_impatience()
  local r = findbybal("focus")
  if not r then return end

  focusmind_cure = true
  if r.action_name == "impatience_focus" then
    lifevision.add(actions.impatience_focus.p)
  else
    killaction(dict[r.action_name].focus)
    lifevision.add(actions.impatience_focus.p)
  end
end

function valid.symp_collapsed()
  if conf.aillusion then
    if affs.collapsedleftnerve or affs.collapsedrightnerve then
      valid.simpleepilepsy()
    end
  else
    valid.simpleepilepsy()
    valid["simplecollapsed" .. multimatches[2][2].."nerve"]()
  end
end

function valid.lost_grapple()
  checkaction(dict.grapple.misc, true)
  if actions.grapple_misc then
    lifevision.add(actions.grapple_misc.p, "lost")
  end
end

function valid.failed_focus_impatience()
  local r = findbybal("focus")
  if r or not conf.aillusion then
    if r then killaction(dict[r.action_name].focus) end

  valid.simpleimpatience()
  end
end

function valid.failed_focus_darkfate()
  local r = findbybal("focus")
  if r or not conf.aillusion then
    if r then killaction(dict[r.action_name].focus) end

  valid.simpledarkfate()
  end
end

function valid.smoke_failed_asthma()
  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  if r then
    killaction(dict[r.action_name][r.balance])

    valid.simpleasthma()
  end
end

function valid.smoke_failed_collapsedlungs()
  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  if r then
    killaction(dict[r.action_name][r.balance])

    valid.simplecollapsedlungs()
  end
end

function valid.focus_failed_insane()
  local r = findbybal("focus")

  if not r then return end

  focusmind_cure = true
  lifevision.add(actions[r.name].p, "insane")
end

function valid.unlit_pipe()
  -- check rebounding first
  if actions.rebounding_misc then
    pipes[dict.rebounding.misc.smokecure].lit = false
    killaction(dict.rebounding.misc)
    return
  end

  -- check new steam overhaul cures
  local r = findbybal("steam")
  if r then
    pipes.steam.lit = false
    pipes.steam.arty = false
    -- if we last lit the pipes very recently, and it seems to be out, then it is actually empty
    if dict.lightpipes.physical.lastlit + 10 <= os.time() then
      pipes.steam.puffs = 0
    end

    killaction(dict[r.action_name].steam)
  end

  -- check old-style smoke cures
  local r = findbybal("herb")
  if r then
    for k,v in actions:iter() do
      if v.p.balance == "herb" and v.p.smokecure then
        pipes[dict[v.p.action_name].herb.smokecure].lit = false
        pipes[dict[v.p.action_name].herb.smokecure].arty = false
        killaction(dict[v.p.action_name][v.p.balance])

        -- if we last lit the pipes very recently, and it seems to be out, then it is actually empty
        if dict.lightpipes.physical.lastlit + 10 <= os.time() then
          pipes[dict[v.p.action_name].herb.smokecure].puffs = 0
        end

        return
      end
    end
  end
end

function valid.maestoso_ruined()
  local r = findbybals("herb", "steam")
  if not r then return end

  lifevision.add(actions[r.name].p, "maestoso")
  herb_cure = true

  sk.warn"maestoso"
end

function valid.darkfate_ruined()
  local r = findbybal("herb")
  if not r then return end

  lifevision.add(actions[r.name].p, "darkfate")
  herb_cure = true
end

function valid.necroscream_canticle()
  local plague_affcount = 0
  for _, aff in pairs{ "epilepsy", "pox", "rigormortis", "scabies", "worms" } do
    if affs[aff] then
      plague_affcount = plague_affcount + 1
    end
  end
  if plague_affcount >= 5 then
    valid.simplevapors()
  elseif plague_affcount == 0 then
    valid.simpleunknownany()
  else
    local aff = {
      [1] = "recklessness",
      [2] = "confusion",
      [3] = "stupidity",
      [4] = "sensitivity"
    }
    valid["simple" .. aff[plague_affcount]]()
  end

  if affs.unknownany then valid.simpleunknownany() end
end

function valid.necromancy_shrivel()
  valid["simplecrippled"..matches[2]..matches[3]]()
end

function valid.hex_thrown()
  if isPrompt() and line == "-" then
    valid.simplevapors()
  else
    valid.simpleunknownany(math.random(1,2))
  end
end

function valid.masked_runes()
  valid.proper_paralysis()
  valid.check_recklessness()
  valid.simpleunknownlucidity()
end

function valid.tp_attack()
  valid.proper_paralysis()
  valid.check_recklessness()
  valid.simpleunknownlucidity()
end

function valid.shofangi_rake()
  valid["simplelacerated"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.ninjakari_numb()
  valid["simplenumbed"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.ninjakari_crippled()
  valid["simplecrippled"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.kata_hold()
  checkaction(dict.grapple.aff, true)
  lifevision.add(actions.grapple_aff.p, nil, "fullbody")
end

function valid.ninjakari_ashlamkh()
  valid["simplecrippled"..matches[2]..matches[3]]()
  if matches[3] == "leg" then
    valid.proper_prone()
  end
end

function valid.ninjakari_bleeding()
  tempLineTrigger(1,1,[[
    if string.find(line, "you") then
      valid.simplebleeding()
  ]])
end

function valid.ninjakari_ninshi()
  local limb = multimatches[2][2]
  limb = string.gsub(limb, " ", "")
  checkaction(dict.grapple.aff, true)
  lifevision.add(actions.grapple_aff.p, "ninshi", limb)
end

function valid.ninjakari_ninombhi()
  local name = multimatches[2][2]
  name = string.gsub(name, " ", "")
  valid["simplenumbed"..name]()
  addwounds("monk", "kata_kick", name)
end

#if skills.transmology then
  valid.cancel_blind = function()
    if actions.trueblind_gone then
      killaction(dict.trueblind.gone)
    end

    if actions.blind_aff then
      killaction(dict.blind.aff)
    end
  end
#end
function valid.proper_blind()
  if defc.trueblind then
    defs.lost_trueblind()
  end

  valid.simpleblind()

#if skills.transmology then
  sk.cancel_blind_trigger = tempExactMatchTrigger("Shadows flit over your eyes, protecting them from blindness.", "mm.valid.cancel_blind()")
  prompttrigger("cancel cancel blind", function() killTrigger(sk.cancel_blind_trigger); sk.cancel_blind_trigger = nil end)
#end
end

function valid.symp_blind()
  if conf.aillusion then
    sk.blind_symptom()
  else
    valid.proper_blind()
  end
end

function valid.proper_deaf()
  if defc.truedeaf then
    defs.lost_truedeaf()
  end

  valid.simpledeaf()
end

function valid.got_aeon()
  if conf.aillusion and (not defc.quicksilver or actions.quicksilver_gone) then
    valid.simpleaeon()
  elseif not conf.aillusion then
    if not conf.aillusion then
      valid.simpleaeon()
    else
      checkaction(dict.checkslows.aff, true)
      lifevision.add(actions.checkslows_aff.p, nil, "aeon")
    end

    defs.lost_quicksilver()
  end
end

valid.shofangi_whibuta = valid.proper_blind
valid.crow_murder = valid.proper_blind

function valid.shofangi_bullstrength()
  if multimatches[1][2] == "chest" then
    valid.simplebrokenchest()
    valid.simplestun()
  else
    valid["simplecrippled"..multimatches[1][2]:gsub(" ", "")]()
  end
end

function valid.starhymn_recessionaldrink()
  local getridof = {}
  if bals_in_use.sip and next(bals_in_use.sip) then
    for _, action in pairs(bals_in_use.sip) do
      getridof[#getridof+1] = action
    end
  elseif bals_in_use.purgative and next(bals_in_use.purgative) then
    for _, action in pairs(bals_in_use.purgative) do
      getridof[#getridof+1] = action
    end
  elseif bals_in_use.allheale and next(bals_in_use.allheale) then
    for _, action in pairs(bals_in_use.allheale) do
      getridof[#getridof+1] = action
    end
  end

  for i = 1, #getridof do
    killaction(dict[getridof[i].action_name][getridof[i].balance])
  end
end

function valid.starhymn_recessionaleat()
  local getridof = {}
  if bals_in_use.herb and next(bals_in_use.herb) then
    for _, action in pairs(bals_in_use.herb) do
      if action.eatcure then getridof[#getridof+1] = action end
    end
  elseif bals_in_use.sparkle and next(bals_in_use.sparkle) then
    for _, action in pairs(bals_in_use.sparkle) do
      getridof[#getridof+1] = action
    end
  end

  for i = 1, #getridof do
    killaction(dict[getridof[i].action_name][getridof[i].balance])
  end
end

function valid.harmonics_shatterplex()
  -- if conf.aillusion and not (affs.rubycrystal and dict.rubycrystal.count == 7) then
  --   return end

  valid.simplemassivetimewarp()
  checkaction(dict.rubycrystal.gone, true)
  lifevision.add(actions.rubycrystal_gone.p)
end

function valid.aeonics_oracle()
  if conf.aillusion and not affs.oracle then return end

  if not affs.oracle then valid.simpleoracle() end
  valid.timewarp_quarter()
  valid.simpleunknownmental(2)
end

function valid.aeonics_timeechoes()
  if conf.aillusion and not affs.timeechoes then return end

  if not affs.timeechoes then valid.simpletimeechoes() end
  valid.timewarp_quarter()
  valid.simpleunknownmental(2)
end

function valid.astrology_ray()
  valid.simpleunknownany()
end

function valid.transmology_morrible()
  if math.random(1,4) == 1 then
    valid.simpleanorexia()
  else
    valid.simpleunknownany() end
end

function valid.damaged_arms()
  -- do we know something is wrong already?
  if affs.crippledleftarm or affs.crippledrightarm or affs.mangledrightarm or affs.mangledleftarm or affs.missingrightarm or affs.missingleftarm then return end

  -- if no, we should diagnose soon
  valid.simpleunknownany()
end

function valid.paradigmatics_greywhispers()
  if not conf.aillusion or affs.greywhispers then
    valid.insanity_added()
    valid.simpleunknownmental()
  end
end

function valid.athletics_forwardflip()
  valid.proper_prone()
  valid["simplecrippled"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.winning1()
  killTrigger(winningTrigger)
  winning1Timer = tempTimer(math.random(10,30), [[mm.valid.winning1TimerAct()]])
end

function valid.winning1TimerAct()
  cecho("\n<white>Psssst. Are you ready to activate the super secret saiyan power? If so, just celebrate a victory with yourself.")
  winning1Trigger = tempExactMatchTrigger("You look around for someone to bump fists with, but sadly, you have no friends.", [[mm.valid.winning2()]])
end

function valid.geomancy_tremor()
  if not defc.levitation then
    valid.proper_prone()
  end

  if haveorwill"prone" and haveorwill"stun" then
    valid.simpleunknowncrippledleg()
  end
end

function sk.proper_recklessness()
  local t = gmcp.Char.Vitals
  if t.hp == t.maxhp and t.mp == t.maxmp and t.ego == t.maxego and t.pow == t.maxpow then
    valid.simplerecklessness()
  end
  signals.before_prompt_processing:block(sk.proper_recklessness)
end
signals.before_prompt_processing:connect(sk.proper_recklessness)
signals.before_prompt_processing:block(sk.proper_recklessness)

function valid.check_recklessness()
  signals.before_prompt_processing:unblock(sk.proper_recklessness)
end

function valid.cancel_checkrecklessness()
  signals.before_prompt_processing:block(sk.proper_recklessness)
end


function sk.proper_paralysis()
  if not pflags.p then 
    signals.before_prompt_processing:block(sk.proper_paralysis)
    return 
  end
  if (me.prone and not me.lastprone) or mm.affl.sap or mm.affl.aeon then
    valid.simpleparalysis()
  else
    checkaction(dict.checkparalysis.aff, true)
    lifevision.add(actions.checkparalysis_aff.p)
  end
  signals.before_prompt_processing:block(sk.proper_paralysis)
end
signals.before_prompt_processing:connect(sk.proper_paralysis)
signals.before_prompt_processing:block(sk.proper_paralysis)

function valid.proper_paralysis()
  signals.before_prompt_processing:unblock(sk.proper_paralysis)
end

function valid.not_prone()
  --check paralysis
  if affs.paralysis then
    removeaff("paralysis")
  end

  if affs.tangle then
    removeaff("tangle")
  end

  if affs.prone then
    removeaff("prone")
  end

  if affs.impale then
    removeaff("impale")
  end

  if affs.crucified then
    removeaff("crucified")
  end

end

function sk.proper_severedspine()
  if pflags.p then
    valid.simpleseveredspine()
  end
  signals.before_prompt_processing:block(sk.proper_severedspine)
end
signals.before_prompt_processing:connect(sk.proper_severedspine)
signals.before_prompt_processing:block(sk.proper_severedspine)

function valid.proper_severedspine()
  signals.before_prompt_processing:unblock(sk.proper_severedspine)
end

function sk.proper_shackled()
  if pflags.p then
    valid.simpleshackled()
  end
  signals.before_prompt_processing:block(sk.proper_shackled)
end
signals.before_prompt_processing:connect(sk.proper_shackled)
signals.before_prompt_processing:block(sk.proper_shackled)

function valid.proper_shackled()
  if conf.aillusion then
    signals.before_prompt_processing:unblock(sk.proper_shackled)
  else
    valid.simpleshackled()
  end
end

function valid.geomancy_lodestone()
  valid.proper_prone()
  if defc.levitation then
    defs.lost_levitation()
  else
    valid.simplestun()
  end
end

function valid.knight_withdrewpinleg(which)
  local result
  if which == "right leg" then
    result = checkany(dict.curingpinlegright.waitingfor, dict.curingpinlegright2.waitingfor)

    if not result then
      if affs.pinlegright then
        checkaction(dict.curingpinlegright.waitingfor, true)
        result = { name = "curingpinlegright_waitingfor" }
      elseif affs.pinlegright2 then
        checkaction(dict.curingpinlegright2.waitingfor, true)
        result = { name = "curingpinlegright2_waitingfor" }
      end
    end

  elseif which == "left leg" then
    result = checkany(dict.curingpinlegleft.waitingfor, dict.curingpinlegleft2.waitingfor)

    -- we won't get curing* if we didn't even start to writhe, so fake it for these purposes
    if not result then
      if affs.pinlegleft2 then
        checkaction(dict.curingpinlegleft2.waitingfor, true)
        result = { name = "curingpinlegleft2_waitingfor" }
      elseif affs.pinlegleft or affs.pinlegunknown then
        checkaction(dict.curingpinlegleft.waitingfor, true)
        result = { name = "curingpinlegleft_waitingfor" }
      end
    end

  else
    result = checkany(dict.curingpinlegright.waitingfor, dict.curingpinlegright2.waitingfor, dict.curingpinlegleft.waitingfor, dict.curingpinlegleft2.waitingfor)

    -- we won't get curing* if we didn't even start to writhe, so fake it for these purposes
    if not result then
      if affs.pinlegright then
        checkaction(dict.curingpinlegright.waitingfor, true)
        result = { name = "curingpinlegright_waitingfor" }
      elseif affs.pinlegright2 then
        checkaction(dict.curingpinlegright2.waitingfor, true)
        result = { name = "curingpinlegright2_waitingfor" }
      elseif affs.pinlegleft2 then
        checkaction(dict.curingpinlegleft2.waitingfor, true)
        result = { name = "curingpinlegleft2_waitingfor" }
      elseif affs.pinlegleft or affs.pinlegunknown then
        checkaction(dict.curingpinlegleft.waitingfor, true)
        result = { name = "curingpinlegleft_waitingfor" }
      end
    end
  end

  if result and actions[result.name] then
    lifevision.add(actions[result.name].p, "withdrew", which)
  end
end

function valid.knight_withdrewimpale()
  local result = checkany(dict.curingimpale.waitingfor)

  -- we won't get curing* if we didn't even start to writhe, so fake it for these purposes
  if not result then
    checkaction(dict.curingimpale.waitingfor, true)
    result = { name = "curingimpale_waitingfor" }
  end

  if result and actions[result.name] then
    lifevision.add(actions[result.name].p, "withdrew")
  end
end

-- fishy.
function valid.kathrow()
  checkaction(dict.curinggrapple.waitingfor, true)
  if actions.curinggrapple_waitingfor then
    lifevision.add(actions.curinggrapple_waitingfor.p, "kathrow")
  end
end

function valid.kadisarm()
  checkaction(dict.curinggrapple.waitingfor, true)
  if actions.curinggrapple_waitingfor then
    lifevision.add(actions.curinggrapple_waitingfor.p, "kadisarm")
  end
end

function valid.harmonics_onyx()
  sk.onprompt_beforeaction_add("harmonics_onyx", function ()
    if affs.blackout then addaff(dict.vapors) end
  end)
end

function valid.telekinesis_choke()
  if not conf.aillusion then
    valid.simpledisrupt()
    valid.telekinesis_vessel()
  else
  sk.onprompt_beforeaction_add("telekinesis_choke", function ()
    if affs.blackout then
      valid.simpledisrupt()
      valid.telekinesis_vessel()
    end
  end)
  end
end

function valid.avengingangel_tic()
  sk.onprompt_beforeaction_add("harmonics_onyx", function ()
    if affs.blackout then addaff(dict.vapors)
    else
      valid.simpleunknownmental()
    end
  end)
end

function valid.shofangi_shred()
  checkaction(dict.curinggrapple.waitingfor, true)
  if actions.curinggrapple_waitingfor then
    lifevision.add(actions.curinggrapple_waitingfor.p, "shred")
  end
end

function valid.shofangi_stomp(limb)
  if haveorwill"prone" then
    valid["simplecrushed"..limb]()
  else
    valid["simplecrippled"..limb:match("(%w+)foot").."leg"]()
  end
end

function valid.ninjakari_yank()
  checkaction(dict.curinggrapple.waitingfor, true)
  if actions.curinggrapple_waitingfor then
    lifevision.add(actions.curinggrapple_waitingfor.p, "yank")
  end
end

function valid.tomati()
  checkaction(dict.curinggrapple.waitingfor, true)
  if actions.curinggrapple_waitingfor then
    lifevision.add(actions.curinggrapple_waitingfor.p, "tomati")
    valid.simplebleeding(100)
    valid.unknownany()
  end
end

function valid.nekotai_amihai()
  checkaction(dict.curinggrapple.waitingfor, true)
  lifevision.add(actions.curinggrapple_waitingfor.p, "amihai")
  valid.simpleunknownany(2)
end

valid.crunch = valid.tomati

function valid.tahtetso_bomolsho()
  if matches[3] == "leg" then
    valid.simplehemiplegylower()
  else
    valid["simplehemiplegy"..matches[2]]()
  end
end

function valid.kata_spronghai()
  valid.simplehaemophilia()

  valid.simplebleeding()
end

function valid.kata_kneecap(side)
  valid["simplecracked" .. side .. "kneecap"]()
end

function valid.kata_elbow()
  valid["simplecracked" .. matches[2] .. "elbow"]()
end

function valid.nekotai_gougedeye()
  valid["simpleeyepeck" .. multimatches[2][2]]()
end

function valid.knighthood_artery()
  valid["simpleartery" .. matches[3] .. matches[4]]()
end

function valid.knighthood_pierced()
  valid["simplepierced" .. matches[3] .. matches[4]]()
end

function valid.knighthood_missingear()
  valid["simplemissing" .. matches[3] .. "ear"]()
  valid.simplestun()
end

function valid.knighthood_piercedleg()
  valid["simplepierced" .. matches[3] .. "leg"]()
end

function valid.knighthood_hemiplegy()
  valid["simplehemiplegy" .. matches[3]]()
end

function valid.knighthood_tendon()
  valid["simpletendon" .. matches[3]]()
  valid.proper_prone()
end

function valid.knighthood_slicedthigh()
  valid["simplesliced"..multimatches[2][2].."thigh"]()
end

function valid.knighthood_pinleg()
  valid["simplepinleg" .. matches[2]]()
  valid["simplepierced" .. matches[2].."leg"]()
end

function valid.telekinesis_trip()
  valid.proper_prone()
  if not affs.prone then valid.simplestun() end
end

function valid.telekinesis_vessel()
-- allow a function to be called here
-- for now, randomly add 1 or 3
  local aff = next_random_vessel(1,3)

  checkaction(dict[aff].aff, true)
  lifevision.add(actions[aff .. "_aff"].p)
end
valid.aorta_vessel = valid.telekinesis_vessel

function valid.nekotai_kaiga()
-- allow a function to be called here
-- for now, randomly add 1 or 3
  local aff = next_random_vessel(2,5)

  checkaction(dict[aff].aff, true)
  lifevision.add(actions[aff .. "_aff"].p)
end

function valid.nekotai_pierced()
  valid["simplepierced"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.wicca_barghest()
  local have_pflag = pflags.p
  sk.onprompt_beforeaction_add("barghest", function ()
    if not have_pflag and pflags.p then
      valid.simpleparalysis()
    end
  end)
end

valid.low_willpower = sk.checkwillpower

function valid.pixie_blackout()
  if defc.insomnia then defs.lost_insomnia() return end
end

function valid.tracking_clamp()
  valid["simpleclamped" .. multimatches[2][2]]()
end

local druidry_spiders = false

function valid.druidry_spiders1()
  druidry_spiders = false
end

function valid.druidry_spiders2()
  if not druidry_spiders then
  valid.simplesensitivity()
  end

  druidry_spiders = false
end

function valid.druidry_spiders_confusion()
  druidry_spiders = true
end

valid.druidry_spiders_chills, valid.druidry_spiders_shrug = valid.druidry_spiders_confusion, valid.druidry_spiders_confusion, valid.druidry_spiders_confusion

function valid.totems_shove_bothlegs()
  valid["simplecrippledleftleg"]()
  valid["simplecrippledrightleg"]()
end

function valid.nekotai_angknek()
  if matches[3] == "leg" then
    valid["simplesliced" .. matches[2] .. "thigh"]()
  else
    valid["simplesliced" .. matches[2] .. "bicep"]()
  end
end

function valid.crow_eyepeck()
  valid["simpleeyepeck" .. multimatches[2][2]]()
end

function valid.chasm_one()
  -- if the promptline + 1 = current, then it's not a fake
  if not vm.last_line_was_prompt() then return end

  givewarning({
    initialmsg = matches[2].." started chasming you! Hinder, blind, or run."
  })
end

function valid.deathsong_one()
  if (not line:find("pale spirits", 1, true)) and (not line:find("haunting sorrow and unlimited love", 1, true)) and (not line:find("cawing sound of the music", 1, true)) then
    mm.givewarning({
      initialmsg = multimatches[2][2].." started Deathsong on you! Become deaf, fear them or run.",
      prefixwarning = multimatches[2][2].." deathsong you",
      startin = .5,
      duration = 3
    })
  end
end

function valid.aeromancy_pierced()
  valid["simplepierced"..multimatches[2][2]..multimatches[2][3]]()
end

function valid.nekotai_tendon()
  valid["simpletendon" .. matches[2]]()
end

function valid.druidry_scarab_came()
  valid.simplescarab()
end

function valid.druidry_scarab_left()
  valid.scarab_woreoff()
end

function valid.stag_crushed()
  valid["simplecrippled" .. matches[2] .. matches[3]]()
end

function valid.shadowbeat_bloodycaps()
  if not conf.aillusion then
    valid.simplebleeding(dict.bleeding.count + 200)
    valid.simplehaemophilia()

    if affs.deaf then
      checkaction(dict.deaf.aff, true)
      lifevision.add(actions[j .. "_aff"].p, "gone")
    end
  else
    if not affs.deaf then return end

    valid.simplebleeding(dict.bleeding.count + 200)
    valid.simplehaemophilia()
  end
end

function valid.starhymn_lightcanta()
  valid.proper_blind()
  valid.proper_prone()
end

function valid.empty_pipe()
  -- check rebounding
  if actions.rebounding_misc then
    pipes[dict.rebounding.misc.smokecure].puffs = 0
    if not pipes[dict.rebounding.misc.smokecure].arty then
      pipes[dict.rebounding.misc.smokecure].lit = false
    end

    killaction(dict.rebounding.misc)
    return
  end

  local r = findbybals{"steam", "herb"}
  r = select(2, next(r))
  -- take in the first action, as it is most likely to be the steam smoke one with overhaul
  if not r or (r.balance == "herb" and not dict[r.action_name].herb.smokecure) then return end

  pipes[dict[r.action_name][r.balance].smokecure].puffs = 0
  if not pipes[dict[r.action_name][r.balance].smokecure].arty then
    pipes[dict[r.action_name][r.balance].smokecure].lit = false
  end

  killaction(dict[r.action_name][r.balance])
end

function valid.empty_light()
  local r = checkany(dict.lightfaeleaf.physical, dict.lightmyrtle.physical, dict.lightcoltsfoot.physical, dict.lightsteam.physical)

  if not r then return end

  killaction(dict[r.action_name].physical)
  pipes[dict[r.action_name].physical.herb].puffs = 0
  if not pipes[dict[r.action_name].physical.herb].arty then
    pipes[dict[r.action_name].physical.herb].lit = false
  end
end

function valid.empty_smoke()
  local r = checkany(dict.achromaticaura.steam, dict.aeon.steam, dict.disloyalty.steam, dict.egovice.steam, dict.healtheech.steam, dict.manabarbs.steam, dict.pacifism.steam, dict.powerspikes.steam, dict.slickness.steam, dict.massivetimewarp.steam, dict.majortimewarp.steam, dict.moderatetimewarp.steam, dict.minortimewarp.steam, dict.slightlyaurawarped.steam, dict.moderatelyaurawarped.steam, dict.aurawarped.steam, dict.massivelyaurawarped.steam, dict.completelyaurawarped.steam)

  if r then
    killaction(dict[r.action_name].steam)
    pipes.steam.puffs = 0
    if not pipes.steam.arty then
      pipes.steam.lit = false
    end
    return
  end

  r = checkany(dict.hemiplegyleft.herb, dict.hemiplegyright.herb, dict.hemiplegylower.herb, dict.piercedleftarm.herb, dict.piercedrightarm.herb, dict.piercedleftleg.herb, dict.piercedrightleg.herb, dict.crushedwindpipe.herb, dict.severedphrenic.herb)

  if r then
    killaction(dict[r.action_name].herb)
    pipes.myrtle.puffs = 0
    if not pipes.myrtle.arty then
      pipes.myrtle.lit = false
    end
    return
  end

  r = checkany(dict.impatience.herb)

  if r then
    killaction(dict[r.action_name].herb)
    pipes.coltsfoot.puffs = 0
    if not pipes.coltsfoot.arty then
      pipes.coltsfoot.lit = false
    end
    return
  end

  r = checkany(dict.rebounding.misc)

  if r then
    killaction(dict[r.action_name].misc)
    pipes.faeleaf.puffs = 0
    if not pipes.faeleaf.arty then
      pipes.faeleaf.lit = false
    end
    return
  end
end

function valid.healed_completely()
  local result = checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,
    dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip)

  if result and actions[result.name] then
    lifevision.add(actions[result.name].p, "completely")
  elseif checkany(dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip) then
    -- we were doing a numb* action, so find which limb to send this command for
    local name = string.gsub(matches[2], " ", "")
    local limb = checkanyaffs(dict["light"..name], dict["medium"..name], dict["heavy"..name], dict["critical"..name])
    if not limb then limb = {name = "light"..name} end
    checkaction (dict[limb.name].sip, true)
    lifevision.add(actions[limb.name.."_sip"].p, "completely")
  end
end

function valid.ice_healed_completely()
  local result = checkany(
    dict.lighthead.ice, dict.heavyhead.ice, dict.criticalhead.ice, dict.lightrightarm.ice, dict.heavyrightarm.ice, dict.criticalrightarm.ice, dict.lightleftarm.ice, dict.heavyleftarm.ice, dict.criticalleftarm.ice, dict.lightleftleg.ice, dict.heavyleftleg.ice, dict.criticalleftleg.ice,
    dict.lightrightleg.ice, dict.heavyrightleg.ice, dict.criticalrightleg.ice, dict.lightchest.ice, dict.heavychest.ice, dict.criticalchest.ice, dict.lightgut.ice, dict.heavygut.ice, dict.criticalgut.ice)

  if result and actions[result.name] then
    ice_gmcp = true
    apply_ice = true
    lifevision.add(actions[result.name].p, "completely")
  end
end

function valid.ice_curingaff()
  local result = checkany(
    dict.damagedskull.ice, dict.damagedthroat.ice, dict.collapsedlungs.ice, dict.crushedchest.ice, dict.internalbleeding.ice, dict.damagedorgans.ice, dict.damagedleftarm.ice, dict.mutilatedleftarm.ice, dict.damagedrightarm.ice, dict.mutilatedrightarm.ice, dict.damagedleftleg.ice, dict.mutilatedleftleg.ice, dict.damagedrightleg.ice, dict.mutilatedrightleg.ice)

  if result and actions[result.name] then
    apply_ice = true
    lifevision.add(actions[result.name].p, "empty")
  end
end

function valid.cured_numb(limb)
  local result = checkany(dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip)
  if result and actions[result.name] then
    lifevision.add(actions[result.name].p)
  elseif checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,
    dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip) then
      -- if we were curing a wounded limb, got numb cured as well...
    limb = string.gsub(limb, " ", "")
    if affs["numbed"..limb] then
      checkaction(dict["numbed"..limb].sip, true)
      lifevision.add(actions["numbed"..limb.."_sip"].p)
    end
  end
end

function valid.appliedhealth_nouse()
  local result = checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip,
    dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip)
  if not result then return end

  if actions[result.name] then
    lifevision.add(actions[result.name].p, "nouse")
  end
end

function valid.ice_nouse()
  local result = checkany(
    dict.lighthead.ice, dict.heavyhead.ice, dict.criticalhead.ice, dict.lightrightarm.ice, dict.heavyrightarm.ice, dict.criticalrightarm.ice, dict.lightleftarm.ice, dict.heavyleftarm.ice, dict.criticalleftarm.ice, dict.lightleftleg.ice, dict.heavyleftleg.ice, dict.criticalleftleg.ice, dict.lightrightleg.ice, dict.heavyrightleg.ice, dict.criticalrightleg.ice, dict.lightchest.ice, dict.heavychest.ice, dict.criticalchest.ice, dict.lightgut.ice, dict.heavygut.ice, dict.criticalgut.ice, dict.damagedskull.ice, dict.damagedthroat.ice, dict.collapsedlungs.ice, dict.crushedchest.ice, dict.damagedorgans.ice, dict.internalbleeding.ice, dict.damagedleftarm.ice, dict.mutilatedleftarm.ice, dict.damagedrightarm.ice, dict.mutilatedrightarm.ice, dict.damagedleftleg.ice, dict.mutilatedleftleg.ice, dict.damagedrightleg.ice, dict.mutilatedrightleg.ice, dict.fourthdegreeburn.ice, dict.thirddegreeburn.ice, dict.seconddegreeburn.ice, dict.firstdegreeburn.ice, dict.ablaze.ice)
  if not result then return end

  if actions[result.name] then
    apply_ice = true
    lifevision.add(actions[result.name].p, "nouse")
  end
end

function valid.healed_partially()
 local result = checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,
    dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip)

  if result and actions[result.name] then
    lifevision.add(actions[result.name].p, "partially")
  elseif checkany(dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip) then
    -- we were doing a numb* action, so find which limb to send this command for
    local name = matches[2]
    name = string.gsub(name, " ", "")
    local limb = checkanyaffs(dict["light"..name], dict["medium"..name], dict["heavy"..name], dict["critical"..name])
    if not limb then limb = {name = "light"..name} end
    checkaction (dict[limb.name].sip, true)
    lifevision.add(actions[limb.name.."_sip"].p, "partially")
  end
end

function valid.ice_healed_partially()
 local result = checkany(
    dict.lighthead.ice, dict.heavyhead.ice, dict.criticalhead.ice, dict.lightrightarm.ice, dict.heavyrightarm.ice, dict.criticalrightarm.ice, dict.lightleftarm.ice, dict.heavyleftarm.ice, dict.criticalleftarm.ice, dict.lightleftleg.ice, dict.heavyleftleg.ice, dict.criticalleftleg.ice, dict.lightrightleg.ice, dict.heavyrightleg.ice, dict.criticalrightleg.ice, dict.lightchest.ice, dict.heavychest.ice, dict.criticalchest.ice, dict.lightgut.ice, dict.heavygut.ice, dict.criticalgut.ice)

  if result and actions[result.name] then
    ice_gmcp = true
    apply_ice = true
    lifevision.add(actions[result.name].p, "partially")
  end
end

-- no effect should add both affs...
function valid.healed_noeffect()
  local result = checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip,
    dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip)
  if not result then return end

  if actions[result.name] then
    lifevision.add(actions[result.name].p, "noeffect")
  end
end

--no effect should add both affs...
function valid.ice_noeffect()
  local result = checkany(
    dict.lighthead.ice, dict.heavyhead.ice, dict.criticalhead.ice, dict.lightrightarm.ice, dict.heavyrightarm.ice, dict.criticalrightarm.ice, dict.lightleftarm.ice, dict.heavyleftarm.ice, dict.criticalleftarm.ice, dict.lightleftleg.ice, dict.heavyleftleg.ice, dict.criticalleftleg.ice, dict.lightrightleg.ice, dict.heavyrightleg.ice, dict.criticalrightleg.ice, dict.lightchest.ice, dict.heavychest.ice, dict.criticalchest.ice, dict.lightgut.ice, dict.heavygut.ice, dict.criticalgut.ice, dict.damagedskull.ice, dict.damagedthroat.ice, dict.collapsedlungs.ice, dict.crushedchest.ice, dict.damagedorgans.ice, dict.internalbleeding.ice, dict.damagedleftarm.ice, dict.mutilatedleftarm.ice, dict.damagedrightarm.ice, dict.mutilatedrightarm.ice, dict.damagedleftleg.ice, dict.mutilatedleftleg.ice, dict.damagedrightleg.ice, dict.mutilatedrightleg.ice, dict.fourthdegreeburn.ice, dict.thirddegreeburn.ice, dict.seconddegreeburn.ice, dict.firstdegreeburn.ice, dict.ablaze.ice)
  if not result then return end

  if actions[result.name] then
    apply_ice = true
    lifevision.add(actions[result.name].p, "noeffect")
  end
end

function valid.apply_ninshi()
  local result = checkany(
    dict.lighthead.sip, dict.mediumhead.sip, dict.heavyhead.sip, dict.criticalhead.sip,
    dict.lightrightarm.sip, dict.mediumrightarm.sip, dict.heavyrightarm.sip, dict.criticalrightarm.sip, dict.lightleftarm.sip, dict.mediumleftarm.sip, dict.heavyleftarm.sip, dict.criticalleftarm.sip, dict.lightleftleg.sip, dict.mediumleftleg.sip, dict.heavyleftleg.sip, dict.criticalleftleg.sip,  dict.lightrightleg.sip, dict.mediumrightleg.sip, dict.heavyrightleg.sip, dict.criticalrightleg.sip, dict.lightchest.sip, dict.mediumchest.sip, dict.heavychest.sip, dict.criticalchest.sip, dict.lightgut.sip, dict.mediumgut.sip, dict.heavygut.sip, dict.criticalgut.sip, dict.numbedhead.sip, dict.numbedchest.sip, dict.numbedgut.sip, dict.numbedleftarm.sip, dict.numbedleftleg.sip, dict.numbedrightarm.sip, dict.numbedrightleg.sip)
  if not result then return end

  if actions[result.name] then
    lifevision.add(actions[result.name].p, "ninshi")
  end
end

function valid.sippedhealth()
  local result = checkany(dict.healhealth.sip)

  if not result then
    result = checkany(dict.onevessel.sip, dict.twovessels.sip, dict.threevessels.sip, dict.fourvessels.sip, dict.fivevessels.sip, dict.sixvessels.sip,dict.sevenvessels.sip, dict.eightvessels.sip, dict.ninevessels.sip, dict.tenvessels.sip, dict.elevenvessels.sip, dict.twelvevessels.sip, dict.thirteenplusvessels.sip)

    if result then sip_cure = true end

    return
 end

  sip_cure = true
  if actions[result.name] then
    lifevision.add(actions[result.name].p)
  end
end

function valid.medicinebag_health()
  valid.sippedhealth()
end

function valid.cured_vessel_health()
  local result = checkany(dict.onevessel.sip, dict.twovessels.sip, dict.threevessels.sip, dict.fourvessels.sip, dict.fivevessels.sip, dict.sixvessels.sip,dict.sevenvessels.sip, dict.eightvessels.sip, dict.ninevessels.sip, dict.tenvessels.sip, dict.elevenvessels.sip, dict.twelvevessels.sip, dict.thirteenplusvessels.sip)

  if not result then return end

  sip_cure = true
  if actions[result.name] then
    lifevision.add(actions[result.name].p)
  end
end


function valid.cured_vessels_health()
  local result = checkany(dict.healhealth.sip, dict.onevessel.sip, dict.twovessels.sip, dict.threevessels.sip, dict.fourvessels.sip, dict.fivevessels.sip, dict.sixvessels.sip,dict.sevenvessels.sip, dict.eightvessels.sip, dict.ninevessels.sip, dict.tenvessels.sip, dict.elevenvessels.sip, dict.twelvevessels.sip, dict.thirteenplusvessels.sip)

  if not result then return end

  sip_cure = true
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "all")
  end
end


function valid.cured_vessel_sparkle()
  local result = checkany(dict.onevessel.sparkle, dict.twovessels.sparkle, dict.threevessels.sparkle, dict.fourvessels.sparkle, dict.fivevessels.sparkle, dict.sixvessels.sparkle,dict.sevenvessels.sparkle, dict.eightvessels.sparkle, dict.ninevessels.sparkle, dict.tenvessels.sparkle, dict.elevenvessels.sparkle, dict.twelvevessels.sparkle, dict.thirteenplusvessels.sparkle,
    dict.onevessel.herb, dict.twovessels.herb, dict.threevessels.herb, dict.fourvessels.herb, dict.fivevessels.herb, dict.sixvessels.herb,dict.sevenvessels.herb, dict.eightvessels.herb, dict.ninevessels.herb, dict.tenvessels.herb, dict.elevenvessels.herb, dict.twelvevessels.herb, dict.thirteenplusvessels.herb)

  if not result then return end
  -- if vessels already got it, don't add anything else
  if herb_cure then sparkle_cure = true return end

  sparkle_cure = true
  herb_cure = true
  if actions[result.name] then
    lifevision.add(actions[result.name].p)
  end
end


function valid.cured_vessels_sparkle()
  local result = checkany(dict.onevessel.sparkle, dict.twovessels.sparkle, dict.threevessels.sparkle, dict.fourvessels.sparkle, dict.fivevessels.sparkle, dict.sixvessels.sparkle,dict.sevenvessels.sparkle, dict.eightvessels.sparkle, dict.ninevessels.sparkle, dict.tenvessels.sparkle, dict.elevenvessels.sparkle, dict.twelvevessels.sparkle, dict.thirteenplusvessels.sparkle,
    dict.onevessel.herb, dict.twovessels.herb, dict.threevessels.herb, dict.fourvessels.herb, dict.fivevessels.herb, dict.sixvessels.herb,dict.sevenvessels.herb, dict.eightvessels.herb, dict.ninevessels.herb, dict.tenvessels.herb, dict.elevenvessels.herb, dict.twelvevessels.herb, dict.thirteenplusvessels.herb)

  if not result then return end
  -- if vessels already got it, don't add anything else
  if herb_cure then sparkle_cure = true return end

 sparkle_cure = true
 herb_cure = true
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "all")
  end
end


-- bindings
#do local data = {"vines", "transfixed", "clampedleft", "clampedright", "hoisted", "roped", "shackled", "grapple", "truss", "tangle", "pinlegright", "pinlegleft", "pinlegright2", "pinlegleft2", "crucified", "gore", "pinlegright", "pinlegleft", "impale"}
#local primeddata = {}; for _, k in pairs(data) do primeddata[#primeddata+1] = "dict."..k..".misc" end; primeddata = table.concat(primeddata, ",")
#local primedwaitingdata = {}; for _, k in pairs(data) do primedwaitingdata[#primedwaitingdata+1] = "dict.curing"..k..".waitingfor" end; primedwaitingdata = table.concat(primedwaitingdata, ",")
#for _,aff in pairs(data) do
#local allactions = "dict."..aff..".misc,"..primeddata
function valid.writhe$(aff)()
  local result = checkany($(allactions), dict.pinlegunknown.misc)

  if not result then return end
#if aff == "pinlegleft" or aff == "pinlegright" then
  lifevision.add(actions[result.name].p)
#else
  if result.name == "$(aff)_misc" then
    lifevision.add(actions.$(aff)_misc.p)
  else
    killaction(dict[result.action_name].misc)
    checkaction(dict.$(aff).misc, true)
    lifevision.add(dict.$(aff).misc)
  end
#end
end

#local allcuringactions = "dict.curing"..aff..".waitingfor,"..primedwaitingdata

#if aff == "pinlegleft2" or aff == "pinlegright2" then
function valid.writhed$(aff)()
  local result = checkany($(allcuringactions))

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "secondary")
  end
end

#else

function valid.writhed$(aff)()
  local result = checkany($(allcuringactions))

  if not result then return end
  lifevision.add(actions[result.name].p)
end
#end

function valid.writhe$(aff)_helpless()
  local result = checkany($(allactions), dict.pinlegunknown.misc)

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "helpless")
  end
end
#end end

function valid.writhethornlashed()
  local result = checkany(dict.thornlashedleftarm.misc, dict.thornlashedleftleg.misc, dict.thornlashedrightarm.misc, dict.thornlashedrightleg.misc, dict.thornlashedhead.misc)

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p)
  end
end

#for _, aff in ipairs({"ectoplasm", "mud", "sap", "slickness", "deathmark", "gunk", "mucous"}) do
function valid.cleanse_cured_$(aff)()
  local result = checkany(dict.ectoplasm.physical, dict.mud.physical, dict.slickness.physical, dict.sap.physical, dict.gunk.physical, dict.mucous.physical, dict.cleanse.physical)
  if not result then
    -- account for pointcleanse, sanitize
    checkaction(dict.$(aff).physical, true)
    lifevision.add(dict.$(aff).physical, nil, "$(aff)")
    return
  end

  if result.name == "$(aff)_physical" then
    lifevision.add(actions[result.name].p)
  else
    killaction(dict.$(aff).physical)
    checkaction(dict[result.action_name].physical, true)
    lifevision.add(dict[result.action_name].physical, nil, "$(aff)")
  end
end
#end

function valid.cleanse_clear()
  local result = checkany(dict.ectoplasm.physical, dict.mud.physical, dict.cleanse.physical, dict.sap.physical, dict.gunk.physical, dict.mucous.physical, dict.cleanse.physical, dict.slickness.physical)
  if not result then return end

  lifevision.add(actions[result.name].p, "empty")
end

#for _, aff in ipairs({"thornlashedleftarm", "thornlashedleftleg", "thornlashedrightarm", "thornlashedrightleg", "thornlashedhead"}) do
function valid.writhed$(aff)()
  local result = checkany(dict.curingthornlashedleftarm.waitingfor, dict.curingthornlashedleftleg.waitingfor, dict.curingthornlashedrightarm.waitingfor, dict.curingthornlashedrightleg.waitingfor, dict.curingthornlashedhead.waitingfor)
  if not result then return end

  if result.name == "curing$(aff)_waitingfor" then
    lifevision.add(actions[result.name].p)
  else
    killaction(dict.curing$(aff).waitingfor)
    lifevision.add(dict[result.action_name].waitingfor)
  end
end
#end

function valid.writhehelpless()
  local result = checkany(dict.impale.misc, dict.vines.misc, dict.transfixed.misc, dict.clampedleft.misc, dict.clampedright.misc, dict.hoisted.misc, dict.roped.misc, dict.shackled.misc, dict.grapple.misc, dict.truss.misc, dict.tangle.misc, dict.thornlashedleftarm.misc, dict.thornlashedleftleg.misc, dict.thornlashedrightarm.misc, dict.thornlashedrightleg.misc, dict.pinlegright.misc, dict.pinlegleft.misc, dict.crucified.misc, dict.gore.misc, dict.pinlegunknown.misc, dict.pinlegright2.misc, dict.pinlegleft2.misc, dict.thornlashedhead.misc)

  if not result then return end
  if actions[result.name] then
    lifevision.add(actions[result.name].p, "helpless")
  end
end

-- regeneration cures
#for _, regeneration in pairs({
#regeneration = {"curingmissingrightleg", "curingmissingleftleg", "curingmangledrightleg", "curingmangledleftleg", "curingtendonright", "curingtendonleft", "curingtendonunknown", "curingcrackedrightkneecap", "curingcrackedleftkneecap", "curingcrackedunknownkneecap", "curingcrackedrightelbow", "curingcrackedleftelbow", "curingmissingrightarm", "curingmissingleftarm", "curingmangledrightarm", "curingmangledleftarm", "curingparegenlegs", "curingshatteredrightankle", "curingshatteredleftankle"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(regeneration) do
#temp[#temp+1] = encodew(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(regeneration) do
function valid.$(aff)()
  local result = checkany(dict.$(aff).waitingfor, $(checkany_string))

  if not result then return end

  if result.name == "$(aff)_waitingfor" then
    lifevision.add(actions.$(aff)_waitingfor.p)
  else
    killaction(dict[result.action_name].waitingfor)
    checkaction(dict.$(aff).waitingfor, true)
    lifevision.add(dict.$(aff).waitingfor)
  end
end
#end
#end

-- crippled arms cures
#for _, regeneration in pairs({
#regeneration = {"crippledrightarm", "crippledleftarm", "unknowncrippledarm"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(regeneration) do
#temp[#temp+1] = encodes(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(regeneration) do
function valid.salve_cured_$(aff)()
  local result = checkany(dict.$(aff).salve, $(checkany_string))

  if not result then return end

  apply_cure = true
  if result.name == "$(aff)_salve" then
    lifevision.add(actions.$(aff)_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.$(aff).salve, true)
    lifevision.add(dict.$(aff).salve)
  end
end
#end
#end

-- crippled legs cures
#for _, regeneration in pairs({
#regeneration = {"crippledrightleg", "crippledleftleg", "unknowncrippledleg"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(regeneration) do
#temp[#temp+1] = encodes(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(regeneration) do
function valid.salve_cured_$(aff)()
  local result = checkany(dict.$(aff).salve, $(checkany_string))

  if not result then return end

  apply_cure = true
  if result.name == "$(aff)_salve" then
    lifevision.add(actions.$(aff)_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.$(aff).salve, true)
    lifevision.add(dict.$(aff).salve)
  end
end
#end
#end

-- normal types, left/right
#for _, t in ipairs({
# {"missingrightear", "missingleftear", "herb", "herb_cure"},
# {"piercedrightarm", "piercedleftarm", "herb", "herb_cure"},
# {"slicedrightthigh", "slicedleftthigh", "herb", "herb_cure"}}) do
function valid.$(t[3])_cured_$(t[1])()
#if t[3] == "smoke" then
  local result = checkany(dict.$(t[1]).herb, dict.$(t[2]).herb)
#else
  local result = checkany(dict.$(t[1]).$(t[3]), dict.$(t[2]).$(t[3]))
#end

  if not result then return end
--  if actions[result.name] then
    $(t[4]) = true
    if result.action_name == "$(t[1])" then
      lifevision.add(actions[result.name].p)
    else
      lifevision.add(actions[result.name].p, "oncuredright") -- left calls right
    end
--  end
end

function valid.$(t[3])_cured_$(t[2])()
#if t[3] == "smoke" then
  local result = checkany(dict.$(t[1]).herb, dict.$(t[2]).herb)
#else
  local result = checkany(dict.$(t[1]).$(t[3]), dict.$(t[2]).$(t[3]))
#end

  if not result then return end
--  if actions[result.name] then
    $(t[4]) = true
    if result.action_name == "$(t[2])" then
      lifevision.add(actions[result.name].p)
    else
      lifevision.add(actions[result.name].p, "oncuredleft")
    end
--  end
end

#end

-- focus
#for kindname, kind in pairs({
#mind   = {"unknownmental", "loneliness", "masochism", "pacifism", "paranoia", "recklessness", "shyness", "stupidity", "vertigo", "void", "weakness", "addiction", "agoraphobia", "anorexia", "claustrophobia", "confusion", "dizziness", "epilepsy", "impatience", "vestiphobia", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "hallucinating", "inlove", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"},
#spirit = {"treebane", "illuminated", "omen", "taintsick", "darkmoon"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(kind) do
#temp[#temp+1] = encodef(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(kind) do
function valid.focus_cured_$(aff)()
  local result = checkany(dict.$(aff).focus, $(checkany_string))
  if not result then return end


$(
  if kindname == "mind" then
    _put 'focusmind_cure = true'
  elseif kindname == "spirit" then
    _put 'focusspirit_cure = true'
  end
)

  if result.name == "$(aff)_focus" then
    lifevision.add(actions.$(aff)_focus.p)
  else
    killaction(dict[result.action_name].focus)
    checkaction(dict.$(aff).focus, true)
    lifevision.add(dict.$(aff).focus)
  end
end

#end
#end

-- arnicas
#for _, herb in pairs({
#arnica = {"brokennose", "crushedleftfoot", "crushedrightfoot", "snappedrib", "fracturedleftarm", "fracturedrightarm", "brokenchest", "fracturedskull"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(herb) do
#temp[#temp+1] = encode(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(herb) do
function valid.arnica_cured_$(aff)()
  local result = checkany(dict.$(aff).herb, $(checkany_string))
#   -- $aff twice, first so most cases it gets returned first when it's the only aff

  if not result then return end

  arnica_cure = true
  if result.name == "$(aff)_herb" then
    lifevision.add(actions.$(aff)_herb.p)
  else
    killaction(dict[result.action_name].herb)
    checkaction(dict.$(aff).herb, true)
    lifevision.add(dict.$(aff).herb)
  end
end

#end
#end

-- normal smokes
#for _, herb in pairs({
#coltsfoot = {"anorexia", "impatience", "loneliness", "masochism", "shyness"},
#faeleaf   = {"cloudcoils"},
#myrtle    = {"crushedwindpipe", "piercedleftarm", "piercedleftleg", "piercedrightarm", "piercedrightleg", "hemiplegylower", "hemiplegyleft", "hemiplegyright", "severedphrenic"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(herb) do
#temp[#temp+1] = encode(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(herb) do
function valid.smoke_cured_$(aff)()
  local result = checkany(dict.$(aff).herb, $(checkany_string))
# -- $aff twice, first so most cases it gets returned first when it's the only aff
  if not result then return end

  smoke_cure = true
  -- check if the pipe went out. 2 since cured affmsg line will be before it
  tempLineTrigger(1,2,[[
    if line == "Your pipe goes dark as the last of its contents burn up." then
      mm.valid.pipe_ran_out()
    end
  ]])
  if result.name == "$(aff)_herb" then
    lifevision.add(actions.$(aff)_herb.p)
  else
    killaction(dict[result.action_name].herb)
    checkaction(dict.$(aff).herb, true)
    lifevision.add(dict.$(aff).herb)
  end
end

#end
#end

function valid.smoke_cured_insomnia()
  local r = checkany(dict.anorexia.herb, dict.impatience.herb, dict.loneliness.herb, dict.masochism.herb, dict.shyness.herb)
  if not r then return end

  killaction(dict[r.action_name].herb)
  defs.lost_insomnia()
  sk.lostbal_herb ()

  checkaction(dict[r.action_name].gone, true)
  lifevision.add(actions[r.action_name.."_gone"].p)
end

-- normal herbs
#for _, herb in pairs({
#pennyroyal = {"confusion", "dementia", "hallucinating", "paranoia", "scrambledbrain", "stupidity", "void", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity"},
#galingale  = {"addiction", "gluttony", "inlove"},
#horehound  = {"achromaticaura", "bedevil", "dissonance", "egovice", "healthleech", "manabarbs", "powerspikes", "recklessness", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp"},
#kafe       = {"daydreaming", "narcolepsy"},
#chervil    = {"bleeding"},
#calamus    = {"slickness"},
#kombu      = {"clumsiness", "deadening", "dizziness", "epilepsy", "omniphobia", "vapors"},
#marjoram   = {"bicepleft", "bicepright", "dislocatedleftarm", "dislocatedleftleg", "dislocatedrightarm", "dislocatedrightleg", "gashedcheek", "puncturedchest", "rigormortis", "slicedtongue", "slicedleftthigh", "slicedrightthigh", "weakness",  "missingleftear", "missingrightear", "opengut", "openchest", "slicedleftbicep", "slicedrightbicep", "stiffhead", "stiffchest", "stiffgut", "stiffrightarm", "stiffleftarm"},
#myrtle     = {"sensitivity", "vertigo", "blind"},
#reishi     = {"aeon", "aurawarp", "jinx", "justice", "pacifism", "peace", "powersink"},
#wormwood   = {"agoraphobia", "claustrophobia", "hypochondria", "vestiphobia"},
#yarrow     = {"arteryleftarm", "arteryleftleg", "arteryrightarm", "arteryrightleg", "clotleftshoulder", "clotrightshoulder", "clotrighthip", "clotlefthip", "laceratedleftarm", "laceratedleftleg", "laceratedrightarm", "laceratedrightleg", "haemophilia", "relapsing", "slicedforehead", "laceratedunknown"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(herb) do
#temp[#temp+1] = encode(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(herb) do
function valid.herb_cured_$(aff)()
  local result = checkany(dict.$(aff).herb, $(checkany_string))

  if not result then return end

  herb_cure = true
  if result.name == "$(aff)_herb" then
    lifevision.add(actions.$(aff)_herb.p)
  else
    killaction(dict[result.action_name].herb)
    checkaction(dict.$(aff).herb, true)
    lifevision.add(dict.$(aff).herb)
  end
end

#end
#end

-- TODO: fix so it does not bypass AI
function valid.herbbanefail()
  local eating = findbybal("herb")
  if not eating then return end

  herb_cure = true
  if not affs.herbbane then
    addaff(dict.herbbane)
  end

  killaction(dict[eating.action_name].herb)
end

function valid.earachefail()
  local result = checkany (dict.truedeaf.steam, dict.deaf.steam, dict.attraction.steam)
  if not result then return end

  herb_cure = true

  if actions[result.name] then
    lifevision.add(actions[result.name].p, "earache")
  end
end

-- normal sips
#for _, purgative in pairs({
#antidote   = {"powersap", "crotamine"},
#choleric   = {"lovepotion", "hypersomnia", "dysentery", "vomitblood", "worms", "vomiting"},
#fire       = {"frozen", "shivering"},
#frost      = {"ablaze", "frost"},
#love       = {"disloyalty"},
#phlegmatic = {"shyness", "void", "powersink", "aeon", "weakness"},
#sanguine   = {"furrowedbrow", "confusion", "scalped", "healthleech", "haemophilia"},
#}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(purgative) do
#temp[#temp+1] = encodep(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(purgative) do
function valid.sip_cured_$(aff)()
  local result = checkany(dict.$(aff).purgative, $(checkany_string))

  if not result then return end

  sip_cure = true
  if result.name == "$(aff)_purgative" then
    lifevision.add(actions.$(aff)_purgative.p)
  else
    killaction(dict[result.action_name].purgative)
    checkaction(dict.$(aff).purgative, true)
    lifevision.add(dict.$(aff).purgative)
  end
end

#end
#end

-- lucidity sips
#for _, lucidity in pairs({
#lucidity = {"epilepsy", "paranoia", "sensitivity", "confusion", "recklessness", "hallucinating", "clumsiness", "stupidity", "addiction", "anorexia", "massiveinsanity","majorinsanity","moderateinsanity","slightinsanity","unknownlucidity"},
#}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(lucidity) do
#temp[#temp+1] = encodel(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(lucidity) do
function valid.sip_cured_$(aff)()
  local result = checkany(dict.$(aff).lucidity, $(checkany_string))

  if not result then return end

  sip_cure = true
  if result.name == "$(aff)_lucidity" then
    lifevision.add(actions.$(aff)_lucidity.p)
  else
    killaction(dict[result.action_name].lucidity)
    checkaction(dict.$(aff).lucidity, true)
    lifevision.add(dict.$(aff).lucidity)
  end
end

#end
#end

-- steam puffs
#for _, steam in pairs({
#steam = {"egovice", "manabarbs", "achromaticaura", "powerspikes", "disloyalty", "pacifism", "illuminated", "healthleech", "aeon", "slickness", "massivetimewarp","majortimewarp","moderatetimewarp","minortimewarp","completelyaurawarped","massivelyaurawarped","aurawarped","moderatelyaurawarped","slightlyaurawarped","unknownsteam"},
#}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(steam) do
#temp[#temp+1] = encodess(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(steam) do
function valid.steam_cured_$(aff)()
  local result = checkany(dict.$(aff).steam, $(checkany_string))

  if not result then return end

  smoke_cure = true
  if result.name == "$(aff)_steam" then
    lifevision.add(actions.$(aff)_steam.p)
  else
    checkaction(dict.$(aff).steam, true)
    lifevision.add(dict.$(aff).steam)
  end
end

#end
#end

function valid.steam_noaff(aff)
  if aff == "luminosity" then
    aff = "illuminated"
  end

  if not dict[aff].steam then
    return
  end

  local result = checkany(dict[aff].steam)
  if not result then return end
  lifevision.add(dict[aff].steam)
end

function valid.lucidity_noaff(aff)
  if aff == "hallucinations" then
    aff = "hallucinating"
  end

  if not dict[aff].lucidity then
    return
  end

  local result = checkany(dict[aff].lucidity)
  if not result then return end
  lifevision.add(dict[aff].lucidity)
end

function valid.wafer_noaff(aff)
  if aff == "sickening" then
    aff = "taintsick"
  end

  if not dict[aff].wafer then
    return
  end

  local result = checkany(dict[aff].wafer)
  if not result then return end
  lifevision.add(dict[aff].wafer)
end

-- wafer nomnoms
#for _, wafer in pairs({
#wafer = {"paralysis", "haemophilia", "powersap", "scabies", "dysentery", "pox", "vomiting", "rigormortis", "taintsick", "asthma","clotleftshoulder","clotrightshoulder","clotlefthip","clotrighthip","unknownwafer"},
#}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(wafer) do
#temp[#temp+1] = encodewafer(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(wafer) do
function valid.wafer_cured_$(aff)()
  local result = checkany(dict.$(aff).wafer, $(checkany_string))

  if not result then return end

  herb_cure = true
  if result.name == "$(aff)_wafer" then
    lifevision.add(actions.$(aff)_wafer.p)
  else
    killaction(dict[result.action_name].wafer)
    checkaction(dict.$(aff).wafer, true)
    lifevision.add(dict.$(aff).wafer)
  end
end


function valid.instant_cure_paralysis()
  local result = checkany(dict.paralysis.wafer, $(checkany_string))
  if not result then return end

  herb_cure = true
  if result.name == "paralysis_wafer" then
    lifevision.add(actions.paralysis_wafer.p, "instantcure")
  else
    killaction(dict[result.action_name].wafer)
    checkaction(dict.paralysis.wafer, true)
    lifevision.add(dict.paralysis.wafer)
  end
end

#end
#end



-- allheale sips
#for _, allheale in pairs({
#allheale = {"firstdegreeburn", "seconddegreeburn", "thirddegreeburn", "fourthdegreeburn", "paralysis", "tangle", "roped", "transfixed", "shackled", "inlove", "powersink", "stupidity", "arteryleftarm", "arteryleftleg", "arteryrightarm", "arteryrightleg", "clumsiness", "recklessness", "relapsing", "aeon", "confusion", "slickness", "shyness", "paranoia", "vertigo", "vestiphobia", "scabies", "dizziness", "missingleftear", "missingrightear", "sunallergy", "sensitivity", "hallucinating", "epilepsy", "crotamine", "hypersomnia", "weakness", "dysentery", "vomiting", "hypochondria", "rigormortis", "masochism", "vapors", "asthma", "dementia", "hemiplegyleft", "hemiplegyright", "pox", "opengut", "piercedleftarm", "piercedleftleg", "piercedrightarm", "piercedrightleg", "ablaze", "worms", "gluttony", "justice", "pacifism", "healthleech", "brokenjaw", "fracturedskull", "vomitblood", "fracturedleftarm", "fracturedrightarm", "brokenchest", "brokennose", "agoraphobia", "brokenleftwrist", "brokenrightwrist", "addiction", "haemophilia", "impatience", "disloyalty", "claustrophobia", "peace", "daydreaming", "narcolepsy", "puncturedaura", "puncturedchest", "puncturedlung", "blacklung", "leglock", "omniphobia", "openchest", "slicedleftbicep", "slicedleftthigh", "slicedrightbicep", "slicedrightthigh", "scalped", "illuminated", "clampedleft", "clampedright", "succumb", "mud", "papaxihealth", "papaximana", "papaxiego", "omen", "heretic", "infidel", "bubble", "taintsick", "sap", "treebane", "stars",  "darkmoon", "fear", "blackout", "drunk", "deadening", "loneliness", "dissonance", "darkseed", "gunk", "egovice", "manabarbs", "powerspikes", "achromaticaura", "gashedcheek", "laceratedleftarm", "laceratedleftleg", "laceratedrightarm", "laceratedrightleg", "laceratedunknown", "severedphrenic", "snappedrib", "furrowedbrow", "crushedwindpipe", "afterimage", "earache", "rainbowpattern", "crushedleftfoot", "crushedrightfoot", "slicedtongue", "shortbreath", "dislocatedleftarm", "dislocatedleftleg", "dislocatedrightarm", "dislocatedrightleg", "scrambledbrain", "hemiplegylower", "twistedleftarm", "twistedleftleg", "twistedrightarm", "twistedrightleg", "trembling", "truss", "void", "homeostasis", "bedevil", "aurawarp", "prone", "crippledleftarm", "crippledleftleg", "crippledrightarm", "crippledrightleg", "clotleftshoulder", "clotlefthip", "clotrightshoulder", "clotrighthip", "enfeeble", "stiffhead", "stiffchest", "stiffgut", "stiffrightarm", "stiffleftarm", "insomnia", "shivering", "frozen", "lovepotion", "attraction", "grapple", "numbedhead", "numbedchest", "numbedgut", "numbedleftarm", "numbedleftleg", "numbedrightarm", "numbedrightleg", "batbane", "herbbane", "snakebane", "powersap",  "illusorywounds", "crucified", "disrupt", "stun", "sleep", "jinx", "batbane", "snakebane", "herbbane", "unknownmental", "cloudcoils", "bleeding", "unknownany", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "oracle", "anorexia", "collapsedlungs", "avengingangel"}}) do

#for _, aff in pairs(allheale) do
function valid.allheale_cured_$(aff)()
  checkaction(dict.blackout.allheale)
  if not actions.blackout_allheale then return end

  bals.allheale = false
  killaction(dict.blackout.allheale)
  checkaction (dict.$(aff).gone, true)
  lifevision.add(dict.$(aff).gone)
end
#end
#end

-- normal salves
#for _, salve in pairs({
#melancholic  = {"blacklung", "puncturedlung", "asthma", "dizziness", "sensitivity", "trembling", "shortbreath", "vapors"},
#mending      = {"slitthroat", "brokenjaw", "fracturedskull", "twistedrightleg", "twistedleftleg"},
#regeneration = {"collapsedleftnerve", "collapsedrightnerve", "crackedleftelbow", "crackedrightelbow", "tendonleft", "tendonright", "crackedleftkneecap", "crackedrightkneecap", "crushedchest", "collapsedlungs", "rupturedstomach", "disembowel", "concussion", "severedspine", "shatteredjaw", "eyepeckleft", "eyepeckright", "shatteredleftankle", "shatteredrightankle", "chestpain", "burstorgans"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(salve) do
#temp[#temp+1] = encodes(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(salve) do
function valid.salve_cured_$(aff)()
  local result = checkany(dict.$(aff).salve, $(checkany_string))

  if not result then return end

  apply_cure = true
  if result.name == "$(aff)_salve" then
    lifevision.add(actions.$(aff)_salve.p)
  else
    killaction(dict[result.action_name].salve)
    checkaction(dict.$(aff).salve, true)
    lifevision.add(dict.$(aff).salve)
  end
end

#end
#end

-- normal ice
#for _, ice in pairs({
#ice = {"damagedskull","damagedthroat","collapsedlungs","crushedchest","damagedorgans","internalbleeding","damagedleftarm","mutilatedleftarm","damagedrightarm","mutilatedrightarm","damagedleftleg","mutilatedleftleg","damagedrightleg","mutilatedrightleg"}}) do
#local checkany_string = ""
#local temp = {}

#for _, aff in pairs(ice) do
#temp[#temp+1] = encodeice(aff)
#end
#checkany_string = table.concat(temp, ", ")

#for _, aff in pairs(ice) do
function valid.ice_cured_$(aff)()
  local result = checkany(dict.$(aff).ice, $(checkany_string))
  if not result then return end

  apply_ice = true
  if result.name == "$(aff)_ice" then
    lifevision.add(actions.$(aff)_ice.p)
  else
    killaction(dict[result.action_name].ice)
    checkaction(dict.$(aff).ice, true)
    lifevision.add(dict.$(aff).ice)
  end
end

#end
#end

-- normal waitingfors
#for _, aff in ipairs({"collapsedlungs", "disembowel", "crushedchest", "rupturedstomach", "collapsedleftnerve", "collapsedrightnerve", "severedspine", "concussion", "damagedhead", "shatteredjaw", "chestpain", "burstorgans", "damagedskull","damagedthroat","damagedorgans","internalbleeding","damagedleftarm","damagedrightarm","damagedleftleg","damagedrightleg","mutilatedleftarm","mutilatedrightarm","mutilatedleftleg","mutilatedrightleg"}) do
function valid.cured$(aff)()
  checkaction(dict.curing$(aff).waitingfor)
  if actions.curing$(aff)_waitingfor then
    lifevision.add(actions.curing$(aff)_waitingfor.p)
  end
end
#end

#for _, aff in ipairs({"eyepeckleft", "eyepeckright"}) do
function valid.cured$(aff)()
  local r = checkany(dict.curingeyepeckleft.waitingfor, dict.curingeyepeckright.waitingfor)

  if not r then return end

  if r.action_name == "curing$(aff)_waitingfor" then
    lifevision.add(actions.curing$(aff)_waitingfor.p)
  else
    killaction(dict[r.action_name].waitingfor)
    checkaction (dict.curing$(aff).waitingfor, true)
    lifevision.add(actions.curing$(aff)_waitingfor.p)
  end
end
#end

-- slightly special damagedhead - it has two 'stages'
function valid.partiallycureddamagedhead()
 checkaction(dict.curingdamagedhead.waitingfor)
  if actions.curingdamagedhead_waitingfor then
    lifevision.add(actions.curingdamagedhead_waitingfor.p, "partial")
  end
end

-- special defences

function defs.getting_trueblind()
  local r = checkany(dict.trueblind.herb, dict.blind.herb, dict.trueblind.wafer, dict.blind.wafer)

  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "gettingtrueblind")
end

function valid.ate_afterimage()
  local r = checkany(dict.trueblind.herb, dict.blind.herb, dict.trueblind.wafer, dict.blind.wafer)

  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "afterimage")
end

function valid.herb_failed_bedevil()
  local r = checkany(dict.bedevil.herb, dict.minortimewarp.herb, dict.egovice.herb, dict.healthleech.herb, dict.recklessness.herb, dict.achromaticaura.herb, dict.powerspikes.herb, dict.moderatetimewarp.herb, dict.dissonance.herb, dict.majortimewarp.herb, dict.manabarbs.herb, dict.massivetimewarp.herb)

  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "failed")
end

function valid.bedevil_steam()
  mm.valid.simplerecklessness()
  mm.knownaff = true
end

function valid.bedevil_lucidity()
  mm.valid.simplepacifism()
  mm.knownaff = true
end

function valid.herb_failed_jitterbug()
  local eating = findbybal("herb")
  local wafer_ate = findbybal("wafer")

  if not wafer_ate and not eating then return end

  herb_cure = true
  if eating then
    sk.lostbal_herb()
    killaction(dict[eating.action_name].herb)
  elseif wafer_ate then
    sk.lostbal_wafer()
    killaction(dict[wafer_ate.action_name].wafer)
  end

end

function valid.steam_failed_jitterbug()
  local smoking = findbybal("steam")

  if not smoking then return end
  smoke_cure = true
  sk.lostbal_steam()
  killaction(dict[smoking.action_name].steam)
end

function valid.lucidity_failed_jitterbug()
  local sipping = findbybal("lucidity")

  if not sipping then return end
  sip_cure = true
  sk.lostbal_lucidity()
  killaction(dict[smoking.action_name].lucidity)
end

function valid.herb_failed_aurawarp()
  local r = checkany(dict.aurawarp.herb)

  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "failed")
end

function defs.alreadygot_trueblind()
  local r = checkany(dict.trueblind.herb, dict.blind.herb, dict.trueblind.wafer, dict.blind.wafer)

  if not r then return end

  herb_cure = true
  if r.action_name == "trueblind_herb" then
    lifevision.add(actions.trueblind_herb.p, "alreadygot")
  elseif r.action_name == "trueblind_wafer" then
    lifevision.add(actions.trueblind_wafer.p, "alreadygot")
  else
    killaction(dict[r.action_name].herb)
    checkaction (dict.trueblind.wafer, true)
    lifevision.add(actions.trueblind_wafer.p, "alreadygot")
  end
end

function valid.ate_sparkle()
  local result = checkany(
    dict.healhealth.sparkle, dict.healhealth.herb,
    dict.healmana.sparkle, dict.healmana.herb,
    dict.healego.sparkle, dict.healego.herb)

  if not result then return end

  -- if vessels already got it, don't add anything else
  -- if herb_cure then debugf("ate_sparkle: herb_cure already set") return end -- temp disabled to help with double-eating in allheale, should check actions instead? also herb_cure reference seems to be leaking from somewhere

  herb_cure = true
  lifevision.add(actions[result.name].p)
end

function valid.scroll_healed()
  local r = checkany(dict.healhealth.scroll, dict.healmana.scroll, dict.healego.scroll)
  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p)
end

function valid.scroll_noeffect()
  local r = checkany(dict.healhealth.scroll, dict.healmana.scroll, dict.healego.scroll)
  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "noeffect")
end

function valid.sour_sparkle()
  local r = checkany(dict.healhealth.herb, dict.healmana.herb, dict.healego.herb) or findbybal("sparkle")
  if not r then return end

  herb_cure = true
  lifevision.add(actions[r.name].p, "sour")
end

function defs.curedblind()
  local result = checkany(dict.trueblind.herb, dict.blind.herb, dict.trueblind.wafer, dict.blind.wafer)
  if not result then return end


  herb_cure = true
  if actions.trueblind_herb then
    lifevision.add(actions.trueblind_herb.p, "curedblind")
  elseif actions.blind_herb then
    lifevision.add(actions.blind_herb.p)
  elseif actions.trueblind_wafer then
    lifevision.add(actions.trueblind_wafer.p, "curedblind")
  elseif actions.blind_wafer then
    lifevision.add(actions.blind_wafer.p)
  end
end

function defs.got_trueblind()
  checkaction(dict.waitingontrueblind.waitingfor)
  if actions.waitingontrueblind_waitingfor then
    lifevision.add(actions.waitingontrueblind_waitingfor.p)
  end
end

function defs.got_truedeaf()
  local result = checkany (dict.truedeaf.steam, dict.attraction.steam, dict.deaf.steam)

  if not result and conf.aillusion then
    return
  elseif not result and not conf.aillusion then
    checkaction (dict.truedeaf.steam, true)
    lifevision.add(actions.truedeaf_steam.p)
    return
  end

  herb_cure = true
  if result.action_name == "truedeaf" then
    lifevision.add(actions.truedeaf_steam.p)

    if affs.attraction then
      checkaction (dict.attraction.steam, true)
      lifevision.add(actions.attraction_steam.p)
    end
  else
    killaction(dict[result.action_name].steam)
    checkaction (dict.truedeaf.steam, true)
    checkaction (dict.attraction.steam, true)
    lifevision.add(actions.truedeaf_steam.p)
    lifevision.add(actions.attraction_steam.p)
  end
end

function defs.cureddeaf()
  local result = checkany (dict.truedeaf.steam, dict.deaf.steam)
  if not result then return end


  herb_cure = true
  if actions.truedeaf_steam then
    lifevision.add(actions.truedeaf_steam.p, "cureddeaf")
  elseif actions.deaf_steam then
    lifevision.add(actions.deaf_steam.p)
  end
end

function defs.gotherb_insomnia()
  checkaction(dict.insomnia.herb)

  herb_cure = true
  if actions.insomnia_herb then
    lifevision.add(actions.insomnia_herb.p)
  end
end

function defs.gotskill_insomnia()
  checkaction(dict.insomnia.misc)
  if actions.insomnia_misc then
    lifevision.add(actions.insomnia_misc.p)
  end
end

function valid.insomnia_hypersomnia()
  checkaction(dict.insomnia.misc)
  if actions.insomnia_misc then
    lifevision.add(actions.insomnia_misc.p, "hypersomnia")
  end
end

function valid.symp_narcolepsy()
  local r = checkany(dict.insomnia.misc, dict.insomnia.herb)
  if not r then return end
  lifevision.add(actions[r.name].p, "narcolepsy")
end

function defs.got_kafe()
  checkaction(dict.kafe.herb)

  herb_cure = true
  if actions.kafe_herb then
    lifevision.add(actions.kafe_herb.p)
  end
end

function valid.sipped_allheale()
  sip_cure = true
end

#for i, aff in ipairs({"confusion", "hallucinating", "addiction", "clumsiness", "dizziness", "epilepsy", "paralysis"}) do
function valid.rainbowpattern_$(aff)()
  if conf.aillusion and not actions.rainbowpattern_waitingfor then return end

  checkaction(dict.$(aff).aff, true)
  if actions["$(aff)_aff"] then
    lifevision.add(actions["$(aff)_aff"].p)
  end
end
#end



local generic_cures_data = {
  "clumsiness", "paranoia", "gluttony", "vertigo", "agoraphobia", "vestiphobia", "dizziness", "claustrophobia", "vapors", "recklessness", "epilepsy", "peace", "dementia", "addiction", "stupidity", "jinx", "healthleech", "sensitivity", "succumb", "arteryleftleg", "arteryleftarm", "arteryrightleg", "arteryrightarm", "slicedforehead", "opengut", "slicedleftthigh", "slicedrightthigh", "missingleftear", "missingrightear", "puncturedchest", "relapsing", "slickness", "laceratedleftarm", "laceratedrightarm", "laceratedrightleg", "laceratedleftleg", "laceratedunknown", "inlove", "achromaticaura", "slicedtongue", "clotleftshoulder", "clotrightshoulder", "clotrighthip", "clotlefthip", "gashedcheek", "weakness", "hallucinating", "rigormortis", "scrambledbrain", "openchest", "pacifism", "void", "confusion", "egovice", "manabarbs", "powerspikes", "achromaticaura", "slicedleftbicep", "slicedrightbicep", "bleeding", "puncturedaura",  "brokennose", "crushedleftfoot", "crushedrightfoot", "snappedrib", "fracturedleftarm", "fracturedrightarm", "crotamine", "healthleech", "powersap", "vomiting", "haemophilia", "weakness", "worms", "ablaze", "vomitblood", "dysentery", "scalped", "disloyalty", "shivering", "frozen", "dysentery", "furrowedbrow", "shyness", "confusion", "lovepotion", "sensitivity", "dizziness", "brokenjaw", "slitthroat", "pox", "scabies", "asthma", "blacklung", "puncturedlung", "crippledrightarm", "crippledleftarm", "crippledrightleg", "crippledleftleg", "fracturedskull", "sunallergy", "twistedleftleg", "twistedrightleg", "twistedleftarm", "twistedrightarm", "brokenrightwrist", "brokenleftwrist", "trembling", "shortbreath", "firstdegreeburn", "masochism", "impatience", "anorexia", "crushedwindpipe", "piercedleftleg", "piercedrightleg", "piercedleftarm", "piercedrightarm", "hemiplegyleft", "hemiplegyright", "hemiplegylower", "severedphrenic", "loneliness", "shyness", "cloudcoils", "loneliness", "masochism", "pacifism", "paranoia", "recklessness", "shyness", "stupidity", "vertigo", "void", "weakness", "addiction", "agoraphobia", "anorexia", "claustrophobia", "confusion", "dizziness", "epilepsy", "vestiphobia", "hallucinating", "treebane", "illuminated", "mud", "sap", "slickness", "slightinsanity", "moderateinsanity", "majorinsanity", "massiveinsanity", "impatience", "healhealth", "hypersomnia", "brokenchest", "daydreaming", "narcolepsy", "insomnia", "fear", "minortimewarp", "moderatetimewarp", "majortimewarp", "massivetimewarp", "oracle", "collapsedlungs", "hypochondria", "severedspine", "paralysis", "healego", "healmana", "avengingangel", "omniphobia", "aurawarp", "aeon", "completelyaurawarped","massivelyaurawarped","aurawarped","moderatelyaurawarped","slightlyaurawarped"
}

for i = 1, #generic_cures_data do
  local aff = generic_cures_data[i]

  valid["generic_"..aff] = function ()

    allheale_cure = false -- please allheale

    -- passive curing...
    if passive_cure_paragraph and dict[aff].gone then
      checkaction(dict[aff].gone, true)
      if actions[aff .. "_gone"] then
        lifevision.add(actions[aff .. "_gone"].p)
      end
      return
    end

    -- ... or something we caused.
    if actions_performed[aff] then
      lifevision.add(actions[actions_performed[aff].name].p)

    -- if it's not something we were directly doing, try to link by balances
    else
      local result

      for j,k in actions:iter() do
#if DEBUG then
        if not k then
          debugf("[m&mf error]: no k here, j is %s. Actions list:", tostring(j))
          for m,n in actions:iter() do
            debugf("%s - %s", tostring(m), tostring(n))
          end
        end
#end
        if k and k.p.balance ~= "waitingfor" and dict[aff][k.p.balance] then result = k.p break end
      end

      if not result then return end

#if DEBUG then
      debugf("Result is %s for aff %s", tostring(result.name), aff)
#end
      killaction(dict[result.action_name][result.balance])

      checkaction(dict[aff][result.balance], true)
      lifevision.add(dict[aff][result.balance])
    end
  end
end

disable_generic_trigs = function ()
  disableTrigger("General cures")
  enableTrigger("Ate")
  enableTrigger("Arnica")
  enableTrigger("Sip")
  enableTrigger("Applied")
  enableTrigger("Applied for burns")
  enableTrigger("Smoke")
  enableTrigger("Cleanse")
end

enable_generic_trigs = function ()
  enableTrigger("General cures")
  disableTrigger("Ate")
  disableTrigger("Arnica")
  disableTrigger("Sip")
  disableTrigger("Applied")
  disableTrigger("Applied for burns")
  disableTrigger("Smoke")
  disableTrigger("Cleanse")
end

check_generics = function ()
  if affs.blackout and not generics_enabled then
    generics_enabled = true
    generics_enabled_for_blackout = true
    enable_generic_trigs()
    echo("\n")
    echof("Enabled blackout curing.")
  elseif generics_enabled and generics_enabled_for_blackout and not affs.blackout then
    generics_enabled_for_blackout, generics_enabled = false, false
    disable_generic_trigs()
    echo("\n")
    echof("Out of blackout, disabled blackout curing.")
  elseif passive_cure_paragraph and not generics_enabled and not generics_enabled_for_passive then
    generics_enabled_for_passive, generics_enabled = true, true
    enable_generic_trigs ()
  elseif not passive_cure_paragraph and generics_enabled and generics_enabled_for_passive then
    generics_enabled_for_passive, generics_enabled = false, false
    disable_generic_trigs ()
  end
end
disable_generic_trigs()
check_generics()

signals.systemstart:connect(function ()
  disableTrigger("General cures")
  disableTrigger("Allheale cures")
  if conf.aillusion then enableTrigger("Pre-parse anti-illusion")
  else disableTrigger("Pre-parse anti-illusion") end
end)

-- passive cures
function valid.passive_cure()
  passive_cure_paragraph = true
  check_generics()
  sk.onprompt_beforeaction_add("check generics", function () passive_cure_paragraph = false; check_generics() end)
  signals.after_lifevision_processing:unblock(cnrl.checkwarning)
end

function valid.lowmagic_green()
  checkaction(dict.powercure.physical)
  if actions.powercure_physical then
    valid.passive_cure()
    lifevision.add(actions.powercure_physical.p)
  end
end

function valid.lowmagic_summer()
  checkaction (dict.magicwrithe.physical)
  if actions.magicwrithe_physical then
    lifevision.add(actions.magicwrithe_physical.p)
  end
end

function valid.highmagic_tipheret()
  checkaction (dict.magicwrithe.physical)
  if actions.magicwrithe_physical then
    lifevision.add(actions.magicwrithe_physical.p)
  end
end

function valid.highmagic_gedulah()
  checkaction(dict.powercure.physical)
  if actions.powercure_physical then
    valid.passive_cure()
    lifevision.add(actions.powercure_physical.p)
  end
end

#if skills.night then
valid.shadowdrink = valid.passive_cure
#else
valid.shadowdrink = function () end
#end

#if skills.healing then
sk.check_emptyheal = function ()
  if sk.currenthealcount+1 == getLineCount() then
    lifevision.add(actions.usehealing_misc.p, "empty")
  else
    lifevision.add(actions.usehealing_misc.p)
  end

  signals.before_prompt_processing:disconnect(sk.check_emptyheal)
end

valid.healing_cured_insomnia = function ()
  lifevision.add(actions.usehealing_misc.p, "empty")
  signals.before_prompt_processing:disconnect(sk.check_emptyheal)
end

valid.healercure = function ()
  checkaction(dict.usehealing.misc)
  if actions.usehealing_misc then
    sk.currenthealcount = getLineCount()
    signals.before_prompt_processing:connect(sk.check_emptyheal)
    valid.passive_cure()

    -- check for maestoso messing things up
    tempLineTrigger(1,1,[[
      if line == "A strange vibration prevents you from healing auric ailments." then
        mm.valid.simplemaestoso()
      end
    ]])
  end
end
#else
valid.healercure = function () end
valid.healing_cured_insomnia = valid.healercure
#end

function valid.got_blind()
  sk.onprompt_beforeaction_add("hypochondria_blind", function ()
    if not affs.blind then
      valid.simplehypochondria()
    end
  end)
end

function valid.proper_crippledrightleg()
  if not vm.last_line_was_prompt() then
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        if getCurrentLine() ~= "The hardened bones of your right leg begin to vibrate." then
          mm.valid.simplecrippledrightleg()
        end]])
#else
    valid.simplecrippledrightleg()
#end
  else
    sk.hypochondria_symptom()
  end
end
function valid.proper_crippledleftleg()
  if not vm.last_line_was_prompt() then
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        if getCurrentLine() ~= "The hardened bones of your left leg begin to vibrate." then
          mm.valid.simplecrippledleftleg()
        end]])
#else
    valid.simplecrippledleftleg()
#end
  else
    sk.hypochondria_symptom()
  end
end
function valid.proper_clumsiness()
  if not vm.last_line_was_prompt() then
    valid.simpleclumsiness()
  else
    sk.hypochondria_symptom()
  end
end
function valid.proper_weakness()
  if not vm.last_line_was_prompt() then
    valid.simpleweakness()
  else
    sk.hypochondria_symptom()
  end
end

function valid.proper_disloyalty()
    valid.simpledisloyalty()
end

function valid.proper_powersap()
  if paragraph_length  > 1 then
    valid.simplepowersap()
  else

    local old_power = stats.currentpower
    sk.onprompt_beforeaction_add("powersap check", function ()
      if stats.currentpower == (old_power - 1) then
        valid.simplepowersap()
      else
        sk.hypochondria_symptom()
      end
    end)
  end
end

function valid.proper_slickness()
  if not conf.aillusion then
    valid.simpleslickness()
  else
    checkaction(dict.checkslickness.aff, true)
    lifevision.add(actions.checkslickness_aff.p)
  end
end

function valid.proper_recklessness()
  if not vm.last_line_was_prompt() then
    valid.simplerecklessness()
  else
    sk.hypochondria_symptom()
  end
end
function valid.proper_crippledleftarm()
  if not vm.last_line_was_prompt() then
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        if getCurrentLine() ~= "The hardened bones of your left arm begin to vibrate." then
          mm.valid.simplecrippledleftarm()
        end]])
#else
    valid.simplecrippledleftarm()
#end
  else
    sk.hypochondria_symptom()
  end
end
function valid.proper_crippledrightarm()
  if not vm.last_line_was_prompt() then
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        if getCurrentLine() ~= "The hardened bones of your right arm begin to vibrate." then
          mm.valid.simplecrippledrightarm()
        end]])
#else
    valid.simplecrippledrightarm()
#end
  else
    sk.hypochondria_symptom()
  end
end

function valid.proper_unknowncrippledarm()
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        local line = getCurrentLine()
        if line ~= "The hardened bones of your right arm begin to vibrate." and "The hardened bones of your left arm begin to vibrate." then
          mm.valid.simpleunknowncrippledarm()
        end]])
#else
    valid.simpleunknowncrippledarm()
#end
end

function valid.proper_unknowncrippledleg()
#if skills.psychometabolism then
      tempLineTrigger(1,1,[[
        local line = getCurrentLine()
        if line ~= "The hardened bones of your right leg begin to vibrate." and "The hardened bones of your left leg begin to vibrate." then
          mm.valid.simpleunknowncrippledleg()
        end]])
#else
    valid.simpleunknowncrippledleg()
#end
end

function valid.lost_arena()
  sk.onprompt_beforeaction_add("arena_death",
    function ()
      if find_until_last_paragraph("^You see", true) and find_until_last_paragraph("^You have been slain", true) then
        echof("I'm sorry =(")

        reset.affs()
        reset.defs()
      end
    end
  )
end

function valid.lost_ffa()
  local oldroom = (atcp.RoomNum or gmcp.Room.Info.num)
  sk.onprompt_beforeaction_add("arena_death",
    function ()
      if oldroom ~= (atcp.RoomNum or gmcp.Room.Info.num) then
        reset.affs()
        reset.defs()
      end
    end)
end

function valid.won_arena()
  echo"\n"
  echof("You won!")

  -- rebounding coming up gets killed
  if actions.waitingonrebounding_waitingfor then
    killaction(dict.waitingonrebounding.waitingfor)
  end

  reset.affs()
end

function valid.died()
  if line == "As your soul leaves your body, the elixir vitae courses through your spirit and suddenly bursts in a bright light, forming a new body around your soul." then
    sk.onprompt_beforeaction_add("death",
      function ()
        if affs.recklessness or (stats.currenthealth == stats.maxhealth and stats.currentmana == stats.maxmana and stats.currentego == stats.maxego) then
          reset.affs()
          reset.defs()
          echo "\n" echof("We hit vitae!")
          signals.before_prompt_processing:unblock(valid.check_life)
          if type(conf.burstmode) == "string" then
            echof("Auto-switching to %s defences mode.", conf.burstmode)
            defs.switch(conf.burstmode, false)
          end
        end
      end)
  else
    sk.onprompt_beforeaction_add("death",
      function ()
        if affs.recklessness or stats.currenthealth == 0 then
          reset.affs()
          reset.defs()
          inamodule = false
          echo "\n"
          if math.random(1,10) == 1 then
            echo[[



                   __, _ __,   _, _ __,
                   |_) | |_)   |\/| |_
                   | \ | |     |  | |
                   ~ ~ ~ ~     ~  ~ ~~~


 ]]
          elseif conf.org == "Magnagora" and math.random(1,10) == 1 then
            echo"\n"echof("Vrrr puuh puuh... klank klank.")
          elseif math.random(1, 10) == 1 then
            echo"\n"echof("We died. Again.")
          else
            echo"\n"echof("We died.") end
          conf.paused = true
          raiseEvent("m&m config changed", "paused")
          signals.before_prompt_processing:unblock(valid.check_life)
        end
      end)
  end
end

function valid.transmigrated()
    sk.onprompt_beforeaction_add("transmigrated",
      function ()
        if stats.currenthealth == 0 then
          reset.affs()
          reset.defs()
          inamodule = false
          echo "\n"
          echo"\n"echof("We died, going to transmigrate.")
          conf.paused = true
          raiseEvent("m&m config changed", "paused")
          signals.before_prompt_processing:unblock(valid.check_life)
        end
      end)
end

function valid.check_life()
  if stats.currenthealth ~= 0 then
    echo"\n" echof("Welcome back to life! System unpaused.")
    conf.paused = false
    raiseEvent("m&m config changed", "paused")
    signals.before_prompt_processing:block(valid.check_life)
  end
end

signals.before_prompt_processing:connect(valid.check_life)
signals.before_prompt_processing:block(valid.check_life)

#if skills.psionics then
function defs.got_trueblind()
  local r = checkany(dict.waitingontrueblind.waitingfor, dict.waitingonsecondsight.waitingfor)
  if not r then return end

  lifevision.add(actions[r.name].p)
end
function defs.getting_secondsight()
  checkaction(dict.secondsight.physical)

  if actions.secondsight_physical then
    lifevision.add(actions.secondsight_physical.p)
  end
end
function defs.alreadygot_secondsight()
  checkaction(dict.secondsight.physical)

  if actions.secondsight_physical then
    lifevision.add(actions.secondsight_physical.p, "alreadygot")
  end
end
#end

valid.generic_ate_sparkle = valid.ate_sparkle;

function valid.ceased_wielding()
  for _, t in pairs(me.wielded) do
    if line:find(t.name, 1, true) then
      unwielded(t)
    end
  end
end

function valid.rewield_failed()
  checkaction(dict.rewield.physical)
  if actions.rewield_physical then
    lifevision.add(actions.rewield_physical.p, "failed")
  end
end

function valid.deepheal_me_partial(whichlimb)
  checkaction(dict.deepheal.physical)
  if actions.deepheal_physical then
    lifevision.add(actions.deepheal_physical.p, "partial", whichlimb:gsub(" ", ""))
  end
end

function valid.deepheal_me_full(whichlimb)
  checkaction(dict.deepheal.physical)
  if actions.deepheal_physical then
    lifevision.add(actions.deepheal_physical.p, nil, whichlimb:gsub(" ", ""))
  end
end

function valid.puer_me_partial(whichlimb)
  checkaction(dict.puer.physical, true)
  if actions.puer_physical then
    lifevision.add(actions.puer_physical.p, "partial", whichlimb:gsub(" ", ""))
  end
end

function valid.puer_me_full(whichlimb)
  checkaction(dict.puer.physical, true)
  if actions.puer_physical then
    lifevision.add(actions.puer_physical.p, nil, whichlimb:gsub(" ", ""))
  end
end

function valid.healspring(whichlimb, type)
  checkaction(dict.healspring.physical, true)
  if actions.healspring_physical then
    lifevision.add(actions.healspring_physical.p, type, whichlimb:gsub(" ", ""))
  end
end

function valid.reflection_cancelled()
  if conf.aillusion and paragraph_length == 1 then ignore_illusion("This can't come out of the blue!") return end

  for _, action in pairs(lifevision.l:keys()) do
    if action:find("_aff", 1, true) then
      killaction(dict[action:match("(%w+)_")].aff)

      -- typically, you'd only have one aff per prompt - so no need to complicate by optimizing
      selectCurrentLine()
      fg("MediumSlateBlue")
      deselect()
      resetFormat()
    end
  end
end

function valid.self_trueheal()
  if conf.aillusion and not (lastpromptnumber+1 == getLineNumber("main")) then return end

  reset.affs()
end

valid.other_trueheal = valid.self_trueheal

-- we check the lifevision queue (since it's in order) for the first _aff action above us, and kill that. We might get multiple affs per para, and don't want to kill the wrong ones - this way seems to be the most failsafe.
function valid.runic_negated()
  local lifevision = lifevision
  for _, action in ripairs(lifevision) do
    if action:find("_aff", 1, true) then
      killaction(dict[action:match("^(%w+)_")].aff)
      return
    end
  end

  -- check fire def from isa as well
  if table.contains(lifevision, "fire_gone") then
    killaction(dict.fire.gone)
  end
end

function valid.bone_nose()
  local actions = lifevision.l:keys()
  local negated_affs = {
    "crippledrightleg_aff",
    "crippledleftleg_aff",
    "unknowncrippledleg_aff",
    "crippledrightarm_aff",
    "crippledleftarm_aff",
    "unknowncrippledarm_aff",
  }
  local affs_to_cancel = table.n_intersection(actions, negated_affs)

  for _, action in pairs(affs_to_cancel) do
    killaction(dict[action:match("(%w+)_")].aff)
  end
end

function valid.gnosis_negated(which)
#if skills.paradigmatics then

  local which = dict[which] and which or afftranslation[which]

  if which == "tangle" then
#if skills.crow then
    signals.before_prompt_processing:disconnect(sk.crow_tanglecheckf)
#else
    signals.before_prompt_processing:disconnect(sk.normal_tanglecheckf)
#end
  end

  if actions[which.."_aff"] then
    killaction(dict[which].aff)
  elseif actions.unknownany_aff then
    killaction(dict.unknownany.aff)
  elseif actions.unknownmental_aff then
    killaction(dict.unknownmental.aff)
  end
#end
end

function valid.future_glimpse(which)
#if skills.aeonics then
  -- translate game name to m&mf name, if necessary
  local which = dict[which] and which or afftranslation[which]

  if which == "tangle" then
#if skills.crow then
    signals.before_prompt_processing:disconnect(sk.crow_tanglecheckf)
#else
    signals.before_prompt_processing:disconnect(sk.normal_tanglecheckf)
#end
  end

  if actions[which.."_aff"] then
    killaction(dict[which].aff)
  elseif actions.unknownany_aff then
    killaction(dict.unknownany.aff)
  elseif actions.unknownmental_aff then
    killaction(dict.unknownmental.aff)
  end
#end
end

function valid.dizziness()
  valid.simpledizziness()
  valid.proper_blind()
end

function valid.nihi_ectoplasm()
  if not mm.conf.aillusion or (mm.conf.aillusion and mm.paragraph_length == 0) then
    -- special case: return isPrompt() handles illusions for us
    addaff(dict.ectoplasm)
    make_gnomes_work()
  end
end

function valid.chaos_negated()
  local actions = lifevision.l:keys()
  local negated_affs = {}

  for aff, afft in pairs(dict) do
    if afft.focus then negated_affs[#negated_affs+1] = aff .. "_aff" end
  end

  local affs_to_cancel = table.n_intersection(actions, negated_affs)

  if next(affs_to_cancel) then
    for _, action in pairs(affs_to_cancel) do
      killaction(dict[action:match("(%w+)_")].aff)
    end
  elseif actions.unknownany_aff then
    killaction(dict.unknownany.aff)
  elseif actions.unknownmental_aff then
    killaction(dict.unknownmental.aff)
  end
end


function valid.death_negated()
  local actions = lifevision.l:keys()
  local negated_affs = {"worms_aff", "rigormortis_aff", "epilepsy_aff", "pox_aff", "scabies_aff", "stupidity_aff", "sensitivity_aff", "paranoia_aff"}

  local affs_to_cancel = table.n_intersection(actions, negated_affs)

  if next(affs_to_cancel) then
    for _, action in pairs(affs_to_cancel) do
      killaction(dict[action:match("(%w+)_")].aff)
    end
  elseif actions.unknownany_aff then
    killaction(dict.unknownany.aff)
  elseif actions.unknownmental_aff then
    killaction(dict.unknownmental.aff)
  end
end

function valid.symp_dizzy()
  -- if not conf.aillusion or paragraph_length ~= 0 then
    defs.lost_truedeaf()
    valid.simpledeaf()
    valid.simpledizziness()
  -- end
end

function valid.proper_shadowtwist()
  defs.lost_quicksilver()

  -- basic twist is 10% manadrain - if we get hit for 15+%, it was the final one
  local oldhealth = stats.currentmana
  local have_pflag = pflags.p
  sk.onprompt_beforeaction_add("asleep_masochism", function ()
    if (100/stats.maxmana*(oldhealth-stats.currentmana)) > 15 then
      valid.proper_aeon()
      valid.simplestun(4)
    -- elseif not have_pflag and pflags.p then : stun can give the prompt flag as well
    --   defs.lost_insomnia()
    --   valid.simplesleep()
    --   valid.simpleprone()
    else
      checkaction(dict.checkslows.aff, true)
      lifevision.add(actions.checkslows_aff.p, nil, "aeon")
      if not conf.paused then send'x' end
    end
  end)
end

sk.bullkick_check = function ()
  if not find_until_last_paragraph("You resist the attempt to move you.") and not find_until_last_paragraph("Your expert balance allows you to remain standing.") then
    valid.simpleprone()
  end

   signals.before_prompt_processing:disconnect(sk.bullkick_check)
end


function valid.bullkick()
  signals.before_prompt_processing:connect(sk.bullkick_check)
end

function valid.maestoso_woreoff()
  if affs.maestoso then
    checkaction(dict.maestoso.gone, true)
    lifevision.add(actions.maestoso_gone.p)
  end
end

function valid.kneecap_stance()
  if actions.dostance_misc then
    valid.simplecrackedunknownkneecap()
    killaction(dict.dostance.misc)
  end
end

function valid.tendon_springup()
  if actions.prone_misc then
    valid.simpletendonunknown()
    killaction(dict.prone.misc)
  end
end

function valid.sacrifice()
  checkaction(dict.sacrifice.happened, true)
  lifevision.add(actions.sacrifice_happened.p)
end

-- cancels transfix for:
-- Mary weaves her hands towards you and light erupts into fascinating patterns that overwhelm your senses. <- simpletransfix
-- Vision returns, though you no longer see the world through the sixth sense. <- cancel the said simpletransfix
function valid.flare_negated()
  valid.lost_blind()

  if actions.transfixed_aff then
    killaction(dict.transfixed.aff)
  end
end

function valid.lostwaferbalance()
  checkaction(dict.stolebalance.happened, true)
  lifevision.add(actions.stolebalance_happened.p, nil, "wafer")
end

function valid.notarget()
  if actions.checkparalysis_misc then
    lifevision.add(actions.checkparalysis_misc.p, "onclear")
  end

  if actions.healhealth_sip and conf.medicinebag and me.activeskills.stag then
    config.set("medicinebag",false,true)
  end
end

function valid.knownaff()
  knownaff = true
end

function valid.removeknownaff()
  knownaff = nil
end

function valid.have_artifact(arty)
  mm.me.artifacts[arty] = true
end

function valid.healingflay()
  if table.size(mm.affl)>0 then
    valid.simpleunknownany()
  end
end



