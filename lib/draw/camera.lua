local config          = require "config"
local vector          = require "lib.vector"

local camera = {}

function camera.update (dt, env)
  
end

function camera.resolve (env) -- keeps the camera pointing at the player, if a player entity is active
  if env.player then
    env.camera.x = env.player.position.x - env.camera.width * 0.5
    env.camera.y = env.player.position.y - env.camera.height * 0.7
    
    local camera_max = vector(env.camera.x + env.camera.width, env.camera.y + env.camera.height)
    
    if env.camera.x < 0 then env.camera.x = 0 end
    if env.camera.y < 0 then env.camera.y = 0 end
    
    if camera_max.x > env.level.width * config.tile_size then
      env.camera.x = env.level.width * config.tile_size - env.camera.width
    end
    
    if camera_max.y > env.level.height * config.tile_size then
      env.camera.y = env.level.height * config.tile_size - env.camera.height
    end
    
    env.camera.x = math.floor(env.camera.x * env.camera.scale) / env.camera.scale
    env.camera.y = math.floor(env.camera.y * env.camera.scale) / env.camera.scale
  end
end

return camera