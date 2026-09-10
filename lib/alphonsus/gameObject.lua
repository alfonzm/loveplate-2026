local Object = require "lib.classic"
local Rect = require "lib.alphonsus.rect"

local GameObject = Object:extend()

local function clearDieInTimer(self)
    if self._dieInTimer then
        self._dieInTimer:remove()
        self._dieInTimer = nil
    end
end

function GameObject:new()
    self.name = "gameObject"
end

function GameObject:remove()
    clearDieInTimer(self)
    self.toRemove = true
end

function GameObject:dieIn(seconds)
    clearDieInTimer(self)
    self._dieInTimer = Timer.after(seconds, function()
        self._dieInTimer = nil
        if not self.toRemove then
            self:remove()
        end
    end)
end

-- helpers
function GameObject:is(name)
    return self.name == name
end

--- True while draw system is rendering the shadow pass. Skip setting normal draw color when true.
function GameObject:isShadowPass()
    return self._isShadowPass == true
end

function GameObject:distanceFrom(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    return math.sqrt(dx * dx + dy * dy)
end

function GameObject:getDistanceBetween(other)
    local r1 = math.max(self.width, self.height) * 0.5 * (self.sizeModifier or 1)
    local r2 = math.max(other.width, other.height) * 0.5 * (other.sizeModifier or 1)
    local dx, dy = self.x - other.x, self.y - other.y
    return math.sqrt(dx * dx + dy * dy) - r1 - r2
end

-- Random point near self: up to `offsetX` / `offsetY` px away from center
-- If `offsetY` is omitted, uses `offsetX` for both (symmetric jitter)
function GameObject:getRandomPositionAround(offsetX, offsetY)
    offsetX = offsetX or 0
    if offsetY == nil then offsetY = offsetX end
    local ox = (math.random() * 2 - 1) * offsetX
    local oy = (math.random() * 2 - 1) * offsetY
    return self.x + ox, self.y + oy
end

function GameObject:moveWith(entity)
    self.movesWith = entity
end

--- check if currently colliding with an object of the given collision class,
-- and return the first object if so
function GameObject:collidingWith(collisionClassName)
    if not self.collider then return nil end
    for _, collider in ipairs(self:getOverlappingColliders(collisionClassName)) do
        local other = collider:getObject()
        if other and other:is(collisionClassName) then
            return other
        end
    end
    return nil
end

-- collider system
-- scale is applied to width/height to allow for smaller colliders than the sprite
-- Box2D rejects near-zero area shapes; love.js aborts on that assertion.
local MIN_COLLIDER = 2

function GameObject:addBasicCollider(scale)
    scale = scale or 1

    local width = self.width or (self.sprite and self.sprite:getWidth() or G.tileSize)
    local height = self.height or (self.sprite and self.sprite:getHeight() or G.tileSize)

    local w = math.max(width * scale, MIN_COLLIDER)
    local h = math.max(height * scale, MIN_COLLIDER)

    self.collider = {
        x = self.x,
        y = self.y,
        w = w,
        h = h,
        ox = 0,
        oy = 0,
    }
end

-- use this if you want to move the entity with the collider system,
-- applying collision resolution, instead of moving the entity directly.
-- dx,dy is the amount to move the entity by this frame, in world space.
-- The collider system will attempt to move the entity by (dx, dy),
-- but if it would overlap any colliders of the given collision classes,
-- it will only move as far as possible without overlapping.
-- this is done in the collision resolution system.
function GameObject:moveWithCollider(dx, dy)
    local col = self.collider
    if col then
        col.move = { x = dx, y = dy }
    end
end

-- collider center in world space; ox/oy offset from entity x/y to collider center
function GameObject:getColliderCenter(x, y)
    x = x or self.x
    y = y or self.y
    local col = self.collider
    if not col then return x, y end
    return x + (col.ox or 0), y + (col.oy or 0)
end

-- 1px skin for contact checks, so flush tile contacts count as collisions
-- not used for movement, which uses skin 0
local CONTACT_SKIN = 1

local function _getColliderAABB(self, x, y, skin)
    skin = skin or 0
    x = x or self.x
    y = y or self.y
    local col = self.collider
    if not col then
        return x, y, x, y
    end
    local cx, cy = self:getColliderCenter(x, y)
    local hw, hh = col.w * 0.5, col.h * 0.5
    return cx - hw - skin, cy - hh - skin, cx + hw + skin, cy + hh + skin
end

local function _getColliderWorldAABB(collider)
    local points = { collider.body:getWorldPoints(collider.fixture:getShape():getPoints()) }
    local l, t, r, b = points[1], points[2], points[1], points[2]
    for i = 3, #points, 2 do
        local x, y = points[i], points[i + 1]
        if x < l then l = x end
        if x > r then r = x end
        if y < t then t = y end
        if y > b then b = y end
    end
    return l, t, r, b
end

local function _setPositionFromColliderCenter(self, cx, cy)
    local col = self.collider
    if not col then
        self.x, self.y = cx, cy
        return
    end
    self.x = cx - (col.ox or 0)
    self.y = cy - (col.oy or 0)
end

-- check if entity would overlap any colliders of the given collision classes if it were at (x, y)
local function _overlaps(self, collisionClasses, x, y)
    local world = self.scene and self.scene.physicsWorld
    local col = self.collider
    if not world or not col then return false end

    if type(collisionClasses) == "string" then
        collisionClasses = { collisionClasses }
    end

    local l1, t1, r1, b1 = _getColliderAABB(self, x, y)
    local candidates = world:queryRectangleArea(l1, t1, r1 - l1, b1 - t1, collisionClasses)

    -- check for actual AABB intersection with each candidate
    for _, collider in ipairs(candidates) do
        local l2, t2, r2, b2 = _getColliderWorldAABB(collider)
        if Rect.aabbIntersects(l1, t1, r1, b1, l2, t2, r2, b2) then
            return true
        end
    end
    return false
end

-- Overlaps at (x, y), with optional skin so flush tile contacts count (movement uses skin 0).
function GameObject:getOverlappingColliders(collisionClasses, x, y, skin)
    local world = self.scene and self.scene.physicsWorld
    local col = self.collider
    if not world or not col then return {} end

    if type(collisionClasses) == "string" then
        collisionClasses = { collisionClasses }
    end

    skin = skin or CONTACT_SKIN
    local l1, t1, r1, b1 = _getColliderAABB(self, x, y, skin)
    local candidates = world:queryRectangleArea(l1, t1, r1 - l1, b1 - t1, collisionClasses)
    local ownBody = self.physicsBody
    local hits = {}

    for _, collider in ipairs(candidates) do
        if not ownBody or collider.id ~= ownBody.id then
            local l2, t2, r2, b2 = _getColliderWorldAABB(collider)
            if Rect.aabbIntersects(l1, t1, r1, b1, l2, t2, r2, b2) then
                hits[#hits + 1] = collider
            end
        end
    end

    return hits
end

function GameObject:colliderContactObject(collider)
    local other = collider:getObject()
    if other then return other end
    return { name = collider.collision_class or "unknown" }
end

-- used for entities that move with collider movement
-- this will set the physics body position to match the entity's position
-- and reset its velocity to zero
function GameObject:syncToPhysicsBody()
    if not self.physicsBody then return end
    self.physicsBody:setLinearVelocity(0, 0)
    local cx, cy = self:getColliderCenter()
    self.physicsBody:setPosition(cx, cy)
    self.physicsBody:setAngle(self.angle and self.angle or 0)
end

function GameObject:syncFromPhysicsBody()
    if not self.physicsBody then return end
    local cx, cy = self.physicsBody:getPosition()
    _setPositionFromColliderCenter(self, cx, cy)
end

-- attempt to move the entity by (dx, dy), but only if
-- it does not overlap any colliders of the given collision classes
function GameObject:moveWithCollisions(collisionClasses, dx, dy)
    -- check for horizontal collisions
    if dx ~= 0 and not _overlaps(self, collisionClasses, self.x + dx, self.y) then
        self.x = self.x + dx
    end

    -- check for vertical collisions
    if dy ~= 0 and not _overlaps(self, collisionClasses, self.x, self.y + dy) then
        self.y = self.y + dy
    end
end

function GameObject:addBasicMovable()
    self.movable = {
        velocity = { x = 0, y = 0 },
        acceleration = { x = 0, y = 0 },
        drag = { x = 0, y = 0 },
        maxVelocity = { x = 100, y = 100 },
        angularVelocity = 0,
        angularAcceleration = 0,
        angularDrag = 0,
        rotateSpeed = 10,
    }
end

-- hp system
function GameObject:takeDamage(damage)
    self.hp = self.hp - damage
end

function GameObject:die()
    if self.onDie then
        self:onDie()
    end
    self:remove()
end

function GameObject:__tostring()
    return 'GameObject'
end

return GameObject
