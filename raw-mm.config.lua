-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

pl.dir.makepath(getMudletHomeDir() .. "/m&m/config")

-- conf has actual values, config data for them

wait_tbl = {
  [0] = {n = 0.7, m = "Systems lag tolerance level set to normal."},
  [1] = {n = 1.1, m = "The lag level was set to \"decent\" - make sure to set it to normal when it clears up."},
  [2] = {n = 1.9, m = "The lag level was set to \"severe\" - make sure to set it to normal when it clears up."},
  [3] = {n = 3.5, m = "The lag level was set to \"awfully terrible\" - make sure to set it to normal when it clears up. Don't even think about fighting in this lag."}
}

local conf_printinstallhint = function (which)
  assert(config_dict[which] and config_dict[which].type, "typo in coding of config options x(")

  if config_dict[which].type == "boolean" then
    echof("Use %s to answer.", tostring(green("mmconfig "..which.." yep/nope")))
  elseif config_dict[which].type == "string" then
    echof("Use %s to answer.", tostring(green("mmconfig "..which.." (option)")))
  elseif config_dict[which].type == "number" and config_dict[which].percentage then
    echof("Use %s to answer.", tostring(green("mmconfig "..which.." (percent)")))
  elseif config_dict[which].type == "number" then
    echof("Use %s to answer.", tostring(green("mmconfig "..which.." (number)")))
  end
end

local conf_installhint = function (which)
  assert(config_dict[which] and config_dict[which].type, "typo in coding of config options x(")

  if config_dict[which].type == "boolean" then
    return "Use mmconfig "..which.." yep/nope to answer."
  elseif config_dict[which].type == "string" then
    return "Use mmconfig "..which.." (option) to answer."
  elseif config_dict[which].type == "number" and config_dict[which].percentage then
    return "Use mmconfig "..which.." (percent) to answer."
  elseif config_dict[which].type == "number" then
    return "Use mmconfig "..which.." (number) to answer."
  else return ""
  end
end

config_dict = pl.OrderedMap {
#conf_name = "blockcommands"
  {$(conf_name) = {
    v2 = true,
    type = "boolean",
    onenabled = function ()
      echof("<0,250,0>Will%s block your commands in slow curing mode (aeon/choke/sap/retardation) if the system is doing something.", getDefaultColor())
      if not denyCurrentSend then echof("Warning: your version of Mudlet doesn't support this, so blockcommands won't actually work. Update to 1.2.0+") end
    end,
    ondisabled = function () echof("<250,0,0>Won't%s block your commands in slow curing mode, but instead allow them to override what the system is doing.", getDefaultColor())
    if not denyCurrentSend then echof("Warning: your version of Mudlet doesn't support this, so blockcommands won't actually work.") end end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      if denyCurrentSend then
        echo "Override commands in slow-curing mode.\n" return
      else
        echo "Override commands in slow-curing mode (requires Mudlet 1.2.0+).\n" return end
    end,
    installstart = function () conf.blockcommands = true end,
  }},
#conf_name = "focusbody"
  {$(conf_name) = {
    type = "boolean",
    g1 = "focus body",
    onenabled = function () echof("<0,250,0>Will%s use Focus Body to cure.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use Focus Body to cure.", getDefaultColor()) end,
    installstart = function () conf.focusbody = nil end,
    installcheck = function () echof("Can you make use of the Focus Body skill?") end
  }},
#conf_name = "focusmind"
  {$(conf_name) = {
    type = "boolean",
    g1 = "focus mind",
    onenabled = function () echof("<0,250,0>Will%s use Focus Mind to cure.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use Focus Mind to cure.", getDefaultColor()) end,
    installstart = function () conf.focusmind = nil end,
    installcheck = function () echof("Can you make use of the Focus Mind skill?") end
  }},
#conf_name = "focusspirit"
  {$(conf_name) = {
    type = "boolean",
    g1 = "focus spirit",
    onenabled = function () echof("<0,250,0>Will%s use Focus Spirit to cure.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use Focus Spirit to cure.", getDefaultColor()) end,
    installstart = function () conf.focusspirit = nil end,
    installcheck = function () echof("Can you make use of the FocusSpirit skill?") end
  }},
#conf_name = "clot"
  {$(conf_name) = {
    type = "boolean",
    g1 = "clot",
    onenabled = function () echof("<0,250,0>Will%s use clot to control bleeding.", getDefaultColor()) end,
    ondisabled = function () echof("Will <0,250,0>only%s use chervil for bleeding.", getDefaultColor()) end,
    installstart = function () conf.clot = nil end,
    installcheck = function () echof("Can you make use of the Clot skill?") end
  }},
#conf_name = "insomnia"
  {$(conf_name) = {
    type = "boolean",
    g1 = "insomnia",
    onenabled = function () echof("<0,250,0>Will%s use the Insomnia skill for insomnia.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use the Insomnia skill for insomnia.", getDefaultColor()) end,
    installstart = function () conf.insomnia = nil end,
    installcheck = function () echof("Can you make use of the Insomnia skill?") end
  }},
#conf_name = "scroll"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s make use of the Healing scroll or magictome.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of the Healing scroll or magictome.", getDefaultColor()) end,
    installstart = function ()
      conf.scroll = false
    end,
    installcheck = function () echof("Should we make use of the Healing scroll or magictome to heal ourselves?") end
  }},
#conf_name = "sparkleherb"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains(rift.sparkleherbs, what) then return true end
    end,
    onset = function ()
      dict.healhealth.herb.eatcure = conf.sparkleherb
      echof("Will use the %s herb for the secondary sparkle effect.", conf.sparkleherb)
    end,
    installstart = function ()
      conf.sparkleherb = nil end,
    installcheck = function ()
      echof("Which herb currently provides the sparkle effect? If none or you don't know, answer coltsfoot.") end
  }},
#conf_name = "secondarysparkle"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s make use of %s instead of sparkleberry.", getDefaultColor(), conf.sparkleherb) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use %s instead of sparkleberry.", getDefaultColor(), conf.sparkleherb) end,
    installstart = function ()
      conf.secondarysparkle = nil end,
    installcheck = function ()
      echof("Do you want to make use of the secondary herb for sparkle effect?") end
  }},
#conf_name = "sparkle"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function ()
      echof("<0,250,0>Will%s make use of the sparkle effect to heal (by eating %s).", getDefaultColor(), (conf.secondarysparkle and conf.sparkleherb or "sparkleberry"))
    end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of the sparkle effect to heal.", getDefaultColor()) end,
    installstart = function ()
      conf.sparkle = nil end,
    installcheck = function ()
      echof("Do you want to make use of sparkle to heal?") end,
  }},
#conf_name = "loadsap"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s import sap specific priorities on sap and import aeon specific priorities on cure", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s import sap specific priorities on sap and import aeon specific priorities on cure", getDefaultColor()) end,
    check = function() return conf.sapprios and conf.sapprios ~= "none" end,
    checkfail = function() echof("<250,0,0>Warning:%s Need to set a prio list for sap to use this config", getDefaultColor()) end,
  }},
#conf_name = "sapprios"
  {$(conf_name) = {
    type = "string",
    check = function(what) return io.exists(getMudletHomeDir().."/m&m/prios/"..what) end,
    onset = function() echof("%sWill use <0,250,0>%s %s for sap curing priorities.", getDefaultColor(), conf.sapprios, getDefaultColor()) end,
  }},
#conf_name = "aeonprios"
  {$(conf_name) = {
    type = "string",
    check = function(what) return io.exists(getMudletHomeDir().."/m&m/prios/"..what) end,
    onset = function() echof("%sWill use <0,250,0>%s%s for aeon curing priorities.", getDefaultColor(), conf.aeonprios, getDefaultColor()) end,
  }},
#conf_name = "catsluck"
  {$(conf_name) = {
    type = "string",
    onset = function() echof("%sWill use <0,250,0>%s%s for casting Cats Luck", getDefaultColor(), conf.catsluck, getDefaultColor()) end,
  }},
#if skills.cavalier then
#conf_name = "hook"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use hook for parrying.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use hook for parrying.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo "Use hook for parry\n"
    end,
    installstart = function () conf.hook = nil end,
    installcheck = function () echof("Are you a cavalier? If yes, you'd want to use hook for parrying.") end
  }},
#end
#conf_name = "showchanges"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s show changes in health/mana/ego on the prompt.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s show changes in health/mana/ego on the prompt.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo("Show h/m changes (in "..tostring(conf.changestype).." format).\n")
    end,
    installstart = function () conf.showchanges = nil end,
    installcheck = function () echof("Do you want to show changes about your health/mana/ego in the prompt?") end
  }},
#conf_name = "changestype"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if what == "full" or what == "short" or what == "fullpercent" or what == "shortpercent" then return true end
    end,
    onset = function ()
      echof("Will use the %s health/mana loss echoes.", conf.changestype)
    end,
    installstart = function () conf.changestype = "shortpercent" end
  }},
#conf_name = "showbaltimes"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s show balance times for balance & equilibrium.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s show balance times.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo "Show balance times.\n"
    end,
    installstart = function () conf.showbaltimes = true end,
    installcheck = function () echof("Do you want to show how long your balances take?") end
  }},
#conf_name = "showafftimes"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s show how long afflictions took to cure.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s show times for curing afflictions.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo "Show how quickly afflictions are cured.\n"
    end,
    installstart = function () conf.showafftimes = true end,
  }},
#conf_name = "doubledo"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s do actions twice under stupidity.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s do actions twice under stupidity.", getDefaultColor()) end,
    onshow = "Double do actions in stupidity",
    v2 = true
  }},
#conf_name = "glenfiddich"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s automatically fill whiskey during deathsongs.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s automatically fill whiskey during deathsongs.", getDefaultColor()) end,
    onshow = "Automatically fill your whiskey during deathsong",
  }},
#conf_name = "cleanse"
  {$(conf_name) = {
    type = "boolean",
    g1 = function ()
      if conf.cleansetype then
        return "cleanse ("..conf.cleansetype..")"
      else
        return "cleanse"
      end
    end,
    onenabled = function () echof("<0,250,0>Will%s use the cleanse effect to cure.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use the cleanse effect to cure.", getDefaultColor()) end,
    installstart = function () conf.cleanse = nil end,
    installcheck = function () echof("Should the system make use of any type of cleanse effect for curing?") end
  }},
#conf_name = "autohide"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s auto hide inactive skillsets on deflist.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s autohide inactive skillsets on deflist.", getDefaultColor()) end,
  }},
#conf_name = "wonderall"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use wondercorn activate all.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use wondercorn activate all.", getDefaultColor()) end,
  }},
#conf_name = "geniesall"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use curio collection activate genies.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use curio collection activate genies.", getDefaultColor()) end,
  }},
#conf_name = "rockclimbing"
  {$(conf_name) = {
    type = "boolean",
    g1 = "rock-climbing",
    onenabled = function () echof("<0,250,0>Have %s the rockclimbing skill.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Don't%s have the rockclimbing skill.", getDefaultColor()) end,
    installstart = function () conf.rockclimbing = nil end,
    installcheck = function () echof("Do you have the Rockclimbing skill?") end
  }},
#conf_name = "alwaysrockclimb"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo "Always rockclimb\n"
    end,
    onenabled = function () echof("<0,250,0>Will%s always use rockclimbing to get out of pits.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s always use rockclimbing, only when necessary due to afflictions.", getDefaultColor()) end,
    installstart = function () conf.alwaysrockclimb = nil end,
    installcheck = function () echof("Should we always use rockclimbing, or save power and only use when normal climb can't work?") end
  }},
#conf_name = "stratagem"
  {$(conf_name) = {
    type = "boolean",
    g1 = "stratagem",
    onenabled = function () echof("<0,250,0>Will%s make most excellent use of Stratagem.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of stratagem.", getDefaultColor()) end,
    installstart = function () conf.stratagem = nil end,
    installcheck = function () echof("Do you have the Stratagem skill in Combat?") end
  }},
#conf_name = "parry"
  {$(conf_name) = {
    type = "boolean",
    g1 = "parry",
    onenabled = function () echof("<0,250,0>Will%s make use of parry.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of parry.", getDefaultColor()) end,
    installstart = function () conf.parry = nil end,
    installcheck = function () echof("Are you able to use parry?") end
  }},
#conf_name = "commandecho"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s show commands the system is doing.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s show commands the system is doing.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour) echo ("Show system commands ("..tostring(conf.commandechotype)..")\n")
    end,
    installstart = function () conf.commandecho = true end
  }},
#if skills.psychometabolism then
#conf_name = "bloodboil"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onenabled = function () echof("<0,250,0>Will%s start accounting for bloodboil.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s account for bloodboil, and will clot/chervil asap instead.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo "Account for bloodboil\n"
    end,
    installstart = function () conf.bloodboil = nil end,
    installcheck = function () echof("Should we let bloodboil cure bleeding when it's up and we're above 50%% ego?") end
  }},
#end
#conf_name = "commandechotype"
  {$(conf_name) = {
    type = "string",
    v2 = true,
    check = function (what)
      if what == "plain" or what == "fancy" then return true end
    end,
    onset = function ()
      echof("Will use the %s command echos.", conf.commandechotype)
    end,
    installstart = function () conf.commandechotype = "fancy" end
  }},
#conf_name = "gmcpvitals"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onenabled = function () echof("<0,250,0>Will%s be pulling vitals from GMCP%s - this'll allow no spam modules!", getDefaultColor(), (not sys.enabledgmcp and " (when GMCP is on)" or "")) end,
    ondisabled = function () echof("<250,0,0>Won't%s be using GMCP vitals.", getDefaultColor()) end,
    installstart = function () conf.gmcpvitals = true end
  }},
#conf_name = "customprompt"
  {$(conf_name) = {
    type = "string",
    v2 = true,
    check = function ()
      return true
    end,
    onset = function ()
      if conf.customprompt == "none" or conf.customprompt == "off" then
        conf.customprompt = false
        echof("Custom prompt disabled.")
      elseif conf.customprompt == "on" then
        if conf.oldcustomprompt ~= "off" then
          conf.customprompt = conf.oldcustomprompt
          cp.makefunction()
          echof("Custom prompt restored.")
        else
          echof("You haven't set a custom prompt before, so we can't revert back to it. Set it with 'mmconfig customprompt <prompt line>.")
          conf.customprompt = false
        end
      else
        cp.makefunction()
        conf.oldcustomprompt = conf.customprompt
        echof("Custom prompt enabled and set; will replace the standard one with yours now.")
        send("\n")
      end
    end,
    installstart = function () conf.customprompt = false end
  }},
#conf_name = "allheale"
  {$(conf_name) = {
    type = "boolean",
    g1 = "allheale",
    onenabled = function () echof("<0,250,0>Will%s make use of allheale potion.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of allheale potion.", getDefaultColor()) end,
    installstart = function () conf.allheale = true end,
    installcheck = function () echof("Should the system make use of allheale to cure?") end
  }},
#conf_name = "relight"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s auto-relight non-artifact pipes.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s auto-relight pipes.", getDefaultColor()) end,
    installstart = function () conf.relight = true end,
    installcheck = function () echof("Should we keep non-artifact pipes lit?") end
  }},
#conf_name = "gagrelight"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s hide relighting of pipes.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s hide relighting pipes.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo(string.format("Re-light pipes quietly%s\n", not conf.relight and " (when relighting is on)" or ""))
    end,
    installstart = function () conf.gagrelight = true end,
    installcheck = function () echof("Should we hide it when pipes are relit (it can get spammy)?") end
  }},
#conf_name = "ccto"
  {$(conf_name) = {
    type = "string",
    onset = function ()
      conf.ccto = conf.ccto:lower()
      if conf.ccto == "sql" or conf.ccto == "squad" then
        echof("Will report stuff to squad.")
      elseif conf.ccto == "clt" then
        echof("Will report stuff to the current selected clan.")
      elseif conf.ccto:find("^tell %w+") then
        echof("Will report stuff to %s via tells.", conf.ccto:match("^tell (%w+)"):title())
      elseif conf.ccto == "ot" then
        echof("Will report stuff to the Order channel.")
      elseif conf.ccto == "team" then
        echof("Will report stuff to the team channel.")
      elseif conf.ccto == "coven" then
        echof("Will report stuff to your coven channel.")
      elseif conf.ccto == "echo" then
        echof("Will echo ccto stuff back to you, instead of announcing it anywhere.")
      else
        echof("Will report stuff to the %s clan.", conf.ccto)
      end
    end,
    vconfig2 = true,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo(string.format("Reporting stuff to %s.\n", tostring(conf.ccto)))
    end,
    installstart = function ()
      conf.ccto = "sqt" end
  }},
#conf_name = "queuing"
  {$(conf_name) = {
    type = "boolean",
    g1 = "stance queuing",
    onenabled = function () echof("<0,250,0>Will%s make use of stance queuing.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of stance queuing.", getDefaultColor()) end,
    installstart = function () conf.queuing = nil end,
    installcheck = function () echof("Are you able to make use of stance queueing?") end
  }},
#conf_name = "repeatcmd"
  {$(conf_name) = {
    type = "number",
    min = 0,
    max = 100000,
    onset = function ()
      if conf.repeatcmd == 0 then echof("Will not repeat commands.")
      elseif conf.repeatcmd == 1 then echof("Will repeat each command one more time.")
      else echof("Will repeat each command %d more times.", conf.repeatcmd)
    end end,
    installstart = function () conf.repeatcmd = 0 end
  }},
#if skills.shamanism then
#conf_name = "clawamount"
  {$(conf_name) = {
    type = "number",
    min = 0,
    max = 100000,
    onset = function () echof("Will make use of sheatheclaw if you're bleeding over %d.", conf.clawamount) end,
    installstart = function () conf.clawamount = 700 end
  }},
#end
#conf_name = "scrollmana"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxmana:emit() echof("Will read the Healing scroll/magictome if mana falls below %d%% (%dm).", conf.scrollmana, sys.scrollmana) end,
    installstart = function () conf.scrollmana = nil end,
    installcheck = function () echof("At what %% of mana do you want to start using the Healing scroll/magictome to heal, if enabled?") end
  }},
#conf_name = "scrollego"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxego:emit() echof("Will read the Healing scroll/magictome if ego falls below %d%% (%de).", conf.scrollego, sys.scrollego) end,
    installstart = function () conf.scrollego = nil end,
    installcheck = function () echof("At what %% of ego do you want to start using the Healing scroll/magictome to heal, if enabled?") end
  }},
#conf_name = "scrollhealth"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxhealth:emit() echof("Will read the Healing scroll/magictome if health falls below %d%% (%dh).", conf.scrollhealth, sys.scrollhealth) end,
    installstart = function () conf.scrollhealth = nil end,
    installcheck = function () echof("At what %% of health do you want to start using the Healing scroll/magictome to heal, if enabled?") end
  }},
#conf_name = "sparklemana"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxmana:emit() echof("Will eat sparkleberry for mana if it falls below %d%% (%dm).", conf.sparklemana, sys.sparklemana) end,
    installstart = function () conf.sparklemana = nil end,
    installcheck = function () echof("At what %% of mana do you want to start using sparkle to heal, if enabled?") end
  }},
#conf_name = "sparkleego"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxego:emit() echof("Will eat sparkleberry for ego if it falls below %d%% (%de).", conf.sparkleego, sys.sparkleego) end,
    installstart = function () conf.sparkleego = nil end,
    installcheck = function () echof("At what %% of ego do you want to start using sparkle to heal, if enabled?") end
  }},
#conf_name = "sparklehealth"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxhealth:emit() echof("Will eat sparkleberry for health if it falls below %d%% (%dh).", conf.sparklehealth, sys.sparklehealth) end,
    installstart = function () conf.sparklehealth = nil end,
    installcheck = function () echof("At what %% of health do you want to start using sparkle to heal, if enabled?") end
  }},
#conf_name = "sipmana"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxmana:emit() echof("Will start sipping mana if it falls below %d%% (%dm).", conf.sipmana, sys.sipmana) end,
    installstart = function () conf.sipmana = nil end,
    installcheck = function () echof("At what %% of mana do you want to start sipping mana?") end
  }},
#conf_name = "sipego"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxego:emit() echof("Will start sipping ego if it falls below %d%% (%de).", conf.sipego, sys.sipego) end,
    installstart = function () conf.sipego = nil end,
    installcheck = function () echof("At what %% of ego do you want to start sipping ego?") end
  }},
#conf_name = "siphealth"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxhealth:emit() echof("Will start sipping health if it falls below %d%% (%dh).", conf.siphealth, sys.siphealth) end,
    installstart = function () conf.siphealth = nil end,
    installcheck = function () echof("At what %% of health do you want to start sipping health?") end
  }},
#conf_name = "manause"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxmana:emit() echof("Will use mana-draining skills if only above %d%% mana (%d).", conf.manause, sys.manause) end,
    installstart = function () conf.manause = 35 end,
    installcheck = function () echof("Above which %% of mana is the system allowed to use mana skills? Like focus, insomnia, etc. If you got below this %%, it'll revert to normal cures.") end
  }},
#if skills.stag then
#conf_name = "mdbaghealth"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxhealth:emit() echof("Will start using the Medicine Bag if your health it falls below %d%% (%dh).", conf.mdbaghealth, sys.mdbaghealth) end,
    installstart = function () conf.mdbaghealth = nil end,
    installcheck = function () echof("At what %% of health do you want to start applying the Medicine Bag?") end
  }},
#end
#if skills.psychometabolism then
#conf_name = "egouse"
  {$(conf_name) = {
    type = "number",
    percentage = true,
    min = 0,
    max = 100,
    onset = function () signals.changed_maxego:emit() echof("Will use ego-draining skills if only above %d%% ego (%d).", conf.egouse, sys.egouse) end,
    installstart = function () conf.egouse = 50 end,
  }},
#end
#conf_name = "lag"
  {$(conf_name) = {
    type = "number",
    min = 0,
    max = 3,
    onset = function () cnrl.update_wait() echof(wait_tbl[conf.lag].m) end,
    installstart = function () conf.lag = 0 end
  }},
#conf_name = "unknownfocus"
  {$(conf_name) = {
    type = "number",
    min = 0,
    onset = function () echof("Will diagnose after we have %d or more unknown, but focusable afflictions.", conf.unknownfocus) end,
    installstart = function () conf.unknownfocus = 2 end,
  }},
#conf_name = "unknownany"
  {$(conf_name) = {
    type = "number",
    min = 0,
    onset = function () echof("Will diagnose after we have %d or more unknown affs.", conf.unknownany) end,
    installstart = function () conf.unknownany = 2 end,
  }},
#conf_name = "waitherbai"
  {$(conf_name) = {
    type = "boolean",
    vconfig2 = true,
    onenabled = function () echof("<0,250,0>Will%s pause eating of herbs while checking herb-cured illusions.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s pause eating of herbs while checking herb-cured illusions.", getDefaultColor()) end,
    onshow = function (defaultcolour)
      fg(defaultcolour) echo ("Don't eat while checking herb-cured illusions.\n")
    end,
    installstart = function () conf.waitherbai = true end
  }},
#conf_name = "myrtleid"
  {$(conf_name) = {
    type = "number",
    min = 0,
    installstart = function () conf.myrtleid = nil; pipes.myrtle.id = 0 end,
    installcheck = function () echof("What pipe should we use for myrtle? Answer with the ID, please.") end,
    onset = function ()
      pipes.myrtle.id = tonumber(conf.myrtleid)
      echof("Set the myrtle pipe id to %d.", pipes.myrtle.id) end,
  }},
#conf_name = "faeleafid"
  {$(conf_name) = {
    type = "number",
    min = 0,
    installstart = function () conf.faeleafid = nil; pipes.faeleaf.id = 0 end,
    installcheck = function () echof("What pipe should we use for faeleaf? Answer with the ID, please.") end,
    onset = function ()
      pipes.faeleaf.id = tonumber(conf.faeleafid)
      echof("Set the faeleaf pipe id to %d.", pipes.faeleaf.id) end,
  }},
#conf_name = "coltsfootid"
  {$(conf_name) = {
    type = "number",
    min = 0,
    installstart = function () conf.coltsfootid = nil; pipes.coltsfoot.id = 0 end,
    installcheck = function () echof("What pipe should we use for coltsfoot? Answer with the ID, please.") end,
    onset = function ()
      pipes.coltsfoot.id = tonumber(conf.coltsfootid)
      echof("Set the coltsfoot pipe id to %d.", pipes.coltsfoot.id) end,
  }},
#conf_name = "steamid"
  {$(conf_name) = {
    type = "number",
    min = 0,
    installstart = function () conf.steamid = nil; pipes.steam.id = 0 end,
    installcheck = function () echof("What pipe should we use for soothing steam? Answer with the ID, please.") end,
    onset = function ()
      pipes.steam.id = tonumber(conf.steamid)
      echof("Set the soothing steam pipe id to %d.", pipes.steam.id) end,
  }},
#conf_name = "scrollid"
  {$(conf_name) = {
    type = "number",
    installstart = function () conf.scrollid = 0 end,
    onset = function () if conf.scrollid == 0 then echof("Will use 'read healing' for the scroll.") else echof("Set the Healing scroll id to scroll%d.", conf.scrollid) end end,
  }},
#conf_name = "stanceskill"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      for k,v in sps.all_stance_skills:pairs() do
        if k == what then return true end
      end
      return false
    end,
    onset = function ()
      sp_config.stance_skills = {}
      for k,v in sps.all_stance_skills:pairs() do
        sp_config.stance_skills[#sp_config.stance_skills+1] = k
        if k == conf.stanceskill then break end
      end
      echof("Available stance skills to use now are: %s", table.concat(sp_config.stance_skills, ", "))
      if #sp_config.stance_skills > 4 then
        config.set("queuing", true, true)
      else
        config.set("queuing", false, true) end

      if contains(sp_config.stance_skills, "legs") and (not sp_config.default_stance or sp_config.default_stance == "") then
        sp.defaultstance("legs", true) end

      sk.update_sk_data()
      sp_checksp()
    end,
    installstart = function () sp_config.stance_skills = nil end,
    installcheck = function () echof("What is the highest available stance skill that you have?") end
  }},
#conf_name = "eventaffs"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Raise Mudlet events on each affliction",
    onenabled = function () update_eventaffs() echof("<0,250,0>Will%s raise Mudlet events for gained/lost afflictions.", getDefaultColor()) end,
    ondisabled = function () update_eventaffs() echof("<250,0,0>Won't%s raise Mudlet events for gained/lost afflictions.", getDefaultColor()) end,
    installstart = function () conf.eventaffs = false; update_eventaffs() end
  }},
#conf_name = "gagclot"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Gag clotting",
    onenabled = function () echof("<0,250,0>Will%s gag the clotting spam.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s gag the clotting spam.", getDefaultColor()) end,
    installstart = function () conf.gagclot = true end,
  }},
#if skills.lowmagic then
#conf_name = "green"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Make use of Green",
    onenabled = function () echof("<0,250,0>Will%s make use of Green.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of Green.", getDefaultColor()) end,
    installstart = function () conf.green = nil end,
    installcheck = function() echof("Do you want to make use of Green for curing locks?") end
  }},
#conf_name = "summer"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Make use of Summer",
    onenabled = function () echof("<0,250,0>Will%s make use of Summer.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of Summer.", getDefaultColor()) end,
    installstart = function () conf.summer = nil end,
    installcheck = function() echof("Do you want to make use of Summer for faster writhing?") end
  }},
#end
#if skills.highmagic then
#conf_name = "gedulah"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Make use of Gedulah",
    onenabled = function () echof("<0,250,0>Will%s make use of Gedulah.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of Gedulah.", getDefaultColor()) end,
    installstart = function () conf.gedulah = nil end,
    installcheck = function() echof("Do you want to make use of Gedulah for curing locks?") end
  }},
#conf_name = "tipheret"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Make use of Tipheret",
    onenabled = function () echof("<0,250,0>Will%s make use of Tipheret.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of Tipheret.", getDefaultColor()) end,
    installstart = function () conf.tipheret = nil end,
    installcheck = function() echof("Do you want to make use of Tipheret for faster writhing?") end
  }},
#end
#conf_name = "autorewield"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      if next(gmcp) then
        echo "Rewield forced unwield.\n"
      else
        echo "Rewield forced unwield (requires GMCP)\n"
      end
    end,
    onenabled = function ()
      if sys.enabledgmcp then
        echof("<0,250,0>Will%s automatically rewield items that we've been forced to unwield.", getDefaultColor())
      else
        echof("<0,250,0>Will%s automatically rewield items that we've been forced to unwield (requires GMCP being enabled).", getDefaultColor())
      end
    end,
    ondisabled = function () echof("<250,0,0>Won't%s automatically rewield things.", getDefaultColor()) end
  }},
#conf_name = "soap"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      if conf.cleanse then echo "Use artefact soap\n"
      else echo "Use artefact soap (when cleanse is on)\n"
      end
    end,
    onenabled = function () echof("<0,250,0>Will%s make use of artifact soap.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of artifact soap.", getDefaultColor()) end,
    installstart = function () conf.soap = nil end,
    installcheck = function () echof("Do you have the soap artifact?") end
  }},
#conf_name = "magictome"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Use a magictome",
    onenabled = function () echof("<0,250,0>Will%s make use of your magictome.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s make use of a magictome.", getDefaultColor()) end,
    installstart = function () conf.magictome = nil end,
    installcheck = function () echof("Do you have a magictome I can use?") end
  }},
#conf_name = "autorecharge"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = "Recharge scrolls & enchantments after use",
    onenabled = function () echof("<0,250,0>Will%s recharge scrolls & enchantments after using them.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s recharge & enchantments after using them.", getDefaultColor()) end,
    installstart = function () conf.autorecharge = nil end,
    installcheck = function () echof("Should we automatically recharge scrolls & enchantments from a cube after usage?") end
  }},
#conf_name = "attemptearlystun"
  {$(conf_name) = {
    type = "boolean",
    onshow = "Try to cure before stun wears off in slowcuring",
    onenabled = function() echof("<0,250,0>Will%s attempt to cure before stun wears off in slowcuring.", getDefaultColor()) end,
    ondisabled = function() echof("<250,0,0>Won't%s attempt to cure before stun wears off in slowcuring.", getDefaultColor()) end,
  }},
#conf_name = "adrenaline"
  {$(conf_name) = {
    type = "boolean",
    onshow = "Use Adrenaline instead of quicksilver for the def",
    onenabled = function() echof("<0,250,0>Will%s use adrenaline instead of quicksilver", getDefaultColor()) end,
    ondisabled = function() echof("<250,0,0>Won't%s use adrenaline instead of quicksilver", getDefaultColor()) end,
  }},
#conf_name = "preclot"
  {$(conf_name) = {
    type = "boolean",
    v2 = true,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      if conf.preclot and conf.clot then
        echo "Will preclot bleeding.\n"
      elseif conf.preclot and not conf.clot then
        echo "Will do preclotting (when clotting is enabled)\n."
      else
        echo "Won't preclot bleeding.\n"
      end
    end,
    onenabled = function () echof("<0,250,0>Will%s do preclotting (saves health at expense of willpower).", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s do preclotting (saves willpwer at expense of health).", getDefaultColor()) end,
    installstart = function () conf.preclot = true end,
    installcheck = function () echof("Should the system do preclotting? Doing so will save you from some bleeding damage, at the cost of more willpower.") end
  }},
#conf_name = "blindherb"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains({"faeleaf", "myrtle"}, what:lower()) then return true end
    end,
    onset = function ()
      conf.blindherb = string.lower(conf.blindherb)
      dict.blind.herb.eatcure = conf.blindherb
      echof("Okay, will use %s to cure blindness.", conf.blindherb)

    end,
    installstart = function ()
      conf.blindherb = nil end,
    installcheck = function () echof("Which herb do you want to use to cure blindness? Select from faeleaf or myrtle.") end
  }},
#conf_name = "deafherb"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains({"earwort", "myrtle"}, what:lower()) then return true end
    end,
    onset = function ()
      conf.deafherb = string.lower(conf.deafherb)
      dict.deaf.herb.eatcure = conf.deafherb
      echof("Okay, will use %s to cure deafness.", conf.deafherb)

    end,
    installstart = function ()
      conf.deafherb = nil end,
    installcheck = function () echof("Which herb do you want to use to cure deafness? Select from earwort or myrtle.") end
  }},
#conf_name = "org"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains({"Magnagora", "Celest", "Hallifax", "Gaudiguch", "Glomdoring", "Serenwilde", "None"}, what:title()) then return true end
    end,
    onset = function ()
      if conf.org == "none" then
        conf.org = string.lower(conf.org)
        signals.orgchanged:emit()
        echof("Okay, won't enable any org-specific skills.")
      else
        conf.org = string.title(conf.org)

        -- if NameDB is present, set own city to be allied - in case you weren't a citizen of this city before and it was an enemy to you
        if ndb and ndb.conf and type(ndb.conf.citypolitics) == "table" then
          ndb.conf.citypolitics[conf.org] = "ally"
        end

        signals.orgchanged:emit()
        echof("Okay, we'll enable %s-specific skills then.", conf.org)
      end

    end,
    installstart = function ()
      conf.org = nil end,
    installcheck = function ()
      echof("What city or commune do you live in? Select from: Magnagora, Celest, Hallifax, Gaudiguch, Glomdoring, Serenwilde or none.") end
  }},
#conf_name = "autowounds"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if what == "on" or what == "off" or tonumber(what) then return true end
    end,
    onset = function ()
      if conf.autowounds == "off" or tonumber(conf.autowounds) == 0 then
        conf.autowounds = 0
        echof("Won't automatically check wounds after warriors hits."); return
      elseif conf.autowounds == "on" then
        conf.autowounds = 3
        echof("Will automatically check wounds, by default, after %d hits.", conf.autowounds); return
      end

      conf.autowounds = tonumber(conf.autowounds)
      echof("Will automatically check wounds after %d hits.", conf.autowounds)
    end,
    installstart = function ()
#if skills.healing then
      conf.autowounds = 3
#else
      conf.autowounds = 10
#end
    end
  }},
#conf_name = "autoreject"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains({"black", "white", "off", "on"}, what:sub(1,5):lower()) then sk.oldautoreject = conf.autoreject return true end
    end,
    onset = function ()
      conf.autoreject = string.lower(conf.autoreject):sub(1,5)

      if conf.autoreject == "off" then
        ignore.lovers = true
        conf.autoreject = sk.oldautoreject; sk.oldautoreject = nil
        echof("Disabled autoreject completely (ie, will ignore curing lovers aff).")
      elseif conf.autoreject == "on" then
        ignore.lovers = nil
        conf.autoreject = sk.oldautoreject; sk.oldautoreject = nil
        echof("Enabled autoreject (won't ignore curing lovers anymore) - right now it's in %slist mode.", conf.autoreject)
      elseif conf.autoreject == "white" then
        local c = table.size(me.lustlist)
        echof("Autoreject has been set to whitelist mode - that means we will be automatically rejecting everybody, except those on the lust list (%d %s).", c, (c == 1 and "person" or "people"))
      elseif conf.autoreject == "black" then
        local c = table.size(me.lustlist)
        echof("Autoreject has been set to blacklist mode - that means we will only be rejecting people on the lust list (%d %s).", c, (c == 1 and "person" or "people"))
      else
        echof("... how did you manage to set the option to '%s'?", tostring(conf.autoreject))
      end
    end,
    installstart = function ()
      conf.autoreject = "white" end
  }},
#conf_name = "lustlist"
  {$(conf_name) = {
    type = "string",
    onset = function ()
      local name = string.title(conf.lustlist)
      if not me.lustlist[name] then me.lustlist[name] = true else me.lustlist[name] = nil end

      if me.lustlist[name] then
        if conf.autoreject == "black" then
          echof("Added %s to the lust list (so we will be autorejecting them).", name)
        elseif conf.autoreject == "white" then
          echof("Added %s to the lust list (so we won't be autorejecting them).", name)
        else
          echof("Added %s to the lust list.", name)
        end
      else
        if conf.autoreject == "black" then
          echof("Removed %s from the lust list (so we will not be autorejecting them now).", name)
        elseif conf.autoreject == "white" then
          echof("Removed %s from the lust list (so we will be autorejecting them).", name)
        else
          echof("Removed %s from the lust list.", name)
        end
      end
    end
  }},
#conf_name = "focus"
  {$(conf_name) = {
    type = "string",
    onset = function()
      local aff = conf.focus
      if (dict[aff].lucidity and not dict[aff].lucidity.focus) and (dict[aff].wafer and not dict[aff].wafer.focus) and (dict[aff].steam and not dict[aff].steam.focus) then
        echof("%s isn't an affliction we can focus.", aff)
        return
      end
      if not me.focus[aff] then me.focus[aff] = true else me.focus[aff] = nil end

      if me.focus[aff] then
        echof("Will be focusing %s always.", aff)
      else
        echof("Will not be focusing %s always.", aff)
      end
    end
  }},
#conf_name = "aeonfocus"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use focus in aeon.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use focus in aeon.", getDefaultColor()) end,
  }},
#conf_name = "beastfocus"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use beastfocus if possible.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use beastfocus.", getDefaultColor()) end,
  }},
#conf_name = "powerfocus"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use powerfocus if possible.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use powerfocus.", getDefaultColor()) end,
  }},

#if skills.illusions then
#conf_name = "changerace"
  {$(conf_name) = {
    type = "string",
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo("Changeself to "..tostring(conf.changerace)..".\n")
    end,
    onset = function ()
      echof("Will changeself to the %s race.", conf.changerace)
    end,
    installstart = function ()
      conf.changerace = nil end,
    installcheck = function ()
      echof("Which race would you like to use for the ChangeSelf defence?") end
  }},
#end
#if skills.nekotai then
#conf_name = "screeright"
  {$(conf_name) = {
    type = "string",
    onset = function ()
      echof("Will use the %s poison for the right sprongcree.", conf.screeright)
    end
  }},
#conf_name = "screeleft"
  {$(conf_name) = {
    type = "string",
    onset = function ()
      echof("Will use the %s poison for the left sprongcree.", conf.screeleft)
    end
  }},
#end
#conf_name = "deathsight"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use Deathsight skill from Discernment instead of an enchantment.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use Deathsight skill from Discernment, but instead an enchantment.", getDefaultColor()) end,
  }},
#conf_name = "slip"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use slip instead of writhing.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use use slip, will writhe instead.", getDefaultColor()) end,
  }},
#conf_name = "echotype"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if echos[what:title()] or echos[what] then return true end
    end,
    onset = function ()
      conf.echotype = echos[conf.echotype:title()] and conf.echotype:title() or conf.echotype
      signals.orgchanged:emit()
      echof("This is how system messages will look like now :)")
    end,
    v2 = true,
    installstart = function ()
      conf.org = nil end,
  }},
#if skills.healing then
#conf_name = "succor"
  {$(conf_name) = {
    type = "boolean",
    onshow = "Make use of succor",
    v2 = true,
    onenabled = function () echof("<0,250,0>Will%s use succor diagnose and check wounds quicker.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use succor.", getDefaultColor()) end,
    installstart = function () conf.succor = nil end,
    installcheck = function () echof("Are you able to make use of succor from Healing?") end
  }},
#conf_name = "healingskill"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if table.contains({"auric", "fractures", "curses", "breaks", "regenerate", "skin", "senses", "depression", "glandular", "mania", "nervous", "muscles", "phlegmatic", "temperature", "phobias", "neurosis", "choleric", "blood", "sanguine", "melancholic"}, what:lower()) then return true end
    end,
    onset = function ()
      conf.healingskill = conf.healingskill:lower()
      signals.healingskillchanged:emit()
      echof("Set your highest available Healing skill to %s.", conf.healingskill:title())
    end,
    v2 = true,
    installstart = function ()
      conf.healingskill = nil end,
    installcheck = function ()
      echof("What is the highest possible Healing aura that you can radiate? If you don't have Healing, just select 'auric'.") end
  }},
#conf_name = "usehealing"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if table.contains({"full", "partial", "none", "off"}, what:lower()) then return true end
    end,
    onset = function ()
      conf.usehealing = conf.usehealing:lower()
      if conf.usehealing == "off" then conf.usehealing = "none" end
      echof("Will use Healing in the '%s' mode.", conf.usehealing)
    end,
    v2 = true,
    installstart = function ()
      conf.usehealing = nil end,
    installcheck = function ()
      echof("Do you want to use Healing skillset in the full, partial or none mode? Full would mean that it'll use Healing for everything that it can and supplement it with normal cures. Partial would mean that it'll use normal cures and supplement it with Healing, while none means it won't make use of Healing at all.") end
  }},
#end
#conf_name = "assumestats"
  {$(conf_name) = {
    type = "number",
    v2 = true,
    min = 0,
    max = 100,
    onset = function () echof("Will assume we're at %d%% of health, mana and ego when under blackout or recklessness.", conf.assumestats) end,
    installstart = function () conf.assumestats = 0 end,
  }},
#conf_name = "warningtype"
  {$(conf_name) = {
    type = "string",
    v2 = true,
    check = function (what)
      if contains({"all", "prompt", "none"}, what) then return true end
    end,
    onset = function ()
      if conf.warningtype == "none" then
        conf.warningtype = false
        echof("Disabled extended instakill warnings.")
      elseif conf.warningtype == "all" then
        echof("Will prefix instakill warnings to all lines.")
        if math.random(1, 10) == 1 then echof("(muahah(") end
      elseif conf.warningtype == "prompt" then
        echof("Will prefix instakill warnings only to prompt lines.")
      end
    end,
    installstart = function ()
      conf.warningtype = "all" end,
  }},
#conf_name = "autoarena"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s automatically enable/disable arena mode as you enter/leave the arena.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s automatically enable/disable arena mode as you enter/leave the arena..", getDefaultColor()) end,
  }}, 
#conf_name = "arena"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s operate in arena mode.", getDefaultColor()) end,
    ondisabled = function () echof("<0,250,0>Won't%s operate in arena mode.", getDefaultColor()) end,
  }},
#conf_name = "oldwarrior" 
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will cure using old warrior mechanics, use 'mmsp convert off' to make appropiate changes", getDefaultColor()) end,
    ondisabled = function () echof("<0,250,0>Will cure using new warrior mechanics, use 'mmsp convert on' to make appropiate changes", getDefaultColor()) end
  }},
#if skills.elementalism or skills.healing then
#conf_name = "cleansetype"
  {$(conf_name) = {
    type = "string",
    check = function (what)
      if contains({"enchant", "spell", "healing"}, what) then return true end
    end,
    onset = function ()
      echof("Will use the %s for the cleanse effect.", conf.cleansetype)
    end,
    installstart = function ()
      conf.cleansetype = nil end,
    installcheck = function () echof("Do you want to use the enchant, the spell or the Healing skill for the cleanse effect?") end
  }},
#end
#conf_name = "vitaemode"
  {$(conf_name) = {
    type = "string",
    vconfig2string = true,
    check = function (what)
      if defdefup[what:lower()] then return true end
    end,
    onshow = function (defaultcolour)
      fg(defaultcolour)
      echo("Upon hitting vitae, will go into ") fg("a_cyan")
      echoLink(tostring(conf.vitaemode), 'printCmdLine"mmconfig vitaemode "',
#if skills.transmology then
      "Set the defences mode system should autoswitch to upon hitting vitae or homunculus rezz",
#else
      "Set the defences mode system should autoswitch to upon hitting vitae",
#end
       true)
      cecho("<a_grey> defences mode.\n")
    end,
    onset = function ()
      conf.vitaemode = conf.vitaemode:lower()
#if skills.transmology then
      echof("Upon hitting vitae/homunculus rezz, will go into %s defences mode.", conf.vitaemode)
#else
      echof("Upon hitting vitae, will go into %s defences mode.", conf.vitaemode)
#end
    end,
    installstart = function ()
      conf.vitaemode = "empty" end
  }},
#if skills.acrobatics then
#conf_name = "springup"
  {$(conf_name) = {
    type = "boolean",
    g1 = "springup",
    onenabled = function () echof("<0,250,0>Will%s use springup to get up.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use springup.", getDefaultColor()) end,
    installstart = function () conf.springup = nil end,
    installcheck = function () echof("Do you have the springup skill?") end
  }},
#conf_name = "contort"
  {$(conf_name) = {
    type = "boolean",
    g1 = "contort",
    onenabled = function () echof("<0,250,0>Will%s use contort to writhe quicker.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use contort.", getDefaultColor()) end,
    installstart = function () conf.contort = nil end,
    installcheck = function () echof("Do you have the contort skill?") end
  }},
#end
#if skills.rituals or skills.cosmic then
#conf_name = "enchantments"
  {$(conf_name) = {
    type = "boolean",
    g1 = "enchantments",
    onenabled = function () echof("<0,250,0>Will%s use enchantments instead of Ritual/Elementalism chants.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use enchantments, will use Rituals/Elementalism chants.", getDefaultColor()) end,
    installstart = function () conf.springup = nil end,
    installcheck = function () echof("Should the system use enchantments instead of Rituals/Elementalism chants?") end
  }},
#end
#if skills.stag then
#conf_name = "medicinebag"
  {$(conf_name) = {
    type = "boolean",
    onenabled = function () echof("<0,250,0>Will%s use the Medicine Bag for health and wounds curing.", getDefaultColor()) end,
    ondisabled = function () echof("<250,0,0>Won't%s use Medicine Bag.", getDefaultColor()) end,
    installstart = function () conf.medicinebag = nil end,
    installcheck = function () echof("Have you got a Medicine Bag? Should we use it for curing?") end
  }},
#end
}

do
  local conf_t = {}
  local conf_path = getMudletHomeDir() .. "/m&m/config/conf"

  if lfs.attributes(conf_path) then table.load(conf_path, conf_t)
    update(conf, conf_t)

    cnrl.update_wait()
    if conf.bashing then enableTrigger"m&m Bashing triggers"
    else disableTrigger"m&m Bashing triggers" end

    local options = pl.tablex.makeset(config_dict:keys())
    if conf.tipheret and not options.tipheret then conf.tipheret = nil echof("Disabled tipheret, since you don't have the skill anymore.") end
    if conf.summer and not options.summer then conf.summer = nil echof("Disabled summer, since you don't have the skill anymore.") end
    if conf.bloodboil and not options.bloodboil then conf.bloodboil = nil echof("Disabled bloodboil, since you don't have the skill anymore.") end
    if conf.green and not options.green then conf.green = nil echof("Disabled green, since you don't have the skill anymore.") end
    if conf.gedulah and not options.gedulah then conf.gedulah = nil echof("Disabled gedulah, since you don't have the skill anymore.") end
    if conf.cleansetype and not options.cleansetype then conf.cleansetype = "enchant" echof("Disabled cleanse via spell, since you don't have the skill anymore") end

    if conf.gmcpvitals == nil then
      conf.gmcpvitals = true

      tempTimer(15, function()
        echof("A new option was added - mmconfig gmcpvitals - that was automatically enabled for you! This'll make it so you don't spam things while locked in a module, provided you have GMCP enabled.")
      end)
    end
  end
end

-- fix up missing values
for k,v in config_dict:iter() do
  if conf[k] == nil then
    if v.type == "number" then
      conf[k] = 0
    else
      conf[k] = false
    end
  end
end

local tntf_tbl = {
  aillusion = { -- is used to change appropriate conf. option
    shortcuts = {"ai", "anti-illusion", "a", "antiillusion"},
    on = function () enableTrigger "Pre-parse anti-illusion";
          echof"Anti-illusion enabled." end,
    alreadyon = function () enableTrigger "Pre-parse anti-illusion";
          echof"Anti-illusion is already enabled." end,
    off = function () disableTrigger "Pre-parse anti-illusion";
          echof"Anti-illusion disabled." end,
    alreadyoff = function () disableTrigger "Pre-parse anti-illusion";
          echof"Anti-illusion is already disabled." end,
  },
  arena = {
    on = function()
      local echos = {"Arena mode enabled. Good luck!", "Beat 'em up! Arena mode enabled.", "Arena mode on.", "Arena mode enabled. Kill them all!"}
            echof(echos[math.random(#echos)])
    end,
    alreadyon = function() echof("Arena mode is already on.") end,
    off = function() echof("Arena mode disabled.") end,
    alreadyoff = function() echof("Arena mode is already off.") end
  },
  keepup = {
    on = function () echof"Auto keepup on." make_gnomes_work() end,
    alreadyon = function () echof"Auto keepup is already on." end,
    off = function () echof"Auto keepup is now off."make_gnomes_work() end,
    alreadyoff = function() echof"Auto keepup is already off." end
  },
  bashing = {
    on = function () enableTrigger"m&m Bashing triggers" echof("Enabled bashing triggers.") end,
    alreadyon = function () echof("Bashing triggers are already on.") end,
    off = function() disableTrigger"m&m Bashing triggers" echof("Disabled bashing triggers.") end,
    alreadyoff = function() echof("Bashing triggers are already off.") end,
  }
}

for k,v in pairs(tntf_tbl) do
  if v.shortcuts then
    for _,shortcut in pairs(v.shortcuts) do
      tntf_tbl[shortcut] = k
    end
    v.real = k
  end
end

function tntf_set(what, option, echoback)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  option = convert_string(option)
  assert(what and (option ~= nil), "syntax is: mm.tntf(what, option)", sendf)

  if not tntf_tbl[what] then
    sendf("%s isn't something you can change.", what)
    return
  end

  if type(tntf_tbl[what]) == "string" then what = tntf_tbl[what] end
  if option and conf[what] then
    (tntf_tbl[what].alreadyon or tntf_tbl[what].on)()
  elseif not option and not conf[what] then
    (tntf_tbl[what].alreadyoff or tntf_tbl[what].off)()
  elseif not option then
    conf[what] = false
    tntf_tbl[what].off()
    raiseEvent("m&m config changed", what)
  else
    conf[what] = true
    tntf_tbl[what].on()
    raiseEvent("m&m config changed", what)
  end
end

-- just display all options in 4 tabs
function sk.show_all_confs()
  local count = 0
  local t = {}; for name, _ in config_dict:iter() do t[#t+1] = name end; table.sort(t)

  for _, name in ipairs(t) do
    if printCmdLine then
      echoLink(string.format("%-20s", tostring(name)), 'printCmdLine("mmconfig '..name..' ")', conf_installhint(name), true)
    else
      echo(string.format("%-20s", tostring(name))) end
    count = count + 1
    if count % 4 == 0 then echo "\n" end
  end
end

function config.setoption(name, data)
  config_dict:set(name, data)
  if conf[name] == nil and config_dict[name].type == "number" then
    conf[name] = 0
  elseif conf[name] == nil then
    conf[name] = false
  end
end

function config.deloption(name)
  if config_dict[name] then
    config_dict:set(name, nil)
  end
end

function config.set(what, option, echoback)
  local sendf
  local showprompt = showprompt
  if echoback then sendf = echof else sendf = errorf; showprompt = function() end end

  if not config_dict[what] or what == "list" or what == "options" then
    sendf("%s - available ones are:", what == "list" and "Listing all options" or "Don't know about such an option")
    sk.show_all_confs()
    return
  end

  if config_dict[what].type == "boolean" then

    if config_dict[what].check and not config_dict[what].check(option) then
      if config_dict[what].checkfail then
        config_dict[what].checkfail()
      else
        sendf("%s isn't something you can set %s to be.", option, what)
      end
      return
    end

    if (type(option) == "boolean" and option == true) or convert_string(option) or (option == nil and not conf[what]) then
      conf[what] = true
      if echoback then config_dict[what].onenabled() end
      raiseEvent("m&m config changed", what)
    elseif (type(option) == "boolean" and option == false) or not convert_string(option) or (option == nil and conf[what]) then
      conf[what] = false
      if echoback then config_dict[what].ondisabled() end
      raiseEvent("m&m config changed", what)
    else
      sendf("don't know about that option - try 'yes' or 'no' for %s.", what)
    end

  elseif config_dict[what].type == "number" then
    if not option or tonumber(option) == nil then
      if config_dict[what].percentage then
        sendf("What percentage do you want to set %s to? Please use mmconfig %s <option> to answer.", what, what)
      else
        sendf("What number do you want to set %s to? Please use mmconfig %s <option> to answer.", what, what)
      end
    return; end

    local num = tonumber(option)
    if config_dict[what].max and num > config_dict[what].max then
      sendf("%s can't be higher than %d.", what, config_dict[what].max)
    elseif config_dict[what].min and num < config_dict[what].min then
      sendf("%s can't be lower than %d.", what, config_dict[what].min)
    else
      conf[what] = num
      config_dict[what].onset()
      raiseEvent("m&m config changed", what)
    end

  elseif config_dict[what].type == "string" then
    if not option then sendf("What do you want to set %s to? Please use mmconfig %s <option> to answer.", what, what); return; end

    if config_dict[what].check and not config_dict[what].check(option) then
      sendf("%s isn't something you can set %s to be.", option, what)
      return
    end

    conf[what] = option
    config_dict[what].onset()
    raiseEvent("m&m config changed", what)

  elseif config_dict[what].type == "custom" then
    if not option then
      if config_dict[what].onmenu then
        config_dict[what].onmenu()
      else
        sendf("What do you want to set %s to? Please use mmconfig %s <option> to answer.", what, what)
        showprompt()
      end

    else
      if config_dict[what].onset then
        config_dict[what].onset()
        raiseEvent("m&m config changed", what)
      end
    end

  else
    sendf("meep... %s doesn't have a type associated with it. Tis broken.", what)
  end

  showprompt()

  if install.installing_system then install.check_install_step() end
  make_gnomes_work()
end

signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/m&m/config/conf", conf) end)

function config.showcolours()
  echof("Here's a list of available colors you can pick. To select, click on the name or use the %s command.", green("mmconfig echotype <name>"))

  for name, f in pairs(echos) do
    local s = "  pick "..tostring(name).." -  "
    echo("  pick ")
    echoLink(tostring(name), '$(sys).config.set("echotype", "'.. tostring(name) ..'", true)', 'Set it to '..tostring(name)..' colour style.', true)
    echo(" -  ")
    echo((" "):rep(30-#s)) f(true, "this is how it'll look")
  end
end

function config.showprompt()
  if not conf.customprompt then
    echof("You don't have a custom prompt set currently.")
  else
    echof("This is the script behind your custom prompt:\n")
    echo(conf.customprompt)
  end
end
