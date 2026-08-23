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
    local w = math.max(self.width * scale, MIN_COLLIDER)
    local h = math.max(self.height * scale, MIN_COLLIDER)
    self.collider = {
        x = self.x,
        y = self.y,
        w = w,
        h = h,
        ox = w / 2,
        oy = h / 2
    }
end

function GameObject:addBasicMovable()
    self.movable = {
        velocity = { x = 0, y = 0 },
        acceleration = { x = 0, y = 0 },
        drag = { x = 0, y = 0 },
        maxVelocity = { x = 0, y = 0 },
        angularVelocity = 0,
        angularAcceleration = 0,
        angularDrag = 0,
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
