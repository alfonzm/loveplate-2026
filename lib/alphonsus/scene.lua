--
-- Scene.lua
-- a game scene/room/screen
--

-- libs
local Object = require "lib.classic" -- oop
local Pixelate = require "lib.alphonsus.pixelate" -- pixelate
local shack = require "lib.shack"
-- local push = require "lib.push" -- resolution
-- local gamera = require "lib.gamera" -- camera
local wf = require "lib.windfield" -- physics
-- local flux = require "lib.flux" -- easing

-- config
local collisions = require "config.collisions"

-- camera
-- local Camera = require "alphonsus.camera"
local Input = require "lib.alphonsus.input"

-- systems
local updateSystem = require "systems.update"
local typingAnimationSystem = require "systems.typingAnimation"
local magnetSystem = require "systems.magnet"
local movableSystem = require "systems.movable"
local drawSystem = require "systems.draw"
local moveToAngleSystem = require "systems.moveToAngle"
local collisionSystem = require "systems.collision"
local hpSystem = require "systems.hp"
local movesWithSystem = require "systems.movesWith"
-- local rotatingSystem = require "systems.rotatingSystem"
local removeSystem = require "systems.remove"
local cameraFollow = require "lib.alphonsus.cameraFollow"
local glowRenderer = require "lib.alphonsus.glowRenderer"
-- local topDownMovementSystem = require "systems.topDownMovementSystem"

local Scene = Object:extend()

function Scene:new()
    self.bgColor = { 0.06, 0.06, 0.06, 1 }
    return self
end

function Scene:enter()
    self.entities = {}
    self.systems = {}

    self.physicsWorld = wf.newWorld(0, 0, false)
    self.physicsWorld:setExplicitCollisionEvents(true)

    for _, class in ipairs(collisions) do
        self.physicsWorld:addCollisionClass(class.name, {
            enter = class.enter,
            exit = class.exit,
            ignores = class.ignores,
        })
    end

    glowRenderer.init()

    shack:setDimensions(G.width, G.height)

    -- setup cam
    -- self.camera = Camera()

    -- setup gamepads
    -- local joysticks = love.joystick.getJoysticks()
    -- for i, j in ipairs(joysticks) do
    --     Input.gamepads[i] = { buttons = {} }
    --     Input.gamepadPressed[i] = {}
    -- end
end

-- Add entity to ECS and physics world
function Scene:add(e)
    if not e.scene then e.scene = self end

    table.insert(self.entities, e)

    if e.onSceneAdd then e:onSceneAdd() end

    local col = e.collider
    if col and col.x and col.y and col.w and col.h then
        e.physicsBody = self.physicsWorld:newRectangleCollider(col.x, col.y, col.w, col.h)
        e.physicsBody:setPosition(e.x, e.y)
        e.physicsBody:setAngle(e.angle)
        e.physicsBody:setCollisionClass(e.name)
        e.physicsBody:setObject(e)
        if e.physicsBodyType then
            e.physicsBody:setType(e.physicsBodyType)
        end
        -- e.physicsBody:setSensor(true)
    end
end

function Scene:update(dt)
    self.physicsWorld:update(dt)

    for i, e in ipairs(self.entities) do
        updateSystem(e, e, dt)
        typingAnimationSystem(e, e, dt)
        magnetSystem(e, e, dt)
        moveToAngleSystem(e, e, dt)
        movableSystem(e, e, dt)
        movesWithSystem(e, e)
        collisionSystem(e, e)
        hpSystem(e, e, dt)
        -- topDownMovementSystem(e, e, dt)
        -- rotatingSystem(e, e, dt)
        removeSystem(e, i, self.entities)
    end

    cameraFollow.update(self)
    shack:update(dt)

    -- self.camera:update(dt)

    if Input.wasPressed('debug') then
        G.debug = not G.debug
    end

    if Input.wasPressed('debugCollider') then
        G.debugCollider = not G.debugCollider
    end

    self:stateUpdate(dt)

    Input.clear()
end

-- basically the update function for scenes
-- override this as needed
function Scene:stateUpdate(dt)
end

function Scene:onLeave()
    cameraFollow.cleanup(self)
end

function Scene:draw(postWorld)
    love.graphics.clear(unpack(self.bgColor))
    Pixelate:start()

    -- Draw world with world-only shaders (vignette)
    if postWorld then
        postWorld(function()
            love.graphics.clear(unpack(self.bgColor))
            self:drawWorld()
        end)
    else
        self:drawWorld()
    end

    -- Draw UI without world shaders
    self:drawUI()

    Pixelate:finish()
    self:drawDebugOverlay()
end

function Scene:drawDebugOverlay()
    if G.debug then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
        love.graphics.print("Entities: " .. tostring(#self.entities), 10, 25)
    end
end

function Scene:drawWorld()
    love.graphics.push()

    for _, e in ipairs(self.entities) do
        local cam = self.camera
        if cam then
            love.graphics.push()
            local parallax = e.cameraParallax
            if parallax == nil then parallax = 1 end
            love.graphics.translate(G.width / 2 - cam.x * parallax, G.height / 2 - cam.y * parallax)
        end
        shack:apply()
        drawSystem(e, e, self.camera)
        if cam then
            love.graphics.pop()
        end
    end

    if G.debugCollider then
        love.graphics.push()
        local cam = self.camera
        if cam then
            love.graphics.translate(G.width / 2 - cam.x, G.height / 2 - cam.y)
        end
        self.physicsWorld:draw(0.5)
        love.graphics.pop()
    end

    glowRenderer.draw(self.entities, self.camera)
    love.graphics.pop()
end

function Scene:drawUI()
    for _, e in ipairs(self.entities) do
        if e.uiDraw then
            e:uiDraw()
        end
    end
    -- -- push:start()
    -- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- local layers = _.sort(_.unique(_.map(self.entities, function(e) return e.parallax end)))

    -- for i, parallax in ipairs(layers) do
    --     -- self.camera.cam:setPosition(self.camera.pos.x * parallax, self.camera.pos.y * parallax)
    --     -- self.camera.cam:draw(function(l,t,w,h)
    --         -- shack:apply()
    --         local entitiesOfLayer = _.filter(self.entities, function(e) return e.parallax == parallax end)
    --         local sortedEntities = _.sort(entitiesOfLayer, function(a,b) return a.layer < b.layer end)
    --         for _, e in ipairs(sortedEntities) do
    --             -- drawSystem(e, e)
    --         end
    --     -- end)
    -- end
    -- -- push:finish()
end

-- ====================================
--              CONTROLS
-- ====================================

function Scene:keypressed(k)
    Input.onKeyPress(k)
end

function Scene:gamepadaxis(j, axis, value)
    local gamepadId, gamepadInstanceId = j:getID()
    Input.gamepads[gamepadId][axis] = value
end

function Scene:gamepadpressed(j, button)
    local gamepadId, gamepadInstanceId = j:getID()
    Input.gamepadPressed[gamepadId][button] = true
end

function Scene:gamepadreleased(j, button)
    local gamepadId, gamepadInstanceId = j:getID()
    Input.gamepads[gamepadId][button] = false
end


-- ====================================
--          HELPER FUNCTIONS
-- ====================================
function Scene:getObject(tag)
    return _.filter(self.entities, function(e)
        return e[tag] == true
    end)
end

function Scene:getNearestEntityFromSource(source, maxDistance, tag)
    -- get visible entities except source
    local filteredEntities = _.reject(self.entities, function(e)
        return source.pos.x == e.pos.x and source.pos.y == e.pos.y
    end)

    if tag then
        filteredEntities = _.filter(filteredEntities, function(e) return e.tag == tag end)
    end

    local visibleEntities = self.camera:getVisibleEntities(filteredEntities)

    if maxDistance then
        -- filter max distance
        visibleEntities = _.filter(visibleEntities, function(e) return e:distanceFrom(source) < maxDistance end)
    end

    -- sort visible entities by distance to source (ascending)
    local sortedEntities = _.sort(visibleEntities, function(a,b)
        return a:distanceFrom(source) < b:distanceFrom(source)
    end)

    return sortedEntities[1]
end

function Scene:getNearbyEntitiesFromSource(source, distance, tag)
    return _.filter(self.entities, function(e)
        return _.distance(source.pos.x, source.pos.y, e.pos.x, e.pos.y) < distance and e.tag == tag
    end)
end

return Scene
