local config          = require "config"
local text            = require "text.en"

local levels          = require "lib.levels"
local tiles           = require "lib.tiles"
local vector          = require "lib.vector"
local sensor          = require "lib.sensor"
local entities        = require "lib.entities"

-- Game State

local state, camera, world, level_object

local function get_env ()
  return {
    camera = camera,
    level = level_object,
    state = state,
    progress = state.progress,
    world = world
  }
end

state = {
  time_error = 0,
  active_level = nil,
  player = nil,
  
  progress = {
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

local function reset_world ()
  world = entities.newWorld()
end

reset_world()
 
camera = { x = -100, y = -10, scale = 5, width = config.window_width / 5, height = config.window_height / 5 }

-- Level Management

level_object = nil

local level_tilemap = nil

local function set_level (level_name, entry_name)
  reset_world()
  
  local definition = require("res.map." .. level_name)
  
  level_object = levels.newLevel(definition)
  level_tilemap = level_object:getTilemap()
  
  local entry_object = level_object:getObject(entry_name)
  
  state.active_level = level_name
  
  state.player = (require "lib.entities.player").create(get_env(), {
    position = levels.getOrigin(entry_object)
  })
end

local function spawn() 
  set_level(state.progress.spawn_location.room, state.progress.spawn_location.spawner)
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
  local player_minimum = state.player.position - config.player.origin
  
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
  local player_minimum = state.player.position - config.player.origin
  
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
        exiting = state.player.velocity.x < 0
      elseif math.ceil(object_origin.x) >= level_object.width then -- right exit
        exiting = state.player.velocity.x > 0
      end
      
      if exiting then
        return use_exit(object.name, object.properties.target)
      end
    end
    
    if contains and object.type == 'spawn' then
      if state.progress.spawn_location.room ~= state.active_level or state.progress.spawn_location.spawner ~= object.name then
        state.progress.spawn_location.room = state.active_level
        state.progress.spawn_location.spawner = object.name
        
        print('spawn set to: ' .. object.name .. ' in ' .. state.active_level)
      end
    end
  end
end

local update_weapon, update_world

function love.update (dt)
  update_world(dt)
  check_triggers()
end

function update_world (dt) 
  local env = get_env()
  
  for id, entity in world:each() do
    entity:update(dt, env)
  end
end

local resolve_camera
local draw_level, draw_world
local draw_watch_expressions, draw_map_wireframe

function love.draw () 
  resolve_camera()
  draw_level()
  draw_world()
end

function resolve_camera ()
  if not state.player then
    print('no player')
    return
  end
  
  camera.x = state.player.position.x - camera.width * 0.5
  camera.y = state.player.position.y - camera.height * 0.7
  
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
end

function draw_world()
  local env = get_env()
  
  for id, entity in world:each() do
    if entity.draw then
      entity:draw(env)
    end
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
          and state.active_level == state.progress.spawn_location.room 
          and object.name == state.progress.spawn_location.spawner then
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