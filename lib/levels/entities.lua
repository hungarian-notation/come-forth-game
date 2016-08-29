local config = require "config"
local vector = require "lib.vector"

local function noop () end

local entities = {
  spawn = noop,
  exit = noop
}

local entity_types = {
  crate = require "lib.entities.crate"
}

function entities.crate (env, object) 
  entity_types.crate.create(env, { 
      position = vector(object.x, object.y),
      object_id = object.id
  })
end

return entities