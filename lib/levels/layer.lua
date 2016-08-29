-- lib.levels.layer

local config = require "config"

local layer = {} ; layer.__index = layer

function layer.new (layer_data)
  if not layer_data then
    return nil
  end
  
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

function layer:getTile (...) 
  -- This function takes either one or two args.
  -- 
  -- Layer:getTile(x, y)  -- see Layer:getTileIdByPosition
  -- Layer:getTile(index) -- see Layer:getTileIdByIndex
  
  local args = {...}
  
  if #args == 1 then
    return self:getTileByIndex(...)
  elseif #args == 2 then
    return self:getTileByPosition(...)
  else
    error("expected one or two arguments")
  end
end

function layer:getTileByPosition(x, y)
  if x < 0 or x >= self.width then
    return nil
  elseif y < 0 or y >= self.height then
    return nil
  else
    return self:getTileByIndex(x + y * self.width + 1)
  end
end

function layer:getTileByIndex(index) 
  return self.data[index]
end

return layer