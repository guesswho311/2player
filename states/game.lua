local game = Gamestate.new()

local bump = require 'lib.bump'

local Entity = require 'entities.Entity'
local Player = require 'entities.Player'
local Speed  = require 'entities.Powerup.Speed'

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
  player1 = Player:new(200,175,    'a',    'd', 'w',   's', 255,  0,  0)
  player2 = Player:new(600,175, 'left','right','up','down',   0,  0,255)
  SpeedUp = Speed:new(100,100)
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
  dt = math.min(dt, maxdt)
  
  TEsound.cleanup()

  local updateEntity = function(entity) entity:update(dt) end
  bump.each(updateEntity, l,t,w,h)

  bump.collide()
end

local function drawEntity(entity)
  entity:draw()
end

function game:draw()
  bump.each(drawEntity, l,t,w,h)
end

return game