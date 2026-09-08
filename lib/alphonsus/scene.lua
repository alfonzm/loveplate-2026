--
-- Scene.lua
-- a game scene/room/screen
--

-- libs
local Object = require "lib.classic" -- oop
local Pixelate = require "lib.alphonsus.pixelate" -- pixelate
local shack = require "lib.shack"
local flux = require "lib.flux" -- easing
-- local push = require "lib.push" -- resolution
-- local gamera = require "lib.gamera" -- camera
local wf = require "lib.windfield" -- physics

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
local rotateToTargetSystem = require "systems.rotateToTarget"
local collisionSystem = require "systems.collision"
local hpSystem = require "systems.hp"
local movesWithSystem = require "systems.movesWith"
-- local rotatingSystem = require "systems.rotatingSystem"
local removeSystem = require "systems.remove"
local cameraFollow = require "lib.alphonsus.cameraFollow"
local cameraCull = require "lib.alphonsus.cameraCull"
local glowRenderer = require "lib.alphonsus.glowRenderer"
-- local topDownMovementSystem = require "systems.topDownMovementSystem"

local Scene = Object:extend()

local isWeb = love.system.getOS() == "Web"
local DARK_OVERLAY_VISIBLE = isWeb and { 26 / 255, 12 / 255, 26 / 255, 0.6 } or { 0, 0, 0, 0.5 }
local DARK_OVERLAY_HIDDEN = isWeb and { 26 / 255, 12 / 255, 26 / 255, 0 } or { 0, 0, 0, 0 }

function Scene:new()
    self.bgColor = { 0.06, 0.06, 0.06, 1 }

    -- rendered on top of world elements; useful for transitions and modal UI
    self.bgOverlayColor = { 0, 0, 0, 0 }

    return self
end

function Scene:enter()
    self.entities = {}
    self.systems = {}

    self.bgOverlayColor = { 0, 0, 0, 0 }

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
        e.physicsBody:setAngle(e.angle and e.angle or 0)
        e.physicsBody:setCollisionClass(e.name)
        e.physicsBody:setObject(e)
    end

    return e
end

function Scene:update(dt)
    self.physicsWorld:update(dt)

    for i, e in ipairs(self.entities) do
        updateSystem(e, e, dt)
        typingAnimationSystem(e, e, dt)
        magnetSystem(e, e, dt)
        rotateToTargetSystem(e, e, dt)
        moveToAngleSystem(e, e, dt)
        movableSystem(e, e, dt)
        movesWithSystem(e, e)
        collisionSystem(e, e)
        hpSystem(e, e, dt)
        -- topDownMovementSystem(e, e, dt)
        -- rotatingSystem(e, e, dt)
        removeSystem(e, i, self.entities)
    end

    cameraFollow.update(self, dt)
    shack:update(dt)

    -- self.camera:update(dt)

    if G.dev then
        if Input.wasPressed('debug') then
            G.debug = not G.debug
        end

        if Input.wasPressed('debugCollider') then
            G.debugCollider = not G.debugCollider
        end
    end

    self:stateUpdate(dt)

    Input.clear()
end

-- basically the update function for scenes
-- override this as needed
function Scene:stateUpdate(dt)
end

-- custom draw function for scenes
-- override this as needed
function Scene:stateDraw()
end

function Scene:onLeave()
    cameraFollow.cleanup(self)
end

function Scene:draw(postWorld)
    Pixelate:start()

    -- Draw world with world-only shaders (vignette)
    if postWorld then
        postWorld(function()
            love.graphics.clear(unpack(self.bgColor))
            self:drawWorld()
        end)
    else
        love.graphics.clear(unpack(self.bgColor))
        self:drawWorld()
    end

    -- Draw UI without world shaders
    self:drawUiPostShaders()

    Pixelate:finish()

    self:drawUiPostPixelate(true)
    self:drawOverlay()
    self:drawUiPostPixelate(false)

    self:drawDebugOverlay()
end

function Scene:showDarkOverlay(tween)
    flux.to(self.bgOverlayColor, tween or 0.1, DARK_OVERLAY_VISIBLE):ease("quadinout")
end

function Scene:hideDarkOverlay()
    flux.to(self.bgOverlayColor, 0.1, DARK_OVERLAY_HIDDEN):ease("quadinout")
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
        local visible = not cam or cameraCull.isVisible(e, cam)
        if visible then
            if cam then
                love.graphics.push()
                -- higher parallax = slower / more distant
                -- lower parallax = faster / closer
                local parallax = e.cameraParallax
                if parallax == nil then parallax = 1 end
                love.graphics.translate(G.width / 2 - cam.x * parallax, G.height / 2 - cam.y * parallax)
            end
            shack:apply()
            drawSystem(e, e, self.camera)
            self:stateDraw()
            if cam then
                love.graphics.pop()
            end
        end
    end

    if G.debugCollider then
        love.graphics.push()
        local cam = self.camera
        if cam then
            love.graphics.translate(G.width / 2 - cam.x, G.height / 2 - cam.y)
        end
        self.physicsWorld:draw(0.5)
        if self.drawDebugColliders then
            self:drawDebugColliders()
        end
        love.graphics.pop()
    end

    glowRenderer.draw(self.entities, self.camera)

    love.graphics.pop()
end

function Scene:drawOverlay()
    if self.bgOverlayColor[4] > 0 then
        love.graphics.setColor(self.bgOverlayColor)
        love.graphics.rectangle("fill", 0, 0, G.width * G.scale, G.height * G.scale)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Scene:drawUiPostShaders()
    for _, e in ipairs(self.entities) do
        if e.uiDraw then
            e:uiDraw()
        end
    end
end

function Scene:drawUiPostPixelate(behindOverlay)
    for _, e in ipairs(self.entities) do
        if e.shouldPixelate == false and (e.drawBehindOverlay == true) == behindOverlay then
            if e.shouldUiDraw and e.uiDraw then
                e:uiDraw(self.camera, true)
            elseif e.draw then
                e:draw(self.camera, true)
            end
        end
    end
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

function Scene:getObjectsByTag(tag)
    return _.filter(self.entities, function(e)
        return e.tag and e.tag == tag
    end)
end

function Scene:getNearestEntityFromSource(source, maxDistance, tag)
    local filteredEntities = _.reject(self.entities, function(e)
        return source.x == e.x and source.y == e.y
    end)

    if tag then
        filteredEntities = _.filter(filteredEntities, function(e) return e.tag == tag end)
    end

    local visibleEntities = _.filter(filteredEntities, function(e)
        return cameraCull.isVisible(e, self.camera)
    end)

    if maxDistance then
        visibleEntities = _.filter(visibleEntities, function(e) return e:distanceFrom(source) < maxDistance end)
    end

    local sortedEntities = _.sort(visibleEntities, function(a, b)
        return a:distanceFrom(source) < b:distanceFrom(source)
    end)

    return sortedEntities[1]
end

function Scene:getNearbyEntitiesFromSource(source, distance, tag)
    return _.filter(self.entities, function(e)
        return _.distance(source.x, source.y, e.x, e.y) < distance and e.tag == tag
    end)
end

function Scene:getVisibleEntitiesWithTag(tag, limitCount)
    local visibleEntities = {}

    for i = 1, #self.entities do
        local e = self.entities[i]
        if e.tag and e.tag:sub(1, #tag) == tag and cameraCull.isVisible(e, self.camera) then
            visibleEntities[#visibleEntities + 1] = e
            if limitCount and #visibleEntities >= limitCount then
                break
            end
        end
    end

    return visibleEntities
end

function Scene:removeAllOfTag(tag)
    for i = #self.entities, 1, -1 do
        local e = self.entities[i]
        if e.tag and e.tag == tag then
            e:remove()
        end
    end
end

return Scene
