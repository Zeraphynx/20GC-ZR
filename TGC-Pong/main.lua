function love.load()
    window = {}
    window.width = love.graphics.getWidth()
    window.height = love.graphics.getHeight()

    player = {}
    player.x = 10
    player.y = 10
    player.width = 10
    player.height = 100
    player.speed = 300
    player.score = 0

    enemy = {}
    enemy.x = window.width - 20
    enemy.y = 10
    enemy.width = 10
    enemy.height = 100
    enemy.speed = 15
    enemy.score = 0
    enemy.padding = 3

    ball = {}
    ball.width = 10
    ball.height = 10
    ball.x = window.width/2 - ball.width/2
    ball.y = window.height/2 - ball.height/2
    ball.vector = math.pi * 2/4
    ball.speedx = 10
    ball.speedy = 5

    score = {}
    score.player = 0
    score.enemy = 0

end

function love.update(dt)
    --Player movement:WASD
    local displacement = 0
    if love.keyboard.isDown('w') then
        displacement = displacement - 1
    end
    if love.keyboard.isDown('s') then
        displacement = displacement + 1
    end

    --Player movement:Displacement
    player.y = player.y + displacement*player.speed*dt

    --Player movement:Bounds
    if (player.y + player.height)>love.graphics.getHeight() then
        player.y = love.graphics.getHeight() - player.height
    end
    if player.y < 0 then
        player.y = 0
    end


    --Enemy movement:

    displacement = 0
    --[[
    if ball.y > enemy.y + enemy.height*2 then
        displacement = 2
    elseif(ball.y > enemy.y + enemy.height) then
        displacement = 1
    elseif ball.y > enemy.y + enemy.height/2 +enemy.padding then
        displacement = 0.25
    end

    if ball.y < enemy.y - enemy.height then
        displacement = -2
    elseif ball.y < enemy.y then
        displacement = -1
    elseif ball.y < enemy.y + enemy.height/2 -enemy.padding then
            displacement = -0.25
    end
    ]]--
    displacement = ball.y - (enemy.y + enemy.height/2)


    enemy.y = enemy.y + enemy.speed*displacement*dt

    --Ball movement
    ball.x = ball.x + ball.speedx*math.sin(ball.vector)
    ball.y = ball.y + ball.speedy*math.cos(ball.vector)

    --Ball movement:Collision
    --[[
    if (ball.x <= player.x +player.width) then
        if ((ball.y >= player.y) and (ball.y <= player.y + player.height)) then
            ball.speedx = ball.speedx*-1
        end
    end
    ]]--

    if (ball.x +ball.width >= enemy.x) then 
        if ((ball.y >= enemy.y) and (ball.y <= enemy.y + enemy.height)) then
            ball.speedx = ball.speedx*-1
            ball.x = enemy.x - ball.width
        end
    end

    --Ball movement:Bounds
    if (ball.y + ball.height)>window.height then
        ball.y = love.graphics.getHeight() - ball.height
        ball.speedy = ball.speedy*-1
    end
    if ball.y < 0 then
        ball.y = 0
        ball.speedy = ball.speedy*-1
    end

    if (ball.x + ball.width)>window.width then
        ball.x = window.width/2 - ball.width/2
        ball.y = window.height/2 - ball.height/2
        ball.speedx = ball.speedx*-1
        score.player = score.player + 1
    end
    if ball.x < 0 then
        --ball.x = window.width/2 - ball.width/2
        --ball.y = window.height/2 - ball.height/2
        ball.x = 0
        score.enemy = score.enemy + 1
        ball.vector = math.pi * math.random(5,35)/40
        ball.speedx = ball.speedx*-1
    end
    
end

function love.draw()
    love.graphics.setColor(1,1,1)
    --love.graphics.rectangle('fill', player.x, player.y, player.width, player.height)
    love.graphics.rectangle('fill', enemy.x, enemy.y, enemy.width, enemy.height)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
    love.graphics.rectangle('fill', ball.x+ball.speedx*10*math.sin(ball.vector)+2.5, ball.y+ball.speedy*10*math.cos(ball.vector)+2.5, 5, 5)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end