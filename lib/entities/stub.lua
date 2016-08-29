local config = require "config"
local vector = require "lib.vector"
local sensor = require "lib.sensor"

local _entity_ = {} ; _entity_.__index = _entity_

function _entity_.create (env, args) 
  
  -- initialize entity
  
  local instance = setmetatable({
      
    position = assert(args.position, 'missing position')
    
  }, _entity_)
  
  return env.world:create(instance)
end

function _entity_:update (dt, env)
  
  -- update entity
  
end

function _entity_:draw (env)
  
  -- draw entity
  
end

return _entity_