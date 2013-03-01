Timer = require 'lib/timer'
local bump = require 'lib/bump'
require 'lib/middleclass'
require 'lib/TEsound'

Gamestate = require "lib/gamestate"
    PlayerA = class('Player1')
    PlayerB = class('Player2')
local menu  = Gamestate.new()
local game  = Gamestate.new()
local pause = Gamestate.new()

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function menu:draw()
    love.graphics.print("Press Enter to continue", 10, 10)
    love.graphics.print ("Howdy", 50, 50)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        -- reset game
        Gamestate.switch(game)
    end
end
function bump.collision(obj1,obj2,dx,dy)
  obj1:collision(obj2,  dx,  dy)
  obj2:collision(obj1, -dx, -dy)
end

function bump.endCollision(obj1, obj2)
  obj1:endCollision(obj2)
  obj2:endCollision(obj1)
end

function bump.shouldCollide(obj1, obj2)
  return obj1:shouldCollide(obj2) or
         obj2:shouldCollide(obj1)
end
function bump.getBBox(obj)
    return obj:getBBox()
end

function PlayerA:shouldCollide(other)
    return instanceof(playerB, other)
end

function PlayerA:collision(other,dx,dy)

end

function game:enter(previous)
    if previous == menu then
        bg = love.graphics.newImage("bg.png")
        sfx = love.audio.newSource("sounds/reload.wav")
        laser = love.audio.newSource("sounds/laser.wav")
        
        magnitude = 0
        player1 = {} -- new table for the hero
        player1.x = 400    -- x,y coordinates of the hero
        player1.y = 100
        player1.width = 20
        player1.height = 20
        player1.speed = 300
        player1.dspeed = 150
        player1.shots = {} -- holds our fired shots
        player1.ammo  = 0
        player1.reload = 0
        
        player2 = {}
        player2.x = 400    -- x,y coordinates of the hero
        player2.y = 450
        player2.width = 20
        player2.height = 20
        player2.speed = 300
        player2.dspeed = 150
        player2.shots = {} -- holds our fired shots
        player2.ammo  = 0
        player2.reload = 0

    end
end

function game:keyreleased(key)
    if (key == "f") then
        if player1.ammo < 2 then
            player1.ammo = player1.ammo + 1
            Timer.add(0.1, function() game:shoot() end)
           
            TEsound.play("sounds/laser.wav")
        elseif player1.ammo >= 2 then
            
            Timer.add(1, function() player1.ammo = 0 
                Timer.clear() 
                love.audio.play(sfx) end)

        end
    elseif (key == " ") then
        if player2.ammo < 2 then
            player2.ammo = player2.ammo + 1
            Timer.add(0.1, function() game:shoot2() end)
           
            TEsound.play("sounds/laser.wav")
        elseif player2.ammo >= 2 then
            
            Timer.add(1, function() player2.ammo = 0 
                Timer.clear() 
                love.audio.play(sfx) end)    
        end
    elseif (key == "p") then
        Gamestate.switch(pause)
    end
end


function game:update(dt)
    Timer.update(dt)
    TEsound.cleanup()

    -- keyboard actions for our hero
    if love.keyboard.isDown("a") then
        player1.x = player1.x - player1.speed*dt
    elseif love.keyboard.isDown("d") then
        player1.x = player1.x + player1.speed*dt
    elseif love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed*dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed*dt
    end
    magnitude = math.sqrt(player1.speed * 2)
    

    if love.keyboard.isDown("a") and love.keyboard.isDown("w") then
        player1.x = player1.x - player1.dspeed*dt
        player1.y = player1.y - player1.dspeed*dt
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("w") then
        player1.x = player1.x + player1.dspeed*dt
        player1.y = player1.y - player1.dspeed*dt
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        player1.x = player1.x + player1.dspeed*dt
        player1.y = player1.y + player1.dspeed*dt
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") then
        player1.x = player1.x - player1.dspeed*dt
        player1.y = player1.y + player1.dspeed*dt
    end

    if love.keyboard.isDown("left") then
        player2.x = player2.x - player2.speed*dt
    elseif love.keyboard.isDown("right") then
        player2.x = player2.x + player2.speed*dt
    elseif love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed*dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed*dt
    end
    if love.keyboard.isDown("left") and love.keyboard.isDown("up") then
        player2.x = player2.x - player2.dspeed*dt
        player2.y = player2.y - player2.dspeed*dt
    elseif love.keyboard.isDown("right") and love.keyboard.isDown("up") then
        player2.x = player2.x + player2.dspeed*dt
        player2.y = player2.y - player2.dspeed*dt
    elseif love.keyboard.isDown("right") and love.keyboard.isDown("down") then
        player2.x = player2.x + player2.dspeed*dt
        player2.y = player2.y + player2.dspeed*dt
    elseif love.keyboard.isDown("left") and love.keyboard.isDown("down") then
        player2.x = player2.x - player2.dspeed*dt
        player2.y = player2.y + player2.dspeed*dt
    end
    
    local remShot = {}
    
    -- update the shots
    for i,v in ipairs(player1.shots) do
    
        -- move them up up up
        v.y = v.y - dt * 200
        
        -- mark shots that are not visible for removal
        if v.x < 0 then
            table.insert(remShot, i)
        end
    end

    for i,v in ipairs(player2.shots) do
    
        -- move them up up up
        v.y = v.y - dt * 200
        
        -- mark shots that are not visible for removal
        if v.y < 0 then
            table.insert(remShot, i)
        end
    end

    -- check to see if player1 is out of bounds
    if (player1.y < 40) then
        player1.x = 400
        player1.y = 100
    elseif (player1.y > 555) then
         player1.x = 400
         player1.y = 100        
    elseif (player1.x < 45) then
        player1.x = 400
        player1.y = 100
    elseif (player1.x > 755) then
        player1.x = 400
        player1.y = 100
   end 
   -- check to see if player2 is out of bounds
    if (player2.y < 40) then
        player2.x = 400
        player2.y = 450
    elseif (player2.y > 555) then
         player2.x = 400
         player2.y = 450        
    elseif (player2.x < 45) then
        player2.x = 400
        player2.y = 450
    elseif (player2.x > 755) then
        player2.x = 400
        player2.y = 450
   end 

end


function game:draw()

    -- let's draw some ground
    love.graphics.setColor(0,191,255,100)
    love.graphics.rectangle("fill", 50, 50, 700, 500)
    
    -- let's draw our hero
    love.graphics.setColor(255,255,0,255)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height, self:getBBox())

    -- draw player 2
    love.graphics.setColor(0,255,0,255)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height, self:getBBox())

    -- let's draw our heros shots
    love.graphics.setColor(255,255,255,255)
    for i,v in ipairs(player1.shots) do
        love.graphics.rectangle("fill", v.x, v.y, 2, 5)
    end

    for i,v in ipairs(player2.shots) do
        love.graphics.rectangle("fill", v.x, v.y, 2, 5)
    end

    love.graphics.print (player1.ammo, 10, 10)
end

function game:shoot()
    local shot = {}
    shot.x = player1.x+player1.width/2
    shot.y = player1.y
    table.insert(player1.shots, shot)
    
end
function game:shoot2()
    local shot = {}
    shot.x = player2.x+player2.width/2
    shot.y = player2.y
    table.insert(player2.shots, shot)
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function game:CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)

  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function pause:enter()
end

function pause:update(dt)
end

function pause:draw()
    love.graphics.setColor(0,255,0,255)
    love.graphics.rectangle("fill", 0, 465, 500, 150)
end
function pause:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end
