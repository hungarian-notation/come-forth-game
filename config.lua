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
    fall_through_time = 0.1,
    
    acceleration      = 500,
    friction          = 0.95,
    
    jump_attenuation  = 0.6,
    
    blaster_cooldown  = 0.2,
    blaster_velocity  = 400,
    
    jump = {
      impulse         = 200,     
      float_time      = 0.2,
      float_gravity   = 50,
    },
    
    high_jump = {
      impulse         = 250,     
      float_time      = 0.2,
      float_gravity   = 50,
    },
    
    gravity           = 800
  }
}

config.object_colors = {
  spawn = { 0x00, 0xFF, 0xFF },
  exit = { 0xAA, 0xFF, 0x00 },
  killbox = { 0xFF, 0x00, 0x00 },
  patrol_enemy = { 0xFF, 0x00, 0xFF }
}

return config; 