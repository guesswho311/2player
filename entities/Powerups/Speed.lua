local bump   = require 'lib.bump'
local Entity = require 'entities.Entity'
local Powerup = require 'entities.Powerup'

local Speed = class('Speed', Powerup)

function Speed:Initialize(l,t,r,g,b)
	Powerup.Initialize(self,l,t,32,32)

	bump.add(self)

end

function Speed:draw()
  local r,g,b = self.r,self.g,self.b
  local l,t, w,h = self.l,self.t, self.w,self.h
  love.graphics.setColor(100,100,100,255);
  love.graphics.rectangle('fill', 25,25, 25,25)
end
return Speed