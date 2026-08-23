local Input = require "lib.alphonsus.input"

local MenuList = {}
MenuList.__index = MenuList

function MenuList.new(labels, lineTexts)
    local self = setmetatable({
        labels = labels,
        selectedIndex = 1,
        _lineTexts = lineTexts,
    }, MenuList)
    self:_syncLineEntitiesFromLabels()
    return self
end

function MenuList:_startTypingLine(lineIndex)
    local pool = self._lineTexts
    local ent = pool[lineIndex]
    if not ent then
        return
    end
    local ta = ent.typingAnimation
    if not ta then
        return
    end

    local menuList = self
    local nextIndex = lineIndex + 1
    ta.onComplete = function()
        if nextIndex <= #menuList.labels then
            menuList:_startTypingLine(nextIndex)
        end
    end
    ent:startTyping()
end

function MenuList:_syncLineEntitiesFromLabels()
    local pool = self._lineTexts
    for i = 1, #pool do
        local ent = pool[i]
        if i > #self.labels then
            ent.visible = false
            local ta = ent.typingAnimation
            if ta then
                ta.active = false
                ta.onComplete = nil
            end
        else
            ent.visible = true
            local ta = assert(ent.typingAnimation, "menu line Text needs typingAnimation")
            local label = self.labels[i]
            ta.fullText = label
            ta.rewinding = false
            ta.active = false
            ta.charIndex = 0
            ta.accum = 0
            ta.onComplete = nil
            ent.text = ""
        end
    end
    if #self.labels > 0 then
        self:_startTypingLine(1)
    end
end

function MenuList:reset()
    self.selectedIndex = 1
    self:_syncLineEntitiesFromLabels()
end

function MenuList:moveUp()
    if self.selectedIndex > 1 then
        self.selectedIndex = self.selectedIndex - 1
    end
end

function MenuList:moveDown()
    if self.selectedIndex < #self.labels then
        self.selectedIndex = self.selectedIndex + 1
    end
end

function MenuList:update()
    if Input.wasPressed("menuUp") then
        self:moveUp()
    end
    if Input.wasPressed("menuDown") then
        self:moveDown()
    end
    if Input.wasPressed("menuConfirm") then
        return self.labels[self.selectedIndex]
    end
end

function MenuList:layout(font, anchorX, topY, lineGap)
    lineGap = lineGap or 2
    local lh = font:getHeight() + lineGap
    for i, _ in ipairs(self.labels) do
        local ent = self._lineTexts[i]
        ent.x = math.floor(anchorX + 0.5)
        ent.y = math.floor(topY + (i - 1) * lh + 0.5)
        ent.color[4] = (i == self.selectedIndex) and 1 or 0.5
    end
end

return MenuList
