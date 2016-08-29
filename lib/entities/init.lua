local bounds = require "lib.bounds"
local vector = require "lib.vector"

local entities = {}

function entities.getBounds (entity) 
  if not ((entity.minimum or entity.position) and entity.size) then
    return nil
  else    
    local min = entity.minimum or (entity.position - (entity.origin or vector.zero()))
    local max = min + entity.size
    
    return bounds.new{ min = min, max = max }
  end
end

function entities.newWorld ()
  local world = { _next = 1, population = {} }
  
  function world:create(entity)    
    entity.id = self._next
    self.population[entity.id] = entity
    self._next = self._next + 1
    return entity
  end
  
  function world:destroy (entity)    
    if not (type(entity) == 'table') or not entity.id then
      error('not an entity')
    elseif self.population[entity.id] ~= entity then
      error('entity not in population')
    else
      self.population[entity.id] = nil
    end
  end
  
  function world:each ()
    return pairs(self.population)
  end
  
  function world:update (dt, env)
    for id, entity in self:each() do
      if entity.update then entity:update(dt, env) end
    end
  end
  
  function world:draw (env)
    for id, entity in self:each() do
      if entity.draw then entity:draw(env) end
    end
  end
  
  return world
end

return entities