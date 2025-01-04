function love.load()
    math.randomseed(os.time())
    window = {}
    window.width = love.graphics.getWidth()
    window.height = love.graphics.getHeight()
    
    player = {}
    player.width = 150
    player.height = 10
    player.x = window.width/2
    player.y = window.height - 20
    player.speed = 400
    player.xOffset = player.width/2
    player.yOffset = player.height/2

    bricks = {}
    bricks.perRow = 20
    bricks.colums = 6
    bricks.width = window.width / bricks.perRow
    bricks.height = bricks.width/2
    for i = 1, bricks.colums, 1 do 
        bricks[i] = {}
        for j = 1, bricks.perRow, 1 do 
            bricks[i][j] = {
                            broken = false, 
                            color = {math.random(0,256)/256,math.random(0,256)/256,math.random(0,256)/256,1},
                            x = bricks.width*(j - 1) + bricks.width/2,
                            y = bricks.height*(i - 1) + bricks.height/2,
                            width = bricks.width,
                            height = bricks.height
                            }
        end
    end
    bricks.collisionThreshhold = math.sqrt((bricks.width/2)^2 + (bricks.height/2)^2)
    

    ball = {}
    ball.speed = 500
    ball.x = window.width/2
    ball.y = window.height/2
    ball.radius = 10
    ball.vector = math.pi * -3/8
    ball.numberofBalls = 3
    ball.vx = math.cos(ball.vector) * ball.speed
    ball.vy = math.sin(ball.vector) * ball.speed
    ball.held = false

end

function love.update(dt)
    
    local displacement = 0
    if love.keyboard.isDown('a') then
        displacement = displacement - 1
    end
    if love.keyboard.isDown('d') then
        displacement = displacement + 1
    end
    if love.keyboard.isDown('lshift') then
        displacement = displacement*2
    end
    
    player.x = player.x + displacement*player.speed*dt

    if player.x - player.width/2 < 0 then
        player.x = player.width/2
    end

    if player.x +player.width/2 > window.width then
        player.x = window.width - player.width/2 
    end

    
    
    local func = function(i,j)
        local dist = math.sqrt((ball.x - bricks[i][j].x)^2 + (ball.y - bricks[i][j].y)^2)
        if dist < bricks.collisionThreshhold then
            if intersects(ball, bricks[i][j]) then
                bricks[i][j].broken = true

                local normal = {x = 0, y = 0}
                if math.abs(ball.x - bricks[i][j].x) > math.abs(ball.y - bricks[i][j].y) then
                    normal.x = (ball.x > bricks[i][j].x) and 1 or -1
                else
                    normal.y = (ball.y > bricks[i][j].y) and 1 or -1
                end

                reflectVector(ball, normal)

            end
        end
    end
    ArrayIteration(func)

    if ball.x - ball.radius < 0 then
        ball.x = ball.radius
        ball.vx = -ball.vx
    end
    if ball.x + ball.radius > window.width then
        ball.x = window.width - ball.radius
        ball.vx = -ball.vx
    end
    if ball.y - ball.radius < 0 then
        ball.y = ball.radius
        ball.vy = -ball.vy
    end
    if ball.y + ball.radius > window.height then
        ball.numberofBalls = ball.numberofBalls - 1
        if ball.numberofBalls == 0 then
            love.event.quit()
        else
            ball.vector = math.pi * -4/8
            ball.vx = math.cos(ball.vector) * ball.speed
            ball.vy = math.sin(ball.vector) * ball.speed
            ball.held = true
        end
    end

    if intersects(ball, player) then
        local normal = {x = 0, y = 1}
        reflectVector(ball, normal)
    end

    if ball.held then
        ball.x = player.x
        ball.y = player.y - ball.radius - player.yOffset*2
    else
        ball.x = ball.x + ball.vx * dt
        ball.y = ball.y + ball.vy * dt
    end

end

function love.draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('fill', player.x - player.xOffset, player.y - player.yOffset, player.width, player.height)
    love.graphics.circle('fill', ball.x, ball.y, ball.radius)

    

    local func = function(i,j)
        love.graphics.setColor(bricks[i][j].color)
        love.graphics.rectangle('fill', bricks.width*(j - 1), bricks.height*(i - 1), bricks.width, bricks.height )
    end
    ArrayIteration(func)



    love.graphics.setColor(1,1,1,1)
    love.graphics.print('Balls: ' .. ball.numberofBalls, 10, 10)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        ball.held = not ball.held
    end
end

function ArrayIteration(x)
    for i = 1, bricks.colums, 1 do 
        for j = 1, bricks.perRow, 1 do
            if not bricks[i][j].broken then
                x(i,j)
            end
        end
    end
end

function intersects(c,s)
    cx = math.abs(c.x - s.x)
    cy = math.abs(c.y - s.y)

    if cx > (s.width/2 + c.radius) then return false end
    if cy > (s.height/2 + c.radius) then return false end

    if cx <= (s.width/2) then return true end
    if cy <= (s.height/2) then return true end

    cornerDistance_sq = (cx - s.width/2)^2 + (cy - s.height/2)^2

    return cornerDistance_sq <= (c.radius^2)
end

function reflectVector(ball, normal)
    local dotProduct = ball.vx * normal.x + ball.vy * normal.y
    ball.vx = ball.vx - 2 * dotProduct * normal.x
    ball.vy = ball.vy - 2 * dotProduct * normal.y
end