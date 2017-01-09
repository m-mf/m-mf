-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

cpp = {}

for _, stat in ipairs {"health", "mana", "ego", "endurance", "willpower"} do
  cpp["compute_"..stat.."_percent"] = function()
    return math.floor((stats["current"..stat]/stats["max"..stat])*100)
  end
end

for _, stat in ipairs {"health", "mana", "ego", "endurance", "willpower"} do
  cpp["compute_"..stat.."_colour"] = function()
    if stats["current"..stat] >= (stats["max"..stat] * .75) then
      return "<a_darkgreen>"
    elseif stats["current"..stat] >= (stats["max"..stat] * .25) then
      return "<a_yellow>"
    else
      return "<a_red>" end
  end
end

cpp.compute_xp = function()
  return stats.nextlevel or "(N/A)"
end

cpp.compute_reverse_xp = function()
  if not stats.nextlevel then return "(N/A)" end

  return 100 - stats.nextlevel
end

cpp.compute_comma_essence = function()
  return commas(stats.essence)
end

cpp.compute_short_essence = function()
  return convert_mag(stats.essence)
end

cpp.compute_short_essence2 = function()
  return convert_mag2(stats.essence)
end

cpp.compute_power_colour = function()
  if stats.currentpower >= 7 then
    return "<a_darkgreen>"
  elseif stats.currentpower >= 2 then
    return "<a_yellow>"
  else
    return "<a_red>" end
end

cpp.compute_defs = function()
  local t = {}
  if affs.deaf or defc.truedeaf then
    t[#t+1] = "d"
  end

  if affs.blind or defc.trueblind then
    t[#t+1] = "b"
  end

  if defc.kafe then
    t[#t+1] = "k"
  end

  if defc.rebounding then
    t[#t+1] = "r"
  end

  return table.concat(t)
end

cpp.compute_eqbal = function()
  local t = {}

  if bals.equilibrium then t[#t+1] = "e" end
  if bals.balance then t[#t+1] = "x" end

  return table.concat(t)
end

cpp.compute_armbal = function()
  local t = {}

  if bals.leftarm == true then
    t[#t+1] = "l"
  elseif bals.leftarm ~= false then
    t[#t+1] = "?" end

  if bals.rightarm == true then
    t[#t+1] = "r"
  elseif bals.rightarm ~= false then
    t[#t+1] = "?" end

  return table.concat(t)
end

cpp.compute_prone = function ()
  return (affs.prone and "p" or "")
end

cpp.compute_Prone = function ()
  return (affs.prone and "P" or "")
end

#if skills.psionics then
cpp.compute_psibal = function()
  local t = {}

  if bals.sub == true then
    t[#t+1] = "<a_darkgreen>s"
  elseif bals.sub ~= false then
    t[#t+1] = "<blue>s" end

  if bals.super == true then
    t[#t+1] = "<a_darkgreen>S"
  elseif bals.super ~= false then
    t[#t+1] = "<blue>S" end

  if bals.id == true then
    t[#t+1] = "<a_darkgreen>i"
  elseif bals.id ~= false then
    t[#t+1] = "<blue>i" end

  return table.concat(t)
end
#end

#if skills.healing then
cpp.compute_empathy = function ()
  return stats.empathy
end

cpp.compute_empathy_colour = function ()
  if stats.empathy > 75 then
    return "<a_darkgreen>"
  elseif stats.empathy > 25 then
    return "<a_yellow>"
  else
    return "<a_red>"
  end
end
#end

#if skills.kata then
cpp.compute_momentum = function ()
  if stats.momentum ~= 0 then
    return stats.momentum.."mo"
  end

  return ""
end

cpp.compute_momentum_colour = function ()
  if not stats.momentum or stats.momentum == 0 then
    return ""
  elseif stats.momentum == 1 then
    return "<a_onemo>"
  elseif stats.momentum == 2 then
    return "<a_twomo>"
  elseif stats.momentum == 3 then
    return "<a_threemo>"
  elseif stats.momentum == 4 then
    return "<a_fourmo>"
  elseif stats.momentum == 5 then
    return "<a_fivemo>"
  elseif stats.momentum == 6 then
    return "<a_sixmo>"
  else
    return ""
  end

end
#end

cpp.compute_diffmana = function()
  return (me.manachange > 0 and "+"..me.manachange or (me.manachange < 0 and me.manachange or ''))
end
cpp.compute_diffhealth = function()
  return (me.healthchange > 0 and "+"..me.healthchange or (me.healthchange < 0 and me.healthchange or ''))
end
cpp.compute_diffego = function()
  return (me.egochange > 0 and "+"..me.egochange or (me.egochange < 0 and me.egochange or ''))
end

cpp.compute_diffmana_paren = function()
  return (me.manachange > 0 and "(+"..me.manachange..")" or (me.manachange < 0 and "("..me.manachange..")" or ''))
end
cpp.compute_diffhealth_paren = function()
  return (me.healthchange > 0 and "(+"..me.healthchange..")" or (me.healthchange < 0 and "("..me.healthchange..")" or ''))
end
cpp.compute_diffego_paren = function()
  return (me.egochange > 0 and "(+"..me.egochange..")" or (me.egochange < 0 and "("..me.egochange..")" or ''))
end

cpp.compute_diffmana_bracket = function()
  return (me.manachange > 0 and "[+"..me.manachange.."]" or (me.manachange < 0 and "["..me.manachange.."]" or ''))
end
cpp.compute_diffhealth_bracket = function()
  return (me.healthchange > 0 and "[+"..me.healthchange.."]" or (me.healthchange < 0 and "["..me.healthchange.."]" or ''))
end
cpp.compute_diffego_bracket = function()
  return (me.egochange > 0 and "[+"..me.egochange.."]" or (me.egochange < 0 and "["..me.egochange.."]" or ''))
end

cp.definitions = {
  ["@health"]        = "mm.stats.currenthealth",
  ["@mana"]          = "mm.stats.currentmana",
  ["@ego"]           = "mm.stats.currentego",
  ["@willpower"]     = "mm.stats.currentwillpower",
  ["@endurance"]     = "mm.stats.currentendurance",
  ["@power"]         = "mm.stats.currentpower",
  ["@reserves"]      = "mm.stats.powerreserves",
  ["@maxhealth"]     = "mm.stats.maxhealth",
  ["@maxmana"]       = "mm.stats.maxmana",
  ["@maxego"]        = "mm.stats.maxego",
  ["@maxwillpower"]  = "mm.stats.maxwillpower",
  ["@maxendurance"]  = "mm.stats.maxendurance",
  ["@esteem"]        = "mm.stats.esteem",
  ["@essence"]       = "mm.stats.essence",
  ["@commaessence"]  = "mm.cpp.compute_comma_essence()",
  ["@shortessence"]  = "mm.cpp.compute_short_essence()",
  ["@shortessence2"] = "mm.cpp.compute_short_essence2()",
  ["@%health"]       = "mm.cpp.compute_health_percent()",
  ["@%mana"]         = "mm.cpp.compute_mana_percent()",
  ["@%ego"]          = "mm.cpp.compute_ego_percent()",
  ["@%willpower"]    = "mm.cpp.compute_willpower_percent()",
  ["@%endurance"]    = "mm.cpp.compute_endurance_percent()",
  ["@%xp"]           = "mm.cpp.compute_xp()",
  ["@-%xp"]          = "mm.cpp.compute_reverse_xp()",
  ["@defs"]          = "mm.cpp.compute_defs()",
  ["@eqbal"]         = "mm.cpp.compute_eqbal()",
  ["@armbal"]        = "mm.cpp.compute_armbal()",
  ["@prone"]         = "mm.cpp.compute_prone()",
  ["@Prone"]         = "mm.cpp.compute_Prone()",
  ["@diffhealth"]   = "svo.cpp.compute_diffhealth()",
  ["@(diffmana)"]   = "svo.cpp.compute_diffmana_paren()",
  ["@(diffhealth)"] = "svo.cpp.compute_diffhealth_paren()",
  ["@[diffmana]"]   = "svo.cpp.compute_diffmana_bracket()",
  ["@[diffhealth]"] = "svo.cpp.compute_diffhealth_bracket()",
#if skills.psionics then
  ["@psibal"]        = "mm.cpp.compute_psibal()",
#end
#if skills.kata then
  ["@mo"]            = "mm.cpp.compute_momentum()",
#end
#if skills.healing then
  ["@emp"]           = "mm.cpp.compute_empathy()",
#end
  ["^1"]             = "mm.cpp.compute_health_colour()",
  ["^2"]             = "mm.cpp.compute_mana_colour()",
  ["^3"]             = "mm.cpp.compute_ego_colour()",
  ["^4"]             = "mm.cpp.compute_willpower_colour()",
  ["^5"]             = "mm.cpp.compute_endurance_colour()",
  ["^6"]             = "mm.cpp.compute_power_colour()",
#if skills.kata then
  ["^7"]             = "mm.cpp.compute_momentum_colour()",
#end
#if skills.healing then
  ["^8"]             = "mm.cpp.compute_empathy_colour()",
#end
  ["^r"]             = "'<a_red>'",
  ["^R"]             = "'<a_darkred>'",
  ["^g"]             = "'<a_green>'",
  ["^G"]             = "'<a_darkgreen>'",
  ["^y"]             = "'<a_yellow>'",
  ["^Y"]             = "'<a_darkyellow>'",
  ["^b"]             = "'<a_blue>'",
  ["^B"]             = "'<a_darkblue>'",
  ["^m"]             = "'<a_magenta>'",
  ["^M"]             = "'<a_darkmagenta>'",
  ["^c"]             = "'<a_cyan>'",
  ["^C"]             = "'<a_darkcyan>'",
  ["^w"]             = "'<a_white>'",
  ["^W"]             = "'<a_darkwhite>'",
}

function cp.adddefinition(tag, func)
  local func = string.format("tostring(%s)", func)

  cp.definitions[tag] = func
  cp.makefunction()
end

function cp.makefunction()
  if not conf.customprompt then return end

  local t = cp.generatetable(conf.customprompt)

  cp.display = loadstring("return table.concat({"..table.concat(t, ", ").."})")
end
signals.systemstart:connect(cp.makefunction)

signals.systemstart:connect(function ()
  if not conf.oldcustomprompt or conf.oldcustomprompt == "off" then
    conf.oldcustomprompt = conf.customprompt
  end
end)

function cp.generatetable(customprompt)
  local t = {}
  local ssub = string.sub

  local tags_array = {}
  for def, defv in pairs(cp.definitions) do
    tags_array[#tags_array+1] = {def = def, defv = defv}
  end

  table.sort(tags_array, function(a,b) return #a.def > #b.def end)

  local buffer = ""

  local function add_character(c)
      buffer = buffer .. c
  end

  local function add_buffer()
    if buffer ~= "" then
      t[#t+1] = "'" .. buffer .. "'"
      buffer = ""
    end
  end

  local function add_code(c)
      add_buffer()
      t[#t+1] = c
  end

  while customprompt ~= "" do
    local matched = false

    for i = 1, #tags_array do
      local def = tags_array[i].def

      if ssub(customprompt, 1, #def) == def then
        add_code(tags_array[i].defv)
        customprompt = ssub(customprompt, #def + 1)
        matched = true
        break
      end
    end

    if not matched then
      add_character(ssub(customprompt, 1, 1))
      customprompt = ssub(customprompt, 2)
    end

  end

  add_buffer()

  return t
end

-- import color_table
for color in pairs(color_table) do
  cp.definitions["^"..color] = "'<"..color..">'"
end
