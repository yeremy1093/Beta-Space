--Declaramos la clase
Pulsar = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Pulsar.png')

function Pulsar:init(x, y, speed)
	self.x = x
	self.y = y
	self.speed = speed
	self.sprite = love.graphics.newQuad(0, 0, 300, 300, sprite_sheet:getDimensions())
	self.width = 300
	self.height = 300
    self.destruible = false
    self.cargando = true
    self.anim = {['cargando'] = Anim(0, 0, 300, 300, 6, 6, 6),
    			['idle'] = Anim(900, 0, 300, 300, 2, 2, 8)}


end

--Funcion de update
function Pulsar:update(dt, nave)
	if self.cargando == true then
		self.y = nave.y - 150
		self.x = nave.x - 121
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
	love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y)
end