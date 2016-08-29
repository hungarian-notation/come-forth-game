local config    = require "config"
local vector    = require "lib.vector"
local segment   = require "lib.segment"
local sensor    = require "lib.sensor"
local tiles     = require "lib.tiles"

local scarab_entity = {} ; scarab_entity.__index = scarab_entity
local quad = {}

function scarab_entity.create (env, args) 
  
  -- initialize entity
  
  local instance = setmetatable({
    object_id       = assert(args.object_id, 'missing object id'),
      
    position        = vector.zero(),  -- computed manually each update
    rotation        = 0,
    minimum         = vector.zero(),
    size            = vector(16, 16),   -- hitbox 
    
    patrol_path     = assert(args.patrol_path, 'missing path'),
    is_clockwise    = args.is_clockwise,
    
    
    path_segments   = {},
    path_length     = nil,
    
    patrol_duration = nil,
    
    patrol_mode     = 'bounce',
    is_deadly       = true,
    
    hitpoints       = assert(args.hitpoints, 'missing hitpoints'),
    
    timer           = 0
  }, scarab_entity)

  instance:compute_path()
  
  if not env.destructibles:is_destroyed(env.level.name, instance.object_id) then
    return env.world:create(instance)
  else
    return nil
  end
end

function scarab_entity:shoot (env, projectile)
  self.hitpoints = self.hitpoints - projectile.damage
  
  if self.hitpoints <= 0 then
    env.world:destroy(self)
    env.destructibles:destroy(env.level.name, self.object_id)
  end
    
  return true
end

function scarab_entity:compute_path ()  
  self.path_length = 0
  
  if self.patrol_path[1] == self.patrol_path[#self.patrol_path] then
    self.patrol_mode = 'loop'
  end
  
  for i = 1, #self.patrol_path - 1 do    
    local path_seg = segment.new(self.patrol_path[i], self.patrol_path[i+1])    
    self.path_segments[i] = path_seg
    self.path_length = self.path_length + path_seg:getLength()
  end
  
  self.patrol_duration = self.path_length / config.enemies.patroller_speed
end

function scarab_entity:update (dt, env)
  self.timer = self.timer + dt
  
  if self.patrol_mode == 'bounce' then
    if self.timer > self.patrol_duration * 2 then
      self.timer = 0
    end
  elseif self.patrol_mode == 'loop' then
    if self.timer > self.patrol_duration then
      self.timer = 0
    end
  else
    error('unknown patrol mode: ' .. tostring(self.patrol_mode))
  end
  
  self:computeProgress()
  
  -- update entity
end

function scarab_entity:computeProgress ()
  local distance = self.timer * config.enemies.patroller_speed
  
  if distance > self.path_length then
    distance = self.path_length - distance
  end
  
  local remaining = math.abs(distance)
  
  local start, goal, direction
  
  if distance < 0 then 
    start = #self.path_segments
    goal = 1
    direction = -1
  else
    start = 1
    goal = #self.path_segments
    direction = 1
  end
  
  local current_segment
  
  for i = start, goal, direction do
    local seg = self.path_segments[i]
    local segment_length = seg:getLength()
    
    if remaining < segment_length then
      current_segment = seg
      break
    else
      remaining = remaining - segment_length
    end
  end
  
  if direction == 1 then
    self.position = current_segment.from + current_segment:getDirection():scale(remaining)
  else
    self.position = current_segment.to + current_segment:getDirection():scale(-remaining)
  end
  
  local normal
  
  if self.is_clockwise then
    normal = current_segment:getAntiNormal()
  else
    normal = current_segment:getNormal()
  end
  
  self.rotation = normal:getAngle()
  
  local center = self.position + normal:scale(8)
  
  self.minimum = center - self.size:scale(1/2)
end

function scarab_entity:draw (env)
  if not quad[self.hitpoints] then
    quad[self.hitpoints] = tiles.getQuad(tiles.named_tiles.scarab[self.hitpoints])
  end
  
  local draw_location = self.position:scale(env.camera.scale):floor():scale(1 / env.camera.scale)
  local sprite_origin = vector(8, 16)
  
  local x_mirror = 1
  
  if not self.is_clockwise then
    x_mirror = -1
  end
  
  if self.timer > self.patrol_duration then
    x_mirror = x_mirror * -1
  end
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.draw(tiles:getTileSet(), quad[self.hitpoints], 
    (draw_location.x - env.camera.x) * env.camera.scale,  -- x
    (draw_location.y - env.camera.y) * env.camera.scale,  -- y
    self.rotation + math.pi / 2,  -- rotation
    
    env.camera.scale * x_mirror,  -- scale
    env.camera.scale,  -- scale
    
    sprite_origin.x,
    sprite_origin.y
  )
end

return scarab_entity