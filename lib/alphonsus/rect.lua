local Rect = {}

function Rect.aabbIntersects(l1, t1, r1, b1, l2, t2, r2, b2)
    return l1 < r2 and r1 > l2 and t1 < b2 and b1 > t2
end

return Rect
