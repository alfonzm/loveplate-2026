local System = require 'lib.knife.system'

local system = System(
    { 'moveToAngle', 'angle', '-movable', 'speed' },
    function(moveToAngle, angle, speed, e)
        if moveToAngle then
            e.movable.velocity.x = math.cos(angle) * speed.x
            e.movable.velocity.y = math.sin(angle) * speed.y
        end
    end
)

return system
