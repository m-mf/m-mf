-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.


vecho = function(newline, what)
  decho("<206,222,215>(<214,206,221>m<161,143,176>&<214,206,221>mf<206,222,215>)<252,251,254>: <249,244,254>" .. what)
  if newline then echo("\n") end
end


function echos.Serenwilde(newline, what)
  decho("<157,60,60>(<55,145,55>m<0,109,0>&<55,145,55>mf<157,60,60>)<212,245,112>: <62,245,62>" .. what)
  if newline then echo("\n") end
end

function echosd.Serenwilde()
  return "<62,245,62>"
end

function echos.SerenwildeLight(newline, what)
  decho("<255,231,179>(<170,154,118>m<135,101,24>&<170,154,118>mf<255,231,179>)<255,241,210>: <255,219,140>" .. what)
  if newline then echo("\n") end
end

function echosd.SerenwildeLight()
  return "<255,219,140>"
end

function echos.Magnagora(newline, what)
  decho("<157,60,60>(<255,0,0>m<118,0,0>&<255,0,0>mf<157,60,60>)<255,65,65>: <255,117,117>" .. what)
  if newline then echo("\n") end
end

function echosd.Magnagora()
  return "<255,117,117>"
end

function echos.Glomdoring(newline, what)
  decho("<80,66,80>(<107,79,125>m<54,21,76>&<107,79,125>mf<80,66,80>)<87,85,89>: <159,128,180>" .. what)
  if newline then echo("\n") end
end

function echosd.Glomdoring()
  return "<159,128,180>"
end

function echos.Celest(newline, what)
  decho("<32,128,94>(<53,213,157>m<0,111,72>&<53,213,157>mf<32,128,94>)<53,213,157>: <0,171,111>" .. what)
  if newline then echo("\n") end
end

function echosd.Celest()
  return "<0,171,111>"
end

function echos.Hallifax(newline, what)
  decho("<206,222,215>(<170,175,175>m<73,152,152>&<170,175,175>mf<206,222,215>)<252,251,254>: <237,244,244>" .. what)
  if newline then echo("\n") end
end

function echosd.Hallifax()
  return "<237,244,244>"
end

function echos.Gaudiguch(newline, what)
  decho("<253,63,73>(<251,0,13>m<163,0,8>&<251,0,13>mf<253,63,73>): <253,114,121>" .. what)
  if newline then echo("\n") end
end

function echosd.Gaudiguch()
  return "<253,114,121>"
end

function echos.default(newline, what)
  decho("<206,222,215>(<214,206,221>m<161,143,176>&<214,206,221>mf<206,222,215>)<252,251,254>: <249,244,254>" .. what)
  if newline then echo("\n") end
end

function echosd.default()
  return "<249,244,254>"
end

signals.systemstart:connect(function ()
  vecho = echos[conf.echotype] or echos[conf.org] or echos.default
  getDefaultColor = echosd[conf.echotype] or echosd[conf.org] or echosd.default

  -- create an r,g,b table that we can setFgColor(unpack(getDefaultColorNums)) later
  getDefaultColorNums = {
    ((echosd[conf.echotype] and echosd[conf.echotype]())
      or (echosd[conf.org] and echosd[conf.org]()) or
      echosd.default()
    ):match("<(%d+),(%d+),(%d+)>")}
end)

signals.orgchanged:connect(function ()
  vecho = echos[conf.echotype] or echos[conf.org] or echos.default
  getDefaultColor = echosd[conf.echotype] or echosd[conf.org] or echosd.default

  -- create an r,g,b table that we can setFgColor(unpack(getDefaultColorNums)) later
  getDefaultColorNums = {
    ((echosd[conf.echotype] and echosd[conf.echotype]())
      or (echosd[conf.org] and echosd[conf.org]()) or
      echosd.default()
    ):match("<(%d+),(%d+),(%d+)>")}
end)

function showprompt()
  if conf.paused then
    decho("<255,0,0>(<128,128,128>p<255,0,0>)<0,0,0> ")
  end

  if not conf.customprompt or inamodule then
    moveCursor("mm_prompt",0,getLastLineNumber("mm_prompt")-1)
    selectCurrentLine("mm_prompt")
    copy("mm_prompt")
    appendBuffer()
  else
    cecho(cp.display() or "")
  end
end

function echof(...)
  if not ... then
#if DEBUG then
    debugf("[m&mf error]: echof empty; \n%s", debug.traceback())
    echo("(e!)")
#end
    return
  end

  moveCursorEnd("main")
  vecho(true, string.format(...))
end

function echofn(...)
  if not ... then
#if DEBUG then
    debugf("[m&mf error]: echofn empty; \n%s", debug.traceback())
    echo("(e!)")
#end
    return
  end

  moveCursorEnd("main")
  vecho(false, string.format(...))
end

local function errorf(...)
   error(string.format(...))
end

function itf(...)
  dinsertText(((echosd[conf.echotype] and echosd[conf.echotype]()) or (echosd[conf.org] and echosd[conf.org]()) or echosd.default()) .. string.format(...) or "")
  -- debugf((echosd[conf.echotype] and echosd[conf.echotype]() or echosd.default()) .. string.format(...) or "")
end

local function debugf(...)
#if DEBUG then
  if not ... then Logger:Log("m-mf", "EMPTY!") return end
  local t = {...}
  local s,m = xpcall(
    function() return string.format(unpack(t)) end,
    function()
      echo("(e!) ")
      debugf(debug.traceback())
    end)
  if s then Logger:Log("m-mf", m) end
#end
end

mm.debugf = debugf

-- need "okay" and "not okay" colors as well

-- given a table of keys and values as integers, return the key with highest value
local function getHighestKey(tbl)
  assert(type(tbl) == "table", "mm.getHighestKey wants a table passed to it")

  local result
  local highest = -1
  for i,j in pairs(tbl) do
    if j > highest then
      highest = j
      result = i
    end
  end

  return result
end

local function getLowestKey(tbl)
  assert(type(tbl) == "table", "mm.getLowestKey wants a table passed to it")

  local result = select(1, next(tbl))
  local lowest = select(2, next(tbl))
  for i,j in pairs(tbl) do
    if j < lowest then
      lowest = j
      result = i
    end
  end

  return result
end

local function getHighestValue(tbl)
  assert(type(tbl) == "table", "mm.getHighestValue wants a table passed to it")

  local result
  local highest = 0
  for i,j in pairs(tbl) do
    if j > highest then
      highest = j
      result = i
    end
  end

  return highest
end

local function getBoundary(tbl)
  local result
  local highest, lowest = 0, select(2, next(tbl))
  for i,j in pairs(tbl) do
    if j > highest then
      highest = j
      result = i
    elseif j < lowest then
      lowest = j
    end
  end

  return highest, lowest
end

function oneconcat(tbl)
  assert(type(tbl) == "table", "mm.oneconcat wants a table as an argument.")
  local result = {}
  for i,_ in pairs(tbl) do
    result[#result+1] = i
  end

  return table.concat(result, ", ")
end

local function oneconcatwithval(tbl)
  assert(type(tbl) == "table", "mm.oneconcatwithval wants a table as an argument.")
  local result = {}
  for i,_ in pairs(tbl) do
    result[#result+1] = i .. "(" .. _ .. ")"
  end

  return table.concat(result, ", ")
end

function concatand(t)
  assert(type(t) == "table", "mm.concatand: argument must be a table")

  if #t == 0 then return ""
  elseif #t == 1 then return t[1]
  else
    return table.concat(t, ", ", 1, #t-1) .. " and "..t[#t]
  end
end

function keystolist(t)
  local r = {}

  for k,v in pairs(t) do
    r[#r+1] = k
  end

  return r
end

function safeconcat(t, separator)
  assert(type(t) == "table", "$(sys).safeconcat: argument must be a table")

  if #t == 0 then return ""
  elseif #t == 1 then return tostring(t[1])
  else
    local temp = {}
    for i = 1, #t do
      temp[#temp+1] = tostring(t[i])
    end
    return table.concat(temp, separator or '')
  end
end

function deleteLineP(count)
  if not count then
    deleteLine()
    gagline = true
    sk.onprompt_beforeaction_add("deleteLine", function ()
      gagline = false
    end)
  end
  tempLineTrigger(count or 1,1,[[
if isPrompt() then
  deleteLine()
  deleteLineP(1)
end
]])
end

function deleteAllP(count)
  if not count then deleteLine() end
  tempLineTrigger(count or 1,1,[[
  deleteLine()
if not isPrompt() then
  mm.deleteAllP()
end
]])
end

local function containsbyname(t, value)
  assert(type(t) == "table", "mm.containsbyname wants a table!")
  for k, v in pairs(t) do
    if v == value then return k end
  end

  return false
end

local function contains(t, value)
  assert(type(t) == "table", "mm.contains wants a table!")
  for k, v in pairs(t) do
    if v == value then
      return true
    elseif k == value then
      return true
    elseif type(v) == "table" then
      if contains(v, value) then return true end
    end
  end

  return false
end

-- longer priorities take the first order
local function syncdelay()
  if not sys.sync then
    return 0
  elseif affs.aeon or affs.choke or affs.retardation then
    return 1
  elseif affs.sap then
    return 0.5
  else return 0 -- failsafe
  end
end

function events(event, arg)
  local name = event:lower()
  if signals[name] then signals[name]:emit(arg) end
end

function gevents(parent, key)
  local name = key:gsub("%.",""):lower()
  if signals[name] then signals[name]:emit() end
end

function deepcopy(object)
  local lookup_table = {}
  local function _copy(object)
      if type(object) ~= "table" then
          return object
      elseif lookup_table[object] then
          return lookup_table[object]
      end
      local new_table = {}
      lookup_table[object] = new_table
      for index, value in pairs(object) do
          new_table[_copy(index)] = _copy(value)
      end
      return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end

local yes = {"yes", "yep", "yup", "oui", "on", "y", "da"}
local no = {"no", "nope", "non", "off", "n", "net"}
local function convert_string(which)
  if contains(yes, which) or which == true then return true end
  if contains(no, which) or which == false then return false end

  return nil
end

toboolean = convert_string

function find_until_last_paragraph (pattern, use_matching)
  local t = getLines(lastpromptnumber, getLastLineNumber("main"))

  for _, line in ipairs(t) do
    if not use_matching and line == pattern then return true
    elseif use_matching and string.find(line, pattern) then return true end
  end

  return false
end


-- merge table2 into table1
update = function(t1, t2)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      t1[k] = update(t1[k] or {}, v)
    else
      t1[k] = v
    end
  end
  return t1
end

local function emptyphp(what)
  for _ in what:pairs() do
    return false
  end

  return true
end

oldsend = _G.send
local fancy_echo_commands = {}

local function fancysend(what, store)
  oldsend(what, false)
  if (conf.doubledo and (affs.stupidity or affs.void or affs.fracturedskull)) and not sys.sync then oldsend(what, false) end
  if conf.repeatcmd > 0 then for i = 1, conf.repeatcmd do oldsend(what, false) end end

  if not store then return end

  fancy_echo_commands[#fancy_echo_commands+1] = what
end

local function fancysendall()
  if #fancy_echo_commands == 0 then return end

  decho(string.format("<51,0,255>(<242,234,233>%s<51,0,255>)", table.concat(fancy_echo_commands, "<102,98,97>|<242,234,233>")))
  fancy_echo_commands = {}
end

-- check if we need to adjust parrying on any limbs or not
local function check_sp_satisfied()
  if sp_something_to_parry() then
    for name, limb in pairs(sp_config.parry_shouldbe) do
      if limb ~= sps.parry_currently[name] then
       sys.sp_satisfied = false; return
      end
    end
  elseif sp_config.priority[1] and sps.parry_currently[sp_config.priority[1]] ~= 100 then
    sp_config.parry_shouldbe[sp_config.priority[1]] = 100
    sys.sp_satisfied = false; return
  end
  sys.sp_satisfied = true
end

sp_limbs = {
  head = "head",
  gut = "gut",
  chest = "chest",
  rightarm = "rarm",
  leftarm = "larm",
  rightleg = "rleg",
  leftleg = "lleg"
}


local yep = function ()
  return "<0,250,0>Yep" .. getDefaultColor()
end

local nope = function ()
  return "<250,0,0>Nope" .. getDefaultColor()
end

local red = function (what)
  return "<250,0,0>" .. what .. getDefaultColor()
end

local green = function (what)
  return "<0,250,0>" .. what .. getDefaultColor()
end

function sk.reverse(a)
  return (a:gsub("().", function (p)
    return a:sub(#a-p+1,#a-p+1);
  end))
end


-- rewielding
--[[
basis:
  we re-wield items only we know we had wielded, that we unwielded involuntarily

  received items.update - if it doesn't have an 'l' or an 'r' attribute, then it means we unwielded it, or picked it up, or whatever. So, check if we had it wielded - if we did, then this was unwielded. needs rewielding.

  received items.updateif it does have an 'l' or an 'r' attribute, remember this as wielded - save in mm.me.wielding_left or mm.me.wielding_right.
]]

signals.gmcpcharname:connect(function ()
  sendGMCP("Char.Items.Inv")
end)

signals.gmcpcharitemslist:connect(function()
  -- catch what is wielded
  local t = gmcp.Char.Items.List
  if t.location ~= "inv" then return end

  me.wielded = {}
  for _, item in pairs(t.items) do
    if item.id and item.attrib and string.find(item.attrib, 'l', 1, true) then
      me.wielded[item.id] = deepcopy(item)
      me.wielded[item.id].hand = "unknown"
    end
  end
end)

function unwielded(item)
  if not item.id then
    return
  end

  sk.rewielddables = sk.rewielddables or {}
  if not (sk.rewielddables[1] and sk.rewielddables[1].id == itemid) then
    sk.rewielddables[#sk.rewielddables+1] = {id = item.id, name = item.name}
  end

  if conf.autorewield then
    sk.onprompt_beforeaction_add("check for forced unwield", function ()
      if paragraph_length > 1 and not find_until_last_paragraph("^You begin to wield", true) then -- detect if this was forced or not
        -- we wish to rewield wieldables!
        dict.rewield.rewieldables = deepcopy(sk.rewielddables)
        echof("Need to rewield %s%s!", tostring(dict.rewield.rewieldables[1].name), tostring(dict.rewield.rewieldables[2] and (" and "..dict.rewield.rewieldables[2].name) or ""))
      end

      sk.rewielddables = nil
    end)
  end

  me.wielded[item.id] = nil
end

signals.gmcpcharitemsupdate:connect(function ()
  local t = gmcp.Char.Items.Update

  if type(me.wielded) ~= "table" then return end

  -- unwielded?
  if t.item.id and me.wielded[t.item.id] and (not t.item.attrib or not string.find(t.item.attrib, 'l', 1, true)) then
    unwielded(t.item)

  -- wielded?
  elseif t.location == "inv" and t.item.attrib and t.item.id and string.find(t.item.attrib, 'l', 1, true) and not me.wielded[t.item.id] then
    me.wielded[t.item.id] = deepcopy(t.item)
    me.wielded[t.item.id].hand = "unknown"

    checkaction(dict.rewield.physical)
    if actions.rewield_physical then
      lifevision.add(actions.rewield_physical.p, nil, t.item.id)
    end
  end
end)

-- from Nick Gammon's forums
function commas (num)
  assert (type (num) == "number" or
          type (num) == "string")

  local result = ""

  -- split number into 3 parts, eg. -1234.545e22
  -- sign = + or -
  -- before = 1234
  -- after = .545e22

  local sign, before, after =
    string.match (tostring (num), "^([%+%-]?)(%d*)(%.?.*)$")

  -- pull out batches of 3 digits from the end, put a comma before them

  while string.len (before) > 3 do
    result = "," .. string.sub (before, -3, -1) .. result
    before = string.sub (before, 1, -4)  -- remove last 3 digits
  end -- while

  -- we want the original sign, any left-over digits, the comma part,
  -- and the stuff after the decimal point, if any
  return sign .. before .. result .. after

end -- function commas

-- could be improved
function convert_mag (num)
  assert(type(num) == "number", "input must be a number")
  local t, tc = {"k", "m"}, {1000, 1000000}

  local m = math.floor(math.log10(num)/3)
  if t[m] then
    return string.format("%.1f%s", num/tc[m], t[m])
  else return num end
end
function convert_mag2 (num)
  assert(type(num) == "number", "input must be a number")
  local t, tc = {"k", "m"}, {1000, 1000000}

  local m = math.floor(math.log10(num)/3)
  if t[m] then
    return string.format("%.2f%s", num/tc[m], t[m])
  else return num end
end
