Gamestate = require "lib/gamestate"

require 'lib/middleclass'
require 'lib/TEsound'

local Timer = require 'lib/timer'
local bump = require 'lib/bump'

local Entity = require 'entities.Entity'
local Player = require 'entities.Player'

local maxdt = 0.1    -- if the window loses focus/etc, use this instead of dt

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

local function reset()
  player1 = Player:new(400,100, 'a','d','w','s', 255,0,0)
  player2 = Player:new(400,450, 'left','right','up','down', 0,0,255)
end
  

function game:enter(previous)
  reset()
end

function game:keyreleased(key)
  if (key == "p") then
    Gamestate.switch(pause)
  end
end


function game:update(dt)
    -- timer.update(dt)
    TEsound.cleanup()

    player1:update(dt)
    player2:update(dt)
    
    -- -- check to see if player1 is out of bounds
--     if (player1.y < 40) then
--         player1.x = 400
--         player1.y = 100
--     elseif (player1.y > 555) then
--          player1.x = 400
--          player1.y = 100        
--     elseif (player1.x < 45) then
--         player1.x = 400
--         player1.y = 100
--     elseif (player1.x > 755) then
--         player1.x = 400
--         player1.y = 100
--    end 
--    -- check to see if player2 is out of bounds
--     if (player2.y < 40) then
--         player2.x = 400
--         player2.y = 450
--     elseif (player2.y > 555) then
--          player2.x = 400
--          player2.y = 450        
--     elseif (player2.x < 45) then
--         player2.x = 400
--         player2.y = 450
--     elseif (player2.x > 755) then
--         player2.x = 400
--         player2.y = 450
--    end 

end


function game:draw()
  player1:draw()
  player2:draw()
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
