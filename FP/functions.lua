require 'styling'
require 'coordinates'

function resetBall(dt)
    ball.x = WINDOW_WIDTH / 2 - 12
    ball.y = WINDOW_HEIGHT - 96

    ball.dx = 100 + math.random(60)
    if math.random(2) == 1 then
        ball.dx = -ball.dx
    end
    ball.dy = 100 + math.random(60)
    ball.dy = -ball.dy
end

function pCollide(p, b)
    return not (p.x > b.x + BALL_SIZE or p.y > b.y + BALL_SIZE or b.x > p.x + PADDLE_WIDTH or b.y > p.y + PADDLE_HEIGHT)
end

function bCollide(b)
    if not (bdr.b1.x > b.x + BALL_SIZE or bdr.b1.y > b.y + BALL_SIZE or b.x > bdr.b1.x + bdr.b1.lng or b.y > bdr.b1.y + bdr.b1.hi) then
        return 1
    end
    if not (bdr.b2.x > b.x + BALL_SIZE or bdr.b2.y + 2 > b.y + BALL_SIZE or b.x > bdr.b2.x + bdr.b2.lng or b.y > bdr.b2.y + bdr.b2.hi - 2) then
        return 2
    end
    if not (bdr.b2.x > b.x + BALL_SIZE or bdr.b2.y - 1 > b.y + BALL_SIZE or b.x > bdr.b2.x + bdr.b2.lng or b.y > bdr.b2.y + 2) then
        return 1
    end
    if not (bdr.b2.x > b.x + BALL_SIZE or bdr.b2.y + bdr.b2.hi - 2 > b.y or b.x > bdr.b2.x + bdr.b2.lng or b.y > bdr.b2.y + bdr.b2.hi + 1) then
        return 1
    end
    if not (bdr.b3.x > b.x + BALL_SIZE or bdr.b3.y > b.y + BALL_SIZE or b.x > bdr.b3.x + bdr.b3.lng or b.y > bdr.b3.y + bdr.b3.hi) then
        return 1
    end
    if not (bdr.b4.x > b.x + BALL_SIZE or bdr.b4.y + 2 > b.y + BALL_SIZE or b.x > bdr.b4.x + bdr.b4.lng or b.y > bdr.b4.y + bdr.b4.hi - 2) then
        return 2
    end
    if not (bdr.b4.x > b.x + BALL_SIZE or bdr.b4.y - 1 > b.y + BALL_SIZE or b.x > bdr.b4.x + bdr.b4.lng or b.y > bdr.b4.y + 2) then
        return 1
    end
    if not (bdr.b4.x > b.x + BALL_SIZE or bdr.b4.y + bdr.b4.hi - 2 > b.y or b.x > bdr.b4.x + bdr.b4.lng or b.y > bdr.b4.y + bdr.b4.hi + 1) then
        return 1
    end
    if not (bdr.b5.x + 2 > b.x + BALL_SIZE or bdr.b5.y > b.y + BALL_SIZE or b.x > bdr.b5.x + bdr.b5.lng - 2 or b.y > bdr.b5.y + bdr.b5.hi) then
        return 1
    end
    if not (bdr.b5.x - 1 > b.x + BALL_SIZE or bdr.b5.y > b.y + BALL_SIZE or b.x > bdr.b5.x + 2 or b.y > bdr.b5.y + bdr.b5.hi) then
        return 2
    end
    if not (bdr.b5.x + bdr.b5.lng + 1 > b.x or bdr.b5.y > b.y + BALL_SIZE or b.x > bdr.b5.x + bdr.b5.lng - 2 or b.y > bdr.b5.y + bdr.b5.hi) then
        return 2
    end
    if not (bdr.b6.x + 2 > b.x + BALL_SIZE or bdr.b6.y > b.y + BALL_SIZE or b.x > bdr.b6.x + bdr.b6.lng - 2 or b.y > bdr.b6.y + bdr.b6.hi) then
        return 1
    end
    if not (bdr.b6.x - 1 > b.x + BALL_SIZE or bdr.b6.y > b.y + BALL_SIZE or b.x > bdr.b6.x + 2 or b.y > bdr.b6.y + bdr.b6.hi) then
        return 2
    end
    if not (bdr.b6.x + bdr.b6.lng + 1 > b.x or bdr.b6.y > b.y + BALL_SIZE or b.x > bdr.b6.x + bdr.b6.lng - 2 or b.y > bdr.b6.y + bdr.b6.hi) then
        return 2
    end
end

function sCollide(s, b)
    if not (s.n1.x1 > b.x + BALL_SIZE or b.x > s.n1.x2 or s.n1.y1 > b.y + BALL_SIZE or b.y > s.n1.y3) then
        if beenHit.a == 0 then
            beenHit.a = 1
            love.audio.play(pnt)
            gameScore = gameScore + 1
        end 
    elseif not (s.n2.x1 > b.x + BALL_SIZE or b.x > s.n2.x2 or s.n2.y1 > b.y + BALL_SIZE or b.y > s.n2.y3) then
        if beenHit.b == 0 then
            beenHit.b = 1
            love.audio.play(pnt)
            gameScore = gameScore + 1
        end 
    elseif not (s.n3.x1 > b.x + BALL_SIZE or b.x > s.n3.x2 or s.n3.y1 > b.y + BALL_SIZE or b.y > s.n3.y3) then
        if beenHit.c == 0 then
            beenHit.c = 1
            love.audio.play(pnt)
            gameScore = gameScore + 1
        end 
    elseif not (s.n4.x1 > b.x + BALL_SIZE or b.x > s.n4.x2 or s.n4.y1 > b.y + BALL_SIZE or b.y > s.n4.y3) then
        if beenHit.d == 0 then
            beenHit.d = 1
            love.audio.play(pnt)
            gameScore = gameScore + 1
        end 
    elseif not (s.n5.x1 > b.x + BALL_SIZE or b.x > s.n5.x2 or s.n5.y1 > b.y + BALL_SIZE or b.y > s.n5.y3) then
        if beenHit.e == 0 then
            beenHit.e = 1
            love.audio.play(pnt)
            gameScore = gameScore + 1
        end 
    end
end

function refresh()
    if playerLives < 3 then
        playerLives = playerLives + 1
    end
    beenHit.a = 0
    beenHit.b = 0
    beenHit.c = 0
    beenHit.d = 0
    beenHit.e = 0
    timer = 0
    hold = 0
    resetBall()
end

function wait()
    dt = love.timer.getDelta()
    if timer < 3 then
        timer = timer + dt
    elseif timer > 3 then
        return 1
    end
end

function gameAudio()
    bgm = love.audio.newSource('bensound-scifi.mp3', 'static')
    bgm:setVolume(.1)
    bgm:setLooping(true)
    bonk = love.audio.newSource('bonk.wav', 'static')
    bonk:setVolume(.1)
    pnt = love.audio.newSource('pickup.wav', 'static')
    pnt:setVolume(.3)
    loss = love.audio.newSource('loss.wav', 'static')
    loss:setVolume(.5)
    win = love.audio.newSource('won.wav', 'static')
    win:setVolume(1.5)
end