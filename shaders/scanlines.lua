local moonshine = require("lib.moonshine")

return {
    effect = moonshine.effects.scanlines,
    settings = {
        width = 4,
        thickness = 2,
        phase = 0,
        opacity = 0.005,
        color = { 255, 255, 255 },
    },
}
