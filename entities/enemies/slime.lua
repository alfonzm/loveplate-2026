local anim8 = require "lib.anim8"

local GameObject = require "lib.alphonsus.gameObject"

local Slime = GameObject:extend()

function Slime:new(opts)
    Slime.super.new(self)
    opts = opts or {}
    self.name = "myEntity"
    self.x = opts.x or 0
    self.y = opts.y-1 or 0

    self.spritesheet = love.graphics.newImage("assets/img/slime-Sheet.png")
    local g = anim8.newGrid(16, 16, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animation = anim8.newAnimation(g('1-4', 1), 0.18)

    return self
end

function Slime:update(dt)
    self.animation:update(dt)
end

function Slime:draw()
    self.animation:draw(self.spritesheet, self.x, self.y)
end

return Slime
