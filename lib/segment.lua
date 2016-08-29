local segment = {} ; segment.__index = segment

function segment.new (from, to)
  return setmetatable({
      
    from  = assert(from, 'missing from vector'),
    to    = assert(to, 'missing to vector')
    
  }, segment)
end

function segment:__tostring ()
  return '[' .. tostring(self.from) .. '->' .. tostring(self.to) .. ']'
end

function segment:getForwardVector ()
  return self.to - self.from
end

function segment:getBackwardVector ()
  return self.from - self.to
end

function segment:getDirection ()
  return self:getForwardVector():normalized()
end

function segment:getNormal ()
  return self:getDirection():getNormal()
end

function segment:getAntiNormal ()
  return self:getDirection():getAntiNormal()
end

function segment:getLength ()
  return self:getForwardVector():length()
end
 
return segment