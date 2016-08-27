local config = {
  tile_size         = 16,
  scale             = 1,
  
  tileset_width     = 320,
  tileset_height    = 320,
  
  tileset_rows      = 20,
  tileset_columns   = 20,
  
  window_width      = 800,
  window_height     = 600
}

config.grid_size = config.tile_size * config.scale

config.object_colors = {
  spawn = { 0x00, 0xFF, 0xFF },
  exit = { 0xFF, 0x00, 0x00 }
}

return config; 