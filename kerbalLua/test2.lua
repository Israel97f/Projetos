package.cpath = "SDL2.dll"
require "SDL"
require "SDL.audio"
require "SDL.mixer"

-- Initialize SDL
SDL.init(SDL.INIT_AUDIO)

-- Load the audio file
local audio = SDL.mixer.loadWAV("son.wav")

-- Play the audio file
SDL.mixer.playChannel(-1, audio, 0)

-- Wait for the audio to finish playing
while SDL.mixer.playing(-1) ~= 0 do
    SDL.delay(100)
end

-- Clean up
SDL.mixer.freeChunk(audio)
SDL.quit()