local Scene = require "lib.alphonsus.scene"
local Tilemap = require "entities.tilemap"
local Link = require "entities.link"
local Slime = require "entities.enemies.slime"
local cameraFollow = require "lib.alphonsus.cameraFollow"

local tilemap = Scene:extend()

function tilemap:enter()
    tilemap.super.enter(self)

    -- add first so it draws behind gameplay entities
    self:add(Tilemap("assets/tilemaps/main.lua"))
    local link = self:add(Link({ x = 16 + 8, y = 16 + 8 }))

    cameraFollow.setTarget(link, {smoothTime = 0})

    -- slime
    self:add(Slime({ x = 16 * 5, y = 16 * 5 }))
end

return tilemap
