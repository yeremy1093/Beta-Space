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
	self.targetx = 0
	self.targety = 0
	self.sprite = love.graphics.newQuad(0, 0, 6, 15, sprite_sheet:getDimensions())
	self.width = 6
	self.height = 15
    self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.anim = {['explotando'] = Anim(0, 0, 25, 25, 4, 4, 10),
    			['idle'] = Anim(0, 0, 6, 15, 2, 2, 10)}


end

--Funcion de update
function Misil:update(dt, nave, enemigos)
	local distance = 1
	local time_adjust = 1
	if self.destruible == true then 
		if 4 == self.anim['explotando']:update(dt, self.spriteExplotion) then
			return false
		end
	else
		if self.targetx == 0 and self.targety == 0 then
			self.y = self.y - self.speed * dt
			self.x = self.x + self.xspeed * dt
		else
			self.y = self.y - ((self.targety - self.y) * dt * time_adjust)
			self.x = self.x - ((self.targetx - self.x) * dt * time_adjust)
		end
		self.anim['idle']:update(dt, self.sprite)
	end

	if self.targetx == 0 and self.targety == 0 then
		for i, naveBasic in pairs(enemigos.navesBasic) do
			for j, dron in pairs(enemigos.drones) do
				if naveBasic.x < self.x + 100 and naveBasic.x > self.x - 100 then
					self.targetx = naveBasic.x
				elseif dron.x < self.x + 100 and dron.x > self.x - 100 then
					self.targetx = dron.x
				end
				if naveBasic.y < self.y + 100 and naveBasic.y > self.y - 100 then
					self.targety = naveBasic.y
				elseif dron.y < self.y + 100 and dron.y > self.y - 100 then
					self.targety = dron.y
				end
			end
		end
	else
		distance = ((self.targetx - self.x)^2 + (self.targety - self.y)^2)^0.5
		time_adjust = self.speed / distance
	end
	return true	
end

function Misil:render()
	if self.destruible == true then
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y)
	end

	love.graphics.print(tostring(self.targetx), 600, 50)
	love.graphics.print(tostring(self.targety), 700, 50)
end