--[[=============================
Variables
=============================]]--

--List of all projectiles
projectiles = {}

--[[=============================
Modules
=============================]]--


--BasicProjectile
function spawnProjectile(stats)
    local p = {}
    p.direction = stats.direction
    p.x = stats.xOffset
    p.y = stats.yOffset
    p.speed = stats.speed
    p.dead = false
    p.type = stats.type
    p.color = stats.color
    table.insert(projectiles,p)
end

--projectile sound
function projectileSound()
    
end

--[[=============================
Main
=============================]]--

--update
function projectilesUpdate(dt)
    for i=#projectiles, 1 , -1 do
        local b = projectiles[i]
        if (b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight()) or b.dead then
            table.remove(projectiles, i)
        end
    end

    for i,b in ipairs(projectiles) do
        b.x = b.x + math.cos(b.direction)*b.speed*dt
        b.y = b.y + math.sin(b.direction)*b.speed*dt
    end

end

--draw
function projectilesDraw()
    for i,b in ipairs(projectiles) do
        love.graphics.setColor(b.color)
        love.graphics.circle("fill",b.x,b.y,3)
    end
end