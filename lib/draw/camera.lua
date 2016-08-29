local config          = require "config"
local vector          = require "lib.vector"

local camera = {} ; camera.__index = camera

function camera.create ()
  return setmetatable({
    x = 0, 
    y = 0, 
    scale = 3, 
    width = config.window_width / 3, 
    height = config.window_height / 3 
  }, camera)
end

function camera:update (dt, env)
  if env.player then
    self.x = env.player.position.x - self.width * 0.5
    self.y = env.player.position.y - self.height * 0.7
    
    local camera_max = vector(self.x + self.width, self.y + self.height)
    
    if self.x < 0 then self.x = 0 end
    if self.y < 0 then self.y = 0 end
    
    if camera_max.x > env.level.width * config.tile_size then
      self.x = env.level.width * config.tile_size - self.width
    end
    
    if camera_max.y > env.level.height * config.tile_size then
      self.y = env.level.height * config.tile_size - self.height
    end
    
    self.x = math.floor(self.x * self.scale) / self.scale
    self.y = math.floor(self.y * self.scale) / self.scale
  end
end

return camera