-- TEMPLATE: copy to mySystem.lua and rename `mySystem` everywhere below.
-- Register in lib/alphonsus/scene.lua (require + call inside Scene:update loop).
local System = require "lib.knife.system"

local _renameMe = System(
    { "myComponent" },
    function(myComponent, e, dt)
        -- myComponent is e.myComponent; e is the entity
    end
)

return _renameMe
