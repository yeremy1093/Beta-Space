Cannon = Class{}

local sprite_sheet_bala = love.graphics.newImage('Imagen/SpritesEnemys/Cannon-1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Cannon:init(x, y)
    self.x = x
	self.y = y
	self.dx = 0
	self.dy = 350
    self.sprite = sprite_sheet_bala
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.explotionAnim = Anim(0, 0, 25, 25, 4, 4, 10)
end

function Cannon:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt

    if self.destruible == true then 
		if 4 == self.explotionAnim:update(dt, self.spriteExplotion) then
			return false
		end
	end
	return true
end

function Cannon:collides(objeto)
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



function Cannon:render()
    if self.destruible == false then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	end
end