local config = require "config"
local tiles = require "lib.tiles"
local vector = require "lib.vector"
local sensor = require "lib.sensor"

local crate_entity = {} ; crate_entity.__index = crate_entity

local quad = {}

function crate_entity.create (env, args) -- create new crate entity
  local instance = setmetatable({
    object_id      = assert(args.object_id),
    position      = args.position or vector.zero,
    size          = vector(config.tile_size, config.tile_size),
    is_solid      = true
  }, crate_entity)

  if args.alien_style then
    instance.style = 'alien_crate'
  else
    instance.style = 'crate'
  end

  if not env.destructibles:is_destroyed(env.level.name, instance.object_id) then
    return env.world:create(instance)
  else
    return nil
  end
end

function crate_entity:shoot (env, projectile)
  env.world:destroy(self)
  env.destructibles:destroy(env.level.name, self.object_id)
  return true
end

function crate_entity:draw (env) -- draw a crate entity
  
  
  if not quad[self.style] then
    quad[self.style] = tiles.getQuad(tiles.named_tiles[self.style])
  end
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.draw(
    tiles:getTileSet(),
    quad[self.style], 
    
    (self.position.x - env.camera.x) * env.camera.scale, 
    (self.position.y - env.camera.y) * env.camera.scale, 
    
    0, 
    
    env.camera.scale, 
    env.camera.scale
  )
end

return crate_entity