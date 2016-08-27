-- lib.levels.layer

local config = require "config"

local Layer = {} ; Layer.__index = Layer

function Layer.new (layer)
  local self = setmetatable({}, Layer)
  
  self.data = {}
  
  self.width = layer.width
  self.height = layer.height
  
  for i = 1, #layer.data do
    local val = layer.data[i]
    
    if val == 0 then 
      self.data[i] = nil
    else
      self.data[i] = val - 1
    end
  end
  
  return self
end

function Layer:getTileId (...) 
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

function Layer:getTileIdByPosition(x, y)
  return self:getTileIdByIndex(x + y * self.width + 1)
end

function Layer:getTileIdByIndex(index) 
  return self.data[index]
end

return Layer