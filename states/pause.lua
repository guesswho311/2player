local pause = Gamestate.new()
  
function pause:enter()
end

function pause:update(dt)
end

function pause:draw()
  game:draw()
  love.graphics.setColor(0,255,0,255)
  love.graphics.print("PAUSED", 10,10)
end

function pause:keyreleased(key, code)
  if key == 'return' then
    Gamestate.switch(game)
  end
end
  
return pause