-- Steps: Register in lib/alphonsus/scene.lua
-- (require + call inside Scene:update loopas needed)
local System = require "lib.knife.system"

local system = System(
    { "myComponent" },
    function(myComponent, e, dt)
        -- myComponent is e.myComponent; e is the entity
    end
)

return system
