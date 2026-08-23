local system = System(
    { '-hp' },
    function (e)
        if e.hp <= 0 then
            e:die()
        end
    end
)

return system
