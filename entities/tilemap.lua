local GameObject = require "lib.alphonsus.gameObject"
local sti = require "lib.sti"

local Tilemap = GameObject:extend()

function Tilemap:new(path)
    Tilemap.super.new(self)
    self.name = "tilemap"
    self.x = 0
    self.y = 0
    self.drawCull = false

    self.map = sti(path)

    return self
end

function Tilemap:update(dt)
    self.map:update(dt)
end

function Tilemap:draw()
    local cam = self.scene and self.scene.camera
    local tx, ty = 0, 0

    -- get offset
    if cam then
        tx = G.width * 0.5 - cam.x
        ty = G.height * 0.5 - cam.y
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- let sti handle the drawing of the map
    -- it renders in a separate canvas, so we need to draw it at the correct position
    -- by passing the offset to the draw function
    self.map:draw(tx, ty)
end

return Tilemap
