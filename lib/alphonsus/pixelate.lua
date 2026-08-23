local pixelate = {
    canvas = nil
}

function pixelate:init(w, h, scale)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    self.w = w
    self.h = h
    self.scale = scale

    -- Canvas for UI
    -- Remove antialiasing to preserve pixelated look when scaled up
    self.canvas = love.graphics.newCanvas(w, h, { msaa = 0 })
    self.canvas:setFilter("nearest", "nearest")
end

function pixelate:start()
    self._prevCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function pixelate:finish()
    love.graphics.setCanvas(self._prevCanvas)
    self._prevCanvas = nil
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, 0, 0, 0, self.scale, self.scale)
    love.graphics.setBlendMode("alpha")
end

return pixelate

