local vector = require "lib.vector"
local tiles = require "lib.tiles"

local sensor = {}

function sensor.sense (level, origin, offset, steps, options)
  options = options or {}
  
  for i = 0, steps do
    local pos   = (origin + offset:scale(i)):floor()
    local grid    = pos:scale(1 / 16):floor()
    local in_tile = vector(pos.x % 16, pos.y % 16):floor()
    
    local wall_tile = level.layers.walls:getTile(grid.x, grid.y)
    
    if wall_tile then
      return wall_tile, i
    end
  end
end

return sensor