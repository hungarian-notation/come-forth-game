local config          = require "config"
local text            = require "text.en"

local keys            = require "keybindings"

local levels          = require "lib.levels"
local tiles           = require "lib.tiles"
local vector          = require "lib.vector"
local sensor          = require "lib.sensor"
local entities        = require "lib.entities"

local tiled           = require "lib.levels.tiled"
local triggers        = require "lib.triggers"

local environment     = require "lib.environment"

local camera          = require "lib.draw.camera"
local wireframes      = require "lib.draw.wireframes"

-- Forward Declarations

local spawn, set_level, reset_environment, reset_world
local use_exit, split_address

local update_world, check_triggers

local 
  draw_level, 
  draw_textbox, 
  draw_object_wireframes,
  draw_entity_wireframes

-- Game State

local env = {}

function reset_environment ()
  env = environment.create()
end

function reset_world ()
  env.world = entities.newWorld()
end

function spawn() 
  env.destructibles:reset()
  set_level(env.progress.spawn_location.room, env.progress.spawn_location.spawner)
  env.respawn_time = config.player.respawn_time
end

-- Level Management

function set_level (level_name, entry_name)
  local player_velocity
  
  if env.player then 
    player_velocity = env.player.velocity
  else
    player_velocity = vector.zero()
  end
  
  reset_world()

  env.level = levels.newLevel(level_name)
  
  local entry_object = env.level:getObject(entry_name)
  
  env.level:initialize(env)
  
  print('making player')
  
  env.player = (require "lib.entities.player").create(env, {
    position = levels.getOrigin(entry_object),
    velocity = player_velocity
  })
end

-- Engine Hooks

function love.keypressed (key, scancode, repeated)
  if env.in_menu then
    
  end
  
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
  
  reset_environment()
  reset_world()
  spawn()
end

function love.update (dt)
  env.textbox:update(dt, env)
  env.world:update(dt, env)
  
  check_triggers()
  
  if not env.player then
    env.respawn_time = env.respawn_time - dt    
    if env.respawn_time < 0 then
      spawn()
    end
  end
end

function love.draw () 
  camera.resolve(env)

  env.level:drawUnderlay(env)
  env.world:draw(env)
  
  wireframes.draw_objects(env)
  wireframes.draw_entities(env)
  
  env.level:drawOverlay(env)
  
  env.textbox:draw(env)
end

-- Game State Control

function use_exit (exit_name, target)
  local room_name, object_name = split_address(target)
  print('using exit ' .. exit_name .. ' to ' .. object_name .. ' in ' .. room_name)
  set_level(room_name, object_name)
end

function split_address (address)   
  for i = #address, 0, -1 do
    if i == 0 then error('address does not contain a delimiter') end
    if address:sub(i, i) == '.' then
      return address:sub(1, i - 1), address:sub( i + 1, -1)
    end
  end
end

function check_triggers () 
  if not env.player then
    return
  end
  
  local player_bounds = entities.getBounds(env.player)
  
  for i, object in ipairs(env.level.objects) do
    if object.shape == 'rectangle' then
      local object_bounds = tiled.getBounds(object, 2)
      
      local contains = object_bounds:contains(player_bounds)
      local touching = object_bounds:intersects(player_bounds)
      
      if object.type == 'trigger' then
        if contains or (not object.properties.on_contains and touching) then
          if not env.triggered[object.name] then
            env.triggered[object.name] = true
            triggers[object.name](env, object)
          end
        end
      end
      
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
end