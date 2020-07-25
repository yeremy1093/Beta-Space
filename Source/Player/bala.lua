--Declaramos la clase
Bala = Class{}

--Hacemos la funcion inicial

imgBala = love.graphics.newImage('Imagen/Sprites/laser.png')

local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Bala:init(x, y, speed)
	self.x = x
	self.y = y
	self.speed = speed
	self.sprite = imgBala
	self.width = self.sprite:getWidth ()
	self.height = self.sprite:getHeight ()

	self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.explotionAnim = Anim(0, 0, 25, 25, 4, 4, 10)
end

--Funcion de update
function Bala:update(dt)
	if self.destruible == true then 
		if 4 == self.explotionAnim:update(dt, self.spriteExplotion) then
			return false
		end
	else
		self.y = self.y - self.speed * dt
	end
	return true	
end

function Bala:render()
	if self.destruible == false then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	end
end