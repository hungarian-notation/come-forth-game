local entities = {}

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
  
  return world
end

return entities