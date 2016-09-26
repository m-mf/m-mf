-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

signals.loggedin:connect(function()
  if next(gmcp) then return end
  if not io.exists(getMudletHomeDir() .. "/m&m_harvester") then
  	send("ab herbs")
  end
  end)

signals.gmcpcharskillsgroups:connect(function()
  local t = _G.gmcp.Char.Skills.Groups
  for _,tt in ipairs(t) do
    if tt.name == "Herbs" then
      hrv.activateHerbs()
    end
  end
    hrv.deactivateHerbs()
  end)

hrv = {}

function hrv.activateHerbs()
  if not io.exists(getMudletHomeDir() .. "/m&m_harvester") then
    sendGMCP([[Char.Skills.Get { "group": "herbs" }]])
  end

  enableTrigger("m&m Harvester")
  enableAlias("m&m Harvester")
end

function hrv.deactivateHerbs()
  disableTrigger("m&m Harvester")
  disableAlias("m&m Harvester")
end

function hrv.checkSkills()
  if not mmhrv then return end
  local t = _G.gmcp.Char.Skills.List
  if t.group ~= "herbs" then return end
  for _,skill in ipairs(t.list) do
    mmhrv.skills[mmhrv.skillmap[skill:lower()] or skill:lower()] = true
  end
end

signals.gmcpcharskillslist:connect(hrv.checkSkills)

