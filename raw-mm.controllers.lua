-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

createBuffer("mm_prompt")

local oldhealth, oldmana, oldego = 0, 0, 0
me.healthchange, me.manachange, me.egochange = 0, 0, 0
local function calculatestatchanges()
  local t = {}
  local stats = stats

  me.healthchange, me.manachange, me.egochange = 0, 0, 0
  if oldhealth > stats.currenthealth then
    me.healthchange = stats.currenthealth - oldhealth

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Health", me.healthchange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>h", me.healthchange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Health, %.1f%%", me.healthchange, 100/stats.maxhealth*me.healthchange*-1)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>h, %.1f%%", me.healthchange, 100/stats.maxhealth*me.healthchange*-1)
      end
    end

  elseif oldhealth < stats.currenthealth then
    me.healthchange = stats.currenthealth - oldhealth

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Health", me.healthchange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>h", me.healthchange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Health, %.1f%%", me.healthchange, 100/stats.maxhealth*me.healthchange)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>h, %.1f%%", me.healthchange, 100/stats.maxhealth*me.healthchange)
      end
    end
  end

  if oldmana > stats.currentmana then
    me.manachange = stats.currentmana - oldmana

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Mana", me.manachange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>m", me.manachange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Mana, %.1f%%", me.manachange, 100/stats.maxmana*me.manachange*-1)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>m, %.1f%%", me.manachange, 100/stats.maxmana*me.manachange*-1)
      end
    end

  elseif oldmana < stats.currentmana then
    me.manachange = stats.currentmana - oldmana

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Mana", me.manachange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>m", me.manachange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Mana, %.1f%%", me.manachange, 100/stats.maxmana*me.manachange)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>m, %.1f%%", me.manachange, 100/stats.maxmana*me.manachange)
      end
    end
  end

  if oldego > stats.currentego then
    me.egochange = stats.currentego - oldego

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Ego", me.egochange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>e", me.egochange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128> Ego, %.1f%%", me.egochange, 100/stats.maxego*me.egochange*-1)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<255,0,0>%d<128,128,128>e, %.1f%%", me.egochange, 100/stats.maxego*me.egochange*-1)
      end
    end

  elseif oldego < stats.currentego then
    me.egochange = stats.currentego - oldego

    if conf.showchanges then
      if conf.changestype == "full" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Ego", me.egochange)
      elseif conf.changestype == "short" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>e", me.egochange)
      elseif conf.changestype == "fullpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128> Ego, %.1f%%", me.egochange, 100/stats.maxego*me.egochange)
      elseif conf.changestype == "shortpercent" then
        t[#t+1] = string.format("<0,255,0>+%d<128,128,128>e, %.1f%%", me.egochange, 100/stats.maxego*me.egochange)
      end
    end
  end

  oldhealth, oldmana, oldego = stats.currenthealth, stats.currentmana, stats.currentego

  -- store away changed for showing later, as the custom prompt that follows overrides
  sk.statchanges = t
end

local blackout_flag
function blackout()
  blackout_flag = true
end

local function checkblackout()
  if blackout_flag and not affs.blackout then
    valid.simpleblackout()
  elseif not blackout_flag and affs.blackout then
    if actions.blackout_allheale then
      lifevision.add(actions.blackout_allheale.p)
    else
      checkaction(dict.blackout.allheale, true)
      lifevision.add(actions.blackout_allheale.p, "woreoff")
    end
  end

  blackout_flag = false
end

function valid.setup_prompt()
  pflags = {}
  if (sys.enabledgmcp and conf.gmcpvitals) or line == "-" then return end

  bals.balance = false
  bals.equilibrium = false

  if bals.leftarm ~= "unset" then bals.leftarm = false end
  if bals.rightarm ~= "unset" then bals.rightarm = false end

#if skills.psionics then
  if type(bals.super) ~= "string" then bals.super = false end
  if type(bals.sub) ~= "string" then bals.sub = false end
  if type(bals.id) ~= "string" then bals.id = false end
#end
end

-- not used when we're pulling vitals from GMCP
local function check_promptflags()
  local pflags = mm.pflags

  if pflags.b and not defc.trueblind and not doingaction "trueblind" and not affs.blind then
     addaff(dict.blind)
  elseif not pflags.b then
    if affs.blind then
      removeaff("blind")
    elseif defc.trueblind then
      defences.lost("trueblind")
    end
  end

  if pflags.d and not defc.truedeaf and not doingaction "truedeaf" and not affs.deaf then
     addaff(dict.deaf)
  elseif not pflags.d then
    if affs.deaf then
      removeaff("deaf")
    elseif defc.truedeaf then
      defences.lost("truedeaf")
    end
  end

  if pflags.k and not defc.kafe then
    defences.got("kafe")
  elseif not pflags.k and defc.kafe then
    defences.lost("kafe")
  end

  if pflags.m and not defc.riding then
    defences.got("riding")
  end

#if skills.kata then
  stats.momentum = select(3, line:find("(%d+)mo")) or 0
#end
end


function onprompt()
  raiseEvent("m&m before the prompt")

  promptcount = promptcount + 1

  checkblackout()
  prompt_stats()
  calculatestatchanges()

  if not (sys.enabledgmcp and conf.gmcpvitals) then
    if not inamodule and not (affs.blackout or actions.blackout_aff) then check_promptflags() else
      bals.balance = true
      bals.equilibrium = true
      bals.rightarm = "unset"
      bals.leftarm = "unset"

#if skills.psionics then
      bals.super = "unset"
      bals.sub = "unset"
      bals.id = "unset"
#end
    end
  end

  sys.lagcount = 0
  signals.before_prompt_processing:emit()

  send_in_the_gnomes()

  if conf.showchanges and not conf.commandecho or (conf.commandecho and conf.commandechotype == 'fancynewline') then
    sk.showstatchanges()
  end

  signals.after_prompt_processing:emit()

  if conf.showchanges and conf.commandecho and conf.commandechotype ~= 'fancynewline' then sk.showstatchanges() end

  if sys.deffing then defupfinish() end

  local currentline = getLineCount()

  if conf.paused then
    deselect()
    moveCursor("main", 0, currentline)
    setFgColor(255, 0, 0)
    insertText("(")
    moveCursor("main", 1, currentline)
    setFgColor(128, 128, 128)
    insertText("p")
    moveCursor("main", 2, currentline)
    setFgColor(255, 0, 0)
    insertText(")")
    moveCursor("main", 3, currentline)
    setFgColor(0,0,0)
    insertText(" ")
    moveCursorEnd()
    resetFormat()
  end

  if sys.sync then
    deselect()
    moveCursor("main", 0, currentline)
    setFgColor(255, 0, 0)
    insertText("(")
    moveCursor("main", 1, currentline)

    if sacid then
      setFgColor(0,255,0)
    elseif sk.doingstuff_inslowmode() then
      setFgColor(255,0,0)
    else
      setFgColor(0,0,255)
    end

    if sk.syncdebug then
      insertLink("a", '$(sys).echof[['..sk.syncdebug..']]', 'Click to see actions we were considering doing at this point', true)
    else
      insertText("a")
    end
    moveCursor("main", 2, currentline)
    setFgColor(255, 0, 0)
    insertText(")")
    moveCursor("main", 3, currentline)
    setFgColor(0,0,0)
    insertText(" ")
    moveCursorEnd()
    resetFormat()
  end

  -- prefix an orange '?:' if we don't know the exact stats
  if affs.recklessness or affs.blackout or affs.anesthesia then
    moveCursor("main", 0, currentline)
    setFgColor(255, 102, 0)
    insertText("?:")
    resetFormat(); deselect()
    moveCursorEnd()
  end

  lastpromptnumber = getLastLineNumber("main")
  paragraph_length = 0

  raiseEvent("m&m done with prompt")
  selectString( line, 1 )
  copy()
  moveCursorEnd("mm_prompt")
  paste("mm_prompt")
end

signals.after_lifevision_processing:connect(function ()
  -- stats are updated in a pre-emit of before_prompt_processing
  if conf.customprompt and not affs.blackout and not inamodule then
    selectString(line, 1)
    replace("")
    cecho(cp.display())
  end
end)

signals.gmcpcharname:connect(function()
  -- check for deathsight skill or enchantment
  sendGMCP([[Char.Skills.Get { "group": "discernment" }]])

  sys.charname = gmcp.Char.Name.name
  me.name = gmcp.Char.Name.name
end)
function sk.checkdeathsightskill()
  local t = _G.gmcp.Char.Skills.List
  if t.group ~= "discernment" then return end

  if table.contains(t.list, "Deathsight") then
    config.set("deathsight", true, false)
  else
    config.set("deathsight", false, false)
  end
end
signals.gmcpcharskillslist:connect(sk.checkdeathsightskill)



local old500num = 0
local old500p = false

function valid.winning5()
  killTrigger(winning4Trigger)
  winning5Timer = tempTimer(math.random(5,15), [[mm.valid.winning5TimerAct()]])
end

function valid.winning5TimerAct()
  cecho("\n<orange>Wahoooo, one last thing, what do we say to celebrate!")
  winning5Trigger = tempExactMatchTrigger([["Yaaahhhhoooo!" you shout.]], [[mm.valid.gaudiwinbutton()]])
end

function prio_makefirst(action, balance)
  assert(action and dict[action], "mm.prio_makefirst: " .. (action and action or "nil") .. " isn't a valid action.")

  local act = dict[action]

  -- find if it's only one available
  if not balance then
    local count = table.size(act)
    if act.aff then count = count - 1 end
    if act.waitingfor then count = count - 1 end

    assert(count == 1, "mm.prio_makefirst: " .. action .. " uses more than one balance, which one do you want to move?")
    local balance = false
    for k,j in pairs(act) do
      if k ~= "aff" and k ~= "waitingfor" then balance = k end
    end
  end

   assert(act[balance] and act[balance] ~= "aff" and act[balance] ~= "waitingfor", "mm.prio_makefirst: " .. action .. " doesn't use the " .. (balance and balance or "nil") .. " balance.")

  -- at this point, we both have the act and balance we want to move up.
  -- logic: move to 500, remember the original val. when we have to move back,
  -- we'll swap it to the original val.
  prio_undofirst()

  old500num = act[balance].spriority
  old500p = act[balance]
  act[balance].spriority = 500
end

function prio_undofirst()
  if not old500p then return end

  old500p.spriority = old500num
  old500p, old500num = false
end

function prio_slowswap(what, arg3, echoback, callback, ...)
  local sendf; if echoback then sendf = echof else sendf = errorf end
  local what, balance = what:match("(%w+)_(%w+)")
  local balance2
  if not tonumber(arg3) then
    assert(balance and balance2, "What balances do you want to use for swapping?", sendf)
    arg3, balance2 = arg3:match("(%w+)_(%w+)")
  end

  if tonumber(arg3) then -- swap to a #
    local name, balance2 = prio.getslowaction(tonumber(arg3))
    if not name then -- see if we have anyone in that # already
      dict[what][balance].spriority = arg3
      if echoback then
        echof("%s is now at %d.", what, arg3)
      end
    else -- if we do have someone at that #, swap them
      dict[what][balance].spriority, dict[name][balance2].spriority =
      dict[name][balance2].spriority, dict[what][balance].spriority
      if echoback then echof("%s is now > %s.", what, name) end
    end
  else -- swap one action_balance with another action_balance
    if dict[what][balance].spriority < dict[arg3][balance2].spriority then
      dict[what][balance].spriority, dict[arg3][balance2].spriority =
      dict[arg3][balance2].spriority, dict[what][balance].spriority
      if echoback then echof("%s is now > %s.", what, arg3) end
    elseif echoback then
      echof("%s is already > %s.", what, arg3)
    end
  end

  if callback and type(callback) == "function" then callback(...) end
end

function prio_swap(what, balance, arg2, arg3, echoback, callback, ...)
  local sendf; if echoback then sendf = echof else sendf = errorf end
  assert(what and (balance and balance ~= "aff" and balance ~= "waitingfor"), "what item and balance do you want to swap?", sendf)
  assert(dict[what], what.." doesn't exist", sendf)
  assert(dict[what][balance], what.. " doesn't use a '"..balance.."' balance")

  local function swaptwo(what, name, balance, ...)
    if dict[what][balance].aspriority < dict[name][balance].aspriority then
      dict[what][balance].aspriority, dict[name][balance].aspriority =
      dict[name][balance].aspriority, dict[what][balance].aspriority
      if echoback then echof("%s is now > %s.", what, name) end
    elseif dict[what][balance].aspriority > dict[name][balance].aspriority then
      dict[what][balance].aspriority, dict[name][balance].aspriority =
      dict[name][balance].aspriority, dict[what][balance].aspriority
      if echoback then echof("%s is now < %s.", what, name) end
    --~ elseif echoback then
      --~ echof("%s is already > %s.", what, name)
    end

    if callback and type(callback) == "function" then callback(...) end
  end

  -- we want our 'what' to be at this arg2 number, swap what was there with its previous position
  if not arg3 then

    assert(tonumber(arg2), "what number do you want to swap " .. what .. " with?", sendf)
    local to_num = tonumber(arg2)
    local name = prio.getaction(to_num, balance)

    -- swapping two affs
    if name then
      swaptwo(what, name, balance, ...)

    -- or just setting one aff
    else
      dict[what][balance].aspriority = to_num
      if echoback then
        echof("%s is now at %d.", what, to_num)
      end
    end

    return
  end

  -- we want to swap two affs
  assert(dict[arg2] and dict[arg2][arg3], "what balance of "..arg2.." do you want to swap with?", sendf)
  swaptwo(what, arg2, arg3, ...)
end

local promptregex = rex.new("NL:(\\d+)/\\d+ H:(\\d+)/(\\d+) M:(\\d+)/(\\d+) E:(\\d+)/(\\d+) P:(\\d+)/\\d+ N:(\\d+)/(\\d+) W:(\\d+)/(\\d+) ")


prompt_stats = function ()
  if not (gmcp and gmcp.Char and gmcp.Char.Vitals) then return end
  -- deepcopy to another table for comparison after
  local temp = {
    maxhealth = stats.maxhealth,
    maxmana = stats.maxmana,
    maxego = stats.maxego
  }

  local stats = stats
  local vitals = gmcp.Char.Vitals

  stats.nextlevel,
  stats.currenthealth, stats.maxhealth,
  stats.currentmana, stats.maxmana,
  stats.currentego, stats.maxego,
  stats.currentpower,
  stats.currentendurance, stats.maxendurance,
  stats.currentwillpower, stats.maxwillpower,
  stats.essence, stats.esteem,
  stats.powerreserves
  -- added or 0 here, because at one point gmcp didn't provide the values
   =  vitals.nl or 0,
      vitals.hp or 0, vitals.maxhp or 0,
      vitals.mp or 0, vitals.maxmp or 0,
      vitals.ego or 0, vitals.maxego or 0,
      vitals.pow or 0,
      vitals.ep or 0, vitals.maxep or 0,
      vitals.wp or 0, vitals.maxwp or 0,
      vitals.essence or 0, vitals.esteem or 0,
      vitals.reserves or 0

#if skills.healing then
  stats.empathy = tonumber(vitals.empathy) or 0
#end

  for i,j in pairs(stats) do
    stats[i] = tonumber(j)
  end

  --[[if (stats.currentwillpower <= 1000 and not (stats.currenthealth == 0 and stats.currentmana == 0 and stats.currentego == 0)) or sk.lowwillpower then
    sk.checkwillpower()
  end]]

  if affs.illusorywounds then
    stats.currenthealth = math.floor(stats.currenthealth * 1.3333)
  end

  if (stats.currenthealth == 0 and stats.currentmana == 0 and stats.currentego == 0) or (affs.recklessness and not actions.recklessness_focus and not actions.recklessness_herb) or affs.anesthesia then
    local assumestats = conf.assumestats/100
    stats.currenthealth, stats.currentmana, stats.currentego =
      math.floor(stats.maxhealth * assumestats), math.floor(stats.maxmana * assumestats), math.floor(stats.maxego * assumestats)
  end

  -- pull balances from it
  if (sys.enabledgmcp and conf.gmcpvitals) then
    local t = gmcp.Char.Vitals

    bals.equilibrium = (t.equilibrium == "1") and true or false
#if skills.kata then
    bals.balance = (t.balance == "1" and t.left_leg == "1" and t.right_leg == "1") and true or false
#else
    bals.balance = (t.balance == "1") and true or false
#end
    bals.rightarm = (t.right_arm == "1") and true or false
    bals.leftarm = (t.left_arm == "1") and true or false
    bals.lucidity = (t.slush == "1") and true or false
    bals.ice = (t.ice == "1") and true or false
    bals.steam = (t.steam == "1") and true or false
    bals.wafer = (t.dust == "1") and true or false
    bals.sip = (t.healing == "1") and true or false
    bals.sparkle = (t.sparkleberry == "1") and true or false
    bals.beast = (t.beastbal == "1") and true or false



    if t.blind == "1" and not defc.trueblind and not doingaction "trueblind" and not affs.blind then
       addaff(dict.blind)
    elseif t.blind ~= "1" then
      if affs.blind then
        removeaff("blind")
      elseif defc.trueblind then
        defences.lost("trueblind")
      end
    end

    if t.deaf == "1" and not defc.truedeaf and not doingaction "truedeaf" and not affs.deaf then
       addaff(dict.deaf)
    elseif t.deaf ~= "1" then
      if affs.deaf then
        removeaff("deaf")
      elseif defc.truedeaf then
        defences.lost("truedeaf")
      end
    end

    me.lastprone = me.prone
    me.prone = (t.prone == "1") and true or false
    if me.lastprone and not me.prone then
      valid.not_prone()
    end

    if dict.bleeding.count > 0 and tonumber(t.bleeding) == 0 then
      dict.bleeding.misc.oncured()
    end
    if tonumber(t.bleeding) > 0 then
      dict.bleeding.aff.oncompleted(tonumber(t.bleeding))
    end
    if dict.bruising.count > 0 and tonumber(t.bruising) == 0 then
      dict.bruising.misc.oncured()
    end
    if tonumber(t.bruising) > 0 then
      dict.bruising.aff.oncompleted(tonumber(t.bruising))
    end

      for _,part in ipairs({"head","chest","gut","leftarm","rightarm","leftleg","rightleg"}) do
        local limb = tonumber(t[part.."wounds"])
        if limb and limb ~= dict["light"..part].count then
          if limb > dict["light"..part].count then
            cn.wounds_to_add[part] = limb
            signals.before_prompt_processing:unblock(cn.addupwounds)
          elseif limb < dict["light"..part].count then
            if limb > 0 then
              mm.valid.ice_healed_partially()
            elseif limb <= 0 then
              mm.valid.ice_healed_completely()
            end
          end
        end
      end

    stats.momentum = tonumber(t.momentum)

    if t.kafe == "1" then defences.got("kafe") else defences.lost("kafe") end

    if t.mount ~= "nothing" then defences.got("riding") else defences.lost("riding") end

#if skills.psionics then
    if t.psisuper == "-1" then
      bals.super = "locked"
    elseif t.psisuper == "0" then
      bals.super = false
    else
      bals.super = true
    end
    if t.psisub == "-1" then
      bals.sub = "locked"
    elseif t.psisub == "0" then
      bals.sub = false
    else
      bals.sub = true
    end
    if t.psiid == "-1" then
      bals.id = "locked"
    elseif t.psiid == "0" then
      bals.id = false
    else
      bals.id = true
    end
#end

  end

  -- see what max values changed, update other info accordingly
  if temp.maxhealth ~= stats.maxhealth then
    signals.changed_maxhealth:emit()
  end
  if temp.maxmana ~= stats.maxmana then
    signals.changed_maxmana:emit()
  end
  if temp.maxego ~= stats.maxego then
    signals.changed_maxego:emit()
  end
end

function QQ()
  signals.quit:emit()
  echof("Going into empty defs mode so pre-cache doesn't take anything out, and stuffing away all riftables...")
  defs.switch("empty")
  inra()
end

savesettings = QQ

function goteq()
  sys.balancetick = sys.balancetick + 1
  if sys.actiontimeoutid then
    killTimer(sys.actiontimeoutid)
    sys.actiontimeoutid = false
  end
end

function gotbalance()
  sys.balancetick = sys.balancetick + 1
  if sys.actiontimeoutid then
    killTimer(sys.actiontimeoutid)
    sys.actiontimeoutid = false
  end
end


function cnrl.update_siphealth()
  if conf.siphealth then sys.siphealth = stats.maxhealth * (conf.siphealth/100) end
  if conf.sparklehealth then sys.sparklehealth = stats.maxhealth * (conf.sparklehealth/100) end
  if conf.scrollhealth then sys.scrollhealth = stats.maxhealth * (conf.scrollhealth/100) end
#if skills.stag then
  if conf.mdbaghealth then sys.mdbaghealth = stats.maxhealth * (conf.mdbaghealth/100) end
#end
end

signals.changed_maxhealth:connect(cnrl.update_siphealth)

function cnrl.update_sipmana()
  if conf.sipmana then sys.sipmana = stats.maxmana * (conf.sipmana/100) end
  if conf.sparklemana then sys.sparklemana = stats.maxmana * (conf.sparklemana/100) end
  if conf.scrollmana then sys.scrollmana = stats.maxmana * (conf.scrollmana/100) end

  sys.manause = math.floor(stats.maxmana * (conf.manause/100))
end

signals.changed_maxmana:connect(cnrl.update_sipmana)

function cnrl.update_sipego()
  if conf.sipego and stats.maxego then sys.sipego = stats.maxego * (conf.sipego/100) end
  if conf.sparkleego and stats.maxego then sys.sparkleego = stats.maxego * (conf.sparkleego/100) end
  if conf.scrollego and stats.maxego then sys.scrollego = stats.maxego * (conf.scrollego/100) end

  if conf.egouse then sys.egouse = math.floor(stats.maxego * (conf.egouse/100)) end
end

signals.changed_maxego:connect(cnrl.update_sipego)

function cnrl.update_wait()
  sys.wait = wait_tbl[conf.lag].n
end

can_usemana = function()
  return stats.currentmana > sys.manause
end

cn.wounds_to_add = {}

function cn.addupwounds()
  for limb, dmg in pairs(cn.wounds_to_add) do
    valid["wounds"..limb.."_add"](dmg)
  end

  cn.wounds_to_add = {}
  signals.before_prompt_processing:block(cn.addupwounds)
end
signals.before_prompt_processing:connect(cn.addupwounds)
signals.before_prompt_processing:block(cn.addupwounds)

function addwounds(class, attack, where, ...)
  if conf.gmcpvitals then return end
  assert(class and attack and where, "Not enough arguments to mm.addwounds(class, attack, where)")
  assert(type(where) ~= "string" or (type(where) == "string" and sk.limbnames[where]), tostring(where) .. " isn't a valid limb name.")

  local dmg
  if not (wounds_data[class] and wounds_data[class][attack]) then
    dmg = math.random(100, 300)
  elseif type(wounds_data[class][attack]) == "function" then
    dmg = wounds_data[class][attack](...)
  else
    dmg = wounds_data[class][attack]
  end

  if type(where) == "table" then
    for _, limb in ipairs(where) do
      cn.wounds_to_add[limb] = (cn.wounds_to_add[limb] or 0) + dmg
    end
  else
    cn.wounds_to_add[where] = (cn.wounds_to_add[where] or 0) + dmg end

  signals.before_prompt_processing:unblock(cn.addupwounds)

  if conf.autowounds and conf.autowounds > 0 and class == "knight" then
    dict.woundscheck.autocheckcount = dict.woundscheck.autocheckcount + 1
    if dict.woundscheck.autocheckcount >= conf.autowounds then sys.manualwoundscheck = true end
  end
end

cnrl.warnids = {}

-- tbl: {initialmsg = "", prefixwarning = "", startin = 0, duration = 0}
function givewarning(tbl)
  checkaction(dict.givewarning.happened, true)
  lifevision.add(actions.givewarning_happened.p, nil, tbl)
end

prefixwarning = function ()
  local currentline = getLineCount()
  local moveCursor, insertText, setFgColor = moveCursor, insertText, setFgColor

  deselect()
  moveCursor("main", 0, currentline)
  setFgColor(0, 050, 200)
  insertText("(")
  moveCursor("main", 1, currentline)
  setFgColor(128, 128, 128)
  insertText(cnrl.warning)
  moveCursor("main", 1+#cnrl.warning, currentline)
  setFgColor(0, 050, 200)
  insertText(")")
  moveCursor("main", 2+#cnrl.warning, currentline)
  setFgColor(0,0,0)
  insertText(" ")
  moveCursorEnd()
  resetFormat()
end

cnrl.lockdata = {
  ["arms"] = function () return (affs.missingleftarm and affs.missingrightarm and codepaste.regen_arms()) end,
  ["green a"] = function() return (affs.slitthroat and affs.slickness and (affs.prone or affs.severedspine or affs.paralysis or affs.tangle)) end,
  ["green b"] = function() return (affs.crushedwindpipe and affs.slickness and affs.asthma and (affs.prone or affs.severedspine or affs.paralysis or affs.tangle)) end,
  ["green c"] = function() return (affs.collapsedlungs and affs.crushedwindpipe and affs.slickness and (affs.prone or affs.severedspine or affs.paralysis or affs.tangle)) end,
  -- ["green d"] = function() return (affs.slitthroat and affs.paralysis) end,
  ["cleanse a"] = function() return (affs.slitthroat and affs.slickness and not affs.prone and not affs.severedspine and not affs.paralysis and not affs.tangle) end,
  ["cleanse b"] = function() return (affs.crushedwindpipe and affs.slickness and affs.asthma and not affs.prone and not affs.severedspine and not affs.paralysis and not affs.tangle) end,
  ["cleanse c"] = function() return (affs.collapsedlungs and affs.crushedwindpipe and affs.slickness) end,
  ["slow"] = function () return (affs.concussion and affs.aeon) end,
  ["hemi"] = function () return (affs.hemiplegyright and affs.hemiplegyleft) end
}

--[[ cnrl.checkwarning gets unblocked whenever we receive an aff that is
      included in any of the locks. If you have a lock, it enables the
      cnrl.checkgreen flag, and unblocks dowarning, which allows powercure
      to run and do it's thing. Post processing, cnrl.dolockwarning is run,
      notifying the user on the prompt of any locks (and if any of them
      are in the process of being cured, highlight the lock name in green).

      When we don't have a lock, checkwarning disables itself, the flag,
      and dowarning]]

cnrl.warnings = {}
me.locks = {}
cnrl.checkwarning = function ()
  local warnings, locks = cnrl.warnings, me.locks
  for lock, func in pairs(cnrl.lockdata) do
    local havelock = func()
    if havelock and not locks[lock] then
      warnings[#warnings+1] = lock
      locks[lock] = true
      raiseEvent("m&m got lock", lock)
    elseif not havelock and locks[lock] then
      table.remove(warnings, table.index_of(warnings, lock))
      locks[lock] = nil
      raiseEvent("m&m lost lock", lock)
    end
  end

  if not cnrl.checkgreen and #warnings > 0 then
    signals.after_prompt_processing:unblock(cnrl.dolockwarning)
    cnrl.checkgreen = true
  elseif cnrl.checkgreen and #warnings == 0 then
    cnrl.checkgreen = false
    signals.after_lifevision_processing:block(cnrl.checkwarning)
    signals.after_prompt_processing:block(cnrl.dolockwarning)
  end
end
signals.after_lifevision_processing:connect(cnrl.checkwarning)
signals.after_lifevision_processing:block(cnrl.checkwarning)

cnrl.dolockwarning = function ()
  local t = cnrl.warnings
  if #t == 1 then
    cecho("<red>(<grey>lock: <orange>" .. t[1].."<red>)")
  elseif #t > 1 then
    cecho("<red>(<grey>locks: <orange>" .. table.concat(t, ", ").."<red>)")
  else
    -- no more warnings? stop checking for them. Failsafe, we should never get here normally.
    cnrl.checkgreen = false
    signals.after_lifevision_processing:block(cnrl.checkwarning)
    signals.after_prompt_processing:block(cnrl.dolockwarning)
  end
end
signals.after_prompt_processing:connect(cnrl.dolockwarning)
signals.after_prompt_processing:block(cnrl.dolockwarning)

function cnrl.processcommand(what)
  if not sys.sync then return end

  if conf.blockcommands and sk.doingstuff_inslowmode() and not sk.gnomes_are_working then
    denyCurrentSend()
    if math.random(1,5) == 1 then
      echof("denying <79,92,88>%s%s. Lemme finish!", what, getDefaultColor())
    elseif math.random(1,10) == 1 then
      echof("denying <79,92,88>%s%s. Use tsc to toggle deny mode.", what, getDefaultColor())
    else
      echof("denying <79,92,88>%s%s.", what, getDefaultColor()) end
    return
  elseif not conf.blockcommands and not sk.gnomes_are_working then -- override mode, users command

    -- kill old timer first
    if sacid then killTimer(sacid) end
    sacid = tempTimer(syncdelay() + getNetworkLatency() + conf.sacdelay, function ()
      sacid = false; make_gnomes_work()
    end)
  end

  -- retardation detection
  -- amnesia screws with it by hiding the sluggish msg itself!
  if not sk.sluggishtimer and not affs.amnesia then
    sk.sawsluggish = getLastLineNumber("main")
    sk.sluggishtimer = tempTimer(sys.wait + syncdelay() + getNetworkLatency(), function ()
      if type(sk.sawsluggish) == "number" and sk.sawsluggish ~= getLastLineNumber("main") and (affs.retardation or affsp.retardation) then
        if affs.retardation then echo"\n" echof("retardation seems to have went away.") end
        removeaff("retardation")
      end

      sk.sluggishtimer = nil
    end)
  end
end

signals.sysdatasendrequest:connect(cnrl.processcommand)
signals.sysdatasendrequest:block(cnrl.processcommand)

function printorder(balance, limited_around)
  local sendf; if echoback then sendf = echof else sendf = errorf end
  assert(type(balance) == "string", "mm.printorder: what balance do you want to print for?", sendf)

  -- step 1: get into table...
  local data = make_prio_table(balance)
  local orderly = {}

  for i,j in pairs(data) do
    orderly[#orderly+1] = i
  end

  table.sort(orderly, function(a,b) return a>b end)

  -- locate where the center of the list is, if we need it
  local center
  if limited_around then
    local counter = 1
    for _, j in pairs(orderly) do
      if j == limited_around then center = counter break end
      counter = counter +1
    end
  end

  echof("%s balance priority list (<112,112,112>clear gaps%s):", balance, getDefaultColor())
  if selectString("clear gaps", 1) ~= -1 then
    setLink("mm.prio.cleargaps('"..balance.."', true)", "Clear all gaps in the "..balance.." balance")
  end

  if limited_around then echof("(...)") end

  local counter = 1
  for i,j in pairs(orderly) do
    --~ if not limited_around or not (j > (limited_around+6) or j < (limited_around-6)) then
    if not limited_around or not (counter > (center+6) or counter < (center-6)) then
      setFgColor(255,147,107)
      echoLink("^", 'mm.prio_swap("'..data[j]..'", "'..balance..'", '..(j+1)..', nil, false, mm.printorder, "'..balance..'", '..(j+1)..')', 'shuffle '..data[j]..' up', true)
      echo(" ")
      setFgColor(148,148,255)
      echoLink("v", 'mm.prio_swap("'..data[j]..'", "'..balance..'", '..(j-1)..', nil, false, mm.printorder, "'..balance..'", '..(j-1)..')', 'shuffle '..data[j]..' down', true)
      setFgColor(112,112,112)
      echo(" (" .. j..") "..data[j])
      echo("\n")
      resetFormat()
    end

    counter = counter + 1
  end
end

function printordersync(limited_around)
  -- step 1: get into table...
  local data = make_sync_prio_table("%s (%s)")
  local orderly = {}

  for i,j in pairs(data) do
    orderly[#orderly+1] = i
  end

  table.sort(orderly, function(a,b) return a>b end)

  echof("aeon/sap/choke/retardation priority list (clear gaps):", balance)
  if selectString("clear gaps", 1) ~= -1 then
    setFgColor(112,112,112)
    setLink("mm.prio.cleargaps('slowcuring', true)", "Clear all gaps in the aeon/sap/choke/retardation priority")
    resetFormat()
  end

  -- locate where the center of the list is, if we need it
  local center
  if limited_around then
    local counter = 1
    for _, j in pairs(orderly) do
      if j == limited_around then center = counter break end
      counter = counter +1
    end
  end

  if limited_around then echof("(...)") end

  local counter = 1
  for i,j in pairs(orderly) do
    if not limited_around or not (counter > (center+6) or counter < (center-6)) then
      setFgColor(255,147,107) echo"  "
      echoLink("^^", '$(sys).prio_slowswap("'..string.format("%s_%s", string.match(data[j], "(%w+) %((%w+)%)"))..'", '..(j+1)..', false, $(sys).printordersync, '..(j+1)..')', 'shuffle '..data[j]..' up', true)
      echo(" ")
      setFgColor(148,148,255)
      echoLink("vv", '$(sys).prio_slowswap("'..string.format("%s_%s", string.match(data[j], "(%w+) %((%w+)%)"))..'", '..(j-1)..', false, $(sys).printordersync, '..(j-1)..')', 'shuffle '..data[j]..' up', true)
      setFgColor(112,112,112)
      echo(" (" .. j..") "..data[j])
      echo("\n")
      resetFormat()
    end

    counter = counter + 1
  end
end


_G.mm.removeaff = function (which)
  assert(type(which) == "string", "mm.removeaff: what aff would you like to remove? name must be a string")

  local removed
  if lifevision.l[which.."_aff"] then
    lifevision.l:set(which.."_aff", nil)
    removed = true
  end

  if affs[which] then
    removeaff(which)
    removed = true
  end

  return removed
end

_G.mm.addaff = function (which)
  assert(type(which) == "string", "mm.addaff: what aff would you like to add? name must be a string")
  assert(dict[which], "mm.addaff: "..which.." isn't a known aff name")

  if affs[which] then
    return false
  else
    if dict[which].aff and dict[which].aff.forced then
      dict[which].aff.forced()
    elseif dict[which].aff then
      dict[which].aff.oncompleted()
    else
      addaff(dict[which])
    end

    signals.after_lifevision_processing:unblock(cnrl.checkwarning)
    signals.aeony:emit()

    return true
  end
end

gagwounds = function ()
  if actions.woundscheck_physical and dict.woundscheck.autocheckcount >= conf.autowounds and conf.autowounds > 0 then
    tempLineTrigger(0, 11, [[deleteLine()]])
  end
end

prompttrigger = function (name, func)
  sk.onprompt_beforeaction_add(name, func)
end

lasttrigger = function(name, func)
  sk.lasttrigger_add(name, func)
end

lasttrigger_do = sk.lasttrigger_do

function enableoverhaul(action, echoback)
  if not sk.overhauldata[action] then
    if echoback then echof("%s isn't yet known by m&mf to have Overhaul curing.") end
    return
  end

  overhaul[action] = true
  sk.overhaul[action] = true

  -- update internal table which enables/disables balances for afflictions
  -- at first, disable old balances
  for _, balance in pairs(sk.overhauldata[action].oldbalances or {}) do
    sk.cureoverhaul[balance][action] = true
  end

  -- then, enable new balances
  for _, balance in pairs(sk.overhauldata[action].newbalances or {}) do
    sk.cureoverhaul[balance][action] = nil
  end

  -- lastly, disable other cures as necessary
  if sk.overhauldata[action].replaces then
    for _, aff in pairs(sk.overhauldata[action].replaces) do
      overhaul[aff] = "replaced by "..action
      sk.overhaul[aff] = "replaced by "..action
    end
  end

  -- for normal cures, if an affliction is in overhaul table, and on the balance that we're checking, don't cure it
  -- for overhaul cures, check that they are in the overhaul table

  if echoback then
    echof("Will use Overhaul cures for "..action.." and treat it like an Overhaul aff%s.", (not sk.overhauldata[action].replaces and '' or ', also disabled '..concatand(sk.overhauldata[action].replaces)))
    showprompt()
  end

  raiseEvent("m&m overhaul added", action)
end

function disableoverhaul(action, echoback)
  overhaul[action] = nil
  sk.overhaul[action] = nil

  if sk.overhauldata[action] then
    for _, balance in pairs(sk.overhauldata[action].oldbalances) do
      sk.cureoverhaul[balance][action] = nil
    end

    for _, balance in pairs(sk.overhauldata[action].newbalances) do
      sk.cureoverhaul[balance][action] = true
    end

    if sk.overhauldata[action].replaces then
      for _, aff in pairs(sk.overhauldata[action].replaces) do
        overhaul[aff] = nil
        sk.overhaul[aff] = nil
      end
    end
  end

  if echoback then
    echof("Won't use Overhaul cures for "..action..", and instead treat it like an normal aff%s.", ((sk.overhauldata[action] and not sk.overhauldata[action].replaces) and '' or ', also re-enabled '..concatand(sk.overhauldata[action].replaces)))
    showprompt()
  end

  raiseEvent("m&m overhaul removed", action)
end

me.activeskills = {}
skillstartcheck = false

signals.gmcpcharskillsgroups:connect(function()
  local t = _G.gmcp.Char.Skills.Groups
  local current = {}
  for _,tt in ipairs(t) do
    if me.skills[tt.name:lower()] then
      table.insert(current, tt.name:lower())
    end
  end

  --this is to make sure everything is deactivated on startup, so there aren't any issues setting things up. After startup, it will only deactivate skills actively forgotten.
  if not skillstartcheck then
    for skill, v in pairs(me.skills) do
      raiseEvent("m&m remove skill", skill)
      if conf.autohide then
        mm.ignoreskill(skill:title(),true,false)
      end
    end
    skillstartcheck = true
  else
    for skill, v in pairs(me.activeskills) do
      if v and not table.contains(current, skill) then
        me.activeskills[skill] = nil
        if conf.autohide then
          mm.ignoreskill(skill:title(),true,false)
        end
        raiseEvent("m&m remove skill", skill)
      end
    end
  end

  for _, skill in ipairs(current) do
    if not me.activeskills[skill] then
      me.activeskills[skill] = true
      if conf.autohide then
        mm.ignoreskill(skill:title(),false,false)
      end
      raiseEvent("m&m add skill", skill)
    end
  end
  end)

function connected()
  signals.connected:emit()
end

function loggedin()
  signals.loggedin:emit()
end



signals.connected:connect(function()
  if conf.gmcpvitals then
    disableTrigger("m&m wound overhaul")
  else
    enableTrigger("m&m wound overhaul")
  end
end)
