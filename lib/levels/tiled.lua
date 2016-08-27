-- lib.levels.tiled

local tiled = {}

function tiled.getLayerData (map_data, layer_name)
  for k, v in ipairs(map_data.layers) do
    if v.name == layer_name then
      return v
    end
  end
end

return tiled