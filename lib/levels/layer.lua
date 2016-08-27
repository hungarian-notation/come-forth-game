-- lib.levels.layer

local config = require "config"

local layer = {} ; layer.__index = layer

function layer.new (layer_data)
  local self = setmetatable({}, layer)
  
  self.data = {}
  
  self.width = layer_data.width
  self.height = layer_data.height
  
  for i = 1, #layer_data.data do
    local val = layer_data.data[i]
    
    if val == 0 then 
      self.data[i] = nil
    else
      self.data[i] = val - 1
    end
  end
  
  return self
end

function layer:getTileId (...) 
  -- This function takes either one or two args.
  -- 
  -- Layer:getTileId(x, y)  -- see Layer:getTileIdByPosition
  -- Layer:getTile(index) -- see Layer:getTileIdByIndex
  
  local args = {...}
  
  if #args == 1 then
    return self:getTileIdByIndex(...)
  elseif #args == 2 then
    return self:getTileIdByPosition(...)
  else
    error("expected one or two arguments")
  end
end

function layer:getTileIdByPosition(x, y)
  return self:getTileIdByIndex(x + y * self.width + 1)
end

function layer:getTileIdByIndex(index) 
  return self.data[index]
end

return layer