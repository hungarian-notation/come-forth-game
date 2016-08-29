local config          = require "config"

local textbox = {} ; textbox.__index = textbox

function textbox.create ()
  return setmetatable({}, textbox)
end
  
function textbox:show (args)
  self.text = assert(args.text, 'must provide text')
  self.duration = args.duration or 5
  self.style = args.style or {}
  self.style.color = self.style.color or { 0xFF, 0xFF, 0xFF }
  self.style.size = self.style.size or 32
end

function textbox:update (dt, env)
  if self.duration and self.duration > 0 then
    self.duration = self.duration - dt
  else
    self.text = nil
    self.duration = 0
  end
end

function textbox:draw (env)
  if self.duration and self.duration > 0 and self.text then
    if not self._active_font_size or self.style.size ~= self._active_font_size then
      self._active_font_size = self.style.size
      self._font = love.graphics.newFont(config.text_display.font, self.style.size)
    end
    
    love.graphics.setColor(unpack(self.style.color))
    love.graphics.setFont(self._font)
    love.graphics.printf(
      self.text, 
      
      (config.window_width - config.text_display.width) / 2, 
      config.text_display.y,
      
      config.text_display.width,
      self.style.align or 'center'
    )
  end
end

return textbox