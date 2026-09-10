local anim8 = require "lib.anim8"

local GameObject = require "lib.alphonsus.gameObject"

local Slime = GameObject:extend()

function Slime:new(opts)
    Slime.super.new(self)
    opts = opts or {}
    self.name = "slime"
    self.x = opts.x or 0
    self.y = (opts.y or 0) - 4

    self.spritesheet = love.graphics.newImage("assets/img/slime-Sheet.png")
    local g = anim8.newGrid(16, 16, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animation = anim8.newAnimation(g('1-4', 1), 0.18)

    self.width = 16
    self.height = 16
    self.offsetX = self.width / 2
    self.offsetY = self.height / 2

    self.shadow = {
        color = { 0, 0, 0, 0.5 },
        offsetX = 0,
        offsetY = 7,
        width = 5,
        height = 2,
    }

    self:addBasicMovable()

    self:addBasicCollider(1)
    self.collider.w = 8
    self.collider.h = 8
    self.collider.oy = 4

    -- self.movable.velocity.x = -30
    -- self.movable.velocity.y = -30

    Timer.after(1, function()
        -- "dash" movement
        -- self.movable.velocity.x = -60
        -- self.movable.velocity.y = -60
        -- self.movable.drag.x = 100
        -- self.movable.drag.y = 100
    end)

    return self
end

function Slime:update(dt)
    self.animation:update(dt)
end

function Slime:draw()
    self.animation:draw(self.spritesheet, self.x, self.y, 0, 1, 1, self.offsetX, self.offsetY)
end

function Slime:onCollide(e)
    log(e.name)
    -- self.movable.velocity.x = 30
    -- self.movable.velocity.y = 0
end

return Slime
