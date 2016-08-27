-- lib.levels

local config = require "config"

local tiled = require "lib.levels.tiled"
local Layer = require "lib.levels.layer"

local tiles = require "lib.tiles"

local TILE_LAYERS = 3

-- Map Data Handling

local Level = {} ; Level.__index = Level 

function Level.new (map_data) 
    local self = setmetatable({}, Level)
    
    self.width = map_data.width
    self.height = map_data.height
    
    self.layers = {
      walls       = Layer.new(tiled.getLayerData(map_data, "walls")),
      platforms   = Layer.new(tiled.getLayerData(map_data, "platforms")),
      background  = Layer.new(tiled.getLayerData(map_data, "background"))
    }
    
    self.objects = {}
    
    local object_layer = tiled.getLayerData(map_data, "objects")
    
    for k, object in ipairs(object_layer.objects) do
      print('found object: ' .. object.type .. ":" .. object.name)
      self.objects[#self.objects + 1] = object
    end
    
    return self
end

function Level:getSprite (x, y, layer)
      local tile_id = layer:getTileId(x, y)
            
      if tile_id then   
        return tiles.getQuad(tile_id)
      end
end

function Level:getTilemap () 
  local tileset_image = love.graphics.newImage("res/art/tileset.png")
  tileset_image:setFilter("nearest", "nearest")
  
  local batch = love.graphics.newSpriteBatch(tileset_image, self.width * self.height * TILE_LAYERS)
  
  for x = 0, self.width - 1 do
    for y = 0, self.height - 1 do
      local background  = self.layers.background:getTileId(x, y)
      local platform    = self.layers.platforms:getTileId(x, y)
      local wall        = self.layers.walls:getTileId(x, y)
      
      if background then batch:add(tiles.getQuad(background), x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
      if platform then batch:add(tiles.getQuad(platform), x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
      if wall then batch:add(tiles.getQuad(wall), x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
    end
  end
  
  return batch
end

return {
  Level = Level,
  newLevel = Level.new
}