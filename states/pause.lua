local pause = Gamestate.new()
  
function pause:enter()
end

function pause:update(dt)
end

function pause:draw()
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill", 0, 465, 500, 150)
end

function pause:keyreleased(key, code)
  if key == 'return' then
    Gamestate.switch(game)
  end
end
  
return pause