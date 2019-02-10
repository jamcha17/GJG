local Object = require('object')

local Tile = Object:extend()

function Tile:new(r, g, b)
    return setmetatable({r = r, g = g, b = b}, self)
end

function Tile:draw(x, y)
    love.graphics.setColor(self.r, self.g, self.b)
    love.graphics.rectangle('fill', x, y, 32, 32)
end

return Tile