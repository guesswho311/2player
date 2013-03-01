local menu = Gamestate.new()

function menu:draw()
  love.graphics.print("Press Enter to continue", 10, 10)
  love.graphics.print ("Howdy", 50, 50)
end

function menu:keyreleased(key, code)
  if key == 'return' then
    Gamestate.switch(game)
  end
end

return menu