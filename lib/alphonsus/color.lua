local Color = {}

local function rgbToHsl(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s
    local l = (max + min) * 0.5

    if max == min then
        h, s = 0, 0
    else
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        else
            h = (r - g) / d + 4
        end
        h = h / 6
    end

    return h, s, l
end

local function hue2rgb(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
end

local function hslToRgb(h, s, l)
    if s == 0 then
        return l, l, l
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return hue2rgb(p, q, h + 1 / 3), hue2rgb(p, q, h), hue2rgb(p, q, h - 1 / 3)
end

--- Returns a new { r, g, b, a } with the given hue (0–1). Saturation, lightness, and alpha are preserved.
function Color.toHue(color, hue)
    local r, g, b = color[1], color[2], color[3]
    local a = color[4] or 1
    local _, s, l = rgbToHsl(r, g, b)
    hue = hue % 1
    if hue < 0 then hue = hue + 1 end
    r, g, b = hslToRgb(hue, s, l)
    return { r, g, b, a }
end

return Color
