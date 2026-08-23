local smoothTime = 1.5 -- higher = slower to catch up
local ease = "cubicout"

-- Follow target lives here only; no scene entity scans.
local followTarget = nil
local followOffsetX = 0
local followOffsetY = 0

local function clearSceneCamera(scene)
    if scene.camTween then
        scene.camTween:stop()
        scene.camTween = nil
    end
    scene.camera = nil
end

-- opts.offsetX / opts.offsetY added to target position each frame.
local function setTarget(entity, opts)
    followTarget = entity
    if opts then
        followOffsetX = opts.offsetX or 0
        followOffsetY = opts.offsetY or 0
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
end

local function update(scene)
    if not followTarget then
        clearSceneCamera(scene)
        return
    end
    local target = followTarget
    local tx = target.x + followOffsetX
    local ty = target.y + followOffsetY
    if not scene.camera then
        scene.camera = { x = tx, y = ty }
    end
    if scene.camTween then
        scene.camTween:stop()
    end
    scene.camTween = Flux.to(scene.camera, smoothTime, {
        x = tx,
        y = ty,
    }):ease(ease)
end

return {
    setTarget = setTarget,
    update = update,
    cleanup = cleanup,
}
