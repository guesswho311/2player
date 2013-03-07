local bump   = require 'lib.bump'
local Entity = require 'entities.Entity'

local Powerup = class('Powerup', Entity)

local random = math.random

function Powerup:initialize(l,t)
  Entity.initialize(self, l,t, 16,16)
  bump.add(self)
end

function Powerup:draw()
  local l,t, w,h = self.l,self.t, self.w,self.h
  love.graphics.setColor(random(255),random(255),random(255),255);
  love.graphics.rectangle('fill', l,t, w,h)
end

function Powerup:destroy()
  bump.remove(self)
  Entity.destroy(self)
end

return Powerup