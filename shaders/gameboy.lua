local fromGlsl = require("shaders.fromGlsl")
local palettes = require("config.palettes")

return {
    effect = fromGlsl("gameboy", "gameboy.glsl", function(shader)
        local palette = Color.paletteFromHexes(palettes[1])
        assert(#palette == 4, "Gameboy palettes must have exactly 4 colors")
        shader:send("palette", palette[1], palette[2], palette[3], palette[4])
    end),
}
