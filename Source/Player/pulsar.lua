--Declaramos la clase
Pulsar = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Pulsar.png')

function Pulsar:init(x, y, speed, nivel, credential)
	self.clase = 'pulsar'
	self.credential = credential
	self.damage = 5
	self.x = x
	self.y = y
	self.xspeed = 0
	self.speed = speed
	self.sprite = love.graphics.newQuad(0, 0, 300, 300, sprite_sheet:getDimensions())
	self.nivel = nivel
	self.width = 100 * self.nivel
	self.height = 100 * self.nivel
    self.destruible = false
    self.cargando = true
    self.anim = {['cargando'] = Anim(0, 0, 300, 300, 6, 6, 8),
    			['idle'] = Anim(0, 0, 300, 300, 6, 6, 10)}


end

--Funcion de update
function Pulsar:update(dt, nave)
	if self.cargando == true then
		self.y = nave.y - (self.height / 2)
		self.x = nave.x - (self.width / 2 - 29)
		if 6 == self.anim['cargando']:update(dt, self.sprite) then
			self.cargando = false
		end
	else
		self.y = self.y - self.speed * dt
		self.anim['idle']:update(dt, self.sprite)
	end
	return true	
end

function Pulsar:render()
	love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y, 0, self.nivel / 3)
end