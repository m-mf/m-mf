-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

pl.dir.makepath(getMudletHomeDir() .. "/m&m/config")

sps.sp_fillup = function ()
  local t = {}
  for limb, _ in pairs(sp_limbs) do
    t[limb] = 0
  end
  return t
end

sps.sp_filldata = function (actionlevel)
  local t = {}
  for i = 1, #sp_config.priority do
    local limb = sp_config.priority[i]
    --debugf("limb (%s), actionlevel (%s), count (%s)", tostring(limb), tostring(sp_config[actionlevel][limb]), tostring(dict["light"..limb].count))
    -- type of a limb can be set to a boolean false, ie ignore in calculations
    if type(sp_config[actionlevel][limb]) == "number" and dict[string.format("light%s", limb)].count > sp_config[actionlevel][limb] then
      t[limb] = dict[string.format("light%s", limb)].count - sp_config[actionlevel][limb]
    end
  end
  return t
end

sps.all_stance_skills = phpTable (
  {legs   = {"rightleg", "leftleg"}},
  {left   = {"leftleg", "leftarm"}},
  {right  = {"rightarm", "rightleg"}},
  {arms   = {"rightarm", "leftarm"}},
  {gut    = {"gut"}},
  {chest  = {"chest"}},
  {head   = {"head"}},
  {lower  = {"gut", "rightleg", "leftleg"}},
  {middle = {"rightarm", "leftarm", "chest", "gut"}},
  {upper  = {"leftarm", "rightarm", "chest", "head"}},
  {vitals = {"gut", "chest", "head"}}
)

sk.update_sk_data = function ()
  -- rightleg = {legs = {}, right = {}}
  sps.stance_limbs = {}
  sps.stance_skills_count = {}
  sp_config.stance_shouldbe = sp_config.default_stance or ""

  if type(sp_config.stance_skills) ~= "table" or not next(sp_config.stance_skills) then return end

  -- make links
  for skill, skillt in sps.all_stance_skills:pairs() do
    if contains(sp_config.stance_skills, skill) then
      for _, limb in pairs(skillt) do
        if not sps.stance_limbs[limb] then
          sps.stance_limbs[limb] = {[skill] = skillt};
        elseif not sps.stance_limbs[limb][skill] then
          sps.stance_limbs[limb][skill] = skillt; end
      end
    end
  end

  -- legs = 2, head = 1, lower = 3, etc.
  for skill, skillt in sps.all_stance_skills:pairs() do
    if contains(sp_config.stance_skills, skill) then
      sps.stance_skills_count[skill] = table.size(skillt)
    end
  end
end

signals.systemstart:connect(sk.update_sk_data)


sk.update_actionlevels = function ()
  for part, al in pairs(sp_config.stance_actionlevel) do
    if al > 100 then
      sp_config.old_stance_actionlevel[part] = al
      sp_config.stance_actionlevel[part] = math.floor(al/100)
    end
  end

  for part, al in pairs(sp_config.parry_actionlevel) do
    if al > 100 then
      sp_config.old_parry_actionlevel[part] = al
      sp_config.parry_actionlevel[part] = math.floor(al/100)
    end
  end

  local min, max = 100, 0
  for part, al in pairs(sp_config.parry_actionlevel) do
    if al < min then
      min = al
    elseif al > max then
      max = al
    end
  end

  if max < 15 and min < 5 then
    for part, al in pairs(sp_config.parry_actionlevel) do
      sp_config.parry_actionlevel[part] = al*5
    end
  end

  echof("stance/parry actionlevels updated for warrior overhaul")
end

signals.systemstart:connect(sk.update_actionlevels)

sp_config = { stance = "", parry = "", priority = {}, parry_actionlevel = {}, stance_actionlevel = {}, parry_shouldbe = sps.sp_fillup(), stance_shouldbe = "", default_stance = "", stance_skills = {}, old_stance_actionlevel = {}, old_parry_actionlevel = {}}
sps.parry_currently = sps.sp_fillup()
sps.stance_currently = ""

sps.parry_options = {
  full = "Assign 100 weighting to the most damaged limb",
  ["distributed weighted"] = "Assign weighting to a limb that is damaged over the limit. ie., if head is 700 over the limit and chest is 300, then the parry will be head 70, chest 30.",
  ["distributed equal"] = "Weighting will be assigned equally to all limbs that are over the limit.",
  manual = "Allows you to manually control parry with the p* aliases."
}

-- if parry is on full, then ignore the currently parried limb for stancing.
sps.stance_options = {
  mostlimb = "Tries to have stance cover the most of all damaged limbs. Will prefer use of arms/legs over left/right stance if possible",
  mostside = "Tries to have stance cover the most of all damaged limbs. Will prefer use of left/right over arms/legs stance if possible",
  singlemostimportant = "Tries to have stance concentrate on the highest priority one",
  singlemostdamaged = "Tries to have stance concentrate on the most damaged one"
}

-- ask users to click on limbs for priority first, then ask for each limb in order to select action level,
-- then ask what to do with stancing when the action level happens, and what to do with parrying
sps.install = {
  {
    check = function () return #sp_config.priority == table.size(sp_limbs) end,
    act = function (step)
      echof("Step %d - assign priorities to the limbs. Click on the following in the order of most important, or use the %s command:", step, green("mmsp nextprio <limb>"))
      echo("  " .. oneconcat(sp_limbs))
          resetFormat()
          deselect()
      for name, _ in pairs(sp_limbs) do
        moveCursor("main",  1, getLineNumber()+2)
        if selectString(name, 1) ~= -1 then
          setLink('mm.sp.nextprio ("' .. name .. '", true)', 'Set ' .. name .. ' as the next limb in importance.')
          resetFormat()
          deselect()
        end
      end
      echo"\n"
    end},
  {
    check = function ()
        for limb,_ in pairs(sp_limbs) do
          if sp_config.stance_actionlevel[limb] == nil then return false end
        end
        return true
      end,
    act = function (step)
      local function makecodestrings(name)
        local t = {}
        t[#t+1] = 'mm.sp.setstancelevel("'..name..'", false, true)'
        if not conf.oldwarrior then
          for amount = 5, 100, 5 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        else
          for amount = 275, 2000, 275 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        end
        return t
      end
      local function maketooltipstrings(name)
        local t = {}
        t[#t+1] = 'Set ' .. name .. ' to ' .. 'none'
        if not conf.oldwarrior then
          for amount = 5, 100, 5 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        else
          for amount = 275, 2000, 275 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        end
        return t
      end


      echof("Step %d - assign a level above which stance should act for each limb by right-clicking, or use the %s command:", step, green("mmsp stancelevel <limb> <amount, or 'none'>"))
      echo "  "
      for name, _ in pairs(sp_limbs) do
        echoPopup(name, makecodestrings(name), maketooltipstrings(name))
        echo(" ")
      end
      echo"\n"
    end},
  {
    check = function ()
        for limb,_ in pairs(sp_limbs) do
          if sp_config.parry_actionlevel[limb] == nil then return false end
        end
        return true
      end,
    act = function (step)
      local function makecodestrings(name)
        local t = {}
        t[#t+1] = 'mm.sp.setparrylevel("'..name..'", false, true)'
        if not conf.oldwarrior then
          for amount = 5, 100, 5 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        else
          for amount = 275, 2000, 275 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        end
        return t
      end
      local function maketooltipstrings(name)
        local t = {}
        t[#t+1] = 'Set ' .. name .. ' to ' .. 'none'
        if not conf.oldwarrior then
          for amount = 5, 100, 5 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        else
          for amount = 275, 2000, 275 do
            t[#t+1] = 'mm.sp.setstancelevel("'..name..'", '..amount..', true)'
          end
        end
        return t
      end


      echof("Step %d - assign a level above which parry should act for for each limb by right-clicking, or use the %s command:", step, green("mmsp parrylevel <limb> <amount, or 'none'>"))
      echo "  "
      for name, _ in pairs(sp_limbs) do
        echoPopup(name, makecodestrings(name), maketooltipstrings(name))
        echo(" ")
      end
      echo"\n"
    end},

  {
    check = function () return sp_config.parry ~= "" end,
    act = function (step)
      echof("Step %d - decide what parry strategy to use when a limb is over the limit by clicking on it, or using the %s command:", step, green("mmsp parrystrat <strategy>"))
      echo "  "
      for name, tooltip in pairs(sps.parry_options) do
        echoLink(name, 'mm.sp.setparry ("' .. name .. '", true)', tooltip)
        echo " "
      end
      echo"\n"
    end},

  {
    check = function () return sp_config.stance ~= "" end,
    act = function (step)
      echof("Step %d - decide what stance strategy to use when a limb is over the limit by clicking on it, or using the %s command:", step, green("mmsp stancestrat <strategy>"))
      echo "  "
      for name, tooltip in pairs(sps.stance_options) do
        echoLink(name, 'mm.sp.setstance ("' .. name .. '", true)', tooltip)
        echo " "
      end
      echo"\n"
    end},

}

function valid.winning3()
  killTrigger(winning2Trigger)
  winning3Timer = tempTimer(math.random(10,30), [[mm.valid.winning3TimerAct()]])
end

function valid.winning3TimerAct()
  cecho("\n<yellow> Ok, fair enough, you know your stuff. What do we do when we lose?")
  winning3Trigger = tempExactMatchTrigger([[With great contempt and scorn, you audibly mutter, "Do better."]],[[mm.valid.winning4()]])
end

sps.installnext = function()
  for i, c in ipairs(sps.install) do
    if not c.check() then
      echo"\n"
      c.act(i)
      return
    end
  end

  echof("Parry/stance setup done :)")
end


function sp.setup()
  local oldstance_skills = deepcopy(sp_config.stance_skills)
  sp_config = { stance = "", parry = "", priority = {}, parry_actionlevel = {}, stance_actionlevel = {}, parry_shouldbe = {}, stance_shouldbe = ""}
  sp_config.stance_skills = oldstance_skills

  sps.installnext()
end


function sp.revert_overhaul(what, echoback)
  assert(what == "on" or what == "off" or what == nil, "what needs to be 'on', 'off' or nil")

  local sendf
  if echoback then sendf = echof else sendf = errorf end

  if not next(sp_config.old_stance_actionlevel) then
    sk.update_actionlevels()
  end

  if not what or (what == "on" and sp_config.stance_actionlevel.head < 100) or (what == "off" and sp_config.stance_actionlevel.head > 100) then

    for part, al in pairs(sp_config.stance_actionlevel) do
      sp_config.stance_actionlevel[part] = sp_config.old_stance_actionlevel[part]
      sp_config.old_stance_actionlevel[part] = al
    end

    for part, al in pairs(sp_config.parry_actionlevel) do
      sp_config.parry_actionlevel[part] = sp_config.old_parry_actionlevel[part]
      sp_config.old_parry_actionlevel[part] = al
    end
  end

  if sp_config.stance_actionlevel.head < 100 then
    enableoverhaul("asthma", echoback)
    enableoverhaul("anorexia", echoback)
    enableoverhaul("slickness", echoback)
    sendf("stance/parry actionlevels set for overhaul")
  elseif sp_config.stance_actionlevel.head > 100 then
    disableoverhaul("asthma", echoback)
    disableoverhaul("anorexia", echoback)
    disableoverhaul("slickness", echoback)
    sendf("reverted stance/parry actionlevels to pre-overhaul")
  end

end

function sp.nextprio(limb, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end
  local prios = sp_config.priority

  if not sp_limbs[limb] then
    sendf("Sorry, %s isn't a proper limb name. They are:\n  %s", limb, oneconcat(sp_limbs))
    return; end

  if contains(prios, limb) then
    sendf("%s is already in the list.", limb); return; end

  prios[#prios+1] = limb
  if echoback then
    echof("%s added; current list: %s", limb, table.concat(prios, ", "))
  end

  if #prios == table.size(sp_limbs) then sps.installnext() end
end

function sp.defaultstance(which, echoback)
  local sendf; if echoback then sendf = echof else sendf = errorf end

  if not which then
    sendf("Which stance to you want to use by default?")
    return
  end

  sp_config.default_stance = which
  if sp_config.stance_shouldbe ~= sp_config.default_stance then
    sp_config.stance_shouldbe = sp_config.default_stance end

  if echoback then
    echof("Default stance has been set to %s.", sp_config.default_stance)
    make_gnomes_work()
  end
end

function sp.setparry(option, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  if not sps.parry_options[option] then
    sendf("Sorry, %s isn't a valid option for parry. They are:\n  %s", option, oneconcat(sps.parry_options))
    return
  end

  sp_config.parry = option
  if echoback then
    echof("Will use the %s strategy for parry.", sp_config.parry)
  end

  sp_checksp()
  sps.installnext()
end

function sp.setstance(option, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  if not sps.stance_options[option] then
    sendf("Sorry, %s isn't a valid option for stance. They are:\n  %s", option, oneconcat(sps.stance_options))
    return
  end

  sp_config.stance = option
  if echoback then
    echof("Will use the %s strategy for stance.", sp_config.stance)
  end

  sp_checksp()
  sps.installnext()
end

function sp.setstancelevel(limb, amount, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  if not sp_limbs[limb] then
    sendf("Sorry, %s isn't a proper limb name. They are:\n  %s", limb, oneconcat(sp_limbs))
    return; end

  if not tonumber(amount) and amount ~= false then
    sendf("To what amount do you want to set %s to?", limb)
    return; end

  sp_config.stance_actionlevel[limb] = tonumber(amount)

  if echoback then
    echof("Set the %s stance action level to %s", limb, amount and tostring(amount) or "none")
  end

  for limb,_ in pairs(sp_limbs) do
    if sp_config.stance_actionlevel[limb] == nil then return end
  end
  sps.installnext()
end

function sp.setparrylevel(limb, amount, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  if not sp_limbs[limb] then
    sendf("Sorry, %s isn't a proper limb name. They are:\n  %s", limb, oneconcat(sp_limbs))
    return; end

  if not tonumber(amount) and amount ~= false then
    sendf("To what amount do you want to set %s to?", limb)
    return; end

  sp_config.parry_actionlevel[limb] = tonumber(amount)

  if echoback then
    echof("Set the %s parry action level to %s", limb, amount and tostring(amount) or "none")
  end

  for limb,_ in pairs(sp_limbs) do
    if sp_config.parry_actionlevel[limb] == nil then return end
  end
  sps.installnext()
end

function sp_setparry(what, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  local t = {
    h = "head",
    c = "chest",
    g = "gut",
    rl = "rightleg",
    ll = "leftleg",
    ra = "rightarm",
    la = "leftarm"
  }

  assert(t[what], "invalid short letter for mm.sp_setparry", sendf)

  for limb, _ in pairs(sp_limbs) do
    if limb == t[what] then sp_config.parry_shouldbe[limb] = 100
      else sp_config.parry_shouldbe[limb] = 0 end
  end

  sp_checksp()
  make_gnomes_work()
end

sp.show = function ()
  echof("Parry & Stance report:")
  echof("Available stance skills we can use: %s", (not next (sp_config.stance_skills) and "(none)" or table.concat(sp_config.stance_skills, ", ")))

  echof("Action levels:")
  for limb, level in pairs(sp_config.stance_actionlevel) do
    echo"  " echof("%s: parry %s, stance %s", limb, tostring (sp_config.parry_actionlevel[limb]), tostring(level))
  end

  echof("Limb priorities: %s", table.concat(sp_config.priority, ", "))
  echof("Parry strategy: %s (currently parrying %s)", type(sp_config.parry) == "string" and sp_config.parry or "custom function",
  (function ()
    local parrying_list = {}
    for limb, parrying in pairs(sp_config.parry_shouldbe) do
      if parrying ~= 0 then parrying_list[#parrying_list+1] = limb.." "..parrying end
    end

    return #parrying_list == 0 and "nothing" or table.concat(parrying_list, ", ") end)())

  echof("Stance strategy: %s (current stance is %s)", type(sp_config.stance) == "string" and sp_config.stance or "custom function", (tostring(sp_config.stance_shouldbe) == "" and "nothing" or tostring(sp_config.stance_shouldbe)))
  echof("Default stance is on: %s", sp_config.default_stance ~= "" and sp_config.default_stance or "(none)")
end

sp_checksp = function ()
  -- check parry
  local prios, priosset = sp_config.priority, true
  if type(prios) ~= "table" then
    priosset = false
  end

  if priosset and sp_config.parry == "full" then
    local alreadyset
    for i = 1, #prios do
      local limb = prios[i]
      if not alreadyset and type(sp_config.parry_actionlevel[limb]) == "number" and dict[string.format("light%s", limb)].count > sp_config.parry_actionlevel[limb] then
        sp_config.parry_shouldbe[limb] = 100
        alreadyset = true
      else
        sp_config.parry_shouldbe[limb] = 0
      end
    end

  elseif priosset and sp_config.parry == "distributed weighted" then
    -- in this kv table, we'll hold the limb = 'how much over' for later calcs
    local t = sps.sp_filldata("parry_actionlevel")
    if not t or not next(t) then return end

    -- count our total
    local total = 0
    for _, k in pairs(t) do total = total + k end

    if total == 0 then
      for limb, _ in pairs(sp_limbs) do
        sp_config.parry_shouldbe[limb] = 0
      end

    else
      total = 100/total

      for limb, _ in pairs(sp_limbs) do
        if t[limb] then sp_config.parry_shouldbe[limb] = math.floor(total*t[limb])
          else sp_config.parry_shouldbe[limb] = 0 end
      end
    end
  elseif priosset and sp_config.parry == "distributed equal" then
    -- in this kv table, we'll hold the limb = how much over for later calcs
    local t = {}
    for i = 1, #prios do
      local limb = prios[i]
      if type(sp_config.parry_actionlevel[limb]) == "number" and dict[string.format("light%s", limb)].count > sp_config.parry_actionlevel[limb] then
        t[limb] = true
      end
    end

    -- got anything?
    if not t or not next(t) then
      for limb, _ in pairs(sp_limbs) do
        sp_config.parry_shouldbe[limb] = 0
      end

    else
      -- count our total
      local total = table.size(t)
      total = 100/total

      for limb, _ in pairs(sp_limbs) do
        if t[limb] then sp_config.parry_shouldbe[limb] = math.floor(total)
          else sp_config.parry_shouldbe[limb] = 0 end
      end
    end
  elseif type(sp_config.parry) == "function" then
    sp_config.parry(sps.sp_filldata("parry_actionlevel"))
  end

  -- check if we need to adjust our parry
  check_sp_satisfied()

  -- stances
  if sp_config.stance == "mostlimb" then
    local t = sps.sp_filldata("stance_actionlevel")
    if not t or not next(t) then return end

    local tt = {}
    for limb, _ in pairs(t) do
      if sps.stance_limbs[limb] then
        for skill, _ in pairs(sps.stance_limbs[limb]) do
          tt[skill] = (tt[skill] or 0) + 1
        end
      end
    end

    local highestkey = getHighestValue(tt)
    -- this list contains just the actions with the most important weighting
    local list = {}
    for k,v in pairs(tt) do
      if v == highestkey then list[k] = true end
    end

    -- two cases: either we have arms/legs present, or we don't.
    -- if we do...
    if list["arms"] or list["legs"] then
      for _, v in ipairs(sp_config.priority) do
        if sps.stance_limbs[v] and sps.stance_limbs[v]["arms"] and list["arms"] then
          sp_config.stance_shouldbe = "arms" break
        elseif sps.stance_limbs[v] and sps.stance_limbs[v]["legs"] and list["legs"] then
          sp_config.stance_shouldbe = "legs" break
        end
      end
    else
      for _, v in ipairs(sp_config.priority) do
        if sps.stance_limbs[v] then
          for n,m in pairs(sps.stance_limbs[v]) do
            if list[n] then
              sp_config.stance_shouldbe = n
            break end
          end
        end
      end
    end


  elseif sp_config.stance == "mostside" then
    local t = sps.sp_filldata("stance_actionlevel")
    if not t or not next(t) then return end

    local tt = {}
    for limb, _ in pairs(t) do
      if sps.stance_limbs[limb] then
        for skill, _ in pairs(sps.stance_limbs[limb]) do
          tt[skill] = (tt[skill] or 0) + 1
        end
      end
    end

    local highestkey = getHighestValue(tt)
    -- this list contains just the actions with the most important weighting
    local list = {}
    for k,v in pairs(tt) do
      if v == highestkey then list[k] = true end
    end

    if list["left"] or list["right"] then
      for _, v in ipairs(sp_config.priority) do
        if sps.stance_limbs[v]["left"] and list["left"] then
          sp_config.stance_shouldbe = "left" break
        elseif sps.stance_limbs[v]["right"] and list["right"] then
          sp_config.stance_shouldbe = "right" break
        end
      end
    else
      for _, v in ipairs(sp_config.priority) do
        for n,m in pairs(sps.stance_limbs[v]) do
          if list[n] then
            sp_config.stance_shouldbe = n
          break end
        end
      end
    end

  elseif sp_config.stance == "singlemostimportant" then
    local t = sps.sp_filldata("stance_actionlevel")
    if not t or not next(t) then return end

    for _, v in ipairs(sp_config.priority) do
      if t[v] and sps.stance_limbs[v] then
        -- pick out which has the least count, ie concentrates most
        local lstance, lcount = select(1, next(sps.stance_limbs[v])), sps.stance_skills_count[select(1, next(sps.stance_limbs[v]))]

        for stancename, _ in pairs(sps.stance_limbs[v]) do
          if sps.stance_skills_count[stancename] < lcount then
            lcount, lstance = sps.stance_skills_count[stancename], stancename
          end
        end

        if lstance then sp_config.stance_shouldbe = lstance end
        break
      end
    end

  elseif sp_config.stance == "singlemostdamaged" then
    local t = sps.sp_filldata("stance_actionlevel")
    if not t or not next(t) then return end

    local most_damaged_limb = getHighestKey(t)

    if not most_damaged_limb or not sps.stance_limbs[most_damaged_limb] or not sps.stance_limbs[most_damaged_limb] then return end

    -- pick out which has the least count, ie concentrates most
    local lstance, lcount = select(1, next(sps.stance_limbs[most_damaged_limb])), sps.stance_skills_count[select(1, next(sps.stance_limbs[most_damaged_limb]))]

    for stancename, _ in pairs(sps.stance_limbs[most_damaged_limb]) do
      if sps.stance_skills_count[stancename] < lcount then
        lcount, lstance = sps.stance_skills_count[stancename], stancename
      end
    end

    if lstance then sp_config.stance_shouldbe = lstance end

  elseif type(sp_config.stance) == "function" then
    sp_config.stance(sps.sp_filldata("stance_actionlevel"))
  end

  signals.after_lifevision_processing:block(sp_checksp)
end

signals.after_lifevision_processing:connect(sp_checksp)
signals.after_lifevision_processing:block(sp_checksp)

sp_something_to_parry = function ()
  for _, amount in pairs(sp_config.parry_shouldbe) do
    if amount ~= 0 then return true end
  end

  return false -- don't unparry if we have all zero's as shouldparry
end

signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/sp_config", sp_config) end)

local sp_config_path = getMudletHomeDir() .. "/m&m/config/sp_config"
if lfs.attributes(sp_config_path) then table.load(sp_config_path, sp_config) end
--sp_config.stance_shouldbe = ""
-- fix up actionlevels because m&m previously set them as strings instead of numbers
for k,v in pairs(sp_config.parry_actionlevel) do sp_config.parry_actionlevel[k] = tonumber(v) end
for k,v in pairs(sp_config.stance_actionlevel) do sp_config.stance_actionlevel[k] = tonumber(v) end
