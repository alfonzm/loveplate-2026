-- Glow effect on game objects
-- Just add a glow property to any entity and it will be rendered with a glow effect
--
-- Glow properties:
-- strength: blur amount. higher = more spread/diffusion
-- luma: brightness threshold (0-1). only pixels brighter than this will glow
-- If glow is set to true, defaults will be used (strength=3, luma=0.2)
local moonshine = require("lib.moonshine")

local GlowRenderer = {}

local glowEffect
local defaultStrength = 3
local defaultLuma = 0.2

function GlowRenderer.init(w, h)
    w = w or G.width
    h = h or G.height
    glowEffect = moonshine(w, h, moonshine.effects.glow)
end

local function resolveGlowParams(g)
    if type(g) == "table" then
        return g.strength or defaultStrength, g.luma or defaultLuma
    end
    return defaultStrength, defaultLuma
end

--- One moonshine pass per unique glow recipe; entities with the same strength/luma are drawn together.
function GlowRenderer.draw(entities, camera)
    if not glowEffect then return end

    local n = #entities
    local i = 1
    while i <= n do
        local e = entities[i]
        if not (e.glow and e.draw) then
            i = i + 1
        else
            local strength, luma = resolveGlowParams(e.glow)
            local batch = { e }
            local scan = i + 1
            while scan <= n do
                local e2 = entities[scan]
                if e2.glow and e2.draw then
                    local s2, l2 = resolveGlowParams(e2.glow)
                    if s2 == strength and l2 == luma then
                        batch[#batch + 1] = e2
                    else
                        break
                    end
                end
                scan = scan + 1
            end

            glowEffect.glow.strength = strength
            glowEffect.glow.min_luma = luma
            glowEffect(function()
                love.graphics.clear(0, 0, 0, 0)
                for _, be in ipairs(batch) do
                    love.graphics.push()
                    if camera then
                        local parallax = be.cameraParallax or 1
                        love.graphics.translate(G.width / 2 - camera.x * parallax, G.height / 2 - camera.y * parallax)
                    end
                    be:draw()
                    love.graphics.pop()
                end
            end)

            i = scan
        end
    end
end

return GlowRenderer
