local moonshine = require("lib.moonshine")

-- Boilerplate to create a moonshine effect from a GLSL file in assets/shaders/.
-- update(shader) runs each frame; return false to passthrough without the shader.
return function(name, file, update)
    return function()
        local code = love.filesystem.read("assets/shaders/" .. file)
        assert(code, "Shader file not found: assets/shaders/" .. file)
        local shader = love.graphics.newShader(code)

        local draw = function(buffer)
            local front, back = buffer()
            love.graphics.setCanvas(front)
            love.graphics.clear()

            local useShader = not update or update(shader) ~= false
            if useShader then
                love.graphics.setShader(shader)
            end

            love.graphics.draw(back)
            love.graphics.setShader()
        end

        return moonshine.Effect {
            name = name,
            shader = shader,
            draw = draw,
            setters = {},
            defaults = {},
        }
    end
end
