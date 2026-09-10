local collisionWorld = require "lib.alphonsus.collisionWorld"

local system = System(
    { 'toRemove' },
    function(toRemove, i, entities)
        if toRemove then
            local e = entities[i]
            if e.onRemove then e:onRemove() end

            if e.scene then collisionWorld.removeEntity(e.scene, e) end
            if e.physicsBody then e.physicsBody:destroy() end

            table.remove(entities, i)
        end
    end
)

return system
