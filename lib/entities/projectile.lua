local config = require "config"
local sensor = require "lib.sensor"
local vector = require "lib.vector"

local projectile_entity = {} ; projectile_entity.__index = projectile_entity

function projectile_entity.create (env, args) 
  local instance = setmetatable({
      position = args.position,
      velocity = vector(config.player.blaster_velocity * args.direction, 0),
      direction = args.direction
    }, projectile_entity)

  return env.world:create(instance)
end

function projectile_entity:update (dt, env)
  self.position = self.position + self.velocity:scale(dt)
  
  local impact, entity = sensor.sense(env, self.position + vector(0, 2), vector(self.direction, 0), 8, {
    sense_entities = true
  })

  if not impact then
    impact, entity = sensor.sense(env, self.position - vector(0, 2), vector(self.direction, 0), 8, {
      sense_entities = true
    })
  end

  if impact then
    if entity then
      if entity:shoot(env, projectile) then
        env.world:destroy(self)
      end
    else
      env.world:destroy(self)
    end
  end
end

function projectile_entity:draw (env)
  love.graphics.setColor(0xFF, 0xFF, 0x22)
  love.graphics.ellipse("fill", (self.position.x - env.camera.x) * env.camera.scale, (self.position.y - env.camera.y) * env.camera.scale, 8 * env.camera.scale, 4 * env.camera.scale)
end

return projectile_entity