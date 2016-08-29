local bounds = {} ; bounds.__index = bounds

function bounds.new(args) 
  local instance = setmetatable({}, bounds)
  
  args.min = args.min or args.minimum
  
  if args.min and args.max then
    instance.min = args.min
    instance.max = args.max
    
    instance.size = instance.max - instance.min
  elseif args.min and args.size then
    instance.min = args.min
    instance.size = args.size
    
    instance.max = instance.min + instance.size
  end
  
  return instance
end

function bounds:contains (other)
  return 
    other.min.x >= self.min.x and
    other.min.y >= self.min.y and
    other.max.x <= self.max.x and
    other.max.y <= self.max.y
end

function bounds:intersects (other)
  return not (
    other.min.x > self.max.x or
    other.min.y > self.max.y or
    other.max.x < self.min.x or
    other.max.y < self.min.y
  )
end

return bounds