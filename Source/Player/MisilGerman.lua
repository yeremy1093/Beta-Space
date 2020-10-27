--Declaramos la clase
Misil = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Missil Y9-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Misil:init(x, y, speed, xspeed)
	self.clase = 'misil'
	self.damage = 2
	self.x = x
	self.y = y
	self.speed = speed
	self.speedChange = speed * 6
	self.newx = x
	self.newy = y - 200
	self.enemyObj = nil
	self.enemyInList = false
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

    self.enemy_min_x = 0


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

			local enemigos_totales = {}
			for i, enemigo in pairs(enemigos.navesBasic) do
				table.insert(enemigos_totales, enemigo)
			end

			for i, enemigo in pairs(enemigos.drones) do
				table.insert(enemigos_totales, enemigo)
			end

			for i, enemigo in pairs(enemigos.huntersMasters) do
				table.insert(enemigos_totales, enemigo)
			end

			if #enemigos_totales == 0 then
				self.yspeed = -self.speed
				self.xspeed = 0
				self.enemyObj = nil
			else
		 
			    for i, enemigo in pairs(enemigos_totales) do
			    	if naveBasic == self.enemyObj then
			    		self.enemyInList = true
						break
					else
						self.enemyInList = false
					end
				end
			end

			if self.enemyInList ~= true then
				self.enemyObj = nil
			end
		end

		if self.xspeed == 0 then
			self.angulo = 0
		else
			if self.xspeed > 0 then
				self.angulo = math.deg(math.atan(self.yspeed/self.xspeed)) + 90
			else
				self.angulo = math.deg(math.atan(self.yspeed/self.xspeed)) - 90
			end
		end

		self.anim['idle']:update(dt, self.sprite)
	end

	if self.enemyObj == nil then
		self:fijar_enemigo(enemigos)
	end
	return true	
end

function Misil:fijar_enemigo(enemigos)
	local enemigos_totales = {}
	for i, enemigo in pairs(enemigos.navesBasic) do
		table.insert(enemigos_totales, enemigo)
	end

	for i, enemigo in pairs(enemigos.drones) do
		table.insert(enemigos_totales, enemigo)
	end
	for i, enemigo in pairs(enemigos.huntersMasters) do
		table.insert(enemigos_totales, enemigo)
	end
	for i, enemigo in pairs(enemigos.lancers) do
		table.insert(enemigos_totales, enemigo)
	end
	for i, enemigo in pairs(enemigos.cruceros) do
		table.insert(enemigos_totales, enemigo)
	end
	for i, enemigo in pairs(enemigos.capitales) do
		table.insert(enemigos_totales, enemigo)
	end
	for i, enemigo in pairs(enemigos.huntersSlaves) do
		table.insert(enemigos_totales, enemigo)
	end

	for i, enemigo in pairs(enemigos_totales) do
		if i == 1 then
			self.enemy_min_x = math.abs(self.x - enemigo.x)
			self.enemyObj = enemigo
			self.enemyInList = true
		end

		if math.abs(self.x - enemigo.x) < self.enemy_min_x then
			self.enemy_min_x = math.abs(self.x - enemigo.x)
			self.enemyObj = enemigo
			self.enemyInList = true
		end
	end

	self.enemy_min_x = 0
end

function Misil:render()
	if self.destruible == true then
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y, math.rad(self.angulo), 1, 1, self.width/2, self.height-7)
	end

end