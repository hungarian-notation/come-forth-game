local config = require "config"
local sensor = require "lib.sensor"
local vector = require "lib.vector"

local projectile_entity = {} ; projectile_entity.__index = projectile_entity

function projectile_entity.create (env, args) 
  local instance = setmetatable({
      position = assert(args.position),
      direction = assert(args.direction), 
      velocity = args.direction:normalized():scale(assert(args.speed)),
      damage = assert(args.damage)
    }, projectile_entity)

  return env.world:create(instance)
end

function projectile_entity:update (dt, env)
  self.position = self.position + self.velocity:scale(dt)
  
  local function target_filter (env, target)
      return target.is_solid or target.shoot
  end
  
  local impact, entity = sensor.sense(env, self.position + vector(0, 5), self.direction:normalized(), 3, {
    sense_entities = true,
    entity_filter = target_filter
  })

  if not impact then
    impact, entity = sensor.sense(env, self.position - vector(0, 5), self.direction:normalized(), 3, {
      sense_entities = true,
      entity_filter = target_filter
    })
  end

  if impact then
    if entity then
      if not entity.shoot or entity:shoot(env, self) then
        env.world:destroy(self)
      end
    else
      env.world:destroy(self)
    end
  end
end

local colors = {
  [1] = {0xFF, 0xFF, 0x22},
  [3] = {0x22, 0xFF, 0xFF}
}

function projectile_entity:draw (env)
  love.graphics.setColor(unpack(colors[self.damage]))
  love.graphics.ellipse("fill", (self.position.x - env.camera.x) * env.camera.scale, (self.position.y - env.camera.y) * env.camera.scale, 6 * env.camera.scale, 6 * env.camera.scale)
end

return projectile_entity