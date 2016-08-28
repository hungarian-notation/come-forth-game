local vector = require "lib.vector"
local tiles = require "lib.tiles"

local sensor = {}

function sensor.sense (level, origin, offset, steps, sense_platforms)
  for i = 0, steps do
    local pos   = (origin + offset:scale(i)):floor()
    local grid    = pos:scale(1 / 16):floor()
    local in_tile = vector(pos.x % 16, pos.y % 16):floor()
    
    local wall_tile = level.layers.walls:getTile(grid.x, grid.y)
    local platform_tile = level.layers.platforms:getTile(grid.x, grid.y)
    
    if sense_platforms and platform_tile and in_tile.y == 0 then
      return platform_tile, i
    elseif wall_tile and tiles[wall_tile].is_solid then
      local collision = true
      
      if tiles[wall_tile].is_ramp then
        if tiles[wall_tile].ramp_dir == 'left' then
          collision = in_tile.y > 16 - in_tile.x
        elseif tiles[wall_tile].ramp_dir == 'right' then
          collision = in_tile.y > in_tile.x
        end
      end
      
      if collision then
        return wall_tile, i
      end
    end
  end
end

return sensor