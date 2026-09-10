local collisions = require "config.collisions"
local collisionWorld = require "lib.alphonsus.collisionWorld"

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

local collisionAabbContacts = System(
    { "collider" },
    function(_col, e)
        local enterClasses = getCollidableClasses(e.name)
        local exitClasses = getCollidableExitClasses(e.name)
        local shouldTrackExit = #exitClasses > 0 or e.onCollideExit

        local current = {}
        for _, class in ipairs(enterClasses) do
            local items, len = collisionWorld.queryEntityOverlaps(e.scene, e, class)
            for i = 1, len do
                local other = items[i]
                current[other] = collisionWorld.contactObject(other)
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

return collisionAabbContacts
