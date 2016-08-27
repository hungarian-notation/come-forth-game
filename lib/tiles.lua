-- lib.tiles

local config = require "config"

local tiles = {}

function tiles.getQuad (tile_id)
  local tx = tile_id % config.tileset_columns
  local ty = math.floor(tile_id / config.tileset_columns)
  return love.graphics.newQuad(tx * config.tile_size, ty * config.tile_size, config.tile_size, config.tile_size, config.tileset_width, config.tileset_height)
end

return tiles