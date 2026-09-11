local function getShadowTranslate(e, shadow)
    local tx = shadow.offsetX
    local ty = shadow.offsetY
    if e.offsetX ~= nil or e.offsetY ~= nil then
        -- x,y is the draw pivot; shadow offsets are from that point
        return tx, ty
    end
    tx = tx + (e.offsetX or (e.width or 0) / 2)
    ty = ty + (e.offsetY or (e.height or 0) / 2)
    return tx, ty
end

local system = System(
    { 'draw' },
    function (draw, e)
        assert(type(draw) == 'function')
        if e.visible == false then
            return
        end

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

            local tx, ty = getShadowTranslate(e, shadow)
            love.graphics.translate(tx, ty)

            if shadow.width and shadow.width > 0 and shadow.height and shadow.height > 0 then
                love.graphics.ellipse("fill", e.x, e.y, shadow.width, shadow.height)
            else
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
