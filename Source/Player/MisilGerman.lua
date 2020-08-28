--Declaramos la clase
Misil = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Missil Y9-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Misil:init(x, y, speed, xspeed)
	self.clase = 'misil'
	self.x = x
	self.y = y
	self.xspeed = xspeed
	self.speed = speed
	self.sprite = love.graphics.newQuad(0, 0, 6, 15, sprite_sheet:getDimensions())
	self.width = 6
	self.height = 15
    self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.anim = {['explotando'] = Anim(0, 0, 25, 25, 4, 4, 10),
    			['idle'] = Anim(0, 0, 6, 15, 2, 2, 10)}


end

--Funcion de update
function Misil:update(dt, nave)
	if self.destruible == true then 
		if 4 == self.anim['explotando']:update(dt, self.spriteExplotion) then
			return false
		end
	else
		self.y = self.y - self.speed * dt
		self.x = self.x + self.xspeed * dt
		self.anim['idle']:update(dt, self.sprite)
	end
	return true	
end

function Misil:render()
	if self.destruible == true then
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y)
	end
end