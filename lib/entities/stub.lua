local config = require "config"
local vector = require "lib.vector"

local _entity = {} ; _entity.__index = _entity

function _entity.create (env, args) 
  local instance = setmetatable({}, _entity)
  
  -- initialize entity
  
  return env.world:create(instance)
end

function _entity:update (dt, env)
  
  -- update entity
  
end

function _entity:draw (env)
  
  -- draw entity
  
end

return _entity