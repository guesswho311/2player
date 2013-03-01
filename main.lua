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