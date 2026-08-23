local Scene = require "lib.alphonsus.scene"

local Starfield = require "entities.starfield"
local Text = require "entities.text"
local UiBar = require "entities.uiBar"

local demo = Scene:extend()

function demo:enter()
    demo.super.enter(self)

    self.demoValue = 75
    self.demoMax = 100

    self:add(Starfield())

    local labelFont = Assets.pixelFontAt(Assets.fontPaths.default, Assets.fontSize.sm)
    local xMargins = 8
    local topOffset = 8
    local labelGap = 6
    local barW = 100
    local barH = 6

    self:add(Text({
        shouldUiDraw = true,
        text = "LÖVE Boilerplate",
        textAlign = "center",
        font = Assets.pixelFontAt(Assets.fontPaths.default, Assets.fontSize.md),
        x = math.floor(G.width * 0.5 + 0.5),
        y = math.floor(G.height * 0.5 - 20 + 0.5),
    }))

    local barLabelW = labelFont:getWidth("DEMO")
    self:add(Text({
        shouldUiDraw = true,
        text = "DEMO",
        font = labelFont,
        x = xMargins,
        y = topOffset,
    }))
    self:add(UiBar({
        shouldUiDraw = true,
        x = xMargins + barLabelW + labelGap,
        y = topOffset,
        width = barW,
        height = barH,
        valueFrom = function()
            return self.demoValue, self.demoMax
        end,
    }))
end

function demo:stateUpdate(dt)
    local t = love.timer.getTime()
    self.demoValue = 50 + math.sin(t) * 40
end

return demo
