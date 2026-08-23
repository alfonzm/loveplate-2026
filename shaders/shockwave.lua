local fromGlsl = require("shaders.fromGlsl")
local Shockwaves = require("lib.alphonsus.shockwaves")
local Shaders = require("lib.alphonsus.shaders")

return {
    effect = fromGlsl("shockwave", "shockwave.glsl", function(shader)
        local scene = Director and Director.currentScene
        local cam = scene and scene.camera
        local wave = Shockwaves.getActive()

        if not wave or not cam then
            return false
        end

        local uvX, uvY = Shaders:worldToUV(wave.x, wave.y, cam)
        shader:send("center", { uvX, uvY })
        shader:send("progress", wave.progress)
        shader:send("textureSize", { G.width, G.height })
        shader:send("time", love.timer.getTime())
    end),
}
