--Declaramos la clase
Bala = Class{}

--Hacemos la funcion inicial

imgBala = love.graphics.newImage('Imagen/Sprites/laser.png')
imgUp1 = love.graphics.newImage('Imagen/Sprites/Laser2.png')

function Bala:init(x, y, speed, type, id)
	self.x = x
	self.y = y
	self.speed = speed
	self.type = type
	if self.type == 0 then
		self.sprite = imgBala
	elseif self.type == 1 then
		self.sprite = imgUp1
		self.id = id
	end
	self.width = self.sprite:getWidth ()
	self.height = self.sprite:getHeight ()
end

--Funcion de update
function Bala:update(dt)
	if self.type == 0 then self.y = self.y - self.speed * dt
	elseif self.type == 1 then 
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
end

function Bala:render()
	love.graphics.draw(self.sprite, self.x, self.y)
end