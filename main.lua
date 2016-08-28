local config          = require "config"
local text            = require "text.en"

local levels          = require "lib.levels"
local tiles           = require "lib.tiles"
local vector          = require "lib.vector"
local player_physics  = require "lib.physics.player"
local sensor          = require "lib.physics.sensor"

-- Game State

local state = {
  time_error = 0,
  active_level = nil
}

local player = {
  position            = vector.zero(),
  velocity            = vector.zero(),
  
  on_ground           = true,
  
  first_jump          = false,
  released_jump       = false,
  float_timer         = 0,
  
  fall_through_timer  = 0,
  
  blaster             = {
      cooldown  = 0,
      released  = false
  },
  
  progress            = {
    spawn_location    = { room = "entrance", spawner = "initial_spawn" },
  
    blaster           = true,
    high_jump         = true,
    double_jump       = true,
    super_blaster     = false,
        
    ankh_sun          = false,
    ankh_moon         = false,
    ankh_stars        = false
  }
}

local next_projectile = 1
local projectiles = {}

local camera = { x = -100, y = -10, scale = 5, width = config.window_width / 5, height = config.window_height / 5 }

-- Level Management

local level_object = nil
local level_tilemap = nil

local function set_level (level_name, entry_name)
  local definition = require("res.map." .. level_name)
  
  level_object = levels.newLevel(definition)
  level_tilemap = level_object:getTilemap()
  
  local entry_object = level_object:getObject(entry_name)
  
  state.active_level = level_name
  player.position = levels.getOrigin(entry_object)
  player.exited = false
  
  projectiles = {}
  next_projectile = 1
end

local function spawn() 
  set_level(player.progress.spawn_location.room, player.progress.spawn_location.spawner)
end


-- Initialization

local function initialize () 
  spawn()
end

-- Engine Hooks

function love.keypressed (key, scancode, repeated)
  if key == 'space' and not repeated then
    spawn()
  end
end

function love.load ()   
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  initialize()
end


local function contains_player (object) 
  local player_minimum = player.position - config.player.origin
  
  local fudge = 1
  
  if player_minimum.x < object.x - fudge then
    return false
  elseif player_minimum.y < object.y - fudge then
    return false
  elseif player_minimum.x > (object.x + object.width - config.player.size.x + fudge) then
    return false
  elseif player_minimum.y > (object.y + object.height - config.player.size.y + fudge) then
    return false
  else
    return true
  end
end

local function touches_player (object) 
  local player_minimum = player.position - config.player.origin
  
  local fudge = 1
  
  if player_minimum.x + config.player.size.x < object.x then
    return false
  elseif player_minimum.y + config.player.size.y < object.y - fudge then
    return false
  elseif player_minimum.x > object.x + object.width then
    return false
  elseif player_minimum.y > object.y + object.height then
    return false
  else
    return true
  end
end

local function split_address (address)   
  for i = #address, 0, -1 do
    if i == 0 then error('address does not contain a delimiter') end
    if address:sub(i, i) == '.' then
      return address:sub(1, i - 1), address:sub( i + 1, -1)
    end
  end
end

local function use_exit (exit_name, target)
  local room_name, object_name = split_address(target)
  print('using exit ' .. exit_name .. ' to ' .. object_name .. ' in ' .. room_name)
  set_level(room_name, object_name)
end

local function check_triggers () 
  for i, object in ipairs(level_object.objects) do
    local contains = contains_player(object)
    local touching = touches_player(object)
    
    if touching and object.type == 'killbox' then
      spawn()
    end
    
    if contains and object.type == 'exit' then
      local object_origin = vector(object.x + object.width / 2, object.y / object.height)
      local exiting = false
      
      if math.floor(object_origin.x) <= 0 then -- left exit
        exiting = player.velocity.x < 0
      elseif math.ceil(object_origin.x) >= level_object.width then -- right exit
        exiting = player.velocity.x > 0
      end
      
      if exiting then
        return use_exit(object.name, object.properties.target)
      end
    end
    
    if contains and object.type == 'spawn' then
      if player.progress.spawn_location.room ~= state.active_level or player.progress.spawn_location.spawner ~= object.name then
        player.progress.spawn_location.room = state.active_level
        player.progress.spawn_location.spawner = object.name
        
        print('spawn set to: ' .. object.name .. ' in ' .. state.active_level)
      end
    end
  end
end

local function update_weapon (dt) 
  local blaster = player.blaster
  
  local shoot_left, shoot_right
  
  shoot_left = love.keyboard.isDown('left')
  shoot_right = love.keyboard.isDown('right')
  
  local function shoot (dir)
    blaster.cooldown = config.player.blaster_cooldown
    blaster.released = false
    
    projectiles[next_projectile] = {
      position = player.position - vector(dir * -8, 16),
      velocity = vector(config.player.blaster_velocity * dir, 0),
      direction = dir
    }
    
    next_projectile = next_projectile + 1
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

local function update_projectiles (dt) 
  for id, projectile in pairs(projectiles) do
    projectile.position = projectile.position + projectile.velocity:scale(dt)
    
    local impact = sensor.sense(level_object, projectile.position, vector(projectile.direction, 0), 8)
    
    if impact then
      projectiles[id] = nil
    end
  end
end

function love.update (dt)
  state.time_error = state.time_error + dt
  
  while state.time_error > config.time_step do
    player_physics.simulate(player, level_object, config.time_step)
    state.time_error = state.time_error - config.time_step
  end
  
  update_weapon(dt)
  update_projectiles(dt)
  
  check_triggers()
end

local draw_player, draw_level, draw_projectiles
local draw_watch_expressions, draw_map_wireframe

function love.draw () 
  
  -- Update Camera
  
  camera.x = player.position.x - camera.width * 0.5
  camera.y = player.position.y - camera.height * 0.7
  
  local camera_max = vector(camera.x + camera.width, camera.y + camera.height)
  
  if camera.x < 0 then
    camera.x = 0
  end
  
  if camera.y < 0 then
    camera.y = 0
  end
  
  if camera_max.x > level_object.width * config.tile_size then
    camera.x = level_object.width * config.tile_size - camera.width
  end
  
  if camera_max.y > level_object.height * config.tile_size then
    camera.y = level_object.height * config.tile_size - camera.height
  end
  
  camera.x = math.floor(camera.x * camera.scale) / camera.scale
  camera.y = math.floor(camera.y * camera.scale) / camera.scale
  
  -- Draw Level
  
  draw_level()
  draw_player()
  draw_projectiles()
  
  -- draw_map_wireframe()
end

function draw_player ()
  local minimum = (player.position - config.player.origin):floor()
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.rectangle("fill", (minimum.x - camera.x) * camera.scale, (minimum.y - camera.y) * camera.scale, config.player.size.x * camera.scale, config.player.size.y * camera.scale)
end

function draw_projectiles()
  for id, projectile in pairs(projectiles) do
    love.graphics.setColor(0xFF, 0xFF, 0x22)
    love.graphics.ellipse("fill", (projectile.position.x - 4 - camera.x) * camera.scale, (projectile.position.y - 2 - camera.y) * camera.scale, 8 * camera.scale, 4 * camera.scale)
  end
end

function draw_level ()
  if level_object then
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(level_tilemap, -camera.x * camera.scale, -camera.y * camera.scale, 0, camera.scale, camera.scale)
        
    for i, object in ipairs(level_object.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF }
      love.graphics.setColor(unpack(color_array))
      
      if object.shape == "rectangle" then
        love.graphics.rectangle("line", 
          (object.x - camera.x) * camera.scale, 
          (object.y - camera.y) * camera.scale, 
          object.width * camera.scale,
          object.height * camera.scale)
        
        if object.type == 'spawn' 
          and state.active_level == player.progress.spawn_location.room 
          and object.name == player.progress.spawn_location.spawner then
            love.graphics.ellipse("line", 
              (object.x + object.width / 2 - camera.x) * camera.scale, 
              (object.y + object.height / 2 - camera.y) * camera.scale, 
              object.width / 2 * camera.scale,
              object.height / 2 * camera.scale)
        end
      end
    end
  end
end

local function draw_wirebox (color, tx, ty)
  love.graphics.setColor(unpack(color))
  love.graphics.rectangle("line", 
    (tx * config.tile_size - camera.x) * camera.scale + 1,  -- x
    (ty * config.tile_size - camera.y) * camera.scale + 1,  -- y
    
    config.tile_size * camera.scale - 2,                    -- width
    config.tile_size * camera.scale - 2                     -- height
  )
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