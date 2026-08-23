local fromGlsl = require("shaders.fromGlsl")

return {
    effect = fromGlsl("grayscale", "grayscale.glsl"),
}
