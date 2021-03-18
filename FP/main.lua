require 'coordinates'
require 'styling'
require 'functions'

gameState = 'title'
gameStage = '0'
gameScore = 0

sBuffer = 0
timer = 0
hold = 0

function love.load()
    math.randomseed(os.time())
    resetBall()
    gameAudio()
end

function love.update(dt)
    if gameState == 'play' then
        if love.keyboard.isDown('right') then
            if player.x < WINDOW_WIDTH - PADDLE_WIDTH then
                player.x = player.x + PADDLE_SPEED * dt
            end
        end
        if love.keyboard.isDown('left') then
            if player.x > 0 then
                player.x = player.x - PADDLE_SPEED * dt
            end
        end
        
        ball.x = ball.x + ball.dx * dt
        if ball.x > WINDOW_WIDTH - BALL_SIZE - 2 then
            ball.dx = -ball.dx
        end
        if ball.x < 2 then
            ball.dx = -ball.dx
        end

        ball.y = ball.y + ball.dy * dt
        if ball.y >= WINDOW_HEIGHT - BALL_SIZE then
            resetBall(dt)
            love.audio.play(loss)
            playerLives = playerLives - 1
        end
        if ball.y < 26 then
            ball.dy = -ball.dy
        end

        if pCollide(player, ball) then
            love.audio.play(bonk)
            ball.dy = -ball.dy * 1.1
        end

        if gameStage == '1' then
            sCollide(s1, ball)
        elseif gameStage == '2' then
            sCollide(s2, ball)
        elseif gameStage == '3' then
            sCollide(s3, ball)
            brdr = bCollide(ball)
            if brdr == 1 then
                ball.dy = -ball.dy
            elseif brdr == 2 then
                ball.dx = -ball.dx
            end
        end
        if ball.y < -12 or ball.x > WINDOW_WIDTH + 1 or ball.x < -12 then
            resetBall(dt)
        end
    end
    if gameState == 'intro' then
        hold = wait()
        if hold == 1 then
            gameState = 'play'
            refresh()
        end
    end
    if gameScore == 5 and sBuffer == 0 then
        gameStage = '2'
        gameState = 'intro'
    end
    if gameScore == 10 and sBuffer== 0 then
        gameStage = '3'
        gameState = 'intro'
    end
    if gameScore == 6 or gameScore == 11 then
        sBuffer = 0
    end  
    if gameScore == 15 then
        gameState = 'win'
        love.audio.play(win)
    end
    if playerLives == 0 then
        gameState = 'lose'
        gameStage = '0'
    end  
end

function love.keypressed(key)
    if key == 'p' then
        if gameState == 'play' then
            gameState = 'pause'
        elseif gameState == 'pause' then
            gameState = 'play'
        end
    end
    if key == 'return' then
        if gameState == 'title' or gameState == 'win' or gameState == 'lose' then
            gameState = 'intro'
            gameStage = '1'
            playerLives = 3
            gameScore = 0
            love.audio.play(bgm)
        end
    end
    if key == 'escape' then
        if gameState == 'title' or gameState == 'pause' or gameState == 'lose' or gameState == 'win' then
            love.event.quit()
        end
    end
end

function love.draw()
    love.graphics.clear(48/255, 45/255, 52/255, 255/255)

    if gameState == 'title' then
        love.graphics.setFont(TITLE_FONT)
        love.graphics.printf('Bumper!', 0, WINDOW_HEIGHT / 6, WINDOW_WIDTH, 'center')
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Press Enter to play', 0, WINDOW_HEIGHT / 3 * 2, WINDOW_WIDTH, 'center')
        love.graphics.printf('Press Esc to quit', 0, WINDOW_HEIGHT / 3 * 2 + 48, WINDOW_WIDTH, 'center')
    end   
    if gameState == 'intro' then
        love.graphics.setFont(LARGE_FONT)
        if gameStage == '1' then
            love.graphics.printf('Stage 1', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
        elseif gameStage == '2' then
            love.graphics.printf('Stage 2', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
            sBuffer = 1
        elseif gameStage == '3' then
            love.graphics.printf('Stage 3', 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'center')
            sBuffer = 1
        end
    end
    if gameState == 'play' then
        love.graphics.rectangle('fill', player.x, player.y, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE, 6, 6)
        love.graphics.setColor(blk)
        love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, 27)
        love.graphics.setColor(wht)

        if gameScore >= 1 then
            love.graphics.polygon('fill', ts.n1.x1, ts.n1.y1, ts.n1.x2, ts.n1.y2, ts.n1.x3, ts.n1.y3)
            if gameScore >= 2 then
                love.graphics.polygon('fill', ts.n2.x1, ts.n2.y1, ts.n2.x2, ts.n2.y2, ts.n2.x3, ts.n2.y3)
                if gameScore >= 3 then
                    love.graphics.polygon('fill', ts.n3.x1, ts.n3.y1, ts.n3.x2, ts.n3.y2, ts.n3.x3, ts.n3.y3)
                    if gameScore >= 4 then
                        love.graphics.polygon('fill', ts.n4.x1, ts.n4.y1, ts.n4.x2, ts.n4.y2, ts.n4.x3, ts.n4.y3)
                        if gameScore >= 5 then
                            love.graphics.polygon('fill', ts.n5.x1, ts.n5.y1, ts.n5.x2, ts.n5.y2, ts.n5.x3, ts.n5.y3)
                            if gameScore >= 6 then
                                love.graphics.polygon('fill', ts.n6.x1, ts.n6.y1, ts.n6.x2, ts.n6.y2, ts.n6.x3, ts.n6.y3)
                                if gameScore >= 7 then
                                    love.graphics.polygon('fill', ts.n7.x1, ts.n7.y1, ts.n7.x2, ts.n7.y2, ts.n7.x3, ts.n7.y3)
                                    if gameScore >= 8 then
                                        love.graphics.polygon('fill', ts.n8.x1, ts.n8.y1, ts.n8.x2, ts.n8.y2, ts.n8.x3, ts.n8.y3)
                                        if gameScore >= 9 then
                                            love.graphics.polygon('fill', ts.n9.x1, ts.n9.y1, ts.n9.x2, ts.n9.y2, ts.n9.x3, ts.n9.y3)
                                            if gameScore >= 10 then
                                                love.graphics.polygon('fill', ts.n10.x1, ts.n10.y1, ts.n10.x2, ts.n10.y2, ts.n10.x3, ts.n10.y3)
                                                if gameScore >= 11 then
                                                    love.graphics.polygon('fill', ts.n11.x1, ts.n11.y1, ts.n11.x2, ts.n11.y2, ts.n11.x3, ts.n11.y3)
                                                    if gameScore >= 12 then
                                                        love.graphics.polygon('fill', ts.n12.x1, ts.n12.y1, ts.n12.x2, ts.n12.y2, ts.n12.x3, ts.n12.y3)
                                                        if gameScore >= 13 then
                                                            love.graphics.polygon('fill', ts.n13.x1, ts.n13.y1, ts.n13.x2, ts.n13.y2, ts.n13.x3, ts.n13.y3)
                                                            if gameScore >= 14 then
                                                                love.graphics.polygon('fill', ts.n14.x1, ts.n14.y1, ts.n14.x2, ts.n14.y2, ts.n14.x3, ts.n14.y3)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        love.graphics.setColor(1, 0, 0, 0.75)
        if playerLives >= 1 then
            love.graphics.polygon('fill', lc.l1.x1, lc.l1.y1, lc.l1.x2, lc.l1.y2, lc.l1.x3, lc.l1.y3, lc.l1.x4, lc.l1.y4, lc.l1.x5, lc.l1.y5, lc.l1.x6, lc.l1.y6)
            if playerLives >= 2 then
                love.graphics.polygon('fill', lc.l2.x1, lc.l2.y1, lc.l2.x2, lc.l2.y2, lc.l2.x3, lc.l2.y3, lc.l2.x4, lc.l2.y4, lc.l2.x5, lc.l2.y5, lc.l2.x6, lc.l2.y6)
                if playerLives == 3 then
                    love.graphics.polygon('fill', lc.l3.x1, lc.l3.y1, lc.l3.x2, lc.l3.y2, lc.l3.x3, lc.l3.y3, lc.l3.x4, lc.l3.y4, lc.l3.x5, lc.l3.y5, lc.l3.x6, lc.l3.y6)
                end
            end
        end
        love.graphics.setColor(wht)

        if gameStage == '1' then
            if beenHit.a == 0 then
                love.graphics.polygon('fill', s1.n1.x1, s1.n1.y1, s1.n1.x2, s1.n1.y2, s1.n1.x3, s1.n1.y3)
            end
            if beenHit.b == 0 then
                love.graphics.polygon('fill', s1.n2.x1, s1.n2.y1, s1.n2.x2, s1.n2.y2, s1.n2.x3, s1.n2.y3)
            end
            if beenHit.c == 0 then
                love.graphics.polygon('fill', s1.n3.x1, s1.n3.y1, s1.n3.x2, s1.n3.y2, s1.n3.x3, s1.n3.y3)
            end
            if beenHit.d == 0 then
                love.graphics.polygon('fill', s1.n4.x1, s1.n4.y1, s1.n4.x2, s1.n4.y2, s1.n4.x3, s1.n4.y3)
            end
            if beenHit.e == 0 then
                love.graphics.polygon('fill', s1.n5.x1, s1.n5.y1, s1.n5.x2, s1.n5.y2, s1.n5.x3, s1.n5.y3)
            end
        elseif gameStage == '2' then
            if beenHit.a == 0 then
                love.graphics.polygon('fill', s2.n1.x1, s2.n1.y1, s2.n1.x2, s2.n1.y2, s2.n1.x3, s2.n1.y3)
            end
            if beenHit.b == 0 then
                love.graphics.polygon('fill', s2.n2.x1, s2.n2.y1, s2.n2.x2, s2.n2.y2, s2.n2.x3, s2.n2.y3)
            end
            if beenHit.c == 0 then
                love.graphics.polygon('fill', s2.n3.x1, s2.n3.y1, s2.n3.x2, s2.n3.y2, s2.n3.x3, s2.n3.y3)
            end
            if beenHit.d == 0 then
                love.graphics.polygon('fill', s2.n4.x1, s2.n4.y1, s2.n4.x2, s2.n4.y2, s2.n4.x3, s2.n4.y3)
            end
            if beenHit.e == 0 then
                love.graphics.polygon('fill', s2.n5.x1, s2.n5.y1, s2.n5.x2, s2.n5.y2, s2.n5.x3, s2.n5.y3)
            end     
        elseif gameStage == '3' then
            if beenHit.a == 0 then
                love.graphics.polygon('fill', s3.n1.x1, s3.n1.y1, s3.n1.x2, s3.n1.y2, s3.n1.x3, s3.n1.y3)
            end
            if beenHit.b == 0 then
                love.graphics.polygon('fill', s3.n2.x1, s3.n2.y1, s3.n2.x2, s3.n2.y2, s3.n2.x3, s3.n2.y3)
            end
            if beenHit.c == 0 then
                love.graphics.polygon('fill', s3.n3.x1, s3.n3.y1, s3.n3.x2, s3.n3.y2, s3.n3.x3, s3.n3.y3)
            end
            if beenHit.d == 0 then
                love.graphics.polygon('fill', s3.n4.x1, s3.n4.y1, s3.n4.x2, s3.n4.y2, s3.n4.x3, s3.n4.y3)
            end
            if beenHit.e == 0 then
                love.graphics.polygon('fill', s3.n5.x1, s3.n5.y1, s3.n5.x2, s3.n5.y2, s3.n5.x3, s3.n5.y3)
            end
            
            love.graphics.rectangle('fill', bdr.b1.x, bdr.b1.y, bdr.b1.lng, bdr.b1.hi)
            love.graphics.rectangle('fill', bdr.b2.x, bdr.b2.y, bdr.b2.lng, bdr.b2.hi)
            love.graphics.rectangle('fill', bdr.b3.x, bdr.b3.y, bdr.b3.lng, bdr.b3.hi)
            love.graphics.rectangle('fill', bdr.b4.x, bdr.b4.y, bdr.b4.lng, bdr.b4.hi)
            love.graphics.rectangle('fill', bdr.b5.x, bdr.b5.y, bdr.b5.lng, bdr.b5.hi)
            love.graphics.rectangle('fill', bdr.b6.x, bdr.b6.y, bdr.b6.lng, bdr.b6.hi)
        end
    end
    if gameState == 'pause' then
        love.graphics.rectangle('fill', player.x, player.y, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE, 6, 6)
        love.graphics.setColor(blk)
        love.graphics.rectangle('fill', 0, WINDOW_HEIGHT / 3 - 8, WINDOW_WIDTH, 120)
        love.graphics.setColor(wht)
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('PAUSED', 0, WINDOW_HEIGHT / 3, WINDOW_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press P to continue or Esc to quit game', 0, WINDOW_HEIGHT / 3 + 60, WINDOW_WIDTH, 'center')
    end
    if gameState == 'lose' then
        love.graphics.setFont(TITLE_FONT)
        love.graphics.printf('GAME OVER', 0, WINDOW_HEIGHT / 4 - 24, WINDOW_WIDTH, 'center')
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Your score:', WINDOW_WIDTH / 5, WINDOW_HEIGHT / 3 + 36, WINDOW_WIDTH, 'left')
        love.graphics.printf(gameScore, WINDOW_WIDTH / 4 * 3, WINDOW_HEIGHT / 3 + 36, WINDOW_WIDTH, 'left')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf("Press Enter to play again or Esc to quit", 0, WINDOW_HEIGHT / 3 * 2, WINDOW_WIDTH, 'center')
    end
    if gameState == 'win' then
        love.graphics.setFont(TITLE_FONT)
        love.graphics.printf('CONGRATULATIONS', 0, WINDOW_HEIGHT / 4 - 24, WINDOW_WIDTH, 'center')
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Your score:', WINDOW_WIDTH / 5, WINDOW_HEIGHT / 3 + 36, WINDOW_WIDTH, 'left')
        love.graphics.printf(gameScore, WINDOW_WIDTH / 4 * 2.5, WINDOW_HEIGHT / 3 + 36, WINDOW_WIDTH, 'left')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf("Press Enter to play again or Esc to quit", 0, WINDOW_HEIGHT / 3 * 2, WINDOW_WIDTH, 'center')
    end
end