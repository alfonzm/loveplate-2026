local MenuList = require "lib.alphonsus.menuList"
local Text = require "entities.text"

--- Vertical menu navigation with a stack of screens (push = submenu, pop = back).
--- opts.scene: required, scene to add Text entities to.
--- opts.font: font for menu text.
local MenuStack = {}
MenuStack.__index = MenuStack

function MenuStack.new(rootLabels, opts)
    opts = opts or {}
    local scene = assert(opts.scene, "MenuStack requires opts.scene")

    local self = setmetatable({
        rootLabels = rootLabels,
        stack = {},
        _lineTexts = {},
        _scene = scene,
        _font = opts.font,
    }, MenuStack)
    self:_ensureLineTexts(#rootLabels)
    self:reset()
    return self
end

function MenuStack:_ensureLineTexts(count)
    local pool = self._lineTexts
    for i = #pool + 1, count do
        local t = Text({
            text = "",
            font = self._font,
            visible = false,
            typingAnimation = {},
        })
        pool[i] = t
        self._scene:add(t)
    end
end

--- Collapse to a single root menu.
function MenuStack:reset()
    self.stack = { MenuList.new(self.rootLabels, self._lineTexts) }
end

function MenuStack:push(labels)
    self:_ensureLineTexts(#labels)
    table.insert(self.stack, MenuList.new(labels, self._lineTexts))
end

--- Returns false if already at root.
function MenuStack:pop()
    if #self.stack <= 1 then
        return false
    end
    table.remove(self.stack)
    local top = self.stack[#self.stack]
    if top then
        top:reset()
    end
    return true
end

function MenuStack:depth()
    return #self.stack
end

function MenuStack:update()
    local top = self.stack[#self.stack]
    if not top then
        return nil
    end
    return top:update()
end

function MenuStack:layout(font, anchorX, topY, lineGap)
    local top = self.stack[#self.stack]
    if top then
        top:layout(font, anchorX, topY, lineGap)
    end
end

function MenuStack:setVisible(vis)
    for _, t in ipairs(self._lineTexts) do
        t.visible = vis
    end
end

return MenuStack
