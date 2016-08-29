local keys      = require "keybindings"

local config    = require "config"
local vector    = require "lib.vector"
local sensor    = require "lib.sensor"

local entities  = require "lib.entities"

local player_entity = {} ; player_entity.__index = player_entity

local simulate_physics

function player_entity.create (env, args) 
  local instance = setmetatable({
    position            = assert(args.position, 'args must contain position vector'),
    origin              = config.player.origin,
    size                = config.player.size,
    
    facing              = vector.zero(),
    stance              = 1,
    
    velocity            = args.velocity or vector.zero(),
    
    _on_ground          = true,
    _first_jump         = false,
    _jump_released      = false,
    _float_tmr          = 0,
    _drop_tmr           = 0,
    
    blaster             = {
        cooldown  = 0,
        released  = false
    },
    
    is_player           = true
  }, player_entity)
  
  return env.world:create(instance)
end

function player_entity:update (dt, env)
  env.state.time_error = env.state.time_error + dt
  
  while env.state.time_error > config.time_step do
    self:simulate_physics(config.time_step, env)
    env.state.time_error = env.state.time_error - config.time_step
  end
  
  -- look for deadly enemies
  
  local my_bounds = entities.getBounds(self)
  
  for id, entity in env.world:each() do
    local bounds = entities.getBounds(entity)
    
    if bounds and bounds:intersects(my_bounds) then
      if entity.is_deadly then
        self:kill(env)
      end
      
      if entity.collect then
        entity:collect(env)
      end
    end
  end
  
  self:update_weapon(dt, env)
  self:update_aim()
end

function player_entity:kill (env)
  env.world:destroy(self)
  env.player = nil
end

function player_entity:update_aim ()
  local left_input, right_input, up_input, down_input, diagonal_aim_input, both_horizonal

  left_input = love.keyboard.isDown(keys.left_directional)
  right_input = love.keyboard.isDown(keys.right_directional)
  
  up_input = love.keyboard.isDown(keys.up_directional)
  down_input = love.keyboard.isDown(keys.down_directional)
  
  diagonal_aim_input = love.keyboard.isDown(keys.diagonal_aim)
  
  both_horizonal = left_input and right_input
  
  if both_horizonal then -- normalize multiple horizontal inputs
    if self.facing.x == -1 then 
      right_input = false
    elseif self.facing.x == 1 then
      left_input = false
    end
  end
  
  if up_input and down_input then -- normalize multiple vertical inputs
    if self.facing.y == -1 then 
      down_input = false
    elseif self.facing.y == 1 then
      up_input = false
    end
  end
  
  if up_input then
    self.facing.y = -1
  elseif down_input then
    self.facing.y = 1
  elseif not diagonal_aim_input then
    self.facing.y = 0
  end
  
  if both_horizonal and up_input then
    self.facing.x = 0
  elseif left_input then
    self.facing.x = -1
    self.stance = -1
  elseif right_input then
    self.facing.x = 1
    self.stance = 1
  elseif (not up_input or down_input) or (diagonal_aim_input) then
    self.facing.x = self.stance
  else
    self.facing.x = 0
  end
  
  if diagonal_aim_input and self.facing.y == 0 then
    self.facing.y = -1
  end
end

function player_entity:draw (env)
  self:update_aim()
  
  local minimum = (self.position - self.origin):floor()
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  
  love.graphics.rectangle("fill", (minimum.x - env.camera.x) * env.camera.scale, (minimum.y - env.camera.y) * env.camera.scale, config.player.size.x * env.camera.scale, config.player.size.y * env.camera.scale)
  
  if env.progress.blaster or env.progress.super_blaster then
    local offset = self.facing:normalized():scale(8 * 1.4)
    local center = minimum + self.size:scale(0.5)
    local looking_at = center + offset
    
    love.graphics.setLineWidth(3 * env.camera.scale)
    love.graphics.setColor(0xAA, 0xAA, 0xAA)
    love.graphics.line((center.x - env.camera.x) * env.camera.scale, (center.y - env.camera.y) * env.camera.scale, (looking_at.x - env.camera.x) * env.camera.scale, (looking_at.y - env.camera.y) * 
  env.camera.scale)

  end
end

function player_entity:update_weapon (dt, env) 
  local blaster = self.blaster
  local equipped_blaster
  
  if env.progress.super_blaster then
    equipped_blaster = config.player.super_blaster
  else
    equipped_blaster = config.player.blaster
  end
  
  local shoot_button = love.keyboard.isDown(keys.shoot)
  
  local function shoot (aim_direction, equipped_blaster)
    blaster.cooldown = equipped_blaster.cooldown
    blaster.released = false
    
    local offset = aim_direction:normalized():scale(8 * 1.4)
    local center = (self.position - self.origin) + self.size:scale(0.5)
    local projectile_origin = center + offset
    
    require('lib.entities.projectile').create(env, {
      position = projectile_origin,
      direction = aim_direction,
      speed = equipped_blaster.velocity,
      damage = equipped_blaster.damage
    })
  end
  
  if not shoot_button then
    blaster.released = true
  end
  
  local has_weapon = env.progress.blaster or env.progress.super_blaster
  
  if blaster.cooldown > 0 then
    blaster.cooldown = blaster.cooldown - dt
  elseif has_weapon and shoot_button then
    shoot(self.facing, equipped_blaster)
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
  
  local left_input, right_input, jump_input, drop_input
  
  left_input = love.keyboard.isDown(keys.left_directional)
  right_input = love.keyboard.isDown(keys.right_directional)
  
  jump_input = love.keyboard.isDown(keys.jump)
  drop_input = love.keyboard.isDown(keys.drop)
  
  if left_input and right_input then -- normalize multiple horizontal inputs
    if self.stance == -1 then 
      right_input = false
    elseif self.stance == 1 then
      left_input = false
    end
  end
  
  if left_input then
    self.velocity.x = self.velocity.x - config.player.acceleration * dt
  elseif right_input then
    self.velocity.x = self.velocity.x + config.player.acceleration * dt
  end
  
  self.velocity.x = self.velocity.x * ((1 - config.player.friction) ^ dt)
  
  local function jump (_first_jump) 
    local factor = 1
    
    if not _first_jump then
      factor = config.player.jump_attenuation
    end
    
    self._on_ground = false
    self._float_tmr = jumpAbility().float_time
    self.velocity.y = -jumpAbility().impulse * factor
    
    self._first_jump = _first_jump
    self._jump_released = false
  end
  
  if self._on_ground and jump_input then
    jump(true)
  end
  
  if drop_input then
    self._drop_tmr = config.player.fall_through_time
  else
    self._drop_tmr = self._drop_tmr - dt
  end
  
  if not self._on_ground then
    if not jump_input then
      self._jump_released = true
    elseif self._jump_released and self._first_jump and env.progress.double_jump then
      jump(false)
    end
    
    local gravity = config.player.gravity
    
    if self._float_tmr > 0 and jump_input then
      gravity = jumpAbility().float_gravity
      self._float_tmr = self._float_tmr - dt
    else
      self._float_tmr = 0
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
  
  if self._on_ground then
    suck_to_floor = 12
  else
    suck_to_floor = 0
  end
  
  local left_floor_distance = sensor.sense(
    env,  
    self.position - vector(-floor_sensor_hoffset, floor_sensor_height), 
    vector(0, 1), 16, 
    
    { 
      sense_platforms = self._drop_tmr <= 0,
      sense_entities = true
    }
  )
  
  local right_floor_distance = sensor.sense(
    env, 
    self.position - vector(floor_sensor_hoffset, floor_sensor_height), 
    vector(0, 1), 16, 
    
    { 
      sense_platforms = self._drop_tmr <= 0,
      sense_entities = true
    }
  )
  
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
      self._on_ground = true
      self.position = self.position - vector(0, floor_sensor_margin - floor_distance)
    elseif floor_distance == floor_sensor_margin then
      self._on_ground = true
    end
    
    if not floor_distance or floor_distance > (floor_sensor_margin + suck_to_floor) then
      self._on_ground = false
    end
  end
  
  -- check ceiling
  
  local ceiling_sensor_height = 24
  local ceiling_sensor_margin = 8
  
  local ceiling_distance = sensor.sense(env, self.position - vector(0, ceiling_sensor_height), vector(0, -1), 16, { sense_entities = true })
  
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
  
  local left_distance = sensor.sense(env, self.position - vector(0, side_sensor[1]), vector(-1, 0), 16, { sense_entities = true })
  
  if not left_distance then
    left_distance = sensor.sense(env, self.position - vector(0, side_sensor[2]), vector(-1, 0), 16, { sense_entities = true })
  end
  
  if left_distance and left_distance < side_margin then
    self.position = self.position + vector(side_margin - left_distance, 0)
    if self.velocity.x < 0 then
      self.velocity.x = 0
    end
  end
    
  -- check right collisions
  
  local right_distance = sensor.sense(env, self.position - vector(0, side_sensor[1]), vector(1, 0), 16, { sense_entities = true })
  
  if not right_distance then
    right_distance = sensor.sense(env, self.position - vector(0, side_sensor[2]), vector(1, 0), 16, { sense_entities = true })
  end
  
  if right_distance and right_distance < side_margin then
    self.position = self.position - vector(side_margin - right_distance, 0)
    
    if self.velocity.x > 0 then
      self.velocity.x = 0
    end
  end
end

return player_entity