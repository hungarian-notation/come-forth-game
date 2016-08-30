local lore = require "lore"

return function (triggers)
  function triggers.lore (env, object, data)
    local item = lore[data]
    
    if item then
      if not item.condition or item:condition(env) then
        env.textbox:show{
          text = item.text,
          duration = 0.2,
          style = {
            color = { 0xDD, 0xDD, 0x22 }
          }
        }
      end
    end
    
    return true
  end
end