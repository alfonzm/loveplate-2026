local collisions = require "config.collisions"

local function getCollidableClasses(entityName)
    for _, collidable in ipairs(collisions) do
        if collidable.name == entityName then
            return collidable.enter or {}
        end
    end
    return {}
end

local function getCollidableExitClasses(entityName)
    for _, collidable in ipairs(collisions) do
        if collidable.name == entityName then
            return collidable.exit or {}
        end
    end
    return {}
end

local system = System(
    { "-physicsBody" },
    function(e)
        -- if no collider, just sync the physics body and return
        if not e.collider then
            e:syncFromPhysicsBody()
            return
        end

        local enterClasses = getCollidableClasses(e.name)
        local exitClasses = getCollidableExitClasses(e.name)
        local shouldTrackExit = #exitClasses > 0 or e.onCollideExit

        local current = {}
        for _, class in ipairs(enterClasses) do
            for _, collider in ipairs(e:getOverlappingColliders(class)) do
                current[collider.id] = e:colliderContactObject(collider)
            end
        end

        e._colliderContacts = e._colliderContacts or {}

        for id, other in pairs(current) do
            if not e._colliderContacts[id] then
                if e.onCollide then e:onCollide(other) end
            end
        end

        if shouldTrackExit then
            for id, other in pairs(e._colliderContacts) do
                if not current[id] and e.onCollideExit then
                    e:onCollideExit(other)
                end
            end
        end

        e._colliderContacts = current
    end
)

return system
