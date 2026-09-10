local collisions = require "config.collisions"

local bump, wf

local collisionWorld = {}

function collisionWorld.shouldUseBump()
    return G.collisionMode == "bump"
end

local function colliderTopLeft(e)
    local col = e.collider
    local cx, cy = e:getColliderCenter()
    return cx - col.w * 0.5, cy - col.h * 0.5
end

function collisionWorld.setEntityFromBumpRect(e, left, top)
    local col = e.collider
    local cx = left + col.w * 0.5
    local cy = top + col.h * 0.5
    e.x = cx - (col.ox or 0)
    e.y = cy - (col.oy or 0)
    col.x = e.x
    col.y = e.y
end

function collisionWorld.bumpFilter(item, other)
    if item.collisionFilter then
        -- allow entity to override collision filter. the entity can
        -- manually check the other object and return resolution type:
        -- "slide" - useful for walls and solid objects
        -- "cross" - i.e. "trigger" - pass through but still get collision events
        -- "touch" - stop exactly at first contact, no slide, no pass through
        return item:collisionFilter(other)
    end
    if other.name == "collidableTiles" or other.name == "wall" then
        return "slide"
    end
    return "cross"
end

function collisionWorld.initScene(scene)
    -- initialize bump
    if collisionWorld.shouldUseBump() then
        bump = bump or require "lib.bump"
        scene.bumpWorld = bump.newWorld()
        return
    end

    -- initialize windfield
    wf = wf or require "lib.windfield"
    scene.physicsWorld = wf.newWorld(0, 0, false)
    scene.physicsWorld:setExplicitCollisionEvents(true)
    for _, class in ipairs(collisions) do
        scene.physicsWorld:addCollisionClass(class.name, {
            ignores = class.ignores,
        })
    end
end

function collisionWorld.addEntity(scene, e)
    local col = e.collider
    if not col or not col.w or not col.h then
        return
    end

    if collisionWorld.shouldUseBump() then
        bump = bump or require "lib.bump"
        local left, top = colliderTopLeft(e)
        scene.bumpWorld:add(e, left, top, col.w, col.h)
        return
    end

    if col.x and col.y then
        e.physicsBody = scene.physicsWorld:newRectangleCollider(col.x, col.y, col.w, col.h)
        local cx, cy = e:getColliderCenter()
        e.physicsBody:setPosition(cx, cy)
        e.physicsBody:setAngle(e.angle and e.angle or 0)
        e.physicsBody:setCollisionClass(e.name)
        e.physicsBody:setObject(e)
        e.physicsBody:setType("kinematic")
    end
end

function collisionWorld.addTileRect(scene, x, y, w, h, className)
    if not collisionWorld.shouldUseBump() then
        wf = wf or require "lib.windfield"
        local physicsBody = scene.physicsWorld:newRectangleCollider(x, y, w, h)
        physicsBody:setPosition(x + w * 0.5, y + h * 0.5)
        physicsBody:setCollisionClass(className or "collidableTiles")
        physicsBody:setType("static")
        return
    end

    bump = bump or require "lib.bump"
    local item = { name = className or "collidableTiles" }
    scene.bumpWorld:add(item, x, y, w, h)
end

function collisionWorld.removeEntity(scene, e)
    if collisionWorld.shouldUseBump() and scene.bumpWorld and scene.bumpWorld:hasItem(e) then
        scene.bumpWorld:remove(e)
    end
end

function collisionWorld.moveEntitySepAxis(scene, e, dx, dy)
    local world = scene.bumpWorld
    local filter = collisionWorld.bumpFilter
    local left, top = colliderTopLeft(e)

    if dx ~= 0 then
        left, top = world:move(e, left + dx, top, filter)
        collisionWorld.setEntityFromBumpRect(e, left, top)
    end

    if dy ~= 0 then
        left, top = colliderTopLeft(e)
        left, top = world:move(e, left, top + dy, filter)
        collisionWorld.setEntityFromBumpRect(e, left, top)
    end
end

local CONTACT_SKIN = 1

function collisionWorld.queryEntityOverlaps(scene, e, className, skin)
    skin = skin or CONTACT_SKIN
    local col = e.collider
    if not col then return {} end

    local cx, cy = e:getColliderCenter()
    local hw, hh = col.w * 0.5, col.h * 0.5
    local l = cx - hw - skin
    local t = cy - hh - skin
    local w = col.w + skin * 2
    local h = col.h + skin * 2

    local items, len = scene.bumpWorld:queryRect(l, t, w, h, function(item)
        if item == e then return false end
        return item.name == className
    end)

    return items, len
end

function collisionWorld.contactObject(other)
    if other.onCollide or other.onCollideExit or (other.is and other.name) then
        return other
    end
    return { name = other.name or "unknown" }
end

function collisionWorld.drawDebugBump(scene)
    if not scene.bumpWorld then return end

    love.graphics.setColor(0.2, 1, 0.45, 0.40)
    local items, len = scene.bumpWorld:getItems()
    for i = 1, len do
        local item = items[i]
        local x, y, w, h = scene.bumpWorld:getRect(item)
        love.graphics.rectangle("fill", x, y, w, h)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return collisionWorld
