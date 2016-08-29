local config          = require "config"
local textbox         = require "lib.textbox"

local environment = {}

function environment.create () 
  local env = {
    in_menu = true,
    
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
    
    triggered = {},
    
    destructibles = require "lib.destructibles",
    
    state = {
      time_error = 0,
      active_level = nil
    },
    
    player = nil,
    
    textbox = textbox.initialize(),
    
    camera = { 
      x = -100, 
      y = -10, 
      
      scale = 3, 
      
      width = config.window_width / 3, 
      height = config.window_height / 3 
    }
  }
  
  return env
end

return environment