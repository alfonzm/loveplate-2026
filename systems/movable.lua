local system = System(
    { 'movable', 'x', 'y' },
    function (movable, x, y, e, dt)
        local mov = movable
        local vel, accel, maxVel, drag = mov.velocity, mov.acceleration, mov.maxVelocity, mov.drag

        -- Update velocity
        vel.x = vel.x + (accel.x * dt)
        vel.y = vel.y + (accel.y * dt)

        -- Update max velocity
        if maxVel.x > 0 and math.abs(vel.x) > maxVel.x then
            vel.x = maxVel.x * _.sign(vel.x)
        end
        if maxVel.y > 0 and math.abs(vel.y) > maxVel.y then
            vel.y = maxVel.y * _.sign(vel.y)
        end
        -- Symmetric caps: limit speed magnitude (diagonal was faster than each axis cap alone).
        if maxVel.x > 0 and maxVel.x == maxVel.y then
            local cap = maxVel.x
            local sp = math.sqrt(vel.x * vel.x + vel.y * vel.y)
            if sp > cap and sp > 0 then
                local k = cap / sp
                vel.x = vel.x * k
                vel.y = vel.y * k
            end
        end

        -- Update position
        if movable.isTopdown then
            local vx,vy = Vector.normalize(vel.x, vel.y)
            e.x = x + (vel.x * math.abs(vx)) * dt
            e.y = y + (vel.y * math.abs(vy)) * dt
        else
            e.x = x + (vel.x) * dt
            e.y = y + (vel.y) * dt
        end

        -- Apply drag if not accelerating
        if movable.isTopdown then
            if accel.x == 0 and drag.x > 0 then
            local sign = _.sign(vel.x)
            vel.x = vel.x - drag.x * dt * sign
            if (vel.x < 0) ~= (sign < 0) then
                vel.x = 0
            end
        end
        if accel.y == 0 and drag.y ~= 0 then
            local sign = _.sign(vel.y)
            vel.y = vel.y - drag.y * dt * sign
            if (vel.y < 0) ~= (sign < 0) then
                vel.y = 0
            end
        end
        else
            -- Velocity-aligned drag (no thrust); works for coasting in any direction.
            if accel.x == 0 and accel.y == 0 then
                local d = math.max(drag.x, drag.y)
                if d > 0 then
                    local sp = math.sqrt(vel.x * vel.x + vel.y * vel.y)
                    if sp > 0 then
                        local drop = math.min(d * dt, sp)
                        vel.x = vel.x - (vel.x / sp) * drop
                        vel.y = vel.y - (vel.y / sp) * drop
                    end
                end
            end
        end

        -- Update angularVelocity
        if mov.angularVelocity and mov.angularAcceleration then
            mov.angularVelocity = mov.angularVelocity + (mov.angularAcceleration * dt)
        end

        -- Update angle using angularVelocity
        if e.angle then
            e.angle = e.angle + mov.angularVelocity * dt
        end

        -- Apply angular drag if not accelerating
        if mov.angularAcceleration == 0 and mov.angularDrag > 0 then
            local sign = _.sign(mov.angularVelocity)
            mov.angularVelocity = mov.angularVelocity - mov.angularDrag * dt * sign
            if (mov.angularVelocity < 0) ~= (sign < 0) then
                mov.angularVelocity = 0
            end
        end
    end
)

return system
