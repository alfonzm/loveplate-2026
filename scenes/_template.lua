-- TEMPLATE: copy to myScene.lua and rename `_renameMe` everywhere below.
local Scene = require "lib.alphonsus.scene"

local _renameMe = Scene:extend()

function _renameMe:new()
    _renameMe.super.new(self)
    -- self.bgColor = { 0.06, 0.06, 0.06, 1 }
    return self
end

function _renameMe:enter()
    _renameMe.super.enter(self)
    -- self:add(SomeEntity())
end

function _renameMe:onLeave()
    _renameMe.super.onLeave(self)
end

function _renameMe:stateUpdate(dt)
end

function _renameMe:stateDraw()
end

return _renameMe
