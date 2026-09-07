local Scene = require "lib.alphonsus.scene"
local sti = require "lib.sti"

local tilemap = Scene:extend()

local map

function tilemap:enter()
    tilemap.super.enter(self)

    map = sti("assets/tilemaps/main.lua")
end

function tilemap:stateUpdate(dt)
    map:update(dt)
end

function tilemap:draw()
    love.graphics.setColor(1, 1, 1, 1)
    map:draw()
end

return tilemap
