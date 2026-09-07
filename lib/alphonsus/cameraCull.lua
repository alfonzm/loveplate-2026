-- a helper to check if the entity is visible on the camera viewport
-- this is used to cull entities that are offscreen and not visible to the player
-- to save on draw calls and improve performance

local cameraCull = {}

function cameraCull.isVisible(e, camera)
    -- bail early
    if not camera then return true end
    if e.drawCull == false then return true end

    local w, h = e.width, e.height
    if not w or not h then return true end

    -- parallax
    local parallax = e.cameraParallax
    if parallax == nil then parallax = 1 end

    -- scale
    local sm = e.sizeModifier or 1
    local scaleX = (e.scaleX or 1) * sm
    local scaleY = (e.scaleY or 1) * sm

    -- world to screen (same as drawWorld)
    local sx = G.width * 0.5 - camera.x * parallax + (e.x or 0)
    local sy = G.height * 0.5 - camera.y * parallax + (e.y or 0)

    -- get bounds
    local ox = (e.offsetX or w * 0.5) * scaleX
    local oy = (e.offsetY or h * 0.5) * scaleY
    local left = sx - ox
    local top = sy - oy
    local right = left + w * scaleX
    local bottom = top + h * scaleY

    -- add some minor padding for allowance so that entities don't pop in and out of view too quickly
    local pad = e.drawCullPadding or 20
    if e.glow then
        pad = math.max(pad, 48)
    end

    return right + pad >= 0 and left - pad <= G.width
        and bottom + pad >= 0 and top - pad <= G.height
end

function cameraCull.isPointVisible(x, y, camera, pad)
    if not camera then
        return true
    end

    pad = pad or 20
    local sx = G.width * 0.5 - camera.x + x
    local sy = G.height * 0.5 - camera.y + y

    return sx + pad >= 0 and sx - pad <= G.width
        and sy + pad >= 0 and sy - pad <= G.height
end

return cameraCull
