local config          = require "config"
local text            = require "text.en"

local keys            = require "keybindings"

local levels          = require "lib.levels"
local tiles           = require "lib.tiles"
local vector          = require "lib.vector"
local sensor          = require "lib.sensor"
local entities        = require "lib.entities"

local tiled           = require "lib.levels.tiled"

-- Game State

local env = {
  debug = false,
  level = nil,
  world = nil,
  
  respawn_time = 3,
  
  progress = {
      spawn_location    = { room = "entrance", spawner = "initial_spawn" },
    
      blaster           = false,
      high_jump         = false,
      double_jump       = false,
      super_blaster     = false,
          
      ankh_sun          = false,
      ankh_moon         = false,
      ankh_stars        = false
  },
  
  destructibles = require "lib.destructibles",
  
  state = {
    time_error = 0,
    active_level = nil
  },
  
  player = nil,
  
  camera = { 
    x = -100, 
    y = -10, 
    
    scale = 5, 
    
    width = config.window_width / 5, 
    height = config.window_height / 5 
  }
}

local function get_env () -- DEPRECATED
  return env
end

local function reset_world ()
  env.world = entities.newWorld()
end

reset_world()

-- Level Management

local function set_level (level_name, entry_name)
  local player_velocity
  
  if env.player then 
    player_velocity = env.player.velocity
  else
    player_velocity = vector.zero()
  end
  
  reset_world()
  
  local definition = require("res.map." .. level_name)
  
  env.level = levels.newLevel(definition)
  
  env.level.name = level_name
  
  env.level.tilemap = env.level:getTileMap()
  env.level.overlay = env.level:getOverlay()
  
  local entry_object = env.level:getObject(entry_name)
  
  env.level:initialize(env)
  
  env.player = (require "lib.entities.player").create(get_env(), {
    position = levels.getOrigin(entry_object),
    velocity = player_velocity
  })
end

local function spawn() 
  env.destructibles:reset()
  set_level(env.progress.spawn_location.room, env.progress.spawn_location.spawner)
  env.respawn_time = config.player.respawn_time
end

-- Initialization

local function initialize () 
  spawn()
end

-- Engine Hooks

function love.keypressed (key, scancode, repeated)
  if key == keys.debug_mode then
    env.debug = not env.debug
  end
  
  if env.debug and key == keys.force_respawn and not repeated then
    spawn()
  end
end

function love.load ()   
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  initialize()
end


local function contains_player (object) 
  if not env.player then
    return
  end
  
  local player_minimum = env.player.position - config.player.origin
  
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
  if not env.player then
    return false
  end
  
  local player_minimum = env.player.position - config.player.origin
  
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
  if not env.player then
    return
  end
  
  for i, object in ipairs(env.level.objects) do
    local contains = contains_player(object)
    local touching = touches_player(object)
    
    if touching and object.type == 'killbox' then
      env.player:kill(env)
    end
    
    if contains and object.type == 'exit' then
      local object_origin = vector(object.x + object.width / 2, object.y / object.height)
      local exiting = false
      
      if math.floor(object_origin.x) <= 0 then -- left exit
        exiting = env.player.velocity.x < 0
      elseif math.ceil(object_origin.x) >= env.level.width then -- right exit
        exiting = env.player.velocity.x > 0
      end
      
      if exiting then
        return use_exit(object.name, object.properties.target)
      end
    end
    
    if contains and object.type == 'spawn' then
      if env.progress.spawn_location.room ~= env.level.name or env.progress.spawn_location.spawner ~= object.name then
        env.progress.spawn_location.room = env.level.name
        env.progress.spawn_location.spawner = object.name
        
        print('spawn set to: ' .. object.name .. ' in ' .. env.level.name)
      end
    end
  end
end

local update_world

function love.update (dt)
  env.world:update(dt, get_env())
  
  check_triggers()
  
  if not env.player then
    env.respawn_time = env.respawn_time - dt    
    if env.respawn_time < 0 then
      
      spawn()
    end
  end
end

local resolve_camera
local draw_level
local draw_watch_expressions, draw_map_wireframe

function love.draw () 
  resolve_camera()
  draw_level()
  
  env.world:draw(get_env())
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.draw(env.level.overlay, -env.camera.x * env.camera.scale, -env.camera.y * env.camera.scale, 0, env.camera.scale, env.camera.scale)
  
  if env.debug then
    for id, entity in env.world:each() do
      local bounds = entities.getBounds(entity)
  
      if bounds then
        if entity.is_deadly then
          love.graphics.setColor(0xFF, 0x00, 0x00)
        else
          love.graphics.setColor(0xFF, 0xFF, 0x00)
        end
        
        love.graphics.setLineWidth(1 * env.camera.scale)
        love.graphics.rectangle(
          "line",
          (bounds.min.x - env.camera.x) * env.camera.scale,  -- x
          (bounds.min.y - env.camera.y) * env.camera.scale,  -- y
          bounds.size.x * env.camera.scale,
          bounds.size.y * env.camera.scale
        )
      end
    end
  end
end

function resolve_camera () -- keeps the camera pointing at the player, if a player entity is active
  if not env.player then
    return
  end
  
  env.camera.x = env.player.position.x - env.camera.width * 0.5
  env.camera.y = env.player.position.y - env.camera.height * 0.7
  
  local camera_max = vector(env.camera.x + env.camera.width, env.camera.y + env.camera.height)
  
  if env.camera.x < 0 then
    env.camera.x = 0
  end
  
  if env.camera.y < 0 then
    env.camera.y = 0
  end
  
  if camera_max.x > env.level.width * config.tile_size then
    env.camera.x = env.level.width * config.tile_size - env.camera.width
  end
  
  if camera_max.y > env.level.height * config.tile_size then
    env.camera.y = env.level.height * config.tile_size - env.camera.height
  end
  
  env.camera.x = math.floor(env.camera.x * env.camera.scale) / env.camera.scale
  env.camera.y = math.floor(env.camera.y * env.camera.scale) / env.camera.scale
end

function draw_level () -- draws the tilemap and any placeholder boxes for level objects
  if env.level then
    love.graphics.setLineWidth(2 * env.camera.scale)
    
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(env.level.tilemap, -env.camera.x * env.camera.scale, -env.camera.y * env.camera.scale, 0, env.camera.scale, env.camera.scale)
        
    for i, object in pairs(env.level.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF}
      love.graphics.setColor(unpack(color_array))
      
      if object.type == 'spawn' or env.debug then
        if object.shape == "rectangle" then
            
          love.graphics.rectangle("line", 
            (object.x - env.camera.x) * env.camera.scale, 
            (object.y - env.camera.y) * env.camera.scale, 
            object.width * env.camera.scale,
            object.height * env.camera.scale)
          
          if object.type == 'spawn' 
            and env.level.name == env.progress.spawn_location.room 
            and object.name == env.progress.spawn_location.spawner then
              love.graphics.ellipse("line", 
                (object.x + object.width / 2 - env.camera.x) * env.camera.scale, 
                (object.y + object.height / 2 - env.camera.y) * env.camera.scale, 
                object.width / 2 * env.camera.scale,
                object.height / 2 * env.camera.scale)
          end
        elseif object.shape == 'polyline' then
          local vectors = tiled.getPath(object)
            
          for i = 1, #vectors - 1 do
            local from = vectors[i]
            local to = vectors[i + 1]
            
            love.graphics.line(
              (from.x - env.camera.x) * env.camera.scale, 
              (from.y - env.camera.y) * env.camera.scale,
              (to.x - env.camera.x) * env.camera.scale, 
              (to.y - env.camera.y) * env.camera.scale
            )
          end
        end
      end
    end
  end
end

local function draw_wirebox (color, tx, ty)
  love.graphics.setColor(unpack(color))
  love.graphics.rectangle("line", 
    (tx * config.tile_size - env.camera.x) * env.camera.scale + 1,  -- x
    (ty * config.tile_size - env.camera.y) * env.camera.scale + 1,  -- y
    
    config.tile_size * env.camera.scale - 2,                    -- width
    config.tile_size * env.camera.scale - 2                     -- height
  )
end

function draw_map_wireframe ()
  local left_ramp_color = {0x00, 0xFF, 0x22, 0xFF}
  local right_ramp_color = {0x00, 0x22, 0xFF, 0xFF}
  local full_block_color = {0xFF, 0xFF, 0xFF, 0xFF}
  local platform_color = {0xFF, 0x33, 0x33, 0xFF}
  
  for x = 0, env.level.width - 1 do
    for y = 0, env.level.height - 1 do
      local wall_tile = env.level.layers.walls:getTile(x, y)
      local platform_tile = env.level.layers.platforms:getTile(x, y)
      
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