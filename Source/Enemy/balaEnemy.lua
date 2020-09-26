BalaEnemy = Class{}

local sprite_sheet_bala = love.graphics.newImage('Imagen/Sprites/laser.png')

function BalaEnemy:init(x, y, dx, dy)
    self.damage = 1
    self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.width = 6
	self.height = 15
	self.sprite = sprite_sheet_bala
	self.fps = math.random(6, 10)
end

function BalaEnemy:update(dt)
    self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt
end

function BalaEnemy:collides(objeto)
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

    -- if the above aren't true, they're overlapping
    return true
end

function BalaEnemy:render()
    love.graphics.draw(self.sprite, self.x, self.y)
end