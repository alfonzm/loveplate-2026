local GameObject = require "lib.alphonsus.gameObject"

local Input = require "lib.alphonsus.input"

local Link = GameObject:extend()

function Link:new(opts)
    Link.super.new(self)
    opts = opts or {}
    self.name = "player"
    self.x = opts.x or 0
    self.y = opts.y or 0

    self.sprite = love.graphics.newImage("assets/img/link.png")
    self.offsetX = self.sprite:getWidth() / 2
    self.offsetY = self.sprite:getHeight() / 2

    self:addBasicCollider(1)
    self.collider.w = 8
    self.collider.h = 8
    self.collider.oy = 4

    self:addBasicMovable()
    self.movable.maxVelocity.x = 60
    self.movable.maxVelocity.y = 60

    return self
end

function Link:update(_dt)
    local speed = 60
    local vel = self.movable.velocity
    vel.x = 0
    vel.y = 0

    if Input.isDown("up") then
        vel.y = -speed
    elseif Input.isDown("down") then
        vel.y = speed
    end
    if Input.isDown("left") then
        vel.x = -speed
    elseif Input.isDown("right") then
        vel.x = speed
    end
end

function Link:draw()
end

function Link:onCollide(e)
    print(e.name)
end

return Link
