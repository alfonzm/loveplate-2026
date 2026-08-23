io.stdout:setvbuf("no")

-- assets
Assets = require 'assets.assets'

-- libraries
_ = require("lib.lume")
Log = require("lib.alphonsus.log")
Vector = require("lib.vector")
System = require("lib.knife.system")
Timer = require("lib.knife.timer")
Flux = require("lib.flux")
Director = require("lib.alphonsus.director")
local Pixelate = require("lib.alphonsus.pixelate")
local Shaders = require("lib.alphonsus.shaders")
local Input = require("lib.alphonsus.input")

-- -- Enable live coding
-- local lick = require("lib.lick")
-- lick.reset = true

-- config
local controls = require("config.controls")

-- scenes
local Demo = require("scenes.demo")

-- particles
ParticleSettings = {
    smoke = require "particles.smoke",
    starfield = require "particles.starfield",
}

function love.load()
    -- Without this, RNG is the same every launch.
    local t = os.time()
    math.randomseed(t)
    love.math.setRandomSeed(t)
    for _ = 1, 3 do
        math.random()
    end

    Pixelate:init(G.width, G.height, G.scale)
    Shaders:init()
    Input.register(controls)
    Director:switch(Demo())
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        love.event.quit()
    end

    Flux.update(dt)
    Timer.update(dt)
    Director:update(dt)
    Input.clear()
end

function love.draw()
    Shaders:draw(function()
        Director:draw(Shaders.postWorld)
    end)
end

function love.keypressed(key, scancode, isrepeat)
    if not isrepeat then
        Input.onKeyPress(key)
    end
end
