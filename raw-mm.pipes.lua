-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

pl.dir.makepath(getMudletHomeDir() .. "/m&m/pipes")

-- set the defaults and overwrite with loaded data if we have any
#for _, item in ipairs{"faeleaf", "myrtle", "coltsfoot", "steam"} do
pipes.$(item) = pipes.$(item) or
  {lit = false, id = 0, arty = false, puffs = 0}

#end

if lfs.attributes(getMudletHomeDir() .. "/m&m/pipes/conf") then
  table.load(getMudletHomeDir() .. "/m&m/pipes/conf", pipes)
  -- add steam to pnames
end

signals.saveconfig:connect(function ()
  local s,m = table.save(getMudletHomeDir() .. "/m&m/pipes/conf", pipes)
  if not s then
    echof("Couldn't save settings; %s", m)
  end
end)

-- overwrite whatever we loaded here, so we can add new pipes
pipes.pnames = {"coltsfoot", "myrtle", "faeleaf", "steam"}

pipes.expectations = {"coltsfoot", "myrtle", "faeleaf", "steam"}

pipes.empties = {}

lastlit = function(which)
  for i = 1, #pipes.expectations do
    local v = pipes.expectations[i]
    if v == which then
      table.remove(pipes.expectations, i)
      pipes.expectations[#pipes.expectations+1] = which
      return
    end
  end

end

function pipeout()
  local what = pipes.expectations[1]
  pipes[what].lit = false
  table.remove(pipes.expectations, 1)
  pipes.expectations[#pipes.expectations+1] = what

  if conf.gagrelight then deleteLineP() end
end

function allpipesout()
  for _, pipe in pairs(pipes) do
    if not pipe.arty then pipe.lit = false end
  end

  if conf.gagrelight then deleteLineP() end
end

function pipestart()
  pipes.empties = {}

  pipes.oldpipes = deepcopy(pipes)

  pipes.coltsfoot = {lit = false, id = 0, arty = false, puffs = 0}

  pipes.faeleaf = {lit = false, id = 0, arty = false, puffs = 0}

  pipes.myrtle = {lit = false, id = 0, arty = false, puffs = 0}

  pipes.steam = {lit = false, id = 0, arty = false, puffs = 0}
end

function artefactlist_start()
  for herb, pipe in pairs(pipes) do
    pipe.arty = false
  end
end

function pipearty(which)
  for herb, pipe in pairs(pipes) do
    if pipe.id == which then
      pipe.arty = true
      echo '\n' echof("Recognized the %s pipe, %s, as an artefact one.", herb, which)
    end
  end
end

function parseplist()
  local id = tonumber(matches[2])
  local herb = matches[3]
  local puffs = matches[4]
  local status = matches[5]

  if puffs == "*" then
    puffs = 99
  else
    puffs = tonumber(puffs)
  end

  if not (id and herb and puffs and status) then return end

  -- convert to internal m&mf name
  if herb == "soothingsteam" then herb = "steam" end

  pipes[herb].id = id

  if status == "Lit" then
    pipes[herb].lit = true
   -- elseif status == "artfct" then -- does not work in Lusty
   --  pipes[herb].arty = true
  else
    pipes[herb].lit = false
    pipes[herb].arty = false
  end

  pipes[herb].puffs = puffs
end

function parseplistempty(id, status)
  if not (id and status) then return end

  pipes.empties[#pipes.empties+1] = {id = id, status = status}
end

function parseplistend()
  local pipes = pipes

  for id = 1, #pipes.pnames do
    local i = pipes.pnames[id]

    if pipes[i].id == 0 and #pipes.empties ~= 0 then
      pipes[i].id = pipes.empties[#pipes.empties].id
      if pipes.empties[#pipes.empties].status == "Lit" then
        pipes[i].lit = true
      else
        pipes[i].lit = false
      end

      if pipes.empties[#pipes.empties].arty then
        pipes[i].arty = true
      end

      table.remove(pipes.empties)
    end
  end

  for i = 1, #pipes.pnames do
    local herb = pipes.pnames[i]

    if pipes.oldpipes[herb] and pipes.oldpipes[herb].arty then
      pipes[herb].arty = pipes.oldpipes[herb].arty
    end
  end

  pipes.oldpipes = nil
end

-- assumes that we set some pipe to 0 already. This is used during installation only
function pipe_assignid(newid)
  newid = tonumber(newid)
  for id = 1, #pipes.pnames do
    local i = pipes.pnames[id]
    if pipes[i].id == 0 then
      pipes[i].id = newid
      conf[i.."id"] = newid
      pipes[i].lit = false
      send("empty "..newid, false)
      return i
    end
  end
end

