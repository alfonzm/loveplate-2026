local GameObject = require "lib.alphonsus.gameObject"

local Text = GameObject:extend()

local BOUNCE_RETURN_DURATION = 0.15

function Text:new(opts)
    Text.super.new(self)
    opts = opts or {}
    self.name = "text"
    self.text = opts.text or ""
    self.x = opts.x or 0
    self.y = opts.y or 0
    if opts.font then
        self.font = opts.font
    else
        local path = opts.fontPath or Assets.fontPaths.default
        local size = opts.fontSize or Assets.fontSize.md
        self.font = Assets.pixelFontAt(path, size)
    end
    self.color = opts.color or { 1, 1, 1, 1 }
    self.textAlign = opts.textAlign or "left"
    self.shouldUiDraw = not not opts.shouldUiDraw
    self.shouldPixelate = opts.shouldPixelate ~= false
    self.visible = opts.visible ~= false
    self.textScale = 1
    self._bounceTween = nil

    if opts.typingAnimation then
        local ta = opts.typingAnimation
        if ta.textAlign then
            self.textAlign = ta.textAlign
        end
        -- Full string lives in opts.text; displayed string starts empty and is driven by typingAnimationSystem.
        self.typingAnimation = {
            fullText = opts.text or "",
            speed = ta.speed or 64,
            active = false,
            charIndex = 0,
            accum = 0,
            rewinding = false,
            hideWhenDone = false,
        }
        self.text = ""
    end
end

local utf8 = rawget(_G, "utf8")

local function textLen(s)
    if utf8 and utf8.len then
        local n = utf8.len(s)
        if n then
            return n
        end
    end
    return #s
end

function Text:show()
    self.visible = true
    if self.typingAnimation then
        self:startTyping()
    end
end

function Text:hide()
    local ta = self.typingAnimation
    if ta then
        ta.hideWhenDone = true
        self:resetTyping()
    else
        self.visible = false
    end
end

function Text:startTyping()
    local ta = self.typingAnimation
    if not ta then
        return
    end
    ta.rewinding = false
    ta.hideWhenDone = false
    ta.active = true
    ta.charIndex = 0
    ta.accum = 0
    self.text = ""
end

function Text:resetTyping()
    local ta = self.typingAnimation
    if not ta then
        return
    end
    ta.rewinding = true
    ta.active = true
    ta.accum = 0
    ta.charIndex = textLen(self.text)
    if ta.charIndex <= 0 then
        self.text = ""
        ta.active = false
        ta.rewinding = false
        if ta.hideWhenDone then
            self.visible = false
            ta.hideWhenDone = false
        end
    end
end

function Text:bounce(scale)
    scale = scale or 1.2
    if self._bounceTween then
        self._bounceTween:stop()
    end
    self.textScale = scale
    local ent = self
    self._bounceTween = Flux.to(self, BOUNCE_RETURN_DURATION, { textScale = 1 })
        :ease("expoout")
        :oncomplete(function()
            ent._bounceTween = nil
        end)
end

local function paint(self, drawX, drawY)
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.color)
    local text = self.text
    drawX = drawX or math.floor(self.x + 0.5)
    local y = drawY or math.floor(self.y + 0.5)
    local w = self.font:getWidth(text)
    if self.textAlign == "center" then
        drawX = math.floor(drawX - w * 0.5 + 0.5)
    end
    local scale = self.textScale
    if scale ~= 1 then
        local h = self.font:getHeight()
        local cx = drawX + w * 0.5
        local cy = y + h * 0.5
        love.graphics.translate(cx, cy)
        love.graphics.scale(scale, scale)
        love.graphics.translate(-cx, -cy)
    end
    love.graphics.print(text, drawX, y)
end

local function render(self, cam, overlay)
    if not self.visible then
        return
    end
    if overlay then
        if self.shouldPixelate then
            return
        end
    elseif not self.shouldPixelate then
        return
    end

    love.graphics.push("all")
    if overlay then
        local lx, ly = self.x, self.y
        if cam and not self.shouldUiDraw then
            lx = lx - cam.x + G.width * 0.5
            ly = ly - cam.y + G.height * 0.5
        end
        paint(
            self,
            math.floor(lx * G.scale + 0.5),
            math.floor(ly * G.scale + 0.5)
        )
    else
        paint(self)
    end
    love.graphics.pop()
end

function Text:draw(cam, overlay)
    if self.shouldUiDraw then
        return
    end
    render(self, cam, overlay)
end

function Text:uiDraw(cam, overlay)
    if not self.shouldUiDraw then
        return
    end
    render(self, cam, overlay)
end

return Text
