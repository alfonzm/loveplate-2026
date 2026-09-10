local collisionWorld = require "lib.alphonsus.collisionWorld"

local collisionAabbResolution = System(
    { "collider" },
    function(col, e)
        if not col.move then return end

        local dx = col.move.x or 0
        local dy = col.move.y or 0
        col.move = nil

        if dx == 0 and dy == 0 then return end

        collisionWorld.moveEntitySepAxis(e.scene, e, dx, dy)
    end
)

return collisionAabbResolution
