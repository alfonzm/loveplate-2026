-- A gameobject entity tiled maps using STI (Simple Tiled Implementation), which supports Tiled export formats.
-- This entity handles rendering of tiles and setting up collision boxes on the windfield world.

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

function Tilemap:onSceneAdd(scene)
    self:setupCollisions()
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

function Tilemap:setupCollisions()
    -- setup collisions for the map
    if not self.map.layers then
        return
    end

    -- loop through each tile layer
    for _, layer in ipairs(self.map.layers) do
        -- check if tilelayer type (and not objectgroup, imagelayer, etc)
        if layer.type == "tilelayer" then
            -- loop vertically
            for y = 1, layer.height do
                -- loop horizontally
                for x = 1, layer.width do
                    -- check if tile is collidable == true
                    local tile = layer.data[y][x]
                    if tile and tile.properties and tile.properties.collidable then
                        local tileX = (x - 1) * self.map.tilewidth
                        local tileY = (y - 1) * self.map.tileheight

                        -- if collidable, add a static collider to the windfield physics world
                        local physicsBody = self.scene.physicsWorld:newRectangleCollider(tileX, tileY, self.map.tilewidth, self.map.tileheight)
                        physicsBody:setPosition(tileX + self.map.tilewidth * 0.5, tileY + self.map.tileheight * 0.5)
                        physicsBody:setCollisionClass("collidableTiles")
                        physicsBody:setType("static") -- static colliders for tilemap
                    end
                end
            end
        end
    end
end

return Tilemap
