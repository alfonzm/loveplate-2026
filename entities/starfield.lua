local Particles = require "entities.particles"

-- max particles must scale with world size
local function maxParticlesForWorld()
    local worldArea = G.worldWidth * G.worldHeight
    local screenArea = G.width * G.height
    return math.max(400, math.floor(5000 * worldArea / (screenArea * 9)))
end

-- Fast-forward simulation at load; use ~max star lifetime or longer so the field looks steady on frame 1.
local PREWARM_SECONDS = 10
local PREWARM_STEP = 1 / 60

local img
local function squareTexture()
    if not img then
        local id = love.image.newImageData(1, 1)
        id:setPixel(0, 0, 1, 1, 1, 1)
        img = love.graphics.newImage(id)
        img:setFilter("nearest", "nearest")
    end
    return img
end

local Starfield = Particles:extend()

function Starfield:new()
    Starfield.super.new(self, G.worldWidth * 0.5, G.worldHeight * 0.5, "starfield", {
        maxParticles = maxParticlesForWorld(),
        texture = squareTexture(),
    })
    self.name = "starfield"
    self.ps:start()
    local t = 0
    while t < PREWARM_SECONDS do
        self:update(PREWARM_STEP)
        t = t + PREWARM_STEP
    end
    return self
end

return Starfield
