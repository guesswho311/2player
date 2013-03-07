local bump    = require 'lib.bump'
local Powerup = require 'entities.Powerup'
local Entity  = require 'entities.Entity'

local Player  = class('Player', Entity)

function Player:initialize(l,t, left,right,up,down, r,g,b)
  Entity.initialize(self, l,t, 32,32)
  
  self.speed = 400
  
  self.left  = left  or 'left'
  self.right = right or 'right'
  self.up    = up    or 'up'
  self.down  = down  or 'down'
  
  self.r = r or 255
  self.g = g or 255
  self.b = b or 255
  
  bump.add(self)
end

function Player:shouldCollide(other)
  return instanceOf(Player, other)
      or instanceOf(Powerup, other)
end

function Player:collision(other, dx,dy)
  if instanceOf(Player, other) then
    self.l,self.t = self.l+dx/2,self.t+dy/2
  elseif instanceOf(Powerup, other) then
    other:activate(self)
    bump.remove(other)
    other:destroy(self)
  end
end

function Player:update(dt, maxdt)
  local left,right,up,down = self.left,self.right,self.up,self.down
  if love.keyboard.isDown(left) then
    self.l = self.l - self.speed*dt
  elseif love.keyboard.isDown(right) then
    self.l = self.l + self.speed*dt
  end
  
  if love.keyboard.isDown(up) then
    self.t = self.t - self.speed*dt
  elseif love.keyboard.isDown(down) then
    self.t = self.t + self.speed*dt
  end
end

function Player:draw()
  local r,g,b = self.r,self.g,self.b
  local l,t, w,h = self.l,self.t, self.w,self.h
  love.graphics.setColor(r,g,b,255);
  love.graphics.rectangle('fill', l,t, w,h)
end

return Player