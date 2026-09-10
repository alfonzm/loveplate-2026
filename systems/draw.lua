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
            assert(e.shadow.offsetX and e.shadow.offsetY, "Shadow must have offsetX and offsetY")
            local shadow = e.shadow
            local color = shadow.color or { 0, 0, 0, 1 }

            -- set shadow color
            love.graphics.setColor(color[1], color[2], color[3], color[4] or 1)
            love.graphics.push()

            if shadow.width and shadow.width > 0 and shadow.height and shadow.height > 0 then
                love.graphics.translate(e.width / 2, e.height / 2 + shadow.offsetY)
                love.graphics.ellipse("fill", e.x, e.y, shadow.width, shadow.height)
            else
                love.graphics.translate(shadow.offsetX, shadow.offsetY)
                e._isShadowPass = true
                draw(e)
                e._isShadowPass = false
            end

            love.graphics.pop()
        end

        love.graphics.setColor(1, 1, 1, 1)
        draw(e)
        love.graphics.setColor(1, 1, 1, 1)
    end
)

return system
