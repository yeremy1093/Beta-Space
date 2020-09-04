--Declaramos la clase
Misil = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Missil Y9-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Misil:init(x, y, speed, xspeed)
	self.clase = 'misil'
	self.x = x
	self.y = y
	self.speed = speed
	self.speedChange = speed * 4
	self.newx = x
	self.newy = y - 200
	self.enemyObj = nil
	self.xspeed = xspeed
	self.yspeed = -speed
	self.angulo = 0
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
	local new_distance = 1
	if self.destruible == true then 
		if 4 == self.anim['explotando']:update(dt, self.spriteExplotion) then
			return false
		end
	else

		if self.enemyObj == nil then
			self.y = self.y + self.yspeed * dt
			self.x = self.x + self.xspeed * dt
		else
			self.newx = self.enemyObj.x
			self.newy = self.enemyObj.y

			if self.y <= self.newy then -- Misil esta arriba del enemigo
				self.yspeed = math.min(self.yspeed + self.speedChange * dt, self.speed)
		    else -- Misil esta abajo del enemigo
		        self.yspeed = math.max(self.yspeed - self.speedChange * dt, -self.speed)
		    end

		    if self.x <= self.newx then -- Misil esta a la izquierda del enemigo
		        self.xspeed = math.min(self.xspeed + self.speedChange * dt, self.speed)
		    else -- Misil esta a la derecha del enemigo
		        self.xspeed = math.max(self.xspeed - self.speedChange * dt, -self.speed)
		    end

		    self.y = self.y + self.yspeed * dt
			self.x = self.x + self.xspeed * dt
		    --Actualizacion de tiempo requerido para llegar al objetivo
		    --Calcula la distancia mas corta para llegar al objetivo
		    --Si el objetivo esta a menos de un pixel de distancia, se considerara que la nave ha llegado al objetivo
		    if self.newx >= self.x - 10 and self.newx <= self.x + 10 then
		    	if self.newy >= self.y - 10 and self.newy <= self.y + 10 then
		        	self.enemyObj = nil
		        	self.newy = self.y - 10
		    	end
		    end
		end

		if self.xspeed == 0 then
            self.angulo = 0
        else
            self.angulo = math.deg(math.atan(math.abs(self.yspeed)/math.abs(self.xspeed)))
            self.angulo = self.angulo + 90
        end
        if self.xspeed < 0 and self.yspeed < 0 then
            self.angulo = 180 - self.angulo
        elseif self.xspeed < 0 and self.yspeed >= 0 then
            self.angulo = self.angulo + 180
        elseif self.xspeed >= 0 and self.yspeed >= 0 then
            self.angulo = 360 - self.angulo
        end

		self.anim['idle']:update(dt, self.sprite)
	end

	if self.enemyObj == nil then
		for i, naveBasic in pairs(enemigos.navesBasic) do
			if naveBasic.x < (self.x + 500) and naveBasic.x > (self.x - 500) then
				if love.math.random(1, 2) == 1 then
					self.enemyObj = naveBasic
					break
				end
			end

			if naveBasic.y < (self.y + 500) and naveBasic.y > (self.y - 500) then
				if love.math.random(1, 2) == 1 then
					self.enemyObj = naveBasic
					break
				end
			end
		end

		for j, dron in pairs(enemigos.drones) do
			
			if dron.x < (self.x + 500) and dron.x > (self.x - 500) then
				if love.math.random(1, 2) == 1 then
					self.enemyObj = dron
					break
				end
			end
			if dron.y < (self.y + 500) and dron.y > (self.y - 500) then
				if love.math.random(1, 2) == 1 then
					self.enemyObj = dron
					break
				end
			end
		end
	end
	return true	
end

function Misil:render()
	if self.destruible == true then
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y, math.rad(self.angulo))
	end
end