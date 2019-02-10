local Object = require "object"

local Vector = Object:extend()

function Vector:new(x, y)
    local t = {
	    x = x or 0,
		y = y or 0
	}
	setmetatable(t, self)
	return t
end

function Vector:__tostring()
    return '('..self.x..', '..self.y..')'
end

function Vector:__add(other)
    if type(other) == 'number' then
        return Vector:new(self.x+other, self.y+other)
    elseif getmetatable(other) == Vector then
        return Vector:new(self.x+other.x, self.y+other.y)
    else
        error('Attempt to add a point to a non-point that is not a number.', 2)
	end
end

function Vector:__mul(other)
    if type(other) == 'number' then
        return Vector:new(self.x*other, self.y*other)
    else
        error('Attempt to multiply a point by a non-scalar.', 2)
	end
end

function Vector:__eq(other)
    if getmetatable(other) ~= Vector then
		error('Attempt to equate a point with a non-point.', 2)
	end
    return self.x == other.x and self.y == other.y
end

return Vector
