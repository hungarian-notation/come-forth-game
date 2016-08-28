-- lib.levels

local vector = require "lib.vector"

--[[

=== example object ===

{
  id = 2,
  name = "tomb_spawn",
  type = "spawn",
  shape = "rectangle",
  x = 480,
  y = 160,
  width = 32,
  height = 48,
  rotation = 0,
  visible = true,
  properties = {}
}

]]


local levels = {}

levels.newLevel = require("lib.levels.level").new

function levels.getOrigin (object)
  local pos = vector(object.x, object.y)
  local size = vector(object.width, object.height)
  return vector(pos.x + size.x / 2, pos.y + size.y)
end

return levels