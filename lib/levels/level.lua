local config = require "config"
local tiled = require "lib.levels.tiled"
local layer = require "lib.levels.layer"
local tiles = require "lib.tiles"

local level = {} ; level.__index = level 

function level.new (map_data) 
    local self = setmetatable({}, level)
    
    self.width = map_data.width
    self.height = map_data.height
    
    self.layers = {
      walls       = layer.new(tiled.getLayerData(map_data, "walls")),
      platforms   = layer.new(tiled.getLayerData(map_data, "platforms")),
      background  = layer.new(tiled.getLayerData(map_data, "background"))
    }
    
    self.objects = {}
    
    local object_layer = tiled.getLayerData(map_data, "objects")
    
    for k, object in ipairs(object_layer.objects) do
      self.objects[#self.objects + 1] = object
    end
    
    return self
end

function level:getObject (object_name)
  for i, object in ipairs(self.objects) do
    if object.name == object_name then
      return object
    end
  end
  
  error('no such object: ' .. object_name)
end

function level:getTilemap () 
  local tileset_image = love.graphics.newImage("res/art/tileset.png")
  tileset_image:setFilter("nearest", "nearest")
  
  local batch = love.graphics.newSpriteBatch(tileset_image, self.width * self.height * 3 --[[ three layers ]])
  
  for x = 0, self.width - 1 do
    for y = 0, self.height - 1 do
      local background  = self.layers.background:getTile(x, y)
      local platform    = self.layers.platforms:getTile(x, y)
      local wall        = self.layers.walls:getTile(x, y)
      
      if background then batch:add(tiles[background].quad, x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
      if platform then batch:add(tiles[platform].quad, x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
      if wall then batch:add(tiles[wall].quad, x * config.grid_size, y * config.grid_size, 0, config.scale, config.scale) end
    end
  end
  
  return batch
end

return level