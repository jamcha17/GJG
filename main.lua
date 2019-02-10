-- Template

function love.load()
    love.graphics.setBackgroundColor(0, 0, 255)
    love.graphics.setColor(0, 0, 0)
end

function love.keypressed(key, scancode, is_repeat)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    --love.graphics.print("Hello World", 400, 300)
end