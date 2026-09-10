local anim8 = require "lib.anim8"

local GameObject = require "lib.alphonsus.gameObject"

local Slime = GameObject:extend()

function Slime:new(opts)
    Slime.super.new(self)
    opts = opts or {}
    self.name = "slime"
    self.x = opts.x or 0
    self.y = opts.y-4 or 0

    self.spritesheet = love.graphics.newImage("assets/img/slime-Sheet.png")
    local g = anim8.newGrid(16, 16, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animation = anim8.newAnimation(g('1-4', 1), 0.18)

    self.width = 16
    self.height = 16

    self.shadow = {
        color = { 0, 0, 0, 0.5 },
        offsetX = 0,
        offsetY = 7,
        width = 5,
        height = 2,
    }

    self:addBasicMovable()

    self:addBasicCollider(1)

    Timer.after(1, function()
        self.movable.velocity.x = -60
        self.movable.velocity.y = -60
        -- self.movable.drag.x = 100
        -- self.movable.drag.y = 100
    end)

    return self
end

function Slime:update(dt)
    self.animation:update(dt)
end

function Slime:draw()
    self.animation:draw(self.spritesheet, self.x, self.y)
end

function Slime:onCollide(e)
    print('slime to ' .. e.name)
end

return Slime
