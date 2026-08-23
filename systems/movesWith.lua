local System = require("lib.knife.system")

local system = System(
    { 'movesWith' },
    function (movesWith, e)
        local entity = movesWith
        e.x = entity.x
        e.y = entity.y
    end
)

return system
