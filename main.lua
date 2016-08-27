local config = require "config"
local text = require "text.en"

local levels = require "lib.levels"

-- Level Management

local current_level = nil
local current_tilemap = nil

local function set_level (level_name)
  local definition = require("res.map." .. level_name)
  local level_object = levels.newLevel(definition)
  
  current_level = level_object
  current_tilemap = level_object:getTilemap()
end

-- Initialization

local function initialize () 
  set_level("entrance")
end

-- Engine Hooks

function love.load () 
  print(text.game_title)
  
  love.window.setTitle(text.game_title)
  love.window.setMode(config.window_width, config.window_height)
  
  initialize()
end

function love.draw () 
  if current_level then
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(current_tilemap)
        
    for i, object in ipairs(current_level.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF }
      love.graphics.setColor(unpack(color_array))
      
      if object.shape == "rectangle" then
        love.graphics.rectangle("line", object.x, object.y, object.width, object.height)
      end
    end
  end
end
