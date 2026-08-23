-- Reveals `e.text` from `fullText` one unit at a time (`speed` ≈ chars/sec).
-- Counts/slices by byte — fine for ASCII; multibyte UTF-8 would need utf8.len/offset.
-- Supports onComplete callback when typing finishes (forward only).

local system = System(
    { "typingAnimation" },
    function(typingAnim, entity, dt)
        if typingAnim.rewinding then
            if not typingAnim.active then
                return
            end
            local full = typingAnim.fullText or ""
            typingAnim.accum = (typingAnim.accum or 0) + typingAnim.speed * 2 * dt
            while typingAnim.accum >= 1 and typingAnim.charIndex > 0 do
                typingAnim.accum = typingAnim.accum - 1
                typingAnim.charIndex = typingAnim.charIndex - 1
            end
            entity.text = string.sub(full, 1, typingAnim.charIndex)
            if typingAnim.charIndex <= 0 then
                entity.text = ""
                typingAnim.charIndex = 0
                typingAnim.active = false
                typingAnim.rewinding = false
                typingAnim.accum = 0
                if typingAnim.hideWhenDone then
                    entity.visible = false
                    typingAnim.hideWhenDone = false
                end
            end
            return
        end

        if not typingAnim.active then
            return
        end
        local full = typingAnim.fullText or ""
        local maxChars = #full
        if maxChars == 0 then
            entity.text = ""
            typingAnim.active = false
            typingAnim.charIndex = 0
            typingAnim.accum = 0
            local cb = typingAnim.onComplete
            if cb then
                typingAnim.onComplete = nil
                cb(entity)
            end
            return
        end

        typingAnim.accum = (typingAnim.accum or 0) + typingAnim.speed * dt
        while typingAnim.accum >= 1 and typingAnim.charIndex < maxChars do
            typingAnim.accum = typingAnim.accum - 1
            typingAnim.charIndex = typingAnim.charIndex + 1
        end

        entity.text = string.sub(full, 1, typingAnim.charIndex)

        if typingAnim.charIndex >= maxChars then
            entity.text = full
            typingAnim.active = false
            typingAnim.accum = 0
            local cb = typingAnim.onComplete
            if cb then
                typingAnim.onComplete = nil
                cb(entity)
            end
        end
    end
)

return system
