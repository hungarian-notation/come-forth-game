-- lib.tiles
-- exports an array of objects indexed by tile_id

local config = require "config"

local tiles = { }

function tiles:getTileSet ()
  if not self._tileset then
    self._tileset = love.graphics.newImage('res/art/tileset.png')
    self._tileset:setFilter("nearest", "nearest")
  end
  
  return self._tileset
end

tiles.named_tiles = {
  crate = 380,
  alien_crate = 360,
  scarab = {381, 382, 383, 384}
}

local getQuadById, getQuadByCoord

function tiles.getQuad (...)
  local args = {...}
  
  if #args == 1 then 
    return getQuadById(args[1])
  elseif #args == 2 or #args == 4 then 
    return getQuadByCoord(args[1], args[2], args[3], args[4])
  else
    error('expected one, two, or four arguments')
  end
end

function getQuadById (tile_id)
  local tx = tile_id % config.tileset_columns
  local ty = math.floor(tile_id / config.tileset_columns)
  return love.graphics.newQuad(tx * config.tile_size, ty * config.tile_size, config.tile_size, config.tile_size, config.tileset_width, config.tileset_height)
end

function getQuadByCoord(tile_x1, tile_y1, tile_x2, tile_y2)
  tile_x2 = tile_x2 or tile_x1
  tile_y2 = tile_y2 or tile_y1
  
  local width = tile_x2 - tile_x1 + 1
  local height = tile_y2 - tile_y1 + 1
  
  return love.graphics.newQuad(tile_x1 * config.tile_size, tile_y1 * config.tile_size, width * config.tile_size, height * config.tile_size, config.tileset_width, config.tileset_height)
end

for id = 0, 399 do
  tiles[id] = { 
    id              = id,    
    is_ramp         = false,
    ramp_dir        = nil,
    quad            = tiles.getQuad(id)
  }
end

-- DATA

tiles[6].is_ramp = true
tiles[6].ramp_dir = 'right'

tiles[26].is_ramp = true
tiles[26].ramp_dir = 'left'

-- END DATA

return tiles