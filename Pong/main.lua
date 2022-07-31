window = {}
window.width = 720
window.height = 500

set = 0

paddle1score = 0
paddle2score = 0

paddle1 = {}
paddle1.height = 40
paddle1.width = 10
paddle1.x = 0
paddle1.y = 0
paddle1.speed = 300

paddle2 = {}
paddle2.height = 40
paddle2.width = 10
paddle2.x = window.width - paddle2.width
paddle2.y = window.height - paddle2.height
paddle2.speed = 300

function ball_info()
ball = {}
ball.height = 8
ball.width = 8
ball.x = window.width/2 - 4
ball.y = window.height/2 - 4
if paddle1score >= paddle2score then
  ball.xspeed = 350
  ball.yspeed = 350
else
  ball.xspeed = -350
  ball.yspeed = -350
end
end

function love.load()
  love.window.setMode(window.width,window.height)
  love.window.setTitle("Pong Game")
  math.randomseed(os.time())
  background = love.graphics.newImage("Background2.jpeg")
  paddlehit = love.audio.newSource("Paddlehit.wav", "stream")
  point = love.audio.newSource("point.wav", "stream")
  boundary=love.audio.newSource("Boundaryhit.wav","stream")
  track1 = love.audio.newSource("mixkit-arcade-game-opener-222.wav", "stream")
end

function love.update(dt)
  if love.keyboard.isDown('w') then
    paddle1.y = paddle1.y - paddle1.speed*dt
  elseif love.keyboard.isDown('s') then
    paddle1.y = paddle1.y + paddle1.speed*dt
  end

  if love.keyboard.isDown('up') then
    paddle2.y = paddle2.y - paddle2.speed*dt
  elseif love.keyboard.isDown('down') then
    paddle2.y = paddle2.y + paddle2.speed*dt
  end
  paddle_boundary(paddle1)
  paddle_boundary(paddle2)

  if set == 1 then
    ball_boundary()
    x_ball_check()
    paddle_ball_collision(paddle1)
    paddle_ball_collision(paddle2)
    ball.x = ball.x + ball.xspeed*dt
    ball.y = ball.y + ball.yspeed*dt
  end

  if set == 1 then
    if ball.x < 0 then
      --love.audio.play(point)
      paddle2score = paddle2score + 1
      set = 0
    elseif ball.x + ball.width> window.width then
      --love.audio.play(point)
      paddle1score = paddle1score + 1
      set = 0
    end
end
if paddle1score == 10 or paddle2score == 10 then
    set = 0
end
end



function paddle_boundary(paddle)
  if paddle.y < 0 then
    paddle.y = 0
  elseif(paddle.y > window.height-paddle.height) then
    paddle.y = window.height - paddle.height
  end
end

function ball_boundary()
  if ball.y < 0 then
    love.audio.play(boundary)
    ball.y = 0
    ball.yspeed = -ball.yspeed
  elseif ball.y+ball.height > window.height then
    love.audio.play(boundary)
    ball.y = window.height - ball.height
    ball.yspeed = -ball.yspeed
  end
end

function love.keypressed(key)
  if key == "space" then
    if set == 0 then
    ball_info()
    set = 1
  end
  elseif key == "return" then
    if paddle1score == 10 or paddle2score == 10 then
      paddle1score = 0
      paddle2score = 0
    end
  elseif key == "escape" then
    love.event.quit()
  end
  end

function x_ball_check()
  if ball.x < 0 then
    set = 0
  elseif ball.x > window.width - ball.width then
    set = 0
  end
end

function paddle_ball_collision(paddle)
  if collision(ball.x, ball.y, ball.width, ball.height, paddle.x, paddle.y, paddle.width, paddle.height) then
    love.audio.play(paddlehit)
    ball.xspeed = -ball.xspeed
    if ball.x < paddle1.width then
      ball.x = paddle1.width
    else
      ball.x = paddle2.x - ball.width
    end
  end
  end

function collision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1<x2+w2 and
         x1+w1>x2 and
         y1<y2+h2 and
          y1+h1>y2
  end

function love.draw()
  --love.graphics.setColor(0.5, 0,0.98)
  --love.graphics.draw(background)
  if paddle1score == 0 and paddle2score == 0 and set == 0 then
    --love.audio.play(track1)
  end
  love.graphics.setNewFont("AtariClassicSmooth-XzW2.ttf", 25)
  if set == 0 then
    love.graphics.printf("Pong", 0,window.height/2 - 240,window.width,'center')
  end
  love.graphics.rectangle("fill", paddle1.x, paddle1.y, paddle1.width, paddle1.height)
  love.graphics.rectangle("fill", paddle2.x, paddle2.y, paddle2.width, paddle2.height)
  if set == 1 then
    --love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
    love.graphics.circle("fill", ball.x, ball.y, ball.width/2)
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(5)
    love.graphics.line(window.width/2,window.height, window.width/2, 0)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.setNewFont("AtariClassicSmooth-XzW2.ttf", 20)
  love.graphics.print(paddle1score, window.width/2 - 100, window.height/2)
  love.graphics.print(paddle2score, window.width/2 + 90, window.height/2)
  love.graphics.setNewFont("AtariClassicSmooth-XzW2.ttf", 15)
  if set == 0 and (paddle1score < 10 and paddle2score < 10) then
    love.graphics.printf("Press Space To Launch The Ball",0, 80,window.width,'center')
  end

  if paddle1score == 10 then
      love.audio.play(track1)
      love.graphics.printf("Press Enter To Restart The Game",0,100,window.width,'center')
        love.graphics.setColor(0,1,0)
        love.graphics.printf("Player 1 Won", -150,window.height/2 - 85,window.width,'center')
        love.graphics.setColor(1,0.2,0)
        love.graphics.printf("Player 2 Lost", 150,window.height/2 - 85,window.width,'center')
        love.graphics.setColor(1,1,1)
    end
  if paddle2score == 10 then
    love.audio.play(track1)
    love.graphics.printf("Press Enter To Restart The Game", 0, 100, window.width, 'center')
        love.graphics.setColor(1,0.2,0)
        love.graphics.printf("Player 1 Lost", -150,window.height/2 - 85,window.width,'center')
        love.graphics.setColor(0,1,0)
        love.graphics.printf("Player 2 Won", 150,window.height/2 - 85,window.width,'center')
        love.graphics.setColor(1, 1, 1)
    end
end
