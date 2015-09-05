-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

meld = {
  -- rooms IDs we have in meld
  rs = {},
  -- center ID of meld
  center = false,
  -- unbreakable rooms
  ub = {},
  -- breakable rooms
  br = {},
  -- circles
  rooms_in_circle = {},
-- internal data
rooms_painted = {}
}


meld.calculate_spots = function()
  local getRoomExits = getRoomExits
  meld.ub, meld.br = {}, {}
  for room, _ in pairs(meld.rs) do
    local t = getRoomExits(room) or {}

    local connectedto = 0
    for _, exit in pairs(t) do
      if meld.rs[exit] then connectedto = connectedto + 1 end
    end

    if connectedto > 1 then
      meld.ub[room] = true
    else
      meld.br[room] = true
    end
  end

  meld.findcircles()
  meld.applysingularity()
end

meld.paint = function()
  if not mm.conf.meldtracker then return end

  -- cleanup
  for i = 1, #meld.rooms_painted do unHighlightRoom(meld.rooms_painted[i]) end
  meld.rooms_painted = {}

  -- get normal, breakable rooms
  for room, _ in pairs(meld.rs) do
    local r,g,b = unpack(color_table.purple)
    local br,bg,bb = unpack(color_table.purple)
    highlightRoom(room, r,g,b,br,bg,bb, 0.5, 200, 255)
    meld.rooms_painted[#meld.rooms_painted+1] = room
  end
  -- now unbreakable
  for room, _ in pairs(meld.ub) do
    local r,g,b = unpack(color_table.purple)
    local br,bg,bb = unpack(color_table.purple)
    highlightRoom(room, r,g,b,br,bg,bb, 0.75, 200, 255)
    meld.rooms_painted[#meld.rooms_painted+1] = room
  end
  -- now breakable, in circles
  for room, _ in pairs(meld.rooms_in_circle) do
    local r,g,b = unpack(color_table.red)
    local br,bg,bb = unpack(color_table.red)
    highlightRoom(room, r,g,b,br,bg,bb, 0.75, 200, 255)
    meld.rooms_painted[#meld.rooms_painted+1] = room
  end
  centerview(mmp.currentroom)
end

meld.findcircles = function()
  local getRoomExits = getRoomExits
  meld.rooms_in_circle = {}

  local function addcircle(tbl, id)
    local current_loop = {id}
    meld.rooms_in_circle[id] = true

    for i = #tbl, 1, -1 do
      local stackid = tbl[i]
      if stackid == id then break end
      current_loop[#current_loop+1] = stackid
      meld.rooms_in_circle[stackid] = true
    end
  --  echo"loop: " display(current_loop)
  end

  local function dfs(start)
    if not start then return end
    local visited = {[start] = true}
    local checked_stack = {start}

    local function recurse(node)
      for _, exit in pairs(getRoomExits(node)) do
        if meld.rs[exit] and not visited[exit] then -- meld.rs[exit] -> make sure it's in our meld, and not a room outside
          checked_stack[#checked_stack+1] = exit
          visited[exit] = true
          recurse(exit)
          checked_stack[#checked_stack] = nil
        elseif meld.rs[exit] and #checked_stack>2 and checked_stack[#checked_stack-1] ~= exit then -- #>2 -> so it's not A<->B pattern
          addcircle(checked_stack, exit)
        end
      end

    end


    return recurse(start)
  end

  dfs(next(meld.rs))
end

meld.applysingularity = function()
  local toremove = {}
  local meldsize = table.size(meld.rs)
  local size = table.size

  for room in pairs(meld.rooms_in_circle) do
    for _, exit in pairs(getRoomExits(room)) do
      if meld.rs[exit] then
        local walked = meld.gatherconnected(exit, room)
        if size(walked)+1 ~= meldsize then
          toremove[#toremove+1] = room
          break
        end
      end
    end
  end

  for _, room in pairs(toremove) do
    meld.rooms_in_circle[room] = nil
  end
end

function meld.gatherconnected(start, ignore)
  local visited = {}
  local function dfs(start)
    if not start then return end
    visited[start] = true
    local checked_stack = {start}

    local function recurse(node)
      for _, exit in pairs(getRoomExits(node)) do
        if meld.rs[exit] and not visited[exit] and exit ~= ignore then -- meld.rs[exit] -> make sure it's in our meld, and not a room outside
          checked_stack[#checked_stack+1] = exit
          visited[exit] = true
          recurse(exit)
          checked_stack[#checked_stack] = nil
        end
      end

    end


    return recurse(start)
  end

  dfs(start)
  return(visited)
end
