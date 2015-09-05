-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

mm.pls_version = "1.1"

-- stores vial ID and months left
pls_vials = {}
-- stores type by key, and inside each, a potion table
pls_potions = {}

pls_knownstuff = pls_knownstuff or {}

pls_decaycount = 0

function pls_capture()
  for k,v in pairs(pls_potions) do
    pls_potions[k] = nil
    pls_vials = {}
  end
end

config.setoption("plist",
{
  type = "custom",
  vconfig2string = true,
  onshow = function (defaultcolour)
    fg("gold")
    echoLink("pls:", "", "m&mf Plist Sorter", true)
    -- change desired amounts; considering vials about to decay at 5 or less months
    fg("a_cyan") echoLink(" set vial amounts", "mm.config.set'plist'", "Click to change the minimum amounts of vials you'd like to have", true)
    fg(defaultcolour) echo("; considering vials about to decay at")
    fg("a_cyan") echoLink(" "..(conf.decaytime or '?'), "printCmdLine'mmconfig decaytime '", "Click to change the amount of months at which a vial will be considered for throwing away", true)
    fg(defaultcolour)
    echo(".\n")
  end,
  onmenu = function ()
    -- sort into categories
    local t = {}
    for k,v in pairs(pls_knownstuff) do t[pls_categories[k] or "unknown"] = t[pls_categories[k] or "unknown"] or {}; t[pls_categories[k] or "unknown"][#t[pls_categories[k] or "unknown"]+1] = k end

    echof("Set the desired amount for each potion by clicking on the number:")
    for catn, catt in pairs(t) do
      echof("%s%s:", catn:title():sub(1, -2), (catn:sub(-1) == "y" and "ies" or catn:sub(-1).."s"))

      for _, potion in pairs(catt) do
        local amount = pls_knownstuff[potion]
        echo(string.format("  %30s ", potion))
        fg("blue")
        echoLink(" "..amount.." ", 'printCmdLine"mmconfig setpotion '..(pls_shortnamesr[potion] and pls_shortnamesr[potion] or "unknown").. ' '..amount..'"', "Change how many vials of "..potion.." you'd like to have", true)
        resetFormat()
        echo"\n"
      end
    end
  end
})

conf.decaytime = conf.decaytime or 3
config.setoption("decaytime",
{
  type = "number",
  onset = function () echof("Will consider vials available for disposal when they decay time is at or less than %d months.", conf.decaytime) end
})

config.setoption("setpotion",
{
  type = "string",
  onset = function()
    if not conf.setpotion:find("^%w+ %d+$") then echof("What amount do you want to set?") return end

    local potion, amount = conf.setpotion:match("^(%w+) (%d+)$")
    amount = tonumber(amount)
    if pls_shortnames[potion] then
      pls_knownstuff[pls_shortnames[potion]] = amount
      echof("Made a note that we'd like to have a minimum %s of %s.", amount, potion)
      return
    elseif not pls_knownstuff[potion] then
      echof("I haven't seen any potions called '%s' yet...", potion)
    else
      pls_knownstuff[potion] = amount
      echof("Made a note that we'd like to have a minimum %s of %s.", amount, potion)
      return
    end
  end
})

function pls_appendrequest()
  local t = {}
  for catn, catt in pairs(pls_potions) do
    for potn, pott in pairs(catt) do
      if pls_knownstuff[potn] and pott.vials < pls_knownstuff[potn] then
        t[#t+1] = (pls_knownstuff[potn] - pott.vials) .. " ".. (pls_shortnamesr[potn] and pls_shortnamesr[potn] or potn)
      end
    end
  end

  if #t == 0 then echof("I don't think you're short on anything!") return
  else appendCmdLine(" I'd like "..table.concat(t, ", ")) end
end

function pls_refillfromkeg()
  local t = {}
  for catn, catt in pairs(pls_potions) do
    for potn, pott in pairs(catt) do
      if pls_knownstuff[potn] and pott.vials < pls_knownstuff[potn] and (pls_shortnamesr[potn] and pls_shortnamesr[potn] or potn) ~= "empty" then
        for i = 1, pls_knownstuff[potn] - pott.vials do
          t[#t+1] = string.format("refill empty from %s", (pls_shortnamesr[potn] and pls_shortnamesr[potn] or potn))
        end
      end
    end
  end

  if #t == 0 then echof("I don't think you're short on anything!") return
  else
    sendAll(unpack(t))
  end
end

function pls_captured()
  tempTimer(0, function()
    local missing = 0
    local decaying

    local function checkdecays(pott)
      if pott.decays == 0 then return ""
      else decaying = (decaying or 0) + pott.decays return (pott.decays.." decaying soon") end
    end

    for catn, catt in pairs(pls_potions) do
      echof("%s%s:", catn:title():sub(1, -2), (catn:sub(-1) == "y" and "ies" or catn:sub(-1).."s"))

      for potn, pott in pairs(catt) do
        if pls_knownstuff[potn] and pott.vials < pls_knownstuff[potn] then
          missing = missing + pls_knownstuff[potn] - pott.vials
          echon("%3d %-30s%7s  %10s", pott.vials, potn, (pls_knownstuff[potn] - pott.vials .. " short"), checkdecays(pott))
        else
          echon("%3d %-30s%7s  %10s", pott.vials, potn, "", checkdecays(pott))
        end
      end
    end
    echo"  "; dechoLink("<0,0,250>("..getDefaultColor().."change desired amounts<0,0,250>)", "mm.config.set('plist')", "Show a menu to change how much of what would you like to have", true) echo"\n"
    if decaying then echo"  "; dechoLink("<0,0,250>("..getDefaultColor().."dispose of "..decaying.." decays<0,0,250>)", "printCmdLine'dispose of decays by: put vial in nexus'", "Dispose of vials (pouring them into other vials if possible) with a custom command.\nMake sure to include the word 'vial' in the command", true) echo"\n" end
    if missing > 0 then
      echo"  "
      dechoLink("<0,0,250>("..getDefaultColor().."append refill request, need "..missing.." refills<0,0,250>)", "mm.pls_appendrequest()", "Insert how many refills would you like into the command line.\nYou should pre-type whenever you want to say or tell this to anyone, and then click", true)
      echo"\n  "
      dechoLink("<0,0,250>("..getDefaultColor().."refill from shops/kegs, need "..missing.." refills<0,0,250>)", "mm.pls_refillfromkeg()", "Click here to refill all necessary things from personal or shop kegs", true)
      echo"\n"
    end
    showprompt()
    pls_decaycount = decaying
  end)
end


function pls_dispose(cmd)
  local function emptyvial(id)
    if pls_vials[id].sips == 0 then echof("%d is already empty.", id) return end
    echof("Emptying vial%d with %s.", id, pls_vials[id].potion)

    -- one pass is enough! If we don't completely dispose of it, then that's alright
    for otherid, t in pairs(pls_vials) do
      if otherid ~= id and (t.potion == pls_vials[id].potion or t.potion == "empty") and t.sips < (type(t.months) == "number" and 60 or 110) and
        (type(t.months) ~= "number" or t.months > conf.decaytime) then

        local deltacapacity = (type(t.months) == "number" and 60 or 110) - t.sips -- this is how much we can fill it up by
        echof("Can fill vial %d with %d more sips.", otherid, deltacapacity)

        local fillingwith = (pls_vials[id].sips < deltacapacity and pls_vials[id].sips or deltacapacity)
        echof("Filling vial with %d sips.", fillingwith)

        send(string.format("pour %d into %d", id, otherid))

        t.sips = t.sips + fillingwith
        echof("Poured %s into %s is now at %d sips", pls_vials[id].potion, tostring(otherid), tostring(t.sips))

        pls_vials[id].sips = pls_vials[id].sips - fillingwith
        echof("Decayable %s is now at %d sips", id, pls_vials[id].sips)

        if t.potion == "empty" then t.potion = pls_vials[id].potion; echof("Poured into empty now has %s potion", tostring(t.potion)) end
        if pls_vials[id].sips <= 0 then echof("Vial %s fully emptied.\n--", tostring(id)) return end
      end
    end
    echof("Vial %d with '%s' wasn't fully emptied, no space to pour it into now.\n--", id, pls_vials[id].potion)
  end

  if not cmd:find("vial", 1, true) then echof("Please include the word 'vial' in the command. Thanks!") return end
  if not next(pls_vials) or not next(pls_potions) then echof("Don't know of any vials you have - check 'pl' please.") return end

  if pls_potions.empty and pls_potions.empty.empty and pls_potions.empty.empty.vials then
    if pls_decaycount > pls_potions.empty.empty.vials and not pls_warned then
      pls_warned = true
      echof("You possibly don't have enough empties to cover all vials (have %d decaying, %s empty, thus need %d more). Do you want to do this again anyway? If yes, then do the command again.", pls_decaycount, pls_potions.empty.empty.vials, pls_decaycount - pls_potions.empty.empty.vials)
      return
    end
  end

  local haddecays
  for id, t in pairs(pls_vials) do
    if type(t.months) == "number" and t.months <= conf.decaytime then
      emptyvial(id)
      send(cmd:gsub("vial", id), false)
      haddecays = true
    end
  end

  pls_warned = false
  if haddecays then
    echof("Disposing of vials which have %d or less months on them...", conf.decaytime)
  else
    echof("Don't have any vials which have under %d months :)", conf.decaytime)
  end
  showprompt()
end

signals.saveconfig:connect(function () table.save(getMudletHomeDir() .. "/mm/config/pls_knownstuff", pls_knownstuff) end)
signals.systemstart:connect(function ()
  local conf_path = getMudletHomeDir() .. "/mm/config/pls_knownstuff"

  if lfs.attributes(conf_path) then
    table.load(conf_path, pls_knownstuff)
  end
end)

tempTimer(0, function()
  -- append with defaults
  for longname, category in pairs(pls_categories or {}) do
    if category == "potion" or category == "purgative" or category == "salve" then
      pls_knownstuff[longname] = pls_knownstuff[longname] or 2
    end
  end
end)

echof("Loaded m&mf Plist Sorter, version %s.", tostring(pls_version))
