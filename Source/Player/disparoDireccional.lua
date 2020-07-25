--Declaramos la clase
Direccional = Class{}

--Hacemos la funcion inicial

imgUp1 = love.graphics.newImage('Imagen/Sprites/Laser2.png')

local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Direccional:init(x, y, speed, id)
	self.x = x
	self.y = y
	self.speed = speed
	self.sprite = imgUp1
	self.id = id
	self.width = self.sprite:getWidth ()
	self.height = self.sprite:getHeight ()

	self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.explotionAnim = Anim(0, 0, 25, 25, 4, 4, 10)
end

--Funcion de update
function Direccional:update(dt)
	if self.destruible == true then 
		if 4 == self.explotionAnim:update(dt, self.spriteExplotion) then
			return false
		end
	else 
		if self.id == 1 then --Bala hacia arriba
			self.y = self.y - self.speed * dt
		elseif self.id == 2 then --Bala hacia abajo
			self.y = self.y + self.speed * dt
		elseif self.id == 3 then --Bala Derecha
			self.x = self.x + self.speed * dt
		elseif self.id == 4 then --Bala izquierda
			self.x = self.x - self.speed * dt
		elseif self.id == 5 then --Bala arriba derecha
			self.y = self.y - self.speed * dt
			self.x = self.x + self.speed * dt
		elseif self.id == 6 then --Bala Abajo Derecha
			self.y = self.y + self.speed * dt
			self.x = self.x + self.speed * dt
		elseif self.id == 7 then --Bala Abajo Izquierda
			self.x = self.x - self.speed * dt
			self.y = self.y + self.speed * dt
		elseif self.id == 8 then --Bala arriba izquierda
			self.x = self.x - self.speed * dt
			self.y = self.y - self.speed * dt
		end	
	end
	return true	
end

function Direccional:render()
	if self.destruible == false then
		love.graphics.draw(self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	end
end