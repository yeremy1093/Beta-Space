--Declaramos la clase
Rayo = Class{}

--Hacemos la funcion inicial

local imgLaser = love.graphics.newImage('Imagen/Sprites/LaserPU AX-2.png')


function Rayo:init(x, y, xspeed, speed, level)
	self.clase = 'pulso'
	self.x = x
	self.y = y
	self.imagex = x
	self.imagey = y
	self.xspeed = xspeed
	self.speed = speed
	self.level = level
	self.sprite = imgLaser
	self.width = 5
	self.height = 5
	self.angulo = 90
	self.contador = 0
    self.destruible = false
end

--Funcion de update
function Rayo:update(dt, player)
	
	self.imagex = player.x + player.width/2
	self.imagey = player.y

	if self.contador == 18 then
		return false
	end

	if self.contador == 0 then
		self.x = player.x - (30 * 5 * self.level)
		self.y = player.y
		self.contador = self.contador + 1
	else
		self.contador = self.contador + 1
		self.x = self.x + (3 * 5 * self.level)
		self.angulo = self.angulo + 10
		self.y = math.floor(-(math.sqrt((30 * 5 * self.level)^2 - (self.x - player.x)^2)) + player.y)
	end

	self.height = player.y - self.y

	return true	
end

function Rayo:render()
	--los valores de draw son: imagen, quad (si hay), x, y, rotacion, escala en x, escala en y
	love.graphics.draw(self.sprite, self.imagex, self.imagey, math.rad(self.angulo), 1, 5 * self.level)
end