local config = require "config"
local text = require "text.en"
local levels = require "lib.levels"
local vector = require "lib.vector"

-- Debug

local watch_expressions = {
    "state.player.position",
    "state.active_level",
    "",
    "state.player.spawn_location.room",
    "state.player.spawn_location.spawner"
}

-- Game State

state = {
  player = {
    spawn_location = { room = "entrance", spawner = "initial_spawn" },
    position = vector.zero()
  },
  
  active_level = nil
}

local player = state.player

-- Level Management

local level_object = nil
local level_tilemap = nil

local function set_level (level_name, entry_name)
  local definition = require("res.map." .. level_name)
  
  level_object = levels.newLevel(definition)
  level_tilemap = level_object:getTilemap()
  
  local entry_object = level_object:getObject(entry_name)
  
  state.active_level = level_name
  state.player.position = levels.getOrigin(entry_object)
end

-- Initialization

local function initialize () 
  set_level(state.player.spawn_location.room, state.player.spawn_location.spawner)
end

-- Engine Hooks

function love.load ()   
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  initialize()
end

local draw_watches

function love.draw () 
  if level_object then
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(level_tilemap)
        
    for i, object in ipairs(level_object.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF }
      love.graphics.setColor(unpack(color_array))
      
      if object.shape == "rectangle" then
        love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
      end
    end
  end
  
  draw_watches()
end

function draw_watches () -- evaluate and render watch expressions
  local label_col = 10 
  local data_col = 300
  
  local line_height = 14
  local base_line = 10
  
  for i, expr in ipairs(watch_expressions) do
    if expr and #expr > 0 then
      love.graphics.setColor(0xFF, 0xFF, 0xFF)
      love.graphics.print(expr, label_col, base_line + line_height * i) 
      love.graphics.setColor(0xAA, 0xFF, 0xFF)
      love.graphics.print(tostring(assert(loadstring('return ' .. expr))()), data_col, base_line + line_height * i)
    end
  end
end