#!/usr/bin/lua

-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

local preprocess = require "luapp" . preprocess
require "luarocks.loader"
local lapp    = require 'pl.lapp'
local lfs     = require 'lfs'
local stringx = require 'pl.stringx'
local tablex  = require 'pl.tablex'
local file    = require 'file'
local compile = require 'compile'

local cwd = lfs.currentdir()

local args = lapp [[
-d,--debug  Build with debugging information enabled
-r,--release (default false) Build all systems
-o,--own  Build an m&mf for yourself
 <name> (default me )  Name to build a system for
]]

--[[
 To build a new update, do:
- commit whatever is left first
- increment the version in this file
- run ./precommit.lua
- bzr commit -m "<new version> update"
- bzr tag <new version>
- finally, run ./generate.lua -r -p
]]

local name    = args.name
local release = not args.debug
local version = args.release
local doall   = args.release ~= "false"
local own     = args.own
local defaultaddons = {
  "peopletracker", "demesne", "namedb", "harvester", "healing", "influencer", "plsorter",
  aeromancer = "meldtracker",
  aquamancer = "meldtracker",
  blacktalon = {"meldtracker", "carriontracker"},
  geomancer  = "meldtracker",
  pyromancer = "meldtracker",
}

io.input(cwd.."/classlist.lua")
local s = io.read("*all")

-- load file into our sandbox; credit to http://lua-users.org/wiki/SandBoxes
local i = {}
-- run code under environment
local function run(untrusted_code)
  local untrusted_function, message = loadstring(untrusted_code)
  if not untrusted_function then return nil, message end
  setfenv(untrusted_function, i)
  return pcall(untrusted_function)
end

assert(run (s))

local function oneconcat(tbl)
  assert(type(tbl) == "table", "oneconcat wants a table as an argument.")
  local result = {}
  for i,_ in pairs(tbl) do
    result[#result+1] = i
  end

  return table.concat(result, ", ")
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '') --trim left spaces
  s = string.gsub(s, '%s+$', '') --trim right spaces
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function dowork(systemfor, release, own)
  systemfor = stringx.title(systemfor)

  local tbl = {}
  tbl.name = systemfor
  tbl.version = version
  tbl.ipairs = ipairs
  tbl.string = string
  tbl.pairs = pairs
  tbl.table = table
  tbl.type = type
  tbl.tostring = tostring
  tbl.require = require
  tbl.package = package
  tbl.class = systemfor
  tbl.io = io
  tbl.skills = {
    highmagic = true,
    lowmagic = true,
    ascendance = true,
  }
  tbl.guild = systemfor
  tbl.sys = "mm"
  tbl.url = {}
  tbl.addons = {}


  if type(tbl.class) == "string" then
    tbl.class = tbl.class:lower()
  else
    for _, class in pairs(tbl.class) do
      tbl.class[class] = class:lower()
    end
  end

  -- add default addons
  for k, addon in pairs(defaultaddons) do
    if not (type(k) ~= 'number' and k ~= tbl.class) then
      if type(addon) == "string" and not tablex.find(tbl.addons, addon) then
      tbl.addons[#tbl.addons+1] = addon
      elseif type(addon) == "table" then
        for _, addn in pairs(addon) do
          if not tablex.find(tbl.addons, addn) then
            tbl.addons[#tbl.addons+1] = addn
          end
        end
      end
    end
  end


  local classes = stringx.split(systemfor:lower(), " & ")


  for _, class in ipairs(classes) do
    -- setup tbl.skills of the person as key-true table
    for _, skillset in ipairs(i.skills[class]) do
      tbl.skills[skillset] = true
    end
  end

  print(string.format("Doing system for %s, skills are: %s", systemfor, oneconcat(tbl.skills)))

  if not release then
    tbl.DEBUG_actions = true
    tbl.DEBUG_lifevision = true
    tbl.DEBUG = true
    tbl.DEBUG_diag = true
    tbl.DEBUG_prio = true
  else
    tbl.DEBUG_actions = false
    tbl.DEBUG_lifevision = false
    tbl.DEBUG = false
    tbl.DEBUG_diag = false
    tbl.DEBUG_prio = false
  end


  local files = {
    "mm.setup", "mm.misc", "mm.empty", "mm.dict", "mm.skeleton", "mm.controllers", "mm.actionsystem", "mm.pipes", "mm.rift", "mm.valid.diag", "mm.valid.simple", "mm.valid.main", "mm.config", "mm.install", "mm.aliases", "mm.defs", "mm.prio", "mm.sp", "mm.funnies", "mm.dor", "mm.customprompt"
  }

  if next(tbl.addons) then
    for _, addon in pairs(tbl.addons) do
      if type(addon) == "string" and not tablex.find(files, "mm."..addon) then
        files[#files+1] = "mm."..addon
      end
    end
    print(string.format("Added %s addon%s to the system...", table.concat(tbl.addons, ", "), #tbl.addons ~= 1 and "s" or ""))
  end

  local result, message
  for _,j in ipairs(files) do
    result, message = pcall(preprocess, {input = {"raw-".. j ..".lua"}, output = {"bin/".. j ..".lua"}, lookup = tbl})
    if not result then print("Failed on "..j.."; "..message) return end
  end

  tbl.files = files

  result, message = preprocess({input = {"raw-end.lua"}, output = {"bin/end.lua"}, lookup = tbl})
  if not result then print(message) end

  -- clean old
  os.remove(cwd.."/bin/m&m.lua")
  os.remove(cwd.."/bin/m&m")

  -- compile new m&m
  compile.dowork(tbl.addons)
  assert(loadfile(cwd.."/bin/m&m")) -- do a compile of the concatinated m&m to
                                    -- check the syntax

  -- clear existing addons
  local mm_template = cwd.."/m&m template"
  for item in lfs.dir(mm_template) do
    local xmlname = item:match(".+%.xml$")
    if xmlname and xmlname ~= "m&m (import me).xml" then os.remove(mm_template.."/"..item) end
  end

  -- copy the m&m over to the template folder
  file.copy(cwd.."/bin/m&m", cwd.."/m&m template/m&m")

  -- if building for yourself, also move it to the own m&mf folder, so it can be used
  if own then
    file.copy(cwd.."/bin/m&m", cwd.."/own m&mf/m&m")
  end

  -- update config.lua
  local f = io.open(cwd.."/m&m template/config.lua", "w+")
  f:write(string.format([[mpackage = "%s m&m"]], systemfor))
  f:flush()
  f:close()

  -- copy new addons in
  for _, addon in pairs(tbl.addons) do
    file.copy(cwd..[[/m&m (]]..addon..[[).xml]], cwd..[[/m&m template/m&m (]]..addon..[[).xml]])
  end

    -- copy main system in
  file.copy(cwd.."/m&m (import me).xml", cwd.."/m&m template/m&m (import me).xml")

  print("Making a package...")
  local cmd = [[7z a -tzip "]]..systemfor..[[ m&m" "]]..cwd..[[/m&m template/*" > NUL:]]
  os.execute(cmd)

  -- send away to output folder
  file.move(cwd.."/"..systemfor.." m&m.zip", cwd.."/output/"..systemfor..".m-mf.v"..version..".zip")
  print("All done! How good is that!")
end


if doall then
  for class, _ in pairs(i.skills) do
    local s,m = pcall(dowork, class, release, own)
    if not s then print(m) return end
  end
else
  local s,m = pcall(dowork, name, release, own)
  if not s then print(m) end
end

