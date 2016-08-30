local keys = require "keybindings"

local tutorials = {}

tutorials.movement = {
  text = 
    "Use " .. keys.left_directional:upper() 
    .. " and " .. keys.right_directional:upper() 
    .. " to move."
}

tutorials.drop = {
  text = "Hold " .. keys.drop:upper() .. " to drop through platforms."
}

tutorials.jump = {
  text = "Use " .. keys.jump:upper() .. " to jump."
}

tutorials.staff = {
  text = "What a strange thing to find in a pyramid." .. "\n" .. "To fire the energy staff, hold " .. keys.shoot:upper()
}

return tutorials