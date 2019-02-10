local Object = require('object')
local Tile = require('tile')

local Tilemap = Object:extend()
Tilemap.TILE_WIDTH = 32

function Tilemap:new()
    local t = {
        cols = love.graphics.getWidth() / 32,
        rows = love.graphics.getHeight() / 32
    }
    for i=0,t.rows-1 do
        t[i] = {}
    end
    return setmetatable(t, self)
end

function Tilemap:set(x, y, tile)
    self[math.floor(y / 32)][math.floor(x / 32)] = tile
end

function Tilemap:get(x, y)
    return self[math.floor(y / 32)][math.floor(x / 32)]
end

function Tilemap:draw()
    for i=0,self.rows-1 do
        for j=0,self.cols-1 do
            if self[i][j] then
                self[i][j]:draw(j*self.TILE_WIDTH, i*self.TILE_WIDTH)
            end
        end
    end
end

return Tilemap