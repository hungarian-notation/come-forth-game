local destructibles = {
  _records = {}
}

function destructibles:reset ()
  assert(self._records)
  self._records = {}
  print('reset destructables')
end

function destructibles:destroy (level_name, object_id)
  self._records[#self._records + 1] = {
    level_name = level_name,
    object_id  = object_id
  }
end

function destructibles:is_destroyed (level_name, object_id)  
  for i, record in pairs(self._records) do
    if record.level_name == level_name and record.object_id == object_id then
      return true
    end
  end
  
  return false
end

return destructibles