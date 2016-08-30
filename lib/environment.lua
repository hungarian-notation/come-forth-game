local config          = require "config"
local vector          = require "lib.vector"

local levels          = require "lib.levels"
local entities        = require "lib.entities"

local textbox         = require "lib.textbox"
local camera          = require "lib.draw.camera"

local environment = {} ; environment.__index = environment

function environment.create () 
  local env = setmetatable({}, environment)
  env:reset()
  return env
end

function environment:reset ()
  self.debug = false
  
  self.level = nil
  self.world = nil
  self.respawn_time = 3
  
  self.state = {}               -- used by triggers to track special game state
  self.progress = {             -- tracks the player's progress 
      spawn_location    = { room = config.initial_level, spawner = config.initial_spawner },
    
      blaster           = false,
      high_jump         = false,
      double_jump       = false,
      super_blaster     = false
  }
  
  self.triggered = {}
  self.destructibles = require "lib.destructibles"
  self.player = nil
  self.textbox = textbox.create()
  self.camera = camera.create()
  
  self:reset_world()
end

function environment:reset_world ()
  self.world = entities.newWorld()
end

function environment:spawn() 
  self.destructibles:reset()
  self:set_level(self.progress.spawn_location.room, self.progress.spawn_location.spawner)
  self.respawn_time = config.player.respawn_time
end


function environment:set_level (level_name, entry_name)
  assert(level_name)
  assert(entry_name)
  
  local player_velocity
  
  if self.player then 
    player_velocity = self.player.velocity
  else
    player_velocity = vector.zero()
  end
  
  self:reset_world()

  self.level = levels.newLevel(level_name)
  
  local entry_object = self.level:getObject(entry_name)
  
  self.level:initialize(self)
  
  self.player = (require "lib.entities.player").create(self, {
    position = levels.getOrigin(entry_object),
    velocity = player_velocity
  })
end

local function split_address (address)
  print(address)
  
  for i = #address, 0, -1 do
    if i == 0 then error('address does not contain a delimiter') end
    if address:sub(i, i) == '.' then
      return address:sub(1, i - 1), address:sub( i + 1, -1)
    end
  end
end

function environment:use_exit (exit_name, target)
  local room_name, object_name = split_address(target)
  self:set_level(room_name, object_name)
end


return environment