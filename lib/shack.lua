-- shack.lua v0.1 (https://github.com/Ulydev/shack)
-- Copyright (c) 2015 Ulysse Ramage — MIT (see upstream for full license text)

local shack = {
    shaking = 0,
    shakingTarget = 0,

    rotation = 0,
    rotationTarget = 0,

    scale = { x = 1, y = 1 },
    scaleTarget = { x = 1, y = 1 },

    shear = { x = 0, y = 0 },
    shearTarget = { x = 0, y = 0 },

    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
}
setmetatable(shack, shack)

local function lerp(a, b, k)
    if a == b then
        return a
    else
        if math.abs(a - b) < 0.005 then
            return b
        else
            return a * (1 - k) + b * k
        end
    end
end

function shack:setDimensions(width, height)
    self.width, self.height = width, height
    return self
end

function shack:update(dt)
    local _speed = 7

    self.shaking = lerp(self.shaking, self.shakingTarget, _speed * dt)
    self.rotation = lerp(self.rotation, self.rotationTarget, _speed * dt)

    self.scale.x = lerp(self.scale.x, self.scaleTarget.x, _speed * dt)
    self.scale.y = lerp(self.scale.y, self.scaleTarget.y, _speed * dt)

    self.shear.x = lerp(self.shear.x, self.shearTarget.x, _speed * dt)
    self.shear.y = lerp(self.shear.y, self.shearTarget.y, _speed * dt)
end

function shack:apply()
    love.graphics.translate(self.width * 0.5, self.height * 0.5)
    love.graphics.rotate((math.random() - 0.5) * self.rotation)
    love.graphics.scale(self.scale.x, self.scale.y)
    love.graphics.translate(-self.width * 0.5, -self.height * 0.5)

    love.graphics.translate((math.random() - 0.5) * self.shaking, (math.random() - 0.5) * self.shaking)

    love.graphics.shear(self.shear.x * 0.01, self.shear.y * 0.01)

    return self
end

function shack:setShake(shaking)
    self.shaking = shaking or 0
    return self
end

function shack:setRotation(rotation)
    self.rotation = rotation or 0
    return self
end

function shack:setShear(x, y)
    self.shear = { x = x or 0, y = y or 0 }
    return self
end

function shack:setScale(x, y)
    if not y then
        local _s = x or 1
        self.scale = { x = _s, y = _s }
    else
        self.scale = { x = x or 1, y = y or 1 }
    end
    return self
end

function shack:setShakeTarget(shaking)
    self.shakingTarget = shaking or 0
    return self
end

function shack:setRotationTarget(rotation)
    self.rotationTarget = rotation or 0
    return self
end

function shack:setScaleTarget(x, y)
    if not y then
        local _s = x or 1
        self.scaleTarget = { x = _s, y = _s }
    else
        self.scaleTarget = { x = x or 1, y = y or 1 }
    end
    return self
end

function shack:setShearTarget(x, y)
    self.shearTarget = { x = x or 0, y = y or 0 }
    return self
end

function shack:getShake()
    return self.shaking
end

function shack:getShakeTarget()
    return self.shakingTarget
end

function shack:getRotation()
    return self.rotation
end

function shack:getRotationTarget()
    return self.rotationTarget
end

function shack:getScale()
    return self.scale.x, self.scale.y
end

function shack:getScaleTarget()
    return self.scaleTarget.x, self.scaleTarget.y
end

function shack:getShear()
    return self.shear.x, self.shear.y
end

function shack:getShearTarget()
    return self.shearTarget.x, self.shearTarget.y
end

function shack:shake(...)
    return self:setShake(...)
end

function shack:rotate(...)
    return self:setRotation(...)
end

function shack:zoom(...)
    return self:setScale(...)
end

function shack:tilt(...)
    return self:setShear(...)
end

return shack
