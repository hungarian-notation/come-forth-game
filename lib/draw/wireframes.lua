local config          = require "config"
local vector          = require "lib.vector"

local entities        = require "lib.entities"
local tiled           = require "lib.levels.tiled"

local wireframes = {}

function wireframes.draw_entities (env)
  love.graphics.setLineWidth(1 * env.camera.scale)
  
  if env.debug then
    for id, entity in env.world:each() do
      local bounds = entities.getBounds(entity)
  
      if bounds then
        if entity.is_deadly then
          love.graphics.setColor(0xFF, 0x00, 0x00)
        else
          love.graphics.setColor(0xFF, 0xFF, 0x00)
        end
        
        love.graphics.setLineWidth(1 * env.camera.scale)
        love.graphics.rectangle(
          "line",
          (bounds.min.x - env.camera.x) * env.camera.scale,  -- x
          (bounds.min.y - env.camera.y) * env.camera.scale,  -- y
          bounds.size.x * env.camera.scale,
          bounds.size.y * env.camera.scale
        )
      end
    end
  end
end

local function draw_rectangle_object (env, object)
  love.graphics.rectangle("line", 
    (object.x - env.camera.x) * env.camera.scale, 
    (object.y - env.camera.y) * env.camera.scale, 
    object.width * env.camera.scale,
    object.height * env.camera.scale)
  
  if object.type == 'spawn' 
    and env.level.name == env.progress.spawn_location.room 
    and object.name == env.progress.spawn_location.spawner then
      love.graphics.ellipse("line", 
        (object.x + object.width / 2 - env.camera.x) * env.camera.scale, 
        (object.y + object.height / 2 - env.camera.y) * env.camera.scale, 
        object.width / 2 * env.camera.scale,
        object.height / 2 * env.camera.scale)
  end
end

local function draw_polyline_object (env, object) 
  local vectors = tiled.getPath(object)
    
  for i = 1, #vectors - 1 do
    local from = vectors[i]
    local to = vectors[i + 1]
    
    love.graphics.line(
      (from.x - env.camera.x) * env.camera.scale, 
      (from.y - env.camera.y) * env.camera.scale,
      (to.x - env.camera.x) * env.camera.scale, 
      (to.y - env.camera.y) * env.camera.scale
    )
  end
end

local function draw_object_debug (env, object)
    local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF}
    love.graphics.setColor(unpack(color_array))
    
    if object.type == 'spawn' or env.debug then
      if object.shape == "rectangle" then
        draw_rectangle_object(env, object)
      elseif object.shape == 'polyline' then
        draw_polyline_object(env, object)
      end
    end
end

function wireframes.draw_objects (env)
  love.graphics.setLineWidth(1 * env.camera.scale)
  
  for i, object in pairs(env.level.objects) do
    draw_object_debug(env, object)
  end
end

return wireframes