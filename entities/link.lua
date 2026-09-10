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

    return self
end

function Link:update(dt)
    local dx, dy = 0, 0
    local speed = 60 * dt

    if Input.isDown("up") then
        dy = dy - speed
    elseif Input.isDown("down") then
        dy = dy + speed
    end
    if Input.isDown("left") then
        dx = dx - speed
    elseif Input.isDown("right") then
        dx = dx + speed
    end

    self:moveWithCollider(dx, dy)
end

function Link:draw()
end

return Link
