local function pixelFont(path, size)
  -- mono hinting + dpiscale 1: grid-snapped glyphs; nearest: no smoothing when scaled
  local f = love.graphics.newFont(path, size, "mono", 1)
  f:setFilter("nearest", "nearest")
  return f
end

local fontCache = {}

local function pixelFontAt(path, size)
  local key = path .. "\0" .. tostring(size)
  local cached = fontCache[key]
  if not cached then
    cached = pixelFont(path, size)
    fontCache[key] = cached
  end
  return cached
end

local function getImagePath(filename)
  return "assets/img/" .. filename
end

local function getSoundPath(filename)
  return "assets/sounds/" .. filename
end

return {
  pixelFontAt = pixelFontAt,
  getImagePath = getImagePath,
  getSoundPath = getSoundPath,
  whiteCircle = getImagePath('white_circle.png'),
  colors = {
    white = { 1, 1, 1, 1 },
  },
  fontPaths = {
    default = "assets/fonts/04b03.ttf",
    pressStart = "assets/fonts/press_start.ttf",
  },
  fontSize = {
    sm = 8,
    md = 16,
    lg = 24,
  },
  sounds = {},
}
