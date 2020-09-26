--Declaramos la clase
Rayo = Class{}

--Hacemos la funcion inicial

local imgLaser = love.graphics.newImage('Imagen/Sprites/LightSaber.png')


function Rayo:init(x, y, xspeed, speed, level)
	self.clase = 'rayo'
	self.damage = 10
	self.x = x
	self.y = y
	self.imagex = x
	self.imagey = y
	self.xspeed = xspeed
	self.speed = speed
	self.level = level
	self.sprite_sheet = imgLaser
	self.width = 10
	self.height = 12
	self.angulo = 90
	self.contador = 0
    self.destruible = false

    self.sprite = love.graphics.newQuad(0, 0, 12, 70, self.sprite_sheet:getDimensions())

    self.timer = 0.03
end

--Funcion de update
function Rayo:update(dt, player)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		self.timer = 0.03
	
		self.imagex = player.x + player.width/2
		self.imagey = player.y

		if self.contador == 20 then
			return false
		end

		if self.contador == 0 then
			self.x = player.x - (70 * 2 * self.level)
			self.y = player.y - 12
			self.contador = self.contador + 1
		else
			self.contador = self.contador + 1
			self.x = self.x + (20 * self.level)
			self.angulo = self.angulo + 10
			self.y = math.floor(-(math.sqrt((70 * 2 * self.level)^2 - (self.x - player.x)^2)) + player.y)
		end

		self.sprite:setViewport(12 * self.contador, 0, 12, 70)

		self.height = player.y - self.y

	end

	return true	
end

function Rayo:render()
	--los valores de draw son: imagen, quad (si hay), x, y, rotacion, escala en x, escala en y
	love.graphics.draw(self.sprite_sheet, self.sprite, self.imagex + 5, self.imagey, math.rad(self.angulo), 1, 2 * self.level)
end