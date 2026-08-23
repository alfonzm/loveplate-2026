local GameObject = require "lib.alphonsus.gameObject"

local UiBar = GameObject:extend()

function UiBar:new(opts)
    UiBar.super.new(self)
    opts = opts or {}
    self.name = "uiBar"
    self.x = opts.x or 0
    self.y = opts.y or 0
    self.value = opts.value or 0
    self.maxValue = opts.maxValue or 1
    self.width = opts.width or 100
    self.height = opts.height or 8

    -- bg is transparent
    self.bgColor = opts.bgColor or { 0, 0, 0, 0 }

    -- fill color is white
    self.fillColor = opts.fillColor or { 1, 1, 1, 1 }

    -- border color is white
    self.borderColor = opts.borderColor or { 1, 1, 1, 1 }

    self.shouldUiDraw = not not opts.shouldUiDraw

    -- Optional: function() return currentValue, maxValue end (max optional; keeps prior max if omitted)
    self.valueFrom = opts.valueFrom

    -- Optional: function(bar) return {r,g,b,a} end — fill + border, after valueFrom
    self.colorFrom = opts.colorFrom
end

function UiBar:_updateValue()
    local fn = self.valueFrom
    if not fn then
        return
    end
    local v, maxV = fn()
    if v ~= nil then
        self.value = v
    end
    if maxV ~= nil then
        self.maxValue = maxV
    end
end

function UiBar:fillWidth()
    local maxV = self.maxValue
    if maxV <= 0 then
        return 0
    end
    local t = self.value / maxV
    if t < 0 then
        t = 0
    elseif t > 1 then
        t = 1
    end
    return t * self.width
end

function UiBar:draw()
    if self.shouldUiDraw then
        return
    end
end

function UiBar:uiDraw()
    if not self.shouldUiDraw then
        return
    end
    self:_updateValue()

    local fillColor = self.fillColor
    local borderColor = self.borderColor
    if self.colorFrom then
        local c = self.colorFrom(self)
        if c then
            fillColor = c
            borderColor = c
        end
    end

    local x = math.floor(self.x + 0.5)
    local y = math.floor(self.y + 0.5)
    local w = math.floor(self.width + 0.5)
    local h = math.floor(self.height + 0.5)
    local fillW = math.floor(self:fillWidth() + 0.5)

    -- draw background and fill
    love.graphics.push("all")
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(fillColor)
    if fillW > 0 then
        love.graphics.rectangle("fill", x, y, fillW, h)
    end

    -- draw border
    love.graphics.setColor(borderColor)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle("line", x + 0.5, y + 0.5, w - 1, h - 1)
    love.graphics.pop()
end

return UiBar
