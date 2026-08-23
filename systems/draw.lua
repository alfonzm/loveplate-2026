local system = System(
    { 'draw' },
    function (draw, e)
        assert(type(draw) == 'function')

        if e.shadow then
            local shadow = e.shadow
            local color = shadow.color
            love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
            love.graphics.push()
            love.graphics.translate(shadow.offsetX, shadow.offsetY)
            e._isShadowPass = true
            draw(e)
            e._isShadowPass = false
            love.graphics.pop()
        end

        love.graphics.setColor(1, 1, 1, 1)
        draw(e)
    end
)

return system
