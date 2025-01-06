function love.load()

    require('projectiles')

    player = {}
    player.width = 30
    player.height = 10
    player.x = 50
    player.y = love.graphics.getHeight() - player.height
    player.speed = 100
    player.cd = 1
    player.cdTimer = 0
    

end

function love.update(dt)

    local displacement = 0
    if love.keyboard.isDown('a') then
        displacement = displacement - 1
    end
    if love.keyboard.isDown('d') then
        displacement =  displacement + 1
    end
    if love.keyboard.isDown('space') and player.cdTimer <= 0 then
        player.cdTimer = player.cd
        spawnProjectile({direction = -math.pi/2, xOffset = player.x, yOffset = player.y - player.height/2, speed = 200, type = 'player', color = {1,1,1,1}})
    end

    player.x = player.x + player.speed*displacement*dt  

    
    projectilesUpdate(dt)
    player.cdTimer = player.cdTimer - 1*dt
end

function love.draw()
    
    love.graphics.rectangle('fill', player.x - player.width/2 , player.y - player.height/2 , player.width, player.height)
    love.graphics.rectangle('fill', player.x - player.width/8 , player.y - player.height , player.width/4, player.height)
    projectilesDraw()

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end