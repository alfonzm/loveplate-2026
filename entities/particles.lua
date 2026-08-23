local GameObject = require "lib.alphonsus.gameObject"

local Particles = GameObject:extend()

function Particles:new(x, y, particleSetting, opts)
    Particles.super.new(self)
    opts = opts or {}
    self.name = "particles"
    local tex = opts.texture or love.graphics.newImage(Assets.whiteCircle)
    self.ps = love.graphics.newParticleSystem(tex, opts.maxParticles or 100)

    self.x = x or 0
    self.y = y or 0

    if type(particleSetting) == 'string' then
        self:load(ParticleSettings[particleSetting])
    elseif type(particleSetting) == 'table' then
        self:load(particleSetting)
    end
    return self
end

function Particles:load(p)
    -- self.ps = love.graphics.newParticleSystem(self.sprite or assets.whiteCircle, 100)
    self.ps:setPosition(self.x, self.y)
    self.ps:setColors(unpack(p.colors)) -- rgba

    self.ps:setEmitterLifetime(p.emitterLifetime or -1)
    self.ps:setParticleLifetime(unpack(p.particleLifetime))
    self.ps:setEmissionRate(p.rate)
    self.ps:setDirection(p.direction)
    self.ps:setSpread(p.spread)

    self.ps:setLinearAcceleration(unpack(p.linearAcceleration)) -- x, y acceleration
    self.ps:setLinearDamping(unpack(p.linearDamping)) -- decceleration (for x and y acceleration)

    if p.speed then
        self.ps:setSpeed(unpack(p.speed))
    end

    self.ps:setRotation(unpack(p.rotation)) -- initial rotation
    self.ps:setSpin(unpack(p.spin)) -- angular velocity

    self.ps:setSizes(unpack(p.sizes)) -- initial size

    self.ps:setInsertMode(p.insertMode)

    if p.emissionArea then
        local a = p.emissionArea
        self.ps:setEmissionArea(a[1], a[2], a[3], a[4], a[5])
    end

    self.ps:stop()
end

function Particles:setColor(color)
    -- self.ps:setColors(color)
end

function Particles:update(dt)
    self.ps:update(dt)
    self.ps:setPosition(self.x, self.y)
end

function Particles:setDirection(angle)
    self.ps:setDirection(angle)
end

function Particles:draw()
    love.graphics.draw(self.ps, 0, 0, 0, 1, 1)
end

return Particles
