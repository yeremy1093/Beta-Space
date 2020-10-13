SectionStella = Class{}

local sprite_sheet_stella = love.graphics.newImage('Imagen/SpritesEnemys/stella.png')
local sprite_sheet_fin = love.graphics.newImage('Imagen/Sprites/Stella-Fin.png')

function SectionStella:init(x, y, gravity)
    self.x = x
    self.y = y
    self.gravity
    self.clase = 'Stella'
    self.width = 5
    self.height = 8
    self.sprite = sprite_sheet_stella
    self.destruible = false
end

function SectionStella:update(dt, fin)
    self.y = self.y + self.gravity * dt
    if fin then
        self.sprite = sprite_sheet_fin
    end
end

function SectionStella:collides(objeto)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > objeto.x + objeto.width or objeto.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > objeto.y + objeto.height or objeto.y > self.y + self.height then
        return false
    end 

    if self.destruible then
        return false
    end
    -- if the above aren't true, they're overlapping
    return true
end



function SectionStella:render()
    love.graphics.draw(self.sprite, self.x, self.y)
end