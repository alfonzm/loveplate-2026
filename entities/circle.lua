local GameObject = require "lib.alphonsus.gameObject"

local Circle = GameObject:extend()

function Circle:new(x, y, size, lifetime)
    Circle.super.new(self)
    self.name = "circle"
    self.x = x
    self.y = y
    self.width = size
    self.height = size
    self.angle = 0
    self:dieIn(lifetime)
    return self
end

function Circle:draw()
    local r = self.width * 0.5
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.ellipse("fill", self.x, self.y, r, r)
end

return Circle
