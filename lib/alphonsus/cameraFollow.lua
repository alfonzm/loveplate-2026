-- Usage:
--   cameraFollow.setTarget(entity, {
--     offsetX = 0,               -- added to target.x each frame
--     offsetY = 0,               -- added to target.y each frame
--     smoothTime = 0.35,         -- higher = slower camera catch-up
--     lookAheadSmoothTime = 0.5, -- higher = slower look-ahead catch-up
--     velocityLookAhead = 0.5,   -- px offset per unit of velocity
--     maxLookAhead = nil,        -- cap look-ahead; nil = ~20% of screen width
--   })

local smoothTime = 0 -- higher = slower camera catch-up
local lookAheadSmoothTime = 0 -- higher = slower offset catch-up
local velocityLookAhead = 0 -- px offset per unit of velocity
local maxLookAhead = nil -- defaults to ~20% of screen width in update

-- Follow target lives here only; no scene entity scans.
local followTarget = nil
local followOffsetX = 0
local followOffsetY = 0
local lookAheadX = 0
local lookAheadY = 0

local function smoothToward(current, target, time, dt)
    if time <= 0 then
        return target
    end
    local t = 1 - math.exp(-dt / time)
    return current + (target - current) * t
end

local function getVelocityLookAheadOffset(target)
    if not target.movable or not target.movable.velocity then
        return 0, 0
    end

    local vx = target.movable.velocity.x
    local vy = target.movable.velocity.y
    local offsetX = vx * velocityLookAhead
    local offsetY = vy * velocityLookAhead

    local maxOffset = maxLookAhead or (G and G.width * 0.2 or 100)
    local mag = math.sqrt(offsetX * offsetX + offsetY * offsetY)
    if mag > maxOffset then
        local scale = maxOffset / mag
        offsetX = offsetX * scale
        offsetY = offsetY * scale
    end

    return offsetX, offsetY
end

local function clearSceneCamera(scene)
    scene.camera = nil
end

-- opts.offsetX / opts.offsetY added to target position each frame.
-- opts.velocityLookAhead / opts.maxLookAhead shift camera toward movement direction.
local function setTarget(entity, opts)
    if entity ~= followTarget then
        lookAheadX = 0
        lookAheadY = 0
    end
    followTarget = entity
    if opts then
        followOffsetX = opts.offsetX or 0
        followOffsetY = opts.offsetY or 0
        smoothTime = opts.smoothTime or smoothTime
        lookAheadSmoothTime = opts.lookAheadSmoothTime or lookAheadSmoothTime
        if opts.velocityLookAhead ~= nil then
            velocityLookAhead = opts.velocityLookAhead
        end
        if opts.maxLookAhead ~= nil then
            maxLookAhead = opts.maxLookAhead
        end
    else
        followOffsetX = 0
        followOffsetY = 0
    end
end

local function cleanup(scene)
    clearSceneCamera(scene)
    followTarget = nil
    followOffsetX = 0
    followOffsetY = 0
    lookAheadX = 0
    lookAheadY = 0
    smoothTime = 0.35
    lookAheadSmoothTime = 0.5
    velocityLookAhead = 0.5
    maxLookAhead = nil
end

local function update(scene, dt)
    if not followTarget then
        clearSceneCamera(scene)
        return
    end

    local target = followTarget
    local desiredLookAheadX, desiredLookAheadY = getVelocityLookAheadOffset(target)
    lookAheadX = smoothToward(lookAheadX, desiredLookAheadX, lookAheadSmoothTime, dt)
    lookAheadY = smoothToward(lookAheadY, desiredLookAheadY, lookAheadSmoothTime, dt)

    local tx = target.x + followOffsetX + lookAheadX
    local ty = target.y + followOffsetY + lookAheadY

    if not scene.camera then
        scene.camera = { x = tx, y = ty }
        return
    end

    scene.camera.x = smoothToward(scene.camera.x, tx, smoothTime, dt)
    scene.camera.y = smoothToward(scene.camera.y, ty, smoothTime, dt)
end

return {
    setTarget = setTarget,
    update = update,
    cleanup = cleanup,
}
