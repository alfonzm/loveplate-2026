local fromGlsl = require("shaders.fromGlsl")

return {
    effect = fromGlsl("gameboy", "gameboy.glsl", function(shader)
        shader:send("palette",
            {0.118, 0.286, 0.349}, -- #1e4959
            {0.231, 0.631, 0.333}, -- #3ba155
            {0.627, 0.780, 0.435}, -- #a0c76f
            {0.922, 0.878, 0.698}  -- #ebe0b2
        )
    end),
}
