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

		
		self.x = player.x + (self.contador * ((70 * 4 * self.level)/18)) - (70 * 2 * self.level)
		self.angulo = self.angulo + 10
		self.y = player.y - (math.sin((self.contador/20) * math.pi) * (70 * 2 * self.level))
		self.height = player.y - self.y
		self.contador = self.contador + 1


		self.sprite:setViewport(12 * self.contador, 0, 12, 70)

	end

	return true	
end

function Rayo:render()
	--los valores de draw son: imagen, quad (si hay), x, y, rotacion, escala en x, escala en y
	love.graphics.draw(self.sprite_sheet, self.sprite, self.imagex + 5, self.imagey, math.rad(self.angulo), 1, 2 * self.level)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end