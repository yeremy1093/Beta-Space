--Declaramos la clase
Pulso = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Pulso D-10.png')

function Pulso:init(x, y, speed, nivel)
	self.clase = 'pulso'
	self.damage = 5
	self.x = x
	self.y = y
	self.xspeed = speed
	self.speed = speed
	self.sprite = love.graphics.newQuad(0, 0, 70, 70, sprite_sheet:getDimensions())
	self.nivel = nivel
    self.destruible = false
    self.anim = Anim(0, 0, 70, 70, 7, 7, 8)

    self.width = 70 * (self.nivel + 3)
    self.height = 70 * (self.nivel + 3)

end

--Funcion de update
function Pulso:update(dt, nave)
	self.y = nave.y - (self.height / 2 + 20)
	self.x = nave.x - (self.width / 2 - 29)

	if 7 == self.anim:update(dt, self.sprite) then
		return false
	end

	return true	
end

function Pulso:render()
	love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y, 0, (self.nivel + 3))
end