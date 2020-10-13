Stella = Class{}


function Stella:init(x, y, gravity)
    self.x = x
    self.y = y
    self.gravity = gravity
    self.listSections = {}
    self.destruible = false
end

function Stella:update(dt)
    local fin = false
    for i, StellaSection in pairs(self.listSections) do
        StellaSection:update(dt)
    end
end

function Stella:collides(objeto)


    if self.destruible then
        return false
    end
    -- if the above aren't true, they're overlapping
    return true
end



function Stella:render()

end