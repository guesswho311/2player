Gamestate = require "lib/gamestate"

require 'lib/middleclass'
require 'lib/TEsound'

menu  = require 'states.menu'
game  = require 'states.game'
pause = require 'states.pause'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(menu)
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
end

function love.keyreleased(key)
  if (key == "escape") then
    love.event.quit()
  end
end