local vector = {type='vector'} ; vector.__index = vector
local vector_metatable = {} ; setmetatable(vector, vector_metatable)

-- specific constructor

function vector.new (x, y)
  local self = setmetatable({}, vector)
  
  assert(x and type(x) == 'number', 'missing x coordinate')
  assert(y and type(y) == 'number', 'missing y coordinate')
  
  self.x = x
  self.y = y
  
  return self
end

-- zero constructor

function vector.zero()
  return vector.new(0, 0)
end

-- multiplex constructor

function vector_metatable.__call (table, ...)
  local args = {...}
  
  if #args == 0 then
    return vector.zero()
  elseif #args == 1 then
    if type(args[1] == "table") then
      if args[1].x and args[1].y then
        return vector.new(args[1].x, args[1].y)
      else
        return vector.new(unpack(args[1]))
      end
    else
      error('expected single argument to be an array-like table')
    end
  elseif #args == 2 then
    return vector.new(args[1], args[2])
  else
    error('expected zero, one, or two arguments')
  end
end

-- quality of life

function vector:__tostring ()
  return '{' .. self.x .. ', ' .. self.y .. '}'
end

function vector.isVector (thing) 
  return thing.type and thing.type == 'vector'
end

function vector.areVectors (...) 
  local args = {...}
  
  for i = 1, #args do
    if not vector.isVector(args[i]) then
      return false
    end
  end
  
  return true
end

local function assert_vectors(...)
  assert(vector.areVectors(...), "expected vectors")
end

-- equality operator

function vector.__eq (a, b) 
  return a.x == b.x and a.y == b.y
end

-- math operators

function vector.__add (a, b) 
  assert_vectors(a, b)
  return vector.new(a.x + b.x, a.y + b.y)
end

function vector.__sub (a, b)
  assert_vectors(a, b)
  return vector.new(a.x - b.x, a.y - b.y)
end

function vector.__unm (v)
  return vector.new(-v.x, -v.y)
end

function vector:scale(scalar)
  return vector.new(self.x * scalar, self.y * scalar)
end

function vector:dot(other)
  return self.x * other.x + self.y * other.y
end

function vector.__mul(a, b)
  if vector.isVector(a) and vector.isVector(b) then
    error("invalid operator '*'; use vector:dot")
  elseif vector.isVector(a) and type(b) == 'number' then
    error("invalid operator '*'; use vector:scale")
  else
    error("invalid operator '*'")
  end
end

function vector:length2 () 
  return self.x * self.x + self.y * self.y
end

function vector:length ()
  return math.sqrt(self:length2())
end

function vector:normalized () 
  local len = self:length()
  
  if len == 0 then
    error('the normal of a zero-length vector is undefined')
  else 
    return vector.new(self.x / len, self.y / len)
  end
end

function vector:getNormal ()
  return vector.new(-self.y, self.x)
end

function vector:getAntiNormal ()
  return vector.new(self.y, -self.x)
end

function vector:floor () 
  return vector.new(math.floor(self.x), math.floor(self.y))
end

function vector:ceil () 
  return vector.new(math.ceil(self.x), math.ceil(self.y))
end

function vector:getAngle ()
  return math.atan2(self.y, self.x)
end

return vector