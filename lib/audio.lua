local audio = {} ; audio.__index = audio

local background_track

function audio.create() 
  return setmetatable({}, audio)
end

function audio:playMusic ()
  if not background_track then
    background_track = love.audio.newSource('res/mus/new_music.mp3', 'stream')
  end
  
  if not background_track:isPlaying() then
    background_track:setLooping(true)
    background_track:play()
  end
end

return audio