local vector = require "lib.vector"
local bounds = require "lib.bounds"

-- lib.levels.tiled

local tiled = {}

function tiled.getBounds (rectangle_object, growth_amount)
  growth_amount = growth_amount or 0
  
  assert(rectangle_object)
  assert(type(rectangle_object) == 'table')
  assert(rectangle_object.shape)
  assert(rectangle_object.shape == 'rectangle')
  
  return bounds.new{ 
    min = vector(rectangle_object.x - growth_amount, rectangle_object.y - growth_amount), 
    size = vector(rectangle_object.width + 2 * growth_amount, rectangle_object.height + 2 * growth_amount) 
  }
end

function tiled.getLayerData (map_data, layer_name)
  for k, v in ipairs(map_data.layers) do
    if v.name == layer_name then
      return v
    end
  end
end

function tiled.getPath (polyline_object)
  local vectors = {}
  
  for i = 1, #polyline_object.polyline do
    vectors[i] = vector(polyline_object.polyline[i]) + vector(polyline_object)
  end
  
  return vectors
end

return tiled