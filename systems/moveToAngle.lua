local System = require 'lib.knife.system'


local system = System(
    { 'moveToAngle', 'angle', '-movable', 'moveToAngleSpeed' },
    function(moveToAngle, angle, moveToAngleSpeed, e)
        if moveToAngle == true then
            -- drawAngleOffset (degrees): math angle of sprite forward at angle 0.
            -- Up: -90, right: 0, down: 90, left: 180 (or -180).
            -- We assume the default sprite faces up at angle 0, so we use -90 to offset the movement angle
            local drawAngleOffset = e.drawAngleOffset or -90
            local moveAngle = angle + math.rad(drawAngleOffset)
            e.movable.velocity.x = math.cos(moveAngle) * moveToAngleSpeed.x
            e.movable.velocity.y = math.sin(moveAngle) * moveToAngleSpeed.y
        end
    end
)

return system
