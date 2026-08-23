local Shockwaves = {
    active = nil,
    _shockwaveFlux = nil,
}

function Shockwaves.worldToUV(wx, wy, cam)
    cam = cam or { x = 0, y = 0 }
    return (wx - cam.x + G.width * 0.5) / G.width,
        (wy - cam.y + G.height * 0.5) / G.height
end

function Shockwaves.trigger(worldX, worldY, opts)
    opts = opts or {}
    local duration = opts.duration or 0.75

    local wave = {
        x = worldX,
        y = worldY,
        progress = 0,
    }

    if Shockwaves._shockwaveFlux then
        Shockwaves._shockwaveFlux:stop()
    end

    Shockwaves.active = wave
    Shockwaves._shockwaveFlux = Flux.to(wave, duration, { progress = 1 })
        :ease("quadout")
        :oncomplete(function()
            if Shockwaves.active == wave then
                Shockwaves.active = nil
            end
            Shockwaves._shockwaveFlux = nil
        end)
end

function Shockwaves.getActive()
    return Shockwaves.active
end

return Shockwaves
