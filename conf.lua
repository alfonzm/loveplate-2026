local tileSize = 16

G = {
    -- set to false on release/build
    dev = true,

    title = 'loveplate-2026',
    scale = 4,
    tileSize = tileSize,
    width = tileSize * 10,
    height = tileSize * 9,
    fullscreen = false,
    debug = false,
    debugCollider = false,
}

-- Playable area (hard-coded 3× logical viewport for now).
G.worldWidth = G.width * 3
G.worldHeight = G.height * 3

function love.conf(t)
    t.identity = "loveplate-2026"
    t.window.title = G.title
    t.window.resizable = false
    t.window.width = G.width * G.scale
    t.window.height = G.height * G.scale
end
