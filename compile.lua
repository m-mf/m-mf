#!/usr/bin/lua

-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

local compile = {}

function compile.dowork(addons)
  local f,msg = io.open("bin/m&m", "w+")
  if not f then print(msg) return end

  -- load dependencies in
  for _, luamodule in ipairs({
    {"notify.signal", "bin/notify/signal.lua"},
    {"notify.double_queue", "bin/notify/double_queue.lua"},

    {"pl.config", "bin/pl/config.lua"},
    {"pl.dir", "bin/pl/dir.lua"},
    {"pl.pretty", "bin/pl/pretty.lua"},
    {"pl.stringx", "bin/pl/stringx.lua"},
    {"pl.utils", "bin/pl/utils.lua"},
    {"pl.lexer", "bin/pl/lexer.lua"},
    {"pl.path", "bin/pl/path.lua"},
    {"pl.class", "bin/pl/class.lua"},
    {"pl.tablex", "bin/pl/tablex.lua"},
    {"pl.List", "bin/pl/List.lua"},
    {"pl.Map", "bin/pl/Map.lua"},
    {"pl.OrderedMap", "bin/pl/OrderedMap.lua"},
  }) do
  	io.input(luamodule[2])
  	local contents = io.read("*a")
    f:write(([[package.preload['%s'] = (function (...)
      ]]):format(luamodule[1]))
  	f:write(contents)
    f:write([[
     end)]])
  end

  -- load m&m files in
  for _, mmfile in ipairs({"bin/start.lua", "bin/mm.setup.lua", "bin/mm.misc.lua", "bin/mm.empty.lua", "bin/mm.dict.lua", "bin/mm.skeleton.lua", "bin/mm.controllers.lua", "bin/mm.actionsystem.lua", "bin/mm.pipes.lua", "bin/mm.rift.lua", "bin/mm.valid.diag.lua", "bin/mm.valid.simple.lua", "bin/mm.valid.main.lua", "bin/mm.config.lua", "bin/mm.install.lua", "bin/mm.aliases.lua", "bin/mm.defs.lua", "bin/mm.prio.lua", "bin/mm.sp.lua", "bin/mm.funnies.lua", "bin/mm.dor.lua", "bin/mm.customprompt.lua"}) do
    io.input(mmfile)
    local contents = io.read("*a")
    f:write(contents)
  end

  for _,addon in pairs(addons) do
    io.input("bin/mm."..addon..".lua")
    local contents = io.read("*a")
    f:write(contents)
  end

  io.input("bin/end.lua")
  local contents = io.read("*a")
  f:write(contents)

  f:flush()
  f:close()
end

return compile
