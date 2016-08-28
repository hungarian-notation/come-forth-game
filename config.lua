local vector = require "lib.vector"

local config = {
  time_step           = 1.0 / 200.0,
  
  tile_size           = 16,
    
  tileset_width       = 320,
  tileset_height      = 320,
    
  tileset_rows        = 20,
  tileset_columns     = 20,
    
  window_width        = 1600,
  window_height       = 900,
    
  player = {  
    size              = vector(16, 32),
    origin            = vector(8, 32),
    acceleration      = 1000,
    friction          = 0.95,
    
    float_time        = 0.2,
    fall_through_time = 0.1,
    
    jump_impulse      = 250,             
    float_gravity     = 50,
    gravity           = 800,               -- accurate gravity, assuming player is 1.5m tall
    
    max_speed         = 400
  }
}

config.object_colors = {
  spawn = { 0x00, 0xFF, 0xFF },
  exit = { 0xFF, 0x00, 0x00 }
}

return config; 