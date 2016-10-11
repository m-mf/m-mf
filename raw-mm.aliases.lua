-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

function togglesip(what)
  assert(what == nil or what == "health" or what == "mana" or what == "ego", "mm.togglesip wants 'health', 'mana' or 'ego' as an argument")

  local hp = dict.healhealth.sip.aspriority
  local mp = dict.healmana.sip.aspriority
  local ep = dict.healego.sip.aspriority
  if what == nil then
    -- toggles health --> mana --> ego --> health
    hp, mp, ep = ep, hp, mp
  else
    local max, mid, min = 0,0,0
    for _,v in ipairs({hp,mp,ep}) do
      if v > max then
        max,mid,min = v,max,mid
      elseif v > mid then
        mid, min = v, mid
      else
        min = v
      end
    end
    if what == "health"  then
      if mp > ep then
        hp, mp, ep = max, mid, min
      else
        hp, mp, ep = max, min, mid
      end
    elseif what == "mana" then
      if hp > ep then
        mp, hp, ep = max, mid, min
      else
        mp, hp, ep = max, min, mid
      end
    elseif what == "ego" then
      if hp > mp then
        ep, hp, mp = max, mid, min
      else
        ep, hp, mp = max, min, mid
      end
    end
  end

  dict.healhealth.sip.aspriority = hp
  dict.healmana.sip.aspriority = mp
  dict.healego.sip.aspriority = ep

  local function getstring(name)
    if name == "healmana_sip" then return "<13,19,180>mana"
    elseif name == "healhealth_sip" then return "<18,181,13>health"
    elseif name == "healego_sip" then return "<181,13,18>bromide"
    end
  end

  local prios = {}
  local links = {}

  for _, j in ipairs({dict.healhealth.sip, dict.healmana.sip, dict.healego.sip}) do
    prios[j.name] = j.aspriority
    links[j.name] = j
  end

  local result = getHighestKey(prios)

  echof("Swapped to "  .. getstring(result) .. getDefaultColor() .. " sipping priority.")

  make_gnomes_work()
end


function aconfig()
  cecho("<a_darkblue>--<purple>(m&mf) <a_grey>Configuration<a_darkblue>" .. ("-"):rep(59) .. "\n")

  cecho("<a_darkcyan>  Automated healing:\n")

#if true or not skills.stag then -- medicine bag support requires squishing the columns together
  cecho("<a_darkgrey>    Sipping:              Sparkle:              Scroll:\n")

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %shealth%s %-4s"
  .."(%s%-2d%%%s) %s%-4d %shealth%s %-4s"
  .."(%s%-2d%%%s) %s%-4d %shealth%s %-4s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.siphealth, "<a_darkgrey>", "<a_cyan>", sys.siphealth, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparklehealth, "<a_darkgrey>", "<a_cyan>", sys.sparklehealth, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollhealth, "<a_darkgrey>", "<a_cyan>", sys.scrollhealth, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %smana%s %-6s"
  .."(%s%-2d%%%s) %s%-4d %smana%s %-6s"
  .."(%s%-2d%%%s) %s%-4d %smana%s %-6s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.sipmana, "<a_darkgrey>", "<a_cyan>", sys.sipmana, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparklemana, "<a_darkgrey>", "<a_cyan>", sys.sparklemana, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollmana, "<a_darkgrey>", "<a_cyan>", sys.scrollmana, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %sego%s %-7s"
  .."(%s%-2d%%%s) %s%-4d %sego%s %-7s"
  .."(%s%-2d%%%s) %s%-4d %sego%s %-7s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.sipego, "<a_darkgrey>", "<a_cyan>", sys.sipego, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparkleego, "<a_darkgrey>", "<a_cyan>", sys.sparkleego, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollego, "<a_darkgrey>", "<a_cyan>", sys.scrollego, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format("                          %sUse sparkle%-9s%sUse scroll\n",
    conf.sparkle and "<a_green>o <a_grey>" or "<a_red>x <a_darkgrey>",
    " ",
    conf.scroll and "<a_green>o <a_grey>" or "<a_red>x <a_darkgrey>"
  ))

if conf.scrollid ~= 0 then
  cecho(string.format("                          <a_green>o <a_grey>Use %-16s<a_blue>- <a_grey>ID: <a_darkgreen>%s\n\n",
    conf.secondarysparkle and conf.sparkleherb or "sparkleberry",
    tostring(conf.scrollid)
  ))
else
  cecho(string.format("                          <a_green>o <a_grey>Use %s\n\n",
    conf.secondarysparkle and conf.sparkleherb or "sparkleberry"
  ))
end
#else
  cecho("<a_darkgrey>    Sipping:           Sparkle:           Scroll:            Medicinebag:\n")

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %shealth%s %-1s"
  .."(%s%-2d%%%s) %s%-4d %shealth%s %-1s"
  .."(%s%-2d%%%s) %s%-4d %shealth%s %-1s"
  .."(%s%-2d%%%s) %s%-4d %shealth%s %-1s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.siphealth, "<a_darkgrey>", "<a_cyan>", sys.siphealth, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparklehealth, "<a_darkgrey>", "<a_cyan>", sys.sparklehealth, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollhealth, "<a_darkgrey>", "<a_cyan>", sys.scrollhealth, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.mdbaghealth, "<a_darkgrey>", "<a_cyan>", sys.mdbaghealth, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %smana%s %-3s"
  .."(%s%-2d%%%s) %s%-4d %smana%s %-3s"
  .."(%s%-2d%%%s) %s%-4d %smana%s %-3s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.sipmana, "<a_darkgrey>", "<a_cyan>", sys.sipmana, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparklemana, "<a_darkgrey>", "<a_cyan>", sys.sparklemana, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollmana, "<a_darkgrey>", "<a_cyan>", sys.scrollmana, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format(
    "%s    (%s%-2d%%%s) %s%-4d %sego%s %-4s"
  .."(%s%-2d%%%s) %s%-4d %sego%s %-4s"
  .."(%s%-2d%%%s) %s%-4d %sego%s %-4s\n",
    "<a_darkgrey>", "<a_darkcyan>", conf.sipego, "<a_darkgrey>", "<a_cyan>", sys.sipego, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.sparkleego, "<a_darkgrey>", "<a_cyan>", sys.sparkleego, "<a_grey>", "<a_darkgrey>", " ",
    "<a_darkcyan>", conf.scrollego, "<a_darkgrey>", "<a_cyan>", sys.scrollego, "<a_grey>", "<a_darkgrey>", " "
  ))

  cecho(string.format("                       %sUse sparkle%-6s%sUse scroll%-7s%sUse medicinebag\n",
    conf.sparkle and "<a_green>o <a_grey>" or "<a_red>x <a_darkgrey>",
    " ",
    conf.scroll and "<a_green>o <a_grey>" or "<a_red>x <a_darkgrey>",
    " ",
    conf.medicinebag and "<a_green>o <a_grey>" or "<a_red>x <a_darkgrey>"
  ))

if conf.scrollid ~= 0 then
  cecho(string.format("                       <a_green>o <a_grey>Use %-13s<a_blue>- <a_grey>ID: <a_darkgreen>%s\n\n",
    conf.secondarysparkle and conf.sparkleherb or "sparkleberry",
    tostring(conf.scrollid)
  ))
else
  cecho(string.format("                       <a_green>o <a_grey>Use %s\n\n",
    conf.secondarysparkle and conf.sparkleherb or "sparkleberry"
  ))
end
#end

  cecho("<a_darkcyan>  Curing status:\n")

  for k,v in config_dict:iter() do
    if v.g1 and conf[k] and not v.v2 then
      cecho("  ") fg("a_green")
      echoLink('  o  ', '$(sys).config.set("'..k..'", false, true)', 'Click to disable '..k, true)
      cecho("<a_grey>Use "..(type(v.g1) == "string" and v.g1 or v.g1())..".\n")
    elseif v.g1 and not conf[k] and not v.v2 then
      cecho("  ") fg("a_red")
      echoLink('  x  ', '$(sys).config.set("'..k..'", true, true)', 'Click to enable '..k, true)
      cecho("<a_darkgrey>Use "..(type(v.g1) == "string" and v.g1 or v.g1())..".\n")
    end
  end

  echo"\n"

  for k,v in config_dict:iter() do
    if not v.g1 and type(v.onshow) == "string" and conf[k] and not v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_green")
      echoLink('  o  ', '$(sys).config.set("'..k..'", false, true)', 'Click to disable '..k, true)
      cecho("<a_grey>"..v.onshow..".\n")
    elseif not v.g1 and type(v.onshow) == "string" and not conf[k] and not v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_red")
      echoLink('  x  ', '$(sys).config.set("'..k..'", true, true)', 'Click to enable '..k, true)
      cecho("<a_darkgrey>"..v.onshow..".\n")
    elseif not v.g1 and type(v.onshow) == "function" and conf[k] and not v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_green")
      echoLink('  o  ', '$(sys).config.set("'..k..'", false, true)', 'Click to disable '..k, true)
      v.onshow("a_grey")
    elseif not v.g1 and type(v.onshow) == "function" and not conf[k] and not v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_red")
      echoLink('  x  ', '$(sys).config.set("'..k..'", true, true)', 'Click to enable '..k, true)
      v.onshow("a_darkgrey")
    end
  end

  echo"\n"

  cecho(string.format("    <a_blue>- <a_grey>Diagnosing after <a_cyan>%s <a_grey>unknown (any) afflictions.\n", tostring(conf.unknownany)))
  cecho(string.format("    <a_blue>- <a_grey>Diagnosing after <a_cyan>%s <a_grey>unknown (focusable) afflictions.\n", tostring(conf.unknownfocus)))
  cecho(string.format("    <a_blue>- <a_grey>Highest available stance skill: <a_darkgrey>%s<a_grey>.\n", tostring(sp_config.stance_skills[#sp_config.stance_skills] and sp_config.stance_skills[#sp_config.stance_skills] or "none set")))

  fg("a_darkblue")
  echo(string.rep("-", 62))
  fg("purple") setUnderline(true) echoLink("mmconfig2", [[mm.aconfig2()]], "View mmconfig2 for advanced options", true) setUnderline(false)
  fg("a_darkblue") echo(string.rep("-", 9))
  resetFormat()

  echo"\n"
  showprompt()
  echo"\n"
end

  function aconfig2()
  cecho("<a_darkblue>--<purple>(m&mf) <a_grey>Configuration, continued<a_darkblue>" .. string.rep("-", 48) .. "\n")

  cecho("<a_darkcyan>  Pipe IDs:\n")
  cecho("<a_darkgrey>    Coltsfoot          Faeleaf            Myrtle            Steam\n")

  cecho(string.format(
    "%s    ID %s%-16d"
  .."%sID %s%-16d"
  .."%sID %s%-15d"
  .."%sID %s%d\n",
    "<a_grey>", "<a_cyan>", pipes.coltsfoot.id,
    "<a_grey>", "<a_cyan>", pipes.faeleaf.id,
    "<a_grey>", "<a_cyan>", pipes.myrtle.id,
    "<a_grey>", "<a_cyan>", pipes.steam.id
  ))

  cecho(string.format(
    "%s    Puffs %s%-2d%-11s"
  .."%sPuffs %s%-2d%-11s"
  .."%sPuffs %s%-2d%-10s"
  .."%sPuffs %s%-2d\n",
    "<a_grey>", "<a_cyan>", pipes.coltsfoot.puffs, " ",
    "<a_grey>", "<a_cyan>", pipes.faeleaf.puffs, " ",
    "<a_grey>", "<a_cyan>", pipes.myrtle.puffs, " ",
    "<a_grey>", "<a_cyan>", pipes.steam.puffs
  ))

local c1,s1 =
    unpack(pipes.coltsfoot.arty and
        {"<gold>", "Arty"} or
            (pipes.coltsfoot.lit and {"<a_yellow>", "Lit!"} or {"<a_darkgrey>", "Unlit."})

    )
local c2,s2 =
    unpack(pipes.faeleaf.arty and
        {"<gold>", "Arty"} or
            (pipes.faeleaf.lit and {"<a_yellow>", "Lit!"} or {"<a_darkgrey>", "Unlit."})

    )
local c3,s3 =
    unpack(pipes.myrtle.arty and
        {"<gold>", "Arty"} or
            (pipes.myrtle.lit and {"<a_yellow>", "Lit!"} or {"<a_darkgrey>", "Unlit."})

    )
local c4,s4 =
    unpack(pipes.steam.arty and
        {"<gold>", "Arty"} or
            (pipes.steam.lit and {"<a_yellow>", "Lit!"} or {"<a_darkgrey>", "Unlit."})

    )

  cecho(string.format("    %s%-19s%s%-19s%s%-18s%s%s\n\n",
    c1,s1,
    c2,s2,
    c3,s3,
    c4,s4
   ))

  cecho("<a_darkcyan>  Advanced options:\n")

  for k,v in config_dict:iter() do
    if not v.g1 and type(v.onshow) == "string" and conf[k] and v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_green")
      echoLink('  o  ', '$(sys).config.set("'..k..'", false, true)', 'Click to disable '..k, true)
      cecho("<a_grey>"..v.onshow..".\n")
    elseif not v.g1 and type(v.onshow) == "string" and not conf[k] and v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_red")
      echoLink('  x  ', '$(sys).config.set("'..k..'", true, true)', 'Click to enable '..k, true)
      cecho("<a_darkgrey>"..v.onshow..".\n")
    elseif not v.g1 and type(v.onshow) == "function" and conf[k] and v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_green")
      echoLink('  o  ', '$(sys).config.set("'..k..'", false, true)', 'Click to disable '..k, true)
      v.onshow("a_grey")
    elseif not v.g1 and type(v.onshow) == "function" and not conf[k] and v.v2 and not v.vconfig2string then
      cecho("  ") fg("a_red")
      echoLink('  x  ', '$(sys).config.set("'..k..'", true, true)', 'Click to enable '..k, true)
      v.onshow("a_darkgrey")
    end
  end

  echo"\n"

  cecho("    <a_blue>- <a_grey>Using "..tostring(conf.echotype and conf.echotype or conf.org).."-style echos.\n")
  cecho(string.format("    <a_blue>- <a_grey>%s\n", (function ()
    if not conf.warningtype then
      return "Extended instakill warnings are disabled."
    elseif conf.warningtype == "all" then
      if math.random(1, 10) == 1 then
        return "Will prefix instakill warnings to all lines. (can be spammy)"
      else
        return "Will prefix instakill warnings to all lines." end
    elseif conf.warningtype == "prompt" then
      return "Will prefix instakill warnings only to prompt lines."
    end
  end)()))

  cecho(string.format("    <a_blue>- <a_grey>%s.\n", (function ()
    if not conf.autowounds or conf.autowounds == 0 then
      return "Won't autocheck wounds against warriors every once in a while"
    else
      return "Will autocheck wounds after <a_cyan>"..conf.autowounds.."<a_grey> warrior hits"
    end
  end)()))

  cecho(string.format("    <a_blue>- <a_grey>Assuming <a_cyan>%s%% <a_grey>of stats under blackout/recklessness.\n", tostring(conf.assumestats)))

  cecho(string.format("    <a_blue>- <a_grey>Curing blindness with <a_darkgrey>%s<a_grey> and deafness with <a_darkgrey>%s<a_grey>.\n", conf.blindherb, conf.deafherb))

  cecho(string.format("    <a_blue>- <a_grey>Won't use mana skills below <a_cyan>%s%%<a_grey> mana.\n", tostring(conf.manause)))
#if skills.shamanism then
  cecho(string.format("    <a_blue>- <a_grey>Will make use of sheatheclaw when bleeding over <a_cyan>%s<a_grey> health.\n", tostring(conf.clawamount)))
#end
#if skills.psychometabolism then
  cecho(string.format("    <a_blue>- <a_grey>Will let bloodboil cure bleeding if we have it and while above <a_cyan>%s%%<a_grey> ego.\n", tostring(conf.egouse)))
#end
#if skills.nekotai then
  cecho(string.format("    <a_blue>- <a_grey>Placing %s poison into the left foot and %s in the right foot for scree.\n", conf.screeleft and conf.screeleft or "(none set)", conf.screeright and conf.screeright or "(none set)"))
#end
#if skills.healing then
  cecho(string.format("    <a_blue>- <a_grey>Your highest Healing skill is <a_darkgrey>%s<a_grey>; using <a_darkgrey>%s<a_grey> Healing mode.\n", (conf.healingskill and conf.healingskill or "(none set)"), tostring(conf.usehealing)))
#end

  local c = table.size(me.lustlist)
  cecho(string.format("    <a_blue>- <a_grey>Autoreject is on %slist mode%s (<a_cyan>%d <a_grey>%s on it).\n", tostring(conf.autoreject), (ignore.lovers and ", but currently off" or ""), c, (c == 1 and "person" or "people")))

  if not conf.customprompt then
    cecho("    <a_blue>- <a_grey>Standard prompt is in use.\n")
  else
    cecho("    <a_blue>- <a_grey>Custom prompt is in use (")
    echoLink("view", '$(sys).config.showprompt(); printCmdLine("mmconfig customprompt "..$(sys).conf.customprompt)', "View the custom prompt you've currently set")
    cecho("<a_grey>)\n")
  end

  for k,v in config_dict:iter() do
    if v.vconfig2string and type(v.onshow) == "string" then
      cecho("    <a_blue>- ")
      cecho("<a_grey>"..v.onshow..".\n")

    elseif v.vconfig2string and type(v.onshow) == "function" then
      cecho("    <a_blue>- ")
      v.onshow("a_grey")
    end
  end

  fg("a_darkblue")
  echo(string.rep("-", 62))
  fg("purple") setUnderline(true) echoLink("mmconfig", [[mm.aconfig()]], "View mmconfig for basic options", true) setUnderline(false)
  fg("a_darkblue") echo(string.rep("-", 10))
  resetFormat()

  echo"\n"
  showprompt()
  echo"\n"
end

function asave()
  signals.saveconfig:emit()
end

function ashow()
  echof("some m&mf info:")
  echof("Defence modes:")
  echo "  " defences.print_def_list()

  if sys.deffing then
    echof("Currently deffing up; waiting on %s to come up.", table.concat(select(2, sk.have_defup_defs()), ", "))
  end
  echof("Anti-illusion: %s", conf.aillusion and "enabled" or "disabled")
  echof("Defence keepup: %s", conf.keepup and "enabled" or "disabled")
  echof("Bashing triggers: %s", conf.bashing and "enabled" or "disabled")
  if me.doqueue.repeating then
    echof("Do-Repeat is enabled: %s", me.doqueue[1]) end

  if conf.lag ~= 0 then
    echof("Lag tolerance level: %d", conf.lag)
  end

  echofn("View parry & stance setup: ")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink("mmsp show", "echo'\\n' mm.sp.show()", "Click here to view your parry and stance setup", true)
  setUnderline(false)
  echo("\n")

  local c = table.size(me.lustlist)
  if c ~= 0 then
    echof("People we're ignoring: %d", c)
  end

  if next(affs) then
    showaffs()
  end

  echofn("View priorities (")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink("reset all to default", '$(sys).prio.usedefault(true)', "Click here to reset all of the systems curing/defup priorities back to default", true)
  setUnderline(false)
  echo("):\n")

  echo"  "
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink("herb", 'mm.printorder("herb")', 'View herb balance priorities', true)
  setUnderline(false) setUnderline(false) echo", " setUnderline(true) setUnderline(true)
  echoLink("focus", 'mm.printorder("focus")', 'View focus balance priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("salve", 'mm.printorder("salve")', 'View salve balance priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("purgative", 'mm.printorder("purgative")', 'View purgative balance priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("sip", 'mm.printorder("sip")', 'View sip balance priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("balance", 'mm.printorder("physical")', 'View balance priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("misc", 'mm.printorder("misc")', 'View miscallaneous priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("aeon/sap/choke/retardation", 'mm.printordersync()', 'View slow curing priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("stance/parry", 'mm.sp.show()', 'View the stance/parry setup', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("lucidity", 'mm.printorder("lucidity")', 'View lucidity priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("steam", 'mm.printorder("steam")', 'View steam priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("wafer", 'mm.printorder("wafer")', 'View wafer priorities', true)
  setUnderline(false) echo", " setUnderline(true)
  echoLink("ice", 'mm.printorder("ice")', 'View ice priorities', true)
  resetFormat()
  echo"\n"

  echofn("Arena mode:       ")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink(conf.arena and "enabled" or "disabled", "$(sys).tntf_set('arena', "..(conf.arena and "false" or "true").. ', false); $(sys).ashow()', (conf.arena and "Disable" or "Enable")..' arena triggers', true)

  echo"\n"
  if conf.paused then
    echof("System is currently paused.") end
  raiseEvent("m&m onshow")
  showprompt()
end

function showfocus()
  echofn("Focusing Under Aeon:       ")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink(conf.aeonfocus and "enabled" or "disabled", "$(sys).tntf_set('aeonfocus', "..(conf.aeonfocus and "false" or "true").. ', false); $(sys).showfocus()', (conf.aeonfocus and "Disable" or "Enable")..' focusing in aeon', true)
  resetFormat()
  echo"\n"

  echofn("Using Beast Focus:         ")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink(conf.beastfocus and "enabled" or "disabled", "$(sys).tntf_set('beastfocus', "..(conf.beastfocus and "false" or "true").. ', false); $(sys).showfocus()', (conf.beastfocus and "Disable" or "Enable")..' using beast to focus when possible', true)
  resetFormat()
  echo"\n"

  echofn("Using Power Focus:         ")
  setFgColor(unpack(getDefaultColorNums))
  setUnderline(true)
  echoLink(conf.powerfocus and "enabled" or "disabled", "$(sys).tntf_set('powerfocus', "..(conf.powerfocus and "false" or "true").. ', false); $(sys).showfocus()', (conf.powerfocus and "Disable" or "Enable")..' using power to focus when possible', true)
  resetFormat()
  echo"\n"

  if next(mm.me.focus) then
    local t = {}
    for aff, val in pairs(mm.me.focus) do
      t[#t+1] = aff
    end
    local str = "Currently focusing: "
    str = str + table.concat(t, ", ")
    echofn(str)
  else
    echofn("Currently not focusing any afflictions.")
  end
  echo"\n"
end


function showaffs()
  if sys.sync then echof("Slow curing mode enabled.") end
  echof("Current list of affs: " .. tostring(affs))
end


function app(what, quiet)
  assert(what == nil or what == "on" or what == "off" or type(what) == "boolean", "mm.app wants 'on' or 'off' as an argument")

  if what == "on" or what == true or (what == nil and not conf.paused) then
    conf.paused = true
  elseif what == "off" or what == false or (what == nil and conf.paused) then
    conf.paused = false
  end

  if not quiet then echof("System " .. (conf.paused and "paused" or "unpaused") .. ".") end
  raiseEvent("m&m config changed", "paused")
  showprompt()

  make_gnomes_work()
end


function dv()
  sys.manualdiag = true
  make_gnomes_work()
end

function inra()
  if not sys.enabledgmcp then echof("You need to enable GMCP for this alias to work.") return end

  sk.inring = true
  sendGMCP("Char.Items.Inv")
  sendSocket"\n"
end

function adf()
  sys.manualdefcheck = true
  make_gnomes_work()
end


function deephealme(limb)
  sys.manualdeepheal = true
  dict.deepheal.currentlimb = limb
  make_gnomes_work()
end

function manualdef()
  --~ checkaction(dict.defcheck.physical, true)
  doaction(dict.defcheck.physical)
end

function manualdiag()
  -- fake gnomes working... why?
  if sys.sync then sk.gnomes_are_working = true end

  -- if we're spamming diag faster than we're getting it from the game, don't stack the diags up
  if actions.diag_physical then killaction(dict.diag.physical) end

  doaction(dict.diag.physical)
  if sys.sync then sk.gnomes_are_working = false end
end

function awf()
  sys.manualwoundscheck = true
  make_gnomes_work()
end

function reset.affs(echoback)
  affs = {}
  setmetatable(affs, affmt)

  for _,k in ipairs({"rightarm", "leftarm", "leftleg", "rightleg", "chest", "gut", "head"}) do
    dict["light" .. k].count, dict["medium" .. k].count, dict["heavy" .. k].count, dict["critical" .. k].count = 0, 0, 0, 0
  end

  for aff, _ in pairs(affl) do
    removeaff(aff)
    raiseEvent("m&m lost aff", aff)
  end
  affl = {}

  actions = pl.OrderedMap()
  lifevision.l = pl.OrderedMap()
  bals_in_use = {}
  actions_performed = {}
  sk.onpromptfuncs = {}
  signals.aeony:emit()
  signals.canoutr:emit()
  check_generics()
  inamodule = false
  if echoback then echof("all afflictions reset.") end
end

function reset.defs(echoback)
  local keepcrowform, keeprunicamulet = defc.crowform, defc.runicamulet

  defc = {
    crowform    = keepcrowform,
    runicamulet = runicamulet
  }

  if echoback then echof("all defences reset.") end
end

function ignorelist()
  local t = {}
  local count = 0

  local skip
  for k,v in pairs(dict) do
    for balance, _ in pairs(v) do
      if (balance == "waitingfor" and not v.aff) then skip = true end
    end

    if not skip then t[#t+1] = k end
    skip = false
  end
  table.sort(t)
  echof("Things we can ignore:") echo"  "

  for _, name in ipairs(t) do
    echo(string.format("%-20s", name))
    count = count + 1
    if count % 4 == 0 then echo "\n  " end
  end
end

function afflist()
  local t = {}
  local count = 0

  for k,v in pairs(dict) do
    if v.aff then t[#t+1] = k end
  end
  table.sort(t)
  echof("Affliction list (%d):", #t) echo"  "

  local underline = setUnderline; _G.setUnderline = function () end
  for _, name in ipairs(t) do
    if dechoLink then
      dechoLink(string.format("%-"..(not mm.valid["proper_"..name] and 23 or 37).."s", not mm.valid["proper_"..name] and name or name.." <0,128,128>pr<r>"),
        string.format([[mm.echof("Function to use for this aff:\nmm.valid.%s()")]],  not mm.valid["proper_"..name] and "simple"..name or "proper_"..name), "Click to the the function to use for "..name, true)
    else
      decho(string.format("%-"..(not mm.valid["proper_"..name] and 23 or 37).."s", not mm.valid["proper_"..name] and name or name.." <0,128,128>pr<r>"))
    end
    count = count + 1
    if count % 4 == 0 then echo "\n  " end
  end
  _G.setUnderline = underline
end

function overhaullist()
  local t = {}
  local count = 0

  for k,v in pairs(dict) do
    if v.aff then t[#t+1] = k end
  end
  table.sort(t)
  echof("Overhaul affliction toggle list (%d):", #t) echo"  "

  -- count how many afflictions use overhaul curing now, and how many have been replaced
  local overhaulchanged, overhaulreplaced = 0, 0

  local underline = setUnderline; _G.setUnderline = function () end
  for _, name in ipairs(t) do
    -- true - enabled, and can can toggle on/off
    if overhaul[name] == true then fg("a_green"); overhaulchanged = overhaulchanged +1
    -- string value - enabled, but can't toggle on/off (enabled via something else)
    elseif overhaul[name] then fg("ForestGreen"); overhaulreplaced = overhaulreplaced +1
    elseif not overhaul[name] and sk.overhauldata[name] then fg("white"); overhaulchanged = overhaulchanged +1
    else fg("a_darkgrey") end

    if not overhaul[name] and not sk.overhauldata[name] then
      echo(string.format("%-23s", name))
    else
      -- if it's not a boolean, then it is a text explaining why is it such - can't be toggled
      if type(overhaul[name]) == "string" then
        echoLink(string.format("%-23s", name), '', overhaul[name]:title(), true)
      else
        echoLink(string.format("%-23s", name),
          overhaul[name] and "mm.disableoverhaul('"..name.."', true)" or
                             "mm.enableoverhaul('"..name.."', true)"
          , "Click to "..(overhaul[name] and "stop" or "start").." treating "..name.." like an Overhaul aff", true)
      end
    end
    count = count + 1
    if count % 4 == 0 then echo "\n  " end
  end
  _G.setUnderline = underline
  resetFormat()
  echo'\n'
  echof("Overhaul stats: %s affs can use Overhaul cures, %s have been replaced by another aff.", overhaulchanged, overhaulreplaced)
  showprompt()
end

function adddefinition(tag, func)
  assert(type(tag) == "string" and type(func) == "string", "mm.adddefinition: need both tag and function to be strings")
  cp.adddefinition(tag, func)
end

function aignore(action, balance)
  if not dict[action] then
    echofn("%s isn't something you can ignore, see ", action)
    setFgColor(unpack(getDefaultColorNums))
    setUnderline(true)
    echoLink("mmshow ignorelist", '$(sys).ignorelist()', 'Click to see the list of things you can ignore', true)
    setUnderline(false)
    echo(" for the list of possibilities.\n")
    showprompt()
    return
  end

  if balance and not bals[balance] then echof("%s isn't a balance you can ignore on, possible ones are: %s", balance, oneconcat(bals)) showprompt() return end

  if balance and ignore[action] and type(ignore[action]) == "table" and ignore[action].balances and ignore[action].balances[balance] then
    ignore[action].balances[balance] = nil
    if not next(ignore[action].balances) then
      ignore[action] = nil
      echof("Won't ignore %s anymore.", action)
    else
      echof("Won't ignore %s on %s balance anymore", action, balance)
    end

  elseif balance and not (ignore[action] and type(ignore[action]) == "table" and ignore[action].balances and ignore[action].balances[balance]) then
      -- if already ignoring in general, change it to a partial ignore
      if type(ignore[action]) == "boolean" and ignore[action] then
         ignore[action] = nil
         echof("Took %s off full ignore, will do a partial ignore instead.", action)
      end

    ignore[action] = ignore[action] or {}
    ignore[action].balances = ignore[action].balances or {}
    ignore[action].balances[balance] = true
    echof("Will ignore curing/doing %s on the %s balance now.", action, balance)

  elseif ignore[action] then
    ignore[action] = nil
    echof("Won't ignore %s anymore.", action)

  else
    ignore[action] = true
    echof("Will ignore curing/doing %s now.", action)
  end
  showprompt()
end

signals.systemstart:connect(function ()
  winningTrigger = tempExactMatchTrigger([["WINNING!" you scream, pumping a fist in the air like an idiot.]], [[mm.valid.winning1()]])
end)

function show_ignore()
  echof("Things we're ignoring:%s", not next(ignore) and " (none)" or '')

  local fullignores, partialignores = {}, {}

  setFgColor(unpack(getDefaultColorNums))
  for key in pairs(ignore) do
    echo(string.format("  %-18s", tostring(key)))
    echo("(")
    setUnderline(true)
    echoLink("remove", '$(sys).ignore.'..tostring(key)..' = nil; $(sys).echof("Took '..tostring(key)..' off ignore.")', 'Remove '..tostring(key)..' from the ignore list', true)
    setUnderline(false)
    echo(")")

    if dict[key] and dict[key].description then
      echo(" - "..dict[key].description)

      if type(ignore[key]) == 'table' and ignore[key].because then
        echo(", ignoring because "..ignore[key].because)
      end
    else
      if type(ignore[key]) == "table" and ignore[key].because then
        echo(" - because "..ignore[key].because)
      end

    end

    if type(ignore[key]) == "table" and ignore[key].balances and next(ignore[key].balances) then
      echo(" (partially; only on "..concatand(keystolist(ignore[key].balances)).." balance"..(#keystolist(ignore[key].balances) > 1 and 's' or '')..")")
    end

    echo("\n")
  end
  showprompt()
end

