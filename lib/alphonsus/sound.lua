local Timer = require("lib.knife.timer")

local Sound = {}

Sound.sources = {}
Sound._musicEndTimer = nil
Sound._musicGapTimer = nil

local isWeb = love.system.getOS() == "Web"
local sourceType = isWeb and "static" or "stream"

local function loadSource(path)
    local source = Sound.sources[path]
    if not source then
        source = love.audio.newSource(path, sourceType)
        source:setLooping(false)
        Sound.sources[path] = source
    end
    return source
end

function Sound.register(pathOrTable)
    if type(pathOrTable) == "table" then
        for _, path in pairs(pathOrTable) do
            Sound.register(path)
        end
        return
    end
    loadSource(pathOrTable)
end

function Sound.play(path, volume, pitch)
    local source = loadSource(path)
    source:setVolume(volume or 1)
    source:setPitch(pitch or 1)
    source:stop()
    love.audio.play(source)
end

function Sound.stop(path)
    local source = Sound.sources[path]
    if source then
        source:stop()
    end
end

local function clearMusicTimers()
    if Sound._musicEndTimer and Sound._musicEndTimer.remove then
        Sound._musicEndTimer:remove()
    end
    if Sound._musicGapTimer and Sound._musicGapTimer.remove then
        Sound._musicGapTimer:remove()
    end
    Sound._musicEndTimer = nil
    Sound._musicGapTimer = nil
end

-- Starts playing a playlist of music tracks in order, with a specified gap between tracks.
-- Loops the playlist indefinitely.
function Sound.startMusicPlaylist(paths, gapSeconds)
    clearMusicTimers()

    local index = 1
    local function playCurrent()
        local path = paths[index]
        Sound.play(path)
        local duration = Sound.sources[path]:getDuration()
        Sound._musicEndTimer = Timer.after(duration, function()
            Sound._musicEndTimer = nil
            Sound._musicGapTimer = Timer.after(gapSeconds, function()
                Sound._musicGapTimer = nil
                index = index % #paths + 1
                playCurrent()
            end)
        end)
    end

    playCurrent()
end

return Sound
