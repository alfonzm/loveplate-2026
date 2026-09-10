local System = require "lib.knife.system"

local collisionResolution = System(
    { "-physicsBody" },
    function(e)
        local col = e.collider
        if not col then return end

        if col.move then
            local dx = col.move.x or 0
            local dy = col.move.y or 0
            col.move = nil

            if dx ~= 0 or dy ~= 0 then
                e:moveWithCollisions("collidableTiles", dx, dy)
            end
        end

        -- move entity to match physics body position after collision resolution
        e:syncToPhysicsBody()
    end
)

return collisionResolution
