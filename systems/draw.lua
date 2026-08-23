local system = System(
    { 'draw' },
    function (draw, e)
        assert(type(draw) == 'function')
        draw(e)
    end
)

return system
