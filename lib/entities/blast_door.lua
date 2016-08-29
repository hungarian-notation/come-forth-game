local config = require "config"
local vector = require "lib.vector"
local sensor = require "lib.sensor"
local tiles = require "lib.tiles"

local blast_door_entity = {} ; blast_door_entity.__index = blast_door_entity
local quad

function blast_door_entity.create (env, args) 
  
  -- initialize entity
  
  local instance = setmetatable({
    object_id      = assert(args.object_id),
    position      = assert(args.position),
    size          = vector(config.tile_size, 3 * config.tile_size),
    is_solid      = true
  }, blast_door_entity)
  
  if not env.destructibles:is_destroyed(env.level.name, instance.object_id) then
    return env.world:create(instance)
  else
    return nil
  end
end

function blast_door_entity:shoot (env, projectile)
  if projectile.damage >= 3 then
    env.world:destroy(self)
    env.destructibles:destroy(env.level.name, self.object_id)
  end
    
  return true
end

function blast_door_entity:draw (env)
  if not quad then 
    quad = tiles.getQuad(0, 12, 0, 14)
  end
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.draw(
    tiles:getTileSet(),
    quad, 
    
    (self.position.x - env.camera.x) * env.camera.scale, 
    (self.position.y - env.camera.y) * env.camera.scale, 
    
    0, 
    
    env.camera.scale, 
    env.camera.scale
  )
end

return blast_door_entity