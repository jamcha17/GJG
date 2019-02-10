local Object = {}
Object.__index = Object

function Object:new()
    return setmetatable({}, self)
end

function Object:extend()
    local t = setmetatable({}, self)
    t.__index = t
    return t
end

return Object
