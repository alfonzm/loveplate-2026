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
    if Input.isDown("up") then
        self.y = self.y - 60 * dt
    elseif Input.isDown("down") then
        self.y = self.y + 60 * dt
    end
    if Input.isDown("left") then
        self.x = self.x - 60 * dt
    elseif Input.isDown("right") then
        self.x = self.x + 60 * dt
    end
end

function Link:draw()
end

return Link
