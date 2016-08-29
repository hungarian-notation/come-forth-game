local config          = require "config"
local text            = require "text.en"
local keys            = require "keybindings"
local levels          = require "lib.levels"
local vector          = require "lib.vector"
local entities        = require "lib.entities"
local tiled           = require "lib.levels.tiled"
local triggers        = require "lib.triggers"

local environment     = require "lib.environment"

local wireframes      = require "lib.draw.wireframes"

-- Forward Declarations

local update_world, check_triggers

-- Game State

local env = environment.create()

-- Engine Hooks

function love.keypressed (key, scancode, repeated)
  if env.in_menu then
    
  end
  
  if key == keys.debug_mode then
    env.debug = not env.debug
  end
  
  if env.debug and key == keys.force_respawn and not repeated then
    env:spawn()
  elseif env.debug and key == keys.force_reset and not repeated then
    env:reset()
    env:spawn()
  end
end

function love.load ()   
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  env:reset()
  env:spawn()
end

function love.update (dt)
  env.textbox:update(dt, env)
  env.world:update(dt, env)
  
  triggers.check_triggers (env)
  
  if not env.player then
    env.respawn_time = env.respawn_time - dt    
    if env.respawn_time < 0 then
      env:spawn()
    end
  end
  
  env.camera:update(dt, env)
end

function love.draw () 
  env.level:drawUnderlay(env)
  env.world:draw(env)
  wireframes.draw_objects(env)
  wireframes.draw_entities(env)
  env.level:drawOverlay(env)
  env.textbox:draw(env)
end