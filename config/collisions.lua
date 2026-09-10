-- Collision class names (Windfield bodies use entity.name / this name).
--
-- enter / exit — used by systems/collision.lua for onCollide / onCollideExit
-- (any order; mutual pairs like player ↔ slime are fine).
-- ignores — passed to Windfield for fixture category/mask filtering only.

local collisions = {
    { name = "wall" },
    { name = "collidableTiles" },
    {
        name = "slime",
        enter = { "collidableTiles", "player" },
    },
    {
        name = "player",
        enter = { "collidableTiles", "slime" },
    },
}

return collisions
