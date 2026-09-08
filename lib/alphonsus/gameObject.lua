local Object = require "lib.classic"

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
    local body = self.physicsBody
    if not body or not body:stay(collisionClassName) then
        return nil
    end
    local stay = body:getStayCollisionData(collisionClassName)
    if not stay or not stay[1] then
        return nil
    end
    local other = stay[1].collider:getObject()
    if other and other:is(collisionClassName) then
        return other
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

-- collider center in world space; ox/oy offset from entity x/y to collider center
function GameObject:getColliderCenter(x, y)
    x = x or self.x
    y = y or self.y
    local col = self.collider
    if not col then return x, y end
    return x + (col.ox or 0), y + (col.oy or 0)
end

function GameObject:setPositionFromColliderCenter(cx, cy)
    local col = self.collider
    if not col then
        self.x, self.y = cx, cy
        return
    end
    self.x = cx - (col.ox or 0)
    self.y = cy - (col.oy or 0)
end

-- windfield query at optional entity x/y; collisionClasses = string or list of class names
function GameObject:overlaps(collisionClasses, x, y)
    local world = self.scene and self.scene.physicsWorld
    local col = self.collider
    if not world or not col then return false end

    if type(collisionClasses) == "string" then
        collisionClasses = { collisionClasses }
    end

    local cx, cy = self:getColliderCenter(x, y)
    local r = math.max(col.w, col.h) * 0.5 * 0.98
    return #world:queryCircleArea(cx, cy, r, collisionClasses) > 0
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
