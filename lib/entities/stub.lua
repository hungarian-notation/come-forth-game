local config = require "config"
local vector = require "lib.vector"
local sensor = require "lib.sensor"

local _entity_ = {} ; _entity_.__index = _entity_

function _entity_.create (env, args) 
  local instance = setmetatable({}, _entity_)
  
  -- initialize entity
  
  return env.world:create(instance)
end

function _entity_:update (dt, env)
  
  -- update entity
  
end

function _entity_:draw (env)
  
  -- draw entity
  
end

return _entity_