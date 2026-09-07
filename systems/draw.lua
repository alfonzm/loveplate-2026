local system = System(
    { 'draw' },
    function (draw, e)
        assert(type(draw) == 'function')

        love.graphics.setColor(1, 1, 1, 1)

        if e.sprite then
            local sprite = e.sprite
            love.graphics.draw(
                sprite,
                e.x,
                e.y,
                e.angle,
                e.scaleX or 1,
                e.scaleY or 1,
                e.offsetX or 0,
                e.offsetY or 0
            )
        end

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
        love.graphics.setColor(1, 1, 1, 1)
    end
)

return system
