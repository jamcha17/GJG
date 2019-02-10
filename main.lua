function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
        --These callback function names can be almost any you want:
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  objects = {} -- table to hold all our physical objects
 
  --let's create the ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
 
  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 20, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.1) --let the ball bounce
  objects.ball.fixture:setUserData("Ball")
 
  --let's create a couple blocks to play around with
  objects.block1 = {}
  objects.block1.body = love.physics.newBody(world, 200, 550, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
  objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 1) -- A higher density gives it more mass.
 
  objects.block2 = {}
  objects.block2.body = love.physics.newBody(world, 200, 400, "dynamic")
  objects.block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 1)

  objects.block3 = {}
  objects.block3.body = love.physics.newBody(world, 300, 500, "static")
  objects.block3.shape = love.physics.newRectangleShape(0, 0, 75, 75)
  objects.block3.fixture = love.physics.newFixture(objects.block3.body, objects.block3.shape, 0.1)

  objects.block4 = {}
  objects.block4.body = love.physics.newBody(world, 400, 300, "static")
  objects.block4.shape = love.physics.newRectangleShape(0, 0, 50, 50)
  objects.block4.fixture = love.physics.newFixture(objects.block4.body, objects.block4.shape, 0.1)

  objects.block5 = {}
  objects.block5.body = love.physics.newBody(world, 500, 400, "dynamic")
  objects.block5.shape = love.physics.newRectangleShape(0, 0, 100, 200)
  objects.block5.fixture = love.physics.newFixture(objects.block5.body, objects.block5.shape, 0.5)
 
  --initial graphics setup
  love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650
end

onObject = 0
 
local canJump = false
 
function beginContact(a, b, coll)
    -- Sets canJump to true if the normal vector is between 0 and pi/4 to the vertical
    
    --x,y = coll:getNormal()
    --text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
    
    -- Factor to multiply ny by so that it points from the ball to the ground
    local normalFactor = 1
    
    if b:getUserData() == "Ball" then
      a, b = b, a
      normalFactor = -1
    end
    
    if a:getUserData() == "Ball" then
        local nx, ny = coll:getNormal()
        if math.abs(math.atan(nx/ny)) < math.pi/4 and ny*normalFactor > 0 then
            canJump = true
        end
    end
end
 
function endContact(a, b, coll)
    --persisting = 0
    --text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
    if (a:getUserData() == ball) then
      onObject = 0
    end
    if (b:getUserData() == ball) then
      onObject = 0
    end
end

function preSolve(a, b, coll)
    --if persisting == 0 then    -- only say when they first start touching
    --    text = text.."\n"..a:getUserData().." touching "..b:getUserData()
    --elseif persisting < 20 then    -- then just start counting
    --    text = text.." "..persisting
    --end
    --persisting = persisting + 1    -- keep track of how many updates they've been touching for
    if (a:getUserData() == "Ball") then
      onObject = 1
    end
    if (b:getUserData() == "Ball") then
      onObject = 1
    end
end

local nextJump = 0
 
function love.update(dt)
  world:update(dt) --this puts the world into motion
 
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    objects.ball.body:applyForce(400, 0)
  end
  if love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    objects.ball.body:applyForce(-400, 0)
  end
  if love.keyboard.isDown("up") then --press the up arrow key to set the ball in the air
    if canJump then
        objects.ball.body:applyForce(0,-650*9.81*1.4)--setPosition(650/2, 650/2)
        canJump = false
    end
  end
  --[[elseif love.keyboard.isDown("down") then --press the up arrow key to set the ball in the air
    if onObject == 0 then
      nextJump = love.timer.getTime( )
      objects.ball.body:applyForce(0,100*9.81)--setPosition(650/2, 650/2)
    end]]
  if love.keyboard.isDown("escape") then
    objects.ball.body:setPosition(20, (650 -50)/2)
    objects.ball.body:setLinearVelocity(0, 0) --we must set the velocity to zero to prevent a potentially large velocity generated by the change in position
  end
end
 
function love.draw()
  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
 
  love.graphics.setColor(0.76, 0.18, 0.05) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
 
  love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
  love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
  love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
  love.graphics.polygon("fill", objects.block3.body:getWorldPoints(objects.block3.shape:getPoints()))
  love.graphics.polygon("fill", objects.block4.body:getWorldPoints(objects.block4.shape:getPoints()))
  love.graphics.polygon("fill", objects.block5.body:getWorldPoints(objects.block5.shape:getPoints()))
end