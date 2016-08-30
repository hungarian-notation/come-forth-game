local config = require "config"
local vector = require "lib.vector"
local entities = require "lib.entities"
local tiled = require "lib.levels.tiled"

local triggers = {trigger_table = {}}

for i, collection in pairs(config.trigger_collections) do
  require("triggers." .. collection)(triggers.trigger_table)
end

function triggers.check_triggers (env) 
  if not env.player then
    return
  end
  
  local player_bounds = entities.getBounds(env.player)
  
  for i, object in ipairs(env.level.objects) do
    if object.shape == 'rectangle' then
      local object_bounds = tiled.getBounds(object, 2)
      
      local contains = object_bounds:contains(player_bounds)
      local touching = object_bounds:intersects(player_bounds)
      
      if object.type == 'trigger' then
        if contains or (not object.properties.on_contains and touching) then
          if not env.triggered[object.name] then
            local data = object.properties and object.properties.data
            env.triggered[object.name] = not triggers.trigger_table[object.name](env, object, data)
          end
        end
      end
      
      if touching and object.type == 'killbox' then
        env.player:kill(env)
      end
      
      if contains and object.type == 'exit' then
        local object_origin = vector(object.x + object.width / 2, object.y / object.height)
        local exiting = false
        
        if math.floor(object_origin.x) <= 0 then -- left exit
          exiting = env.player.velocity.x < 0
        elseif math.ceil(object_origin.x) >= env.level.width then -- right exit
          exiting = env.player.velocity.x > 0
        end
        
        if exiting then
          return env:use_exit(object.name, object.properties.target)
        end
      end
      
      if contains and object.type == 'spawn' then
        if env.progress.spawn_location.room ~= env.level.name or env.progress.spawn_location.spawner ~= object.name then
          env.progress.spawn_location.room = env.level.name
          env.progress.spawn_location.spawner = object.name
        end
      end
    end
  end
end

return triggers