local moonshine = require("lib.moonshine")

local Shaders = {
    postWorld = nil,
    postAll = nil,
}

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
    self.postWorld = buildChain(w, h, require("shaders.postWorld"))
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
