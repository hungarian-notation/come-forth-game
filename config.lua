local vector = require "lib.vector"

local config = {
  trigger_collections = {
    "test_triggers"
  },
  
  time_step           = 1.0 / 200.0,
  
  tile_size           = 16,
    
  tileset_width       = 320,
  tileset_height      = 320,
    
  tileset_rows        = 20,
  tileset_columns     = 20,
    
  window_width        = 768,
  window_height       = 576,
    
  text_display = {
    width = 700,
    y = 100,
    font = 'res/blocktopia.ttf'
  },
    
  player = {  
    respawn_time      = 3,
    
    size              = vector(16, 32),
    origin            = vector(8, 32),
    fall_through_time = 0.1,
    
    acceleration      = 500,
    friction          = 0.95,
    
    jump_attenuation  = 0.6,
    
    blaster = {
      cooldown        = 0.4,
      velocity        = 400,
      damage          = 1
    },
    
    super_blaster = {
      cooldown        = 0.3,
      velocity        = 400,
      damage          = 3
    },
    
    
    jump = {
      impulse         = 180,     
      float_time      = 0.2,
      float_gravity   = 50,
    },
    
    high_jump = {
      impulse         = 220,     
      float_time      = 0.2,
      float_gravity   = 50,
    },
    
    gravity           = 800
  },
  
  enemies = {
    patroller_speed = 48
  }
}

config.object_colors = {
  spawn = { 0x00, 0xFF, 0xFF },
  exit = { 0xAA, 0xFF, 0x00 },
  killbox = { 0xFF, 0x00, 0x00 },
  scarab = { 0xFF, 0x00, 0xFF }
}

return config; 