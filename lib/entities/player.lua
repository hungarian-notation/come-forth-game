local config = require "config"
local vector = require "lib.vector"
local sensor = require "lib.sensor"

local player_entity = {} ; player_entity.__index = player_entity

local simulate_physics

function player_entity.create (env, args) 
  local instance = setmetatable({
    position            = assert(args.position, 'args must contain position vector'),
    velocity            = args.velocity or vector.zero(),
    
    on_ground           = true,
    first_jump          = false,
    released_jump       = false,
    float_timer         = 0,
    
    fall_through_timer  = 0,
    
    blaster             = {
        cooldown  = 0,
        released  = false
    }
  }, player_entity)
  
  return env.world:create(instance)
end

function player_entity:update (dt, env)
  env.state.time_error = env.state.time_error + dt
  
  while env.state.time_error > config.time_step do
    self:simulate_physics(config.time_step, env)
    env.state.time_error = env.state.time_error - config.time_step
  end
  
  self:update_weapon(dt, env)
end

function player_entity:draw (env)
  local minimum = (self.position - config.player.origin):floor()
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.rectangle("fill", (minimum.x - env.camera.x) * env.camera.scale, (minimum.y - env.camera.y) * env.camera.scale, config.player.size.x * env.camera.scale, config.player.size.y * env.camera.scale)
end

function player_entity:update_weapon (dt, env) 
  local blaster = self.blaster
  
  local shoot_left, shoot_right
  
  shoot_left = love.keyboard.isDown('left')
  shoot_right = love.keyboard.isDown('right')
  
  local function shoot (dir)
    blaster.cooldown = config.player.blaster_cooldown
    blaster.released = false
    
    require('lib.entities.projectile').create(env, {
      position = self.position - vector(dir * -8, 16),
      direction = dir
    })
  end
  
  if not (shoot_left or shoot_right) then
    blaster.released = true
  end
  
  if blaster.cooldown > 0 then
    blaster.cooldown = blaster.cooldown - dt
  elseif blaster.released then
    if shoot_left then
      shoot(-1)
    elseif shoot_right then
      shoot(1)
    end
  end
end

function player_entity:simulate_physics (dt, env)  
  local function jumpAbility () 
    if env.progress.high_jump then
      return config.player.high_jump
    else
      return config.player.jump
    end
  end
  
  local left, right, up, down
  
  left = love.keyboard.isDown('a')
  right = love.keyboard.isDown('d')
  up = love.keyboard.isDown('w')
  down = love.keyboard.isDown('s')
  
  if left then
    self.velocity.x = self.velocity.x - config.player.acceleration * dt
  end
  
  if right then
    self.velocity.x = self.velocity.x + config.player.acceleration * dt
  end
  
  self.velocity.x = self.velocity.x * ((1 - config.player.friction) ^ dt)
  
  local function jump (first_jump) 
    local factor = 1
    
    if not first_jump then
      factor = config.player.jump_attenuation
    end
    
    self.on_ground = false
    self.float_timer = jumpAbility().float_time
    self.velocity.y = -jumpAbility().impulse * factor
    
    self.first_jump = first_jump
    self.released_jump = false
  end
  
  if self.on_ground and up then
    jump(true)
  end
  
  if down then
    self.fall_through_timer = config.player.fall_through_time
  else
    self.fall_through_timer = self.fall_through_timer - dt
  end
  
  if not self.on_ground then
    if not up then
      self.released_jump = true
    elseif self.released_jump and self.first_jump and env.progress.double_jump then
      jump(false)
    end
    
    local gravity = config.player.gravity
    
    if self.float_timer > 0 and up then
      gravity = jumpAbility().float_gravity
      self.float_timer = self.float_timer - dt
    else
      self.float_timer = 0
    end
    
    self.velocity.y = self.velocity.y + gravity * dt
  else
    self.velocity.y = 0
  end
  
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt
  
  -- check ground
      
  local floor_sensor_hoffset = 4
  local floor_sensor_height = 4
  local floor_sensor_margin = 4
  
  local suck_to_floor
  
  if self.on_ground then
    suck_to_floor = 12
  else
    suck_to_floor = 0
  end
  
  local left_floor_distance = sensor.sense(env, self.position - vector(-floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, self.fall_through_timer <= 0)
  local right_floor_distance = sensor.sense(env, self.position - vector(floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, self.fall_through_timer <= 0)
  
  local floor_distance
  
  if left_floor_distance and not right_floor_distance then
    floor_distance = left_floor_distance
  elseif right_floor_distance and not left_floor_distance then
    floor_distance = right_floor_distance
  elseif left_floor_distance and right_floor_distance then
    floor_distance = math.min(left_floor_distance, right_floor_distance)
  else
    floor_distance = nil
  end
  
  if self.velocity.y >= 0 then
    if floor_distance and floor_distance < (floor_sensor_margin + suck_to_floor) then
      self.on_ground = true
      self.position = self.position - vector(0, floor_sensor_margin - floor_distance)
    elseif floor_distance == floor_sensor_margin then
      self.on_ground = true
    end
    
    if not floor_distance or floor_distance > (floor_sensor_margin + suck_to_floor) then
      self.on_ground = false
    end
  end
  
  -- check ceiling
  
  local ceiling_sensor_height = 24
  local ceiling_sensor_margin = 8
  
  local ceiling_distance = sensor.sense(env, self.position - vector(0, ceiling_sensor_height), vector(0, -1), 16)
  
  if ceiling_distance and ceiling_distance < ceiling_sensor_margin then
    self.position = self.position + vector(0, ceiling_sensor_margin - ceiling_distance)
    if self.velocity.y < 0 then
      self.velocity.y = 0
    end
  end
  
  -- check sides
  
  local side_margin = 8         -- minimum distance from player center to wall
  local side_sensor = {8, 24}   -- heights of side sensors relative to player origin
  
  -- check left collision
  
  local left_distance = sensor.sense(env, self.position - vector(0, side_sensor[1]), vector(-1, 0), 16)
  
  if not left_distance then
    left_distance = sensor.sense(env, self.position - vector(0, side_sensor[2]), vector(-1, 0), 16)
  end
  
  if left_distance and left_distance < side_margin then
    self.position = self.position + vector(side_margin - left_distance, 0)
    if self.velocity.x < 0 then
      self.velocity.x = 0
    end
  end
    
  -- check right collisions
  
  local right_distance = sensor.sense(env, self.position - vector(0, side_sensor[1]), vector(1, 0), 16)
  
  if not right_distance then
    right_distance = sensor.sense(env, self.position - vector(0, side_sensor[2]), vector(1, 0), 16)
  end
  
  if right_distance and right_distance < side_margin then
    self.position = self.position - vector(side_margin - right_distance, 0)
    if self.velocity.x > 0 then
      self.velocity.x = 0
    end
  end
end

return player_entity