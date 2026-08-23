local Input = require "lib.alphonsus.input"

local director = {
    currentScene = nil
}

function director:switch(scene)
    if self.currentScene and self.currentScene.onLeave then
        self.currentScene:onLeave()
    end
    self.currentScene = scene
    self.currentScene:enter()
end

function director:update(dt)
    if Input.wasKeyPressed("r") then
        director:restartScene()
    end
    self.currentScene:update(dt)
end

function director:draw(postWorld)
    self.currentScene:draw(postWorld)
end

function director:restartScene()
    self:switch(self.currentScene)
end

function director:add(e)
    e.scene = self.currentScene
    self.currentScene:add(e)
end

return director
