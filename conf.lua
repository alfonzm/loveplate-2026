G = {
  title = 'LÖVE Boilerplate',
  scale = 3,
  -- tile_size = 16,
  width = 16 * 36,
  height = 16 * 20,
  fullscreen = false,
  debug = false,
  debugCollider = false,
}

-- Playable area (hard-coded 3× logical viewport for now).
G.worldWidth = G.width * 3
G.worldHeight = G.height * 3

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
end
