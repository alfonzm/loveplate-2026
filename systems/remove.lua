local system = System(
    { 'toRemove' },
    function(toRemove, i, entities)
        if toRemove then
            local e = entities[i]
            if e.onRemove then e:onRemove() end

            -- remove windfield collider
            if e.physicsBody then e.physicsBody:destroy() end

            table.remove(entities, i)
        end
    end
)

return system
