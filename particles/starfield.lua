-- Star duration (s), random in [MIN, MAX]; higher = slower blink.
local MIN_LIFETIME = 4
local MAX_LIFETIME = 8

-- spawn rate must scale with map size
local function emissionRateForWorld()
    local worldArea = G.worldWidth * G.worldHeight
    local screenArea = G.width * G.height
    return math.max(5, 200 * worldArea / (screenArea * 9))
end

-- Spawn box = screen × this (>1 bleeds past edges).
local EMISSION_PAD = 1.05

-- Size curve over life: start, peak, end.
local SIZE_A, SIZE_B, SIZE_C = 0.6, 1.5, 0.4

-- White stars; only alphas vary over life (start → mid → end).
local ALPHA_START = 0.2
local ALPHA_MID = 1
local ALPHA_END = 0.4

return {
    colors = {
        1, 1, 1, ALPHA_START,
        1, 1, 1, ALPHA_MID,
        1, 1, 1, ALPHA_END,
    },
    emitterLifetime = -1,
    particleLifetime = { MIN_LIFETIME, MAX_LIFETIME },
    direction = 0,
    spread = math.pi * 2,
    linearAcceleration = { 0, 0 },
    linearDamping = { 0 },
    speed = { 0, 0 },
    rotation = { 0, 0 },
    spin = { 0, 0 },
    sizes = { SIZE_A, SIZE_B, SIZE_C },
    rate = emissionRateForWorld(),
    insertMode = "random",
    emissionArea = { "uniform", G.worldWidth * EMISSION_PAD, G.worldHeight * EMISSION_PAD, 0, false },
}
