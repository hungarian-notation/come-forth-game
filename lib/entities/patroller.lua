local config    = require "config"
local vector    = require "lib.vector"
local segment   = require "lib.segment"
local sensor    = require "lib.sensor"

local patroller_entity = {} ; patroller_entity.__index = patroller_entity

local time_to_patrol = 5

function patroller_entity.create (env, args) 
  
  -- initialize entity
  
  local instance = setmetatable({
    patrol_path     = assert(args.patrol_path, 'missing path'),
    guide_path      = assert(args.patrol_facings, 'missing facings'),
    path_normals    = {},
    path_lengths    = {},
    path_length     = nil,
    
    timer           = 0
  }, patroller_entity)

  instance:compute_path()
  
  return env.world:create(instance)
end

function patroller_entity:compute_path ()  
  self.path_length = 0
  
  for i = 1, #self.patrol_path - 1 do    
    local path_seg = segment.new(self.patrol_path[i], self.patrol_path[i+1])
    local guide_seg = segment.new(self.guide_path[i], self.guide_path[i+1])
    
    local path_normal = path_seg:getNormal()
    
    local to_guide = guide_seg.from - path_seg.from
    local projection = path_normal:dot(to_guide)
    
    if projection < 0 then 
      path_normal = path_normal:scale(-1)
    end
    
    self.path_normals[i] = path_normal
    self.path_lengths[i] = path_seg:getForwardVector():length()
    
    self.path_length = self.path_length + self.path_lengths[i]
  end
end

function patroller_entity:update (dt, env)
  
  self.timer = self.timer + dt
  
  while self.timer > time_to_patrol do
      self.timer = self.timer - time_to_patrol
  end
  
  
  
  -- update entity
  
end

function patroller_entity:draw (env)
  local portions = #self.patrol_path - 1
  local sigma = (self.timer / time_to_patrol) * portions
  
  local portion = math.floor(sigma)
  local progress = sigma % 1
  
  local from = self.patrol_path[portion + 1]
  local to = self.patrol_path[portion + 2]
  
  local position = from:scale(1 - progress) + to:scale(progress)
  local normal = self.path_normals[portion + 1]:scale(16)
  
  local point_to = position + normal
  
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.ellipse("fill", (position.x - env.camera.x) * env.camera.scale, (position.y - env.camera.y) * env.camera.scale, 4 * env.camera.scale, 4 * env.camera.scale)
  love.graphics.setColor(0xAA, 0xAA, 0xAA)
  
  love.graphics.line(
    (position.x - env.camera.x) * env.camera.scale, 
    (position.y - env.camera.y) * env.camera.scale,
    (point_to.x - env.camera.x) * env.camera.scale, 
    (point_to.y - env.camera.y) * env.camera.scale
  )
  
  -- draw entity
  
end

return patroller_entity