-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

--[[  basic idea: if asked to eat something, and we a) don't have it (or not enough),
      or b) are in aeon and have it we outr it, and eat it

      otherwise just eat
  ]]
pl.dir.makepath(getMudletHomeDir() .. "/m&m/rift+inv")

rift.riftcontents = {}
rift.invcontents = {}
me.riftcontents = rift.riftcontents
me.invcontents = rift.invcontents

rift.precache = {}
rift.precachedata = {}

rift.doprecache = false

rift.allherbs = {"arnica", "calamus", "chervil", "colewort", "coltsfoot", "earwort", "faeleaf", "flax", "galingale", "horehound", "juniper", "kafe", "kombu", "marjoram", "merbloom", "mistletoe", "myrtle", "pennyroyal", "rawtea", "reishi", "rosehips", "sage", "sargassum", "sparkleberry", "spices", "weed", "wormwood", "yarrow", "steam", "dust",}
rift.curativeherbs = {"arnica", "calamus", "chervil", "coltsfoot", "earwort", "faeleaf", "galingale", "horehound", "kafe", "kombu", "marjoram", "myrtle", "pennyroyal", "reishi", "sparkleberry",  "wormwood", "yarrow", "merbloom", "steam", "dust"}
rift.functionalherbs = {"colewort", "flax", "juniper", "merbloom", "mistletoe", "rawtea", "rosehips", "sage", "sargassum", "spices", "weed"}
rift.sparkleherbs = {"arnica", "calamus", "chervil", "colewort", "coltsfoot", "earwort", "faeleaf", "flax", "galingale", "horehound", "kafe", "kombu", "marjoram", "merbloom", "myrtle", "pennyroyal","rawtea","reishi","weed","wormwood","yarrow"}

rift.resetriftcontents = function()
  for _, herb in ipairs(rift.allherbs) do
    rift.riftcontents[herb] = 0
  end

  myrift = rift.riftcontents
end

rift.resetinvcontents = function()
  for _, herb in ipairs(rift.allherbs) do
    rift.invcontents[herb] = 0
  end

  myinv = rift.invcontents
end

rift.resetriftcontents()
rift.resetinvcontents()

rift.herbs_plural = {
  arnica       = "(%d+) arnica buds",
  calamus      = "(%d+) calamus roots",
  chervil      = "(%d+) chervil sprigs",
  colewort     = "(%d+) colewort leaves",
  coltsfoot    = "(%d+) coltsfoot plugs",
  earwort      = "(%d+) pieces of earwort",
  faeleaf      = "(%d+) faeleaf stalks",
  flax         = "(%d+) bunches of flax",
  galingale    = "(%d+) galingale stems",
  horehound    = "(%d+) horehound blossoms",
  juniper      = "(%d+) juniper berries",
  kafe         = "(%d+) kafes",
  kombu        = "(%d+) clumps of kombu seaweed",
  marjoram     = "(%d+) marjoram sprigs",
  merbloom     = "(%d+) merblooms",
  mistletoe    = "(%d+) mistletoe sprigs",
  myrtle       = "(%d+) bog myrtle leaves",
  pennyroyal   = "(%d+) pennyroyal bunches",
  rawtea       = "(%d+) raw tea leaves",
  reishi       = "(%d+) reishi mushrooms",
  rosehips     = "(%d+) rosehips",
  sage         = "(%d+) sage branches",
  sargassum    = "(%d+) clumps of sargassum seaweed",
  sparkleberry = "(%d+) sparkleberries",
  spices       = "(%d+) spice packets",
  steam        = "(%d+) clumps of soothing steam",
  dust         = "(%d+) wafers of purity dust",
  weed         = "(%d+) weed sprigs",
  wormwood     = "(%d+) wormwoods",
  yarrow       = "(%d+) yarrow sprigs",
}

rift.herbs_singular = {
  ["a bog myrtle leaf"]           = "myrtle",
  ["a bunch of flax"]             = "flax",
  ["a bunch of pennyroyal"]       = "pennyroyal",
  ["a calamus root"]              = "calamus",
  ["a clump of soothing steam"]   = "steam",
  ["a colewort leaf"]             = "colewort",
  ["a horehound blossom"]         = "horehound",
  ["a juniper berry"]             = "juniper",
  ["a kafe bean"]                 = "kafe",
  ["a packet of spices"]          = "spices",
  ["a piece of black earwort"]    = "earwort",
  ["a piece of merbloom seaweed"] = "merbloom",
  ["a pile of rosehips"]          = "rosehips",
  ["a plug of coltsfoot"]         = "coltsfoot",
  ["a reishi mushroom"]           = "reishi",
  ["a sage branch"]               = "sage",
  ["a sparkleberry"]              = "sparkleberry",
  ["a sprig of cactus weed"]      = "weed",
  ["a sprig of chervil"]          = "chervil",
  ["a sprig of marjoram"]         = "marjoram",
  ["a sprig of mistletoe"]        = "mistletoe",
  ["a stalk of faeleaf"]          = "faeleaf",
  ["a stem of galingale"]         = "galingale",
  ["a wafer of purity dust"]      = "dust",
  ["a wormwood stem"]             = "wormwood",
  ["a yarrow sprig"]              = "yarrow",
  ["an arnica bud"]               = "arnica",
  ["kombu seaweed"]               = "kombu",
  ["raw tea leaves"]              = "rawtea",
  ["sargassum seaweed"]           = "sargassum",
}

-- non-herb items - used in inra sorting
rift.items_plural = {
  redtint    = "(%d+) redtints",
  bluetint   = "(%d+) bluetints",
  goldtint   = "(%d+) goldtints",
  greentint  = "(%d+) greentints",
  purpletint = "(%d+) purpletints",
  yellowtint = "(%d+) yellowtints",
}

rift.items_singular = {
  ["a red tincture"]    = "redtint",
  ["a blue tincture"]   = "bluetint",
  ["a gold tincture"]   = "goldtint",
  ["a green tincture"]  = "greentint",
  ["a purple tincture"] = "purpletint",
  ["a yellow tincture"] = "yellowtint",
}


local function intlen(number)
  return number == 0 and 1 or math.floor(math.log10(number)+1)
end

rift.update_riftlabel = function()
  if true then return end
  local count = 0
  local tbl = {}
  local columncount = 3
  local charwidth = 20

  for _, j in pairs(rift.curativeherbs) do
    count = count + 1

    tbl[#tbl+1] = string.format([[<font style="color:grey;">%s</font>%s%d<font style="color:grey;">/</font>%d ]], j, string.rep("&nbsp;", charwidth - #j- intlen(rift.invcontents[j]) - intlen(rift.riftcontents[j])), rift.invcontents[j], rift.riftcontents[j])
    if count % columncount == 0 then tbl[#tbl+1] = "<br />" end
  end

  --~ echo("mm_rift", string.format([[<center><p style="font-size: small; color:white; font-weight:;">%s</p></center>]], table.concat(tbl)))
end

rift.outr = function (what)
  if not sys.canoutr then return end

  if (rift.precache[what] and rift.precache[what] == 0) or not rift.invcontents[what] or not rift.precache[what] or (rift.invcontents[what] and rift.precache[what] and (rift.invcontents[what] - 1 >= rift.precache[what])) then
    send("outr " .. what, conf.commandecho)
  else
   send("outr " .. (rift.precache[what] - rift.invcontents[what] + 1) .. " " .. what, conf.commandecho)
  end

  -- allow other outrs to catch up, then re-check again
  if sys.blockoutr then killTimer(sys.blockoutr); sys.blockoutr = nil end
  sys.blockoutr = tempTimer(sys.wait + syncdelay(), function () sys.blockoutr = nil;  make_gnomes_work() end)
end

rift.checkprecache = function()
  rift.doprecache = false

  for herb, amount in pairs(rift.precache) do
    if rift.precache[herb] ~= 0 and (rift.invcontents[herb] < rift.precache[herb]) then
      rift.doprecache = true; return
    end
  end
end

rub_cleanse = function()
  if not conf.soap then
    if not conf.cleansetype or conf.cleansetype == "enchant" then
      send("rub cleanse", conf.commandecho)
      if conf.autorecharge and not sys.sync then
        send("recharge cleanse from cube", conf.commandecho) end
    elseif conf.cleansetype == "spell" then
      send("cast cleanse me", conf.commandecho)
#if skills.healing then
    elseif conf.usehealing ~= "none" then
      send("sanitise me", conf.commandecho)
#end
    end
  else
    send("scrub", conf.commandecho) end
end

function sk.synceat(what, focus, aff)
  if focus then
    send("eat "..what.." "..focus.." "..aff, conf.commandecho)
  else
    send("eat " .. what, conf.commandecho)
  end
end

function sk.asynceat(what, focus, aff)
  if focus then
    send("eat "..what.." "..focus.." "..aff, conf.commandecho)
  else
    send("eat " .. what, conf.commandecho)
  end
end
eat = sk.asynceat

signals.aeony:connect(function ()
  if sys.sync then
    eat = sk.synceat
  else
    eat = sk.asynceat
  end
end)

function sk.asyncfill(what, where)
  if rift.invcontents[what] > 0 then
    send("put " .. what .. " in " .. where, conf.commandecho)
    rift.outr(what)
  else
    rift.outr(what)
    send("put " .. what .. " in " .. where, conf.commandecho)
  end
end

function sk.syncfill(what, where)
  if rift.invcontents[what] > 0 then
    send("put " .. what .. " in " .. where, conf.commandecho)
  else
    rift.outr(what)
  end
end
fillpipe = sk.asyncfill

signals.aeony:connect(function ()
  if sys.sync then
    fillpipe = sk.syncfill
  else
    fillpipe = sk.asyncfill
  end
end)

function sk.applyarnica_async(where)
  if rift.invcontents.arnica > 0 then
    send("apply arnica to " .. where, conf.commandecho)
    rift.outr("arnica")
  else
    rift.outr("arnica")
    send("apply arnica to " .. where, conf.commandecho)
  end
end
applyarnica = sk.applyarnica_async

function sk.applyarnica_sync()
  if rift.invcontents.arnica > 0 then
    send("apply arnica to " .. where, conf.commandecho)
  else
    rift.outr("arnica")
  end
end

signals.aeony:connect(function ()
  if sys.sync then
    applyarnica = sk.applyarnica_sync
  else
    applyarnica = sk.applyarnica_async
  end
end)

function riftline()
  for i = 1, #matches, 3 do
    rift.riftcontents[matches[i+1]] = tonumber(matches[i+2])
  end

  rift.update_riftlabel()
end

function showrift()
  display(rift.riftcontents)
end

function showinv()
  display(rift.invcontents)
end

function showprecache()
  local count = 1

  local function makelink(herb, sign)
    if sign == "-" and rift.precache[herb] == 0 then
      echo " "
    elseif sign == "+" then
      echoLink(sign, [[mm.setprecache("]]..herb..[[", 1, "add", nil, true)]], sign .. " the " .. herb .. " amount")
    elseif sign == "-" then
      echoLink(sign, [[mm.setprecache("]]..herb..[[", 1, "subtract", nil, true)]], sign .. " the " .. herb .. " amount")
    else
      echo " "
    end

    return ""
  end

--[[  moveCursor("main", 0, getLastLineNumber("main"))
  debugf("line: " .. getCurrentLine() .. ", latest: " .. getLastLineNumber("main"))
  if getCurrentLine() == "-" or getCurrentLine() == " " then
    insertText(" ")
    for i = 1, 1000 do deleteLine()
    debugf("deleting") end
  end]]
  echof("Herb pre-cache list (%s mode):", defs.mode)

  local t = {}; for herb in pairs(rift.precache) do t[#t+1] = herb end; table.sort(t)
  for i = 1, #t do
  local herb, amount = t[i], rift.precache[t[i]]
    if count % 3 ~= 0 then
      decho(string.format("<153,204,204>[<91,134,214>%d<153,204,204>%s%s] %-"..(intlen(amount) == 1 and "23" or "22").."s", amount, makelink(herb, "+"), makelink(herb, "-"), herb))
    else
      decho(string.format("<153,204,204>[<91,134,214>%d<153,204,204>%s%s] %s", amount, makelink(herb, "+"), makelink(herb, "-"), herb)) end

    if count % 3 == 0 then echo("\n") end
    count = count + 1
  end

--[[  moveCursor("main", 0, getLastLineNumber("main"))
  moveCursor("main", #getCurrentLine(), getLastLineNumber("main"))
  insertText("\n-\n")]]
  echo"\n"
  showprompt()
end

function setprecache(herb, amount, flag, echoback, show_list)
  local sendf
  if echoback then sendf = echof else sendf = errorf end

  assert(rift.precache[herb], "what herb do you want to set a precache amount for?", sendf)

  if flag == "add" then
    rift.precache[herb] = rift.precache[herb] + amount
  elseif flag == "subtract" then
    rift.precache[herb] = rift.precache[herb] - amount
    if rift.precache[herb] < 0 then rift.precache[herb] = 0 end
  elseif not flag or flag == "set" then
    rift.precache[herb] = amount
  end

  if echoback then
    echof("Will keep at least %d of %s out in the inventory now.", rift.precache[herb], herb)
  elseif show_list then
    showprecache()
  end
  rift.checkprecache()
end

function invline()
  local line = line
  rift.resetinvcontents()

  local tabledline = line:split(", ")

  -- for everything we got in our inv
  for i = 1, #tabledline do
    local j = tabledline[i]
    if j:sub(-1) == "." then j = j:sub(1,#j - 1) end -- kill trailing dot

    -- tally up rift.herbs_singular items
    if rift.herbs_singular[j] then
      rift.invcontents[rift.herbs_singular[j]] = rift.invcontents[rift.herbs_singular[j]] + 1
    end

    -- tally up rift.herbs_plural items
    for k,l in pairs(rift.herbs_plural) do

      local result = j:match(l)

      if result then
        --~ echof("local %s = %s:match(%s)", result, j, l)
        rift.invcontents[k] = rift.invcontents[k] + tonumber(result)
      end
    end
  end

  rift.update_riftlabel()
  rift.checkprecache()
end

function riftremoved()
  local removed = tonumber(matches[2])
  local what = matches[3]
  local inrift = tonumber(matches[4])

  if rift.riftcontents[what] then rift.riftcontents[what] = inrift end
  if rift.invcontents[what] then rift.invcontents[what] = rift.invcontents[what] + removed end

  rift.update_riftlabel()

  signals.removed_from_rift:emit(removed, what, inrift)

  -- don't add
  checkaction(dict.doprecache.misc, false)
  if actions.doprecache_misc then
    lifevision.add(actions.doprecache_misc.p)
  end
end

function riftadded()
  local removed = tonumber(matches[2])
  local what = matches[3]
  local inrift = tonumber(matches[4])

  if rift.riftcontents[what] then rift.riftcontents[what] = inrift end
  if rift.invcontents[what] then rift.invcontents[what] = rift.invcontents[what] - removed end
  if rift.invcontents[what] and rift.invcontents[what] < 0 then rift.invcontents[what] = 0 end

  rift.update_riftlabel()
  rift.checkprecache()
end

function riftnada()
  local what = matches[2]
  if rift.invcontents[what] then rift.invcontents[what] = 0 end

  rift.update_riftlabel()
  rift.checkprecache()
end

function riftate()
  local what = matches[2]

  if not rift.herbs_singular[what] then return end

  if not conf.arena then
    rift.invcontents[rift.herbs_singular[what]] = rift.invcontents[rift.herbs_singular[what]] - 1
    if rift.invcontents[rift.herbs_singular[what]] < 0 then rift.invcontents[rift.herbs_singular[what]] = 0 end
  end

  rift.update_riftlabel()
  rift.checkprecache()
end

do
  local oldCL = createLabel
  function createLabel(name, posX, posY, width, height, fillBackground)
    oldCL(name, 0, 0, 0, 0, fillBackground)
    moveWindow(name, posX, posY)
    resizeWindow(name, width, height)
  end
end

function valid.winning2()
  killTrigger(winning1Trigger)
  winning2Timer = tempTimer(math.random(10, 30), [[mm.valid.winning2TimerAct()]])
end

function valid.winning2TimerAct()
  cecho("\n<green> Ok, first step done, how do we greet someone?")
  winning2Trigger = tempExactMatchTrigger("You eagerly look around for someone interesting to cruise but come up disappointed.", [[mm.valid.winning3()]])
end

function create_riftlabel()
  local mainwidth, mainheight = getMainWindowSize()
  local width, height = 350,90

  --~ createLabel("mm_rift", mainwidth-width, mainheight-height-20, width, height, 0)
end

signals.systemstart:add_post_emit(function ()
  create_riftlabel()

  if lfs.attributes(getMudletHomeDir() .. "/m&m/rift+inv/rift") then
    table.load(getMudletHomeDir() .. "/m&m/rift+inv/rift", rift.riftcontents)
  end
  if lfs.attributes(getMudletHomeDir() .. "/m&m/rift+inv/inv") then
    table.load(getMudletHomeDir() .. "/m&m/rift+inv/inv", rift.invcontents)
  end

  for mode, _ in pairs(defdefup) do
    rift.precachedata[mode] = {}

    for _,herb in pairs(rift.curativeherbs) do
      rift.precachedata[mode][herb] = 0
    end
  end
  --~ display(rift.precachedata)

  local tmp = {}
  if lfs.attributes(getMudletHomeDir() .. "/m&m/rift+inv/precachedata") then
    table.load(getMudletHomeDir() .. "/m&m/rift+inv/precachedata", tmp)
    update(rift.precachedata, tmp)
    rift.precache = rift.precachedata[defs.mode]
    --~ display(rift.precache)
  end
  rift.update_riftlabel()
end)

signals.saveconfig:connect(function ()
  table.save(getMudletHomeDir() .. "/m&m/rift+inv/rift", rift.riftcontents)
  table.save(getMudletHomeDir() .. "/m&m/rift+inv/inv", rift.invcontents)
  table.save(getMudletHomeDir() .. "/m&m/rift+inv/precachedata", rift.precachedata)
end)


signals.aeony:emit()

