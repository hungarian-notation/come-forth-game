local config = require "config"

local sensor = require "lib.physics.sensor"
local vector = require "lib.vector"

local player_physics = {}

function player_physics.simulate (player, level_object, dt)  
  
  local function jumpAbility () 
    if player.progress.high_jump then
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
    player.velocity.x = player.velocity.x - config.player.acceleration * dt
  end
  
  if right then
    player.velocity.x = player.velocity.x + config.player.acceleration * dt
  end
  
  player.velocity.x = player.velocity.x * ((1 - config.player.friction) ^ dt)
  
  local function jump (first_jump) 
    local factor = 1
    
    if not first_jump then
      factor = config.player.jump_attenuation
    end
    
    player.on_ground = false
    player.float_timer = jumpAbility().float_time
    player.velocity.y = -jumpAbility().impulse * factor
    
    player.first_jump = first_jump
    player.released_jump = false
  end
  
  if player.on_ground and up then
    jump(true)
  end
  
  if down then
    player.fall_through_timer = config.player.fall_through_time
  else
    player.fall_through_timer = player.fall_through_timer - dt
  end
  
  if not player.on_ground then
    if not up then
      player.released_jump = true
    elseif player.released_jump and player.first_jump and player.progress.double_jump then
      jump(false)
    end
    
    local gravity = config.player.gravity
    
    if player.float_timer > 0 and up then
      gravity = jumpAbility().float_gravity
      player.float_timer = player.float_timer - dt
    else
      player.float_timer = 0
    end
    
    player.velocity.y = player.velocity.y + gravity * dt
  else
    player.velocity.y = 0
  end
  
  player.position.x = player.position.x + player.velocity.x * dt
  player.position.y = player.position.y + player.velocity.y * dt
  
  -- check ground
      
  local floor_sensor_hoffset = 4
  local floor_sensor_height = 4
  local floor_sensor_margin = 4
  
  local suck_to_floor
  
  if player.on_ground then
    suck_to_floor = 12
  else
    suck_to_floor = 0
  end
  
  local left_floor_distance = sensor.sense(level_object, player.position - vector(-floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, player.fall_through_timer <= 0)
  local right_floor_distance = sensor.sense(level_object, player.position - vector(floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, player.fall_through_timer <= 0)
  
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
  
  if player.velocity.y >= 0 then
    if floor_distance and floor_distance < (floor_sensor_margin + suck_to_floor) then
      player.on_ground = true
      player.position = player.position - vector(0, floor_sensor_margin - floor_distance)
    elseif floor_distance == floor_sensor_margin then
      player.on_ground = true
    end
    
    if not floor_distance or floor_distance > (floor_sensor_margin + suck_to_floor) then
      player.on_ground = false
    end
  end
  
  -- check ceiling
  
  local ceiling_sensor_height = 24
  local ceiling_sensor_margin = 8
  
  local ceiling_distance = sensor.sense(level_object, player.position - vector(0, ceiling_sensor_height), vector(0, -1), 16)
  
  if ceiling_distance and ceiling_distance < ceiling_sensor_margin then
    player.position = player.position + vector(0, ceiling_sensor_margin - ceiling_distance)
    if player.velocity.y < 0 then
      player.velocity.y = 0
    end
  end
  
  -- check sides
  
  local side_margin = 8         -- minimum distance from player center to wall
  local side_sensor = {8, 24}   -- heights of side sensors relative to player origin
  
  -- check left collision
  
  local left_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[1]), vector(-1, 0), 16)
  
  if not left_distance then
    left_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[2]), vector(-1, 0), 16)
  end
  
  if left_distance and left_distance < side_margin then
    player.position = player.position + vector(side_margin - left_distance, 0)
    if player.velocity.x < 0 then
      player.velocity.x = 0
    end
  end
    
  -- check right collisions
  
  local right_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[1]), vector(1, 0), 16)
  
  if not right_distance then
    right_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[2]), vector(1, 0), 16)
  end
  
  if right_distance and right_distance < side_margin then
    player.position = player.position - vector(side_margin - right_distance, 0)
    if player.velocity.x > 0 then
      player.velocity.x = 0
    end
  end
end

return player_physics