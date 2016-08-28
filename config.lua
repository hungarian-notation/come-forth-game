local vector = require "lib.vector"

local config = {
  tile_size         = 16,
  scale             = 1,
  
  tileset_width     = 320,
  tileset_height    = 320,
  
  tileset_rows      = 20,
  tileset_columns   = 20,
  
  window_width      = 800,
  window_height     = 600,
  
  player = {
    size            = vector(16, 32),
    origin          = vector(8, 32),
    acceleration    = 1000,
    friction        = 0.95,
    
    float_time      = 0.2,
    
    jump_impulse    = 250,             
    float_gravity   = 50,
    gravity         = 800,               -- accurate gravity, assuming player is 1.5m tall
    
    max_speed       = 400
  }
}

config.grid_size = config.tile_size * config.scale

config.object_colors = {
  spawn = { 0x00, 0xFF, 0xFF },
  exit = { 0xFF, 0x00, 0x00 }
}

return config; 