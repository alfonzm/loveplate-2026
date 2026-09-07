local System = require 'lib.knife.system'

local DEFAULT_DRAW_ANGLE_OFFSET = -90

local system = System(
    { 'rotateToTarget', 'angle' },
    function(rotateToTarget, angle, e)
        local target = rotateToTarget
        local offset = e.rotateToTargetOffset or { x = 0, y = 0 }
        local targetX = target.x + offset.x
        local targetY = target.y + offset.y

        local dx = targetX - e.x
        local dy = targetY - e.y

        local drawAngleOffset = e.drawAngleOffset or DEFAULT_DRAW_ANGLE_OFFSET
        e.angle = math.atan2(dy, dx) - math.rad(drawAngleOffset)
    end
)

return system
