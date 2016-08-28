local config = require "config"
local text = require "text.en"

local levels = require "lib.levels"
local tiles = require "lib.tiles"

local vector = require "lib.vector"
local sensor = require "lib.physics.sensor"

-- Debug

local watch_expressions = {
    "",
    "love.timer.getFPS()",
    "",
    "state.player.position",
    "state.player.velocity",
    "state.player.on_ground",
    "state.player.has_double_jump",
    "state.player.released_jump",
    "state.active_level",
    "",
    "state.player.spawn_location.room",
    "state.player.spawn_location.spawner"
}

-- Game State

state = {
  player = {
    spawn_location = { room = "entrance", spawner = "initial_spawn" },
    
    position = vector.zero(),
    velocity = vector.zero(),
    on_ground = true,
    
    has_double_jump = false,
    released_jump = false,
    
    float_timer = 0
  },
  
  active_level = nil
}

local player = state.player

-- Level Management

local level_object = nil
local level_tilemap = nil

local function set_level (level_name, entry_name)
  local definition = require("res.map." .. level_name)
  
  level_object = levels.newLevel(definition)
  level_tilemap = level_object:getTilemap()
  
  local entry_object = level_object:getObject(entry_name)
  
  state.active_level = level_name
  state.player.position = levels.getOrigin(entry_object)
end

-- Initialization

local function initialize () 
  set_level(state.player.spawn_location.room, state.player.spawn_location.spawner)
end

-- Engine Hooks

function love.load ()   
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  initialize()
end

local function simulate (dt)
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
  
  local function jump (has_double_jump) 
    player.on_ground = false
    player.float_timer = config.player.float_time
    player.velocity.y = -config.player.jump_impulse
    
    player.has_double_jump = has_double_jump
    player.released_jump = false
  end
  
  if player.on_ground and up then
    jump(true)
  end
  
  if not player.on_ground then
    if not up then
      player.released_jump = true
    elseif player.released_jump and player.has_double_jump then
      jump(false)
    end
    
    local gravity = config.player.gravity
    
    if player.float_timer > 0 and up then
      gravity = config.player.float_gravity
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
  
  local was_on_ground = player.on_ground
  
  player.on_ground = false
      
  local floor_sensor_hoffset = 4
  local floor_sensor_height = 4
  local floor_sensor_margin = 4
  
  local suck_to_floor
  
  if was_on_ground then
    suck_to_floor = 12
  else
    suck_to_floor = 6
  end
  
  local left_floor, left_floor_distance = sensor.sense(level_object, player.position - vector(-floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, not down)
  local right_floor, right_floor_distance = sensor.sense(level_object, player.position - vector(floor_sensor_hoffset, floor_sensor_height), vector(0, 1), 16, not down)
  
  local floor = left_floor or right_floor
  
  local min_floor_distance, max_floor_distance
  
  if floor then  
    min_floor_distance = math.min(left_floor_distance or right_floor_distance, right_floor_distance or left_floor_distance)
    max_floor_distance = math.min(left_floor_distance or right_floor_distance, right_floor_distance or left_floor_distance)
  end
  
  if floor and player.velocity.y > 0 and min_floor_distance < (floor_sensor_margin + suck_to_floor) then
    player.on_ground = true
    player.position = player.position - vector(0, floor_sensor_margin - min_floor_distance)
  elseif min_floor_distance == floor_sensor_margin and player.velocity.y >= 0 then
    player.on_ground = true
  end
  
  -- check ceiling
  
  local ceiling_sensor_height = 24
  local ceiling_sensor_margin = 8
  
  local ceiling, ceiling_distance = sensor.sense(level_object, player.position - vector(0, ceiling_sensor_height), vector(0, -1), 16)
  
  if ceiling and ceiling_distance < ceiling_sensor_margin then
    player.position = player.position + vector(0, ceiling_sensor_margin - ceiling_distance)
    if player.velocity.y < 0 then
      player.velocity.y = 0
    end
  end
  
  -- check sides
  
  local side_margin = 8         -- minimum distance from player center to wall
  local side_sensor = {8, 24}   -- heights of side sensors relative to player origin
  
  -- check left collision
  
  local left_wall, left_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[1]), vector(-1, 0), 16)
  
  if not left_wall then
    left_wall, left_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[2]), vector(-1, 0), 16)
  end
  
  if left_wall and left_distance < side_margin then
    player.position = player.position + vector(side_margin - left_distance, 0)
    if player.velocity.x < 0 then
      player.velocity.x = 0
    end
  end
  
  -- check right collisions
  
  local right_wall, right_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[1]), vector(1, 0), 16)
  
  if not right_wall then
    right_wall, right_distance = sensor.sense(level_object, player.position - vector(0, side_sensor[2]), vector(1, 0), 16)
  end
  
  if right_wall and right_distance < side_margin then
    player.position = player.position - vector(side_margin - right_distance, 0)
    if player.velocity.x > 0 then
      player.velocity.x = 0
    end
  end
end

function love.update (dt)
  simulate(dt / 4)
  simulate(dt / 4)
  simulate(dt / 4)
  simulate(dt / 4)
end

local draw_player, draw_level
local draw_watch_expressions, draw_map_wireframe

function love.draw () 
  draw_level()
  draw_player()
  
  -- draw_map_wireframe()
  draw_watch_expressions()
end

function draw_player ()
  local minimum = (state.player.position - config.player.origin):floor()
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.rectangle("fill", minimum.x * config.scale, minimum.y * config.scale, config.player.size.x * config.scale, config.player.size.y * config.scale)
end

function draw_level ()
  if level_object then
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(level_tilemap)
        
    for i, object in ipairs(level_object.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF }
      love.graphics.setColor(unpack(color_array))
      
      if object.shape == "rectangle" then
        love.graphics.rectangle("line", object.x * config.scale, object.y * config.scale, object.width * config.scale, object.height * config.scale)
      end
    end
  end
end

local function draw_wirebox (color, tx, ty)
  love.graphics.setColor(unpack(color))
  love.graphics.rectangle("line", tx * config.grid_size + 1, ty * config.grid_size + 1, config.grid_size - 2, config.grid_size - 2)
end

function draw_map_wireframe ()
  local left_ramp_color = {0x00, 0xFF, 0x22, 0xFF}
  local right_ramp_color = {0x00, 0x22, 0xFF, 0xFF}
  local full_block_color = {0xFF, 0xFF, 0xFF, 0xFF}
  local platform_color = {0xFF, 0x33, 0x33, 0xFF}
  
  for x = 0, level_object.width - 1 do
    for y = 0, level_object.height - 1 do
      local wall_tile = level_object.layers.walls:getTile(x, y)
      local platform_tile = level_object.layers.platforms:getTile(x, y)
      
      if platform_tile then
        draw_wirebox(platform_color, x, y)
      end 
      
      if wall_tile and tiles[wall_tile].is_solid then
        if tiles[wall_tile].is_ramp then          
          if tiles[wall_tile].ramp_dir == 'left' then
            draw_wirebox(left_ramp_color, x, y)
          else
            draw_wirebox(right_ramp_color, x, y)
          end
        else
            draw_wirebox(full_block_color, x, y)
        end
      end
    end
  end
end

function draw_watch_expressions () -- evaluate and render watch expressions
  local label_col = 10 
  local data_col = 250
  
  local line_height = 14
  local base_line = 10
  
  love.graphics.setColor(0xFF, 0x00, 0xFF)
  love.graphics.print("[watch expression]", label_col, base_line) 
  love.graphics.print("= [value]", data_col, base_line) 
      
  for i, expr in ipairs(watch_expressions) do
    if expr and #expr > 0 then
      love.graphics.setColor(0xFF, 0xFF, 0xFF)
      love.graphics.print(expr, label_col, base_line + line_height * i) 
      love.graphics.setColor(0xAA, 0xFF, 0xFF)
      love.graphics.print('= ' .. tostring(assert(loadstring('return ' .. expr))()), data_col, base_line + line_height * i)
    end
  end
end