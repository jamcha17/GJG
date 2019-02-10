-- Template
local Tile = require('tile')
local Tilemap = require('tilemap')

local grass = Tile:new(0, 255, 0)
local tilemap = Tilemap:new()
tilemap:set(0, 0, grass)

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setColor(0, 0, 0)
end

function love.keypressed(key, scancode, is_repeat)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    tilemap:draw()
end