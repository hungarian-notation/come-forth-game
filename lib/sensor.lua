local vector = require "lib.vector"
local tiles = require "lib.tiles"

local sensor = {}

function sensor.sense (env, origin, offset, steps, args)
  
  -- Normalize Arguments
  
  args = args or {}
  
  args.sense_platforms = args.sense_platforms or false
  
  if args.sense_entities then
    args.entity_filter = args.entity_filter or function (env, entity)
      return entity.is_solid
    end
  else
    args.sense_entities = false
  end
  
  -- Collect Entities (if sense_entities)
  
  local sensable_entities = {}
  
  if args.sense_entities then
    for id, entity in env.world:each() do
      if entity.position and entity.size then
        sensable_entities[entity.id] = entity
      end
    end
  end
  
  for i = 0, steps do
    local pos   = (origin + offset:scale(i)):floor()
    local grid    = pos:scale(1 / 16):floor()
    local in_tile = vector(pos.x % 16, pos.y % 16):floor()
    
    local wall_tile = env.level.layers.walls:getTile(grid.x, grid.y)
    local platform_tile = env.level.layers.platforms:getTile(grid.x, grid.y)
    
    if args.sense_entities then
      for id, entity in pairs(sensable_entities) do
        if args.entity_filter(env, entity) then
          local min = entity.position - (entity.origin or vector.zero())
          local max = min + entity.size
          
          if pos.x >= min.x and pos.x < max.x and pos.y >= min.y and pos.y < max.y then
            return i, entity -- collision with entity
          end
        end
      end
    end
    
    if args.sense_platforms and platform_tile and in_tile.y == 0 then
      return i -- collision with platform
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
        return i -- collision with wall
      end
    end
  end
  
  return nil
end

return sensor