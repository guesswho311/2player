local game = Gamestate.new()

local bump = require 'lib.bump'

local Entity = require 'entities.Entity'
local Player = require 'entities.Player'

local maxdt = 0.1    -- if the window loses focus/etc, use this instead of dt


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
  if previous == menu then
    reset()
  end
end

function game:keyreleased(key)
  if (key == "p") then
    Gamestate.switch(pause)
  end
end


function game:update(dt)
    TEsound.cleanup()

    player1:update(dt)
    player2:update(dt)
    bump.collide()
end


function game:draw()
  player1:draw()
  player2:draw()
end

return game