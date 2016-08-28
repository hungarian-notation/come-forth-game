local config = require "config"
local text = require "text.en"

local levels = require "lib.levels"
local tiles = require "lib.tiles"

local vector = require "lib.vector"
local sensor = require "lib.physics.sensor"

-- Debug

local watch_expressions = {
    "",
    "love.timer.getFPS()",
    "",
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

local draw_player, draw_level

local draw_watch_expressions, draw_map_wireframe

function love.draw () 
  draw_level()
  draw_player()
  
  draw_map_wireframe()
  draw_watch_expressions()
end

function draw_player ()
  local minimum = state.player.position - config.player.origin
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  love.graphics.rectangle("fill", minimum.x * config.scale, minimum.y * config.scale, config.player.size.x * config.scale, config.player.size.y * config.scale)
end

function draw_level ()
  if level_object then
    love.graphics.setColor(0xFF, 0xFF, 0xFF)
    love.graphics.draw(level_tilemap)
        
    for i, object in ipairs(level_object.objects) do
      local color_array = config.object_colors[object.type] or { 0xFF, 0xFF, 0xFF }
      love.graphics.setColor(unpack(color_array))
      
      if object.shape == "rectangle" then
        love.graphics.rectangle("line", object.x * config.scale, object.y * config.scale, object.width * config.scale, object.height * config.scale)
      end
    end
  end
end

local function draw_wirebox (color, tx, ty)
  love.graphics.setColor(unpack(color))
  love.graphics.rectangle("line", tx * config.grid_size + 1, ty * config.grid_size + 1, config.grid_size - 2, config.grid_size - 2)
end

function draw_map_wireframe ()
  local left_ramp_color = {0x00, 0xFF, 0x22, 0xFF}
  local right_ramp_color = {0x00, 0x22, 0xFF, 0xFF}
  local full_block_color = {0xFF, 0xFF, 0xFF, 0xFF}
  
  for x = 0, level_object.width - 1 do
    for y = 0, level_object.height - 1 do
      local wall_tile = level_object.layers.walls:getTile(x, y)
      
      if wall_tile and tiles[wall_tile].is_solid then
        if tiles[wall_tile].is_ramp then          
          if tiles[wall_tile].ramp_dir == 'left' then
            draw_wirebox(left_ramp_color, x, y)
          else
            draw_wirebox(right_ramp_color, x, y)
          end
        else
            draw_wirebox(full_block_color, x, y)
        end
      end
    end
  end
end

function draw_watch_expressions () -- evaluate and render watch expressions
  local label_col = 10 
  local data_col = 250
  
  local line_height = 14
  local base_line = 10
  
  love.graphics.setColor(0xFF, 0x00, 0xFF)
  love.graphics.print("[watch expression]", label_col, base_line) 
  love.graphics.print("= [value]", data_col, base_line) 
      
  for i, expr in ipairs(watch_expressions) do
    if expr and #expr > 0 then
      love.graphics.setColor(0xFF, 0xFF, 0xFF)
      love.graphics.print(expr, label_col, base_line + line_height * i) 
      love.graphics.setColor(0xAA, 0xFF, 0xFF)
      love.graphics.print('= ' .. tostring(assert(loadstring('return ' .. expr))()), data_col, base_line + line_height * i)
    end
  end
end