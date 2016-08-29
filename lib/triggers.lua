local keys = require "keybindings"

local triggers = {}

local state = {}

function triggers.need_blaster (env)
  if not env.progress.blaster then
    env.textbox:show {text = "These crates are old but tough. It's going to be difficult to break them without some sort of tool."}
    state.prompted_for_blaster = true
  end
end

function triggers.approaching_blaster (env)
  if state.prompted_for_blaster then
    env.textbox:show {text = "This might be just the thing to break those crates!"}
  else
    env.textbox:show {text = "This thing is powerful. It could blow a crate straight to hell."}
  end
end

function triggers.shoot_tutorial (env)
  if not env.progress.blaster then
    env.triggered.shoot_tutorial = false
  else 
    env.textbox:show {text = "Hit '" .. keys.shoot:upper() .. "' to fire your staff."}
  end
end

function triggers.need_better_jump (env)
  if not env.progress.high_jump then
    env.textbox:show {text = "You can't jump high enough."}
  end
end

return triggers