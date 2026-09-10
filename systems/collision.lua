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

        local collidableClasses = getCollidableClasses(e.name)

        for _, class in pairs(collidableClasses) do
            if e.physicsBody:enter(class) then
                local otherCollisionData = e.physicsBody:getEnterCollisionData(class)
                local other = otherCollisionData.collider:getObject()

                if e.onCollide then e:onCollide(other) end
            end
        end

        for _, class in pairs(getCollidableExitClasses(e.name)) do
            if e.physicsBody:exit(class) then
                local otherCollisionData = e.physicsBody:getExitCollisionData(class)
                local other = otherCollisionData.collider:getObject()

                if e.onCollideExit then e:onCollideExit(other) end
            end
        end
    end
)

return system
