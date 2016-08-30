local tutorials = require "tutorials"

return function (triggers)
  function triggers.tutorial (env, object, data)
    local tut = tutorials[data]
    
    if tut then
      if not tut.condition or tut:condition(env) then
        
        local text
        
        if type(assert(tut.text)) == 'string' then
          text = tut.text
        elseif type(tut.text) == 'function' then
          text = tut.text(env, object, data)
        end
        
        env.textbox:show{
          text = text,
          duration = 0.2,
          style = {
            color = { 0x22, 0xAA, 0xAA }
          }
        }
      end
    end
    
    return true
  end
end