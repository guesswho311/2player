local bump   = require 'lib.bump'
local Powerup = require 'entities.Powerup'

local Speed = class('Speed', Powerup)

-- function Speed:Initialize(l,t)
--   Powerup.initialize(self,l,t)
-- end

-- function Speed:draw()
--   local l,t, w,h = self.l,self.t, self.w,self.h
--   love.graphics.setColor(0,255,0,255);
--   love.graphics.rectangle('fill', l,t, w,h)
-- end

function Speed:activate(other)
  other.speed = 600
end

return Speed