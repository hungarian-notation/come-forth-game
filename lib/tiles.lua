-- lib.tiles
-- exports an array of objects indexed by tile_id

local config = require "config"

local tiles = {}

local function getQuad (tile_id)
  local tx = tile_id % config.tileset_columns
  local ty = math.floor(tile_id / config.tileset_columns)
  return love.graphics.newQuad(tx * config.tile_size, ty * config.tile_size, config.tile_size, config.tile_size, config.tileset_width, config.tileset_height)
end

for id = 0, 399 do
  tiles[id] = { 
    id              = id,    
    is_solid        = false,
    is_ramp         = false,
    ramp_dir        = nil,
    quad            = getQuad(id)
  }
end

-- DATA

local solid_tiles = { 
  0,    1,    2,    3,    4,    5,    6,    7,    8,
  20,   21,   22,   23,   24,   25,   26,   27,   28
}

for i, id in ipairs(solid_tiles) do
  tiles[id].is_solid = true
end

tiles[6].is_ramp = true
tiles[6].ramp_dir = 'right'

tiles[26].is_ramp = true
tiles[26].ramp_dir = 'left'

-- END DATA

return tiles