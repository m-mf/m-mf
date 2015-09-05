-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

--[[
Dusk has overtaken the light in Lusternia.
The phase of the moon is that of the Waxing Crescent.

In your world, it is 2010/08/03 16:02:06 GMT.
See HELP GMT for an explanation of GMT.

It is deep night in Lusternia, before midnight.

It is the middle of the night in Lusternia.]]

life.hellotrigs = {}

life.hellodata = {
  ["Dusk has overtaken the light in Lusternia."] = function ()
    local t = {"Good evening.", "Good evening, " .. sys.charname..".", "Hello!"}
    echof(t[math.random(1, #t)])
  end,
  ["It is dusk in Lusternia."] = function ()
    local t = {"Good evening.", "Good evening, " .. sys.charname..".", "Hello!"}
    echof(t[math.random(1, #t)])
  end,

  ["It is deep night in Lusternia, before midnight."] = function ()
    local t = {"*yawn*. Hi.", "Ello. It's a lovely night tonight.", "What a night. Look at the stars!"}
    echof(t[math.random(1, #t)])
  end,
  ["It is early morning in Lusternia."] = function ()
    local t = {"*yawn*. Morning!", "Gooood morning, " .. sys.charname .. "!", "Hello!", "Morning!"}
    echof(t[math.random(1, #t)])
  end,
  ["It is early afternoon in Lusternia."] = function ()
    local t = {"Good afternoon.", "Good afternoon, " .. sys.charname .. ".", "Hello!", "hi!"}
    echof(t[math.random(1, #t)])
  end,
}

life.hellodata["It is the middle of the night in Lusternia."] = life.hellodata["It is deep night in Lusternia, before midnight."]
life.hellodata["You think that it is currently night-time up above."] = life.hellodata["It is deep night in Lusternia, before midnight."]
life.hellodata["Darkness rules the land. It is deepest midnight."] = life.hellodata["It is deep night in Lusternia, before midnight."]
life.hellodata["It is late night, approaching dawn."] = life.hellodata["It is deep night in Lusternia, before midnight."]
life.hellodata["The shadows have lengthened. It is late afternoon in Lusternia."] = life.hellodata["It is early afternoon in Lusternia."]
life.hellodata["It's mid-morning in Lusternia."] = life.hellodata["It is early morning in Lusternia."]
life.hellodata["The sun has awakened from its long slumber. It is dawn."] = life.hellodata["It is early morning in Lusternia."]
life.hellodata["The sun sits at its apex. It is exactly noon."] = life.hellodata["It is early afternoon in Lusternia."]
life.hellodata["You think that it is currently day-time up above."] = life.hellodata["It is early afternoon in Lusternia."]


lifep.sayhello = function()
  for _, id in ipairs(life.hellotrigs) do
    killTrigger(tostring(id))
  end
  life.hellotrigs = nil
  deleteAllP()

  for pattern, func in pairs(life.hellodata) do
    if line:find(pattern) then
      tempTimer(.1, function () func() end)
      break
    end
  end
end

life.sayhello = function ()
  tempTimer(math.random(2, 7), function ()
    life.hellotrigs = {}
    for pattern, func in pairs(life.hellodata) do
      life.hellotrigs[#life.hellotrigs+1] = (tempExactMatchTrigger or tempTrigger)(pattern, 'mm.lifep.sayhello()')
    end
    send("time raw", false)
  end)
end
signals.charname:connect(life.sayhello)
signals.gmcpcharname:connect(life.sayhello)
