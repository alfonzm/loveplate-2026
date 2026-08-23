-- Input action → keyboard keys (see lib/alphonsus/input.lua)

local controls = {
    ["up"] = { "w", "up" },
    ["down"] = { "s", "down" },
    ["left"] = { "a", "left" },
    ["right"] = { "d", "right" },
    ["confirm"] = { "space", "return" },
    ["menuUp"] = { "up", "w" },
    ["menuDown"] = { "down", "s" },
    ["menuConfirm"] = { "return", "space" },
    ["debug"] = { "tab" },
    ["debugCollider"] = { "`" },
}

return controls
