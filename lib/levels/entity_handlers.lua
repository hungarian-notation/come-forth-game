local config =  require "config"
local vector =  require "lib.vector"
local tiled =   require "lib.levels.tiled"

local function noop () end

local entity_handlers = {
  spawn = noop,
  exit = noop,
  killbox = noop,
  patrol_facing = noop -- this is simply referenced by its patrol
}

local entity_types = {
  crate_entity        = require "lib.entities.crate",
  scarab_entity       = require "lib.entities.scarab"
}

function entity_handlers.crate (env, object) 
  entity_types.crate_entity.create(env, { 
      position = vector(object.x, object.y),
      object_id = object.id
  })
end

function entity_handlers.scarab (env, object)  
  entity_types.scarab_entity.create(env, { 
      patrol_path   = tiled.getPath(object),
      is_clockwise  = object.properties.clockwise or false,
      object_id = object.id
  })
end

return entity_handlers