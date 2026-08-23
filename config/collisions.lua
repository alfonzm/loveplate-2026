-- Collision classes for windfield
--
-- name = collision class name
-- enter = classes that trigger an "enter" event when colliding with this class
-- exit = classes that trigger an "exit" event
-- ignores = classes this type does not collide with
--
-- Order matters: each `other` class in enter/exit must already exist.

local collisions = {
    { name = "player" },
    { name = "wall" },
}

return collisions
