-- TEMPLATE: copy to myScene.lua and rename `myScene` everywhere below.
local Scene = require "lib.alphonsus.scene"

local _renameMe = Scene:extend()

function _renameMe:enter()
    _renameMe.super.enter(self)
end

function _renameMe:stateUpdate(dt)
end

function _renameMe:stateDraw()
end

return _renameMe
