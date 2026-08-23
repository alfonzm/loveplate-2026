local System = require "lib.knife.system"

local function restoreIdleCaps(magnetable, movable)
    local cap = magnetable._idleMaxVel
    if cap then
        movable.maxVelocity.x = cap.x
        movable.maxVelocity.y = cap.y
        magnetable._idleMaxVel = nil
        return true
    end
    return false
end

local function endMagnetChase(magnet, movable, e)
    magnet.target = nil
    movable.acceleration.x = 0
    movable.acceleration.y = 0
    if restoreIdleCaps(magnet, movable) and e.onMagnetChaseEnded and not e.toRemove then
        e:onMagnetChaseEnded()
    end
end

local system = System(
    { "magnet", "movable", "x", "y" },
    function(magnet, movable, x, y, e, _dt)
        local p = magnet.target
        if not p or p.toRemove then
            endMagnetChase(magnet, movable, e)
            return
        end

        if e.canContinueMagnetTo and not e:canContinueMagnetTo(p) then
            endMagnetChase(magnet, movable, e)
            return
        end

        if not magnet._idleMaxVel then
            magnet._idleMaxVel = {
                x = movable.maxVelocity.x,
                y = movable.maxVelocity.y,
            }
        end

        local dx = p.x - x
        local dy = p.y - y
        local distSq = dx * dx + dy * dy
        local pickupRadius = magnet.pickupRadius
        if distSq <= pickupRadius * pickupRadius then
            if e.onMagnetTargetReached then
                e:onMagnetTargetReached(p)
            end
            endMagnetChase(magnet, movable, e)
            return
        end

        local dist = math.sqrt(distSq)
        if dist < 1e-6 then
            return
        end
        local nx, ny = dx / dist, dy / dist
        movable.acceleration.x = nx * magnet.accel
        movable.acceleration.y = ny * magnet.accel
        movable.maxVelocity.x = magnet.maxSpeed
        movable.maxVelocity.y = magnet.maxSpeed
    end
)

return system
