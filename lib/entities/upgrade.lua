local config  = require "config"
local vector  = require "lib.vector"
local sensor  = require "lib.sensor"
local tiles   = require "lib.tiles"

local upgrade_entity = {} ; upgrade_entity.__index = upgrade_entity

local sprite_origins = {
  high_jump     = {16, 18},
  double_jump   = {16, 16},
  blaster       = {18, 18},
  super_blaster = {18, 16}  
}

local sprite_quads = {}
local cycle_rate = 1

function upgrade_entity.create (env, args) 
  
  -- initialize entity
  
  local instance = setmetatable({
      
    position      = assert(args.position, 'missing position'),
    size          = vector(32, 32),
    upgrade_name  = assert(args.upgrade_name, 'missing upgrade_name'),
    cycle         = 0
    
  }, upgrade_entity)
  
  if not env.progress[instance.upgrade_name] then
    return env.world:create(instance)
  end
end

function upgrade_entity:update (dt, env)
  if env.progress[self.upgrade_name] then
    env.world:destroy(self)
  end
  
  self.cycle = self.cycle + dt
  
  if self.cycle > cycle_rate then
    self.cycle = 0
  end
end

function upgrade_entity:collect (env)
  env.world:destroy(self)
  env.progress[self.upgrade_name] = true
end

function upgrade_entity:draw (env)
  if not sprite_quads[self.upgrade_name] then
    local origin = assert(sprite_origins[self.upgrade_name], 'missing sprite origin for upgrade: ' .. self.upgrade_name)
    sprite_quads[self.upgrade_name] = tiles.getQuad(origin[1], origin[2], origin[1] + 1, origin[2] + 1)
  end
  
  local position = (self.position + vector(0, -4):scale(math.sin(2 * math.pi * self.cycle / cycle_rate)))
  
  position = position:scale(env.camera.scale):floor():scale(1/env.camera.scale)
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.draw(
    tiles:getTileSet(),
    sprite_quads[self.upgrade_name], 
    
    (position.x - env.camera.x) * env.camera.scale, 
    (position.y - env.camera.y) * env.camera.scale, 
    
    0, 
    
    env.camera.scale, 
    env.camera.scale
  )
end

return upgrade_entity