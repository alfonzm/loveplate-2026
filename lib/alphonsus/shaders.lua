local moonshine = require("lib.moonshine")

local Shaders = {
    postWorld = nil,
    postAll = nil,
}

function Shaders:worldToUV(wx, wy, cam)
    if cam then
        return (wx - cam.x + G.width * 0.5) / G.width,
            (wy - cam.y + G.height * 0.5) / G.height
    end
    return wx / G.width, wy / G.height
end

local function buildChain(w, h, entries)
    if not entries or #entries == 0 then
        return nil
    end

    local chain = moonshine(w, h, entries[1].effect)
    for i = 2, #entries do
        chain = chain.chain(entries[i].effect)
    end

    for _, entry in ipairs(entries) do
        if entry.settings then
            local name = entry.effect().name
            for k, v in pairs(entry.settings) do
                chain[name][k] = v
            end
        end
    end

    return chain
end

function Shaders:init()
    local w, h = love.graphics.getDimensions()
    self.postWorld = buildChain(G.width, G.height, require("shaders.postWorld"))
    self.postAll = buildChain(w, h, require("shaders.postAll"))
end

function Shaders:draw(fn)
    if self.postAll then
        self.postAll(fn)
    else
        fn()
    end
end

return Shaders
