local vector = require "lib.vector"

-- lib.levels.tiled

local tiled = {}

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