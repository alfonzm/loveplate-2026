local GameObject = require "lib.alphonsus.gameObject"

local _RenameMe = GameObject:extend()

function _RenameMe:new(opts)
    _RenameMe.super.new(self)
    opts = opts or {}
    self.name = "myEntity"
    self.x = opts.x or 0
    self.y = opts.y or 0
    return self
end

function _RenameMe:draw()
end

return _RenameMe
