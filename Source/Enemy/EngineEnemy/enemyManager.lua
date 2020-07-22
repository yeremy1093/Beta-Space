Enemy = Class{}

local enemy_timer = 0.05
local shot_timer = 0.05

function Enemy:init()
	self.nivel = 1
	self.tipos_enemigos = {'asteroide_small'}

	self.asteroides = {}
	self.chance_asteroides = 8

	self.navesBasic = {}
	self.chance_naveBasic = 8

	self.engineShot = EngineShot()
end

function Enemy:update(dt, puntuacion, balas, player)
	if puntuacion >= 200000 then
		self.nivel = 6
	elseif puntuacion >= 80000 then
		self.nivel = 5
	elseif puntuacion >= 20000 then
		self.nivel = 4
	elseif puntuacion >= 8000 then
		self.nivel = 3
	elseif puntuacion >= 2000 then
		self.nivel = 2
	end

	self:ajuste_nivel(dt)
	
	--Checamos cuando debemos remover o mover los asteroides
	update_asteroides(dt, self.asteroides, balas, player)

	--Checamos cuando debemos remover o mover los cazas
	update_cazas_basicos(dt, self.navesBasic, balas, player)

	self:updateShots(dt, player)
	
end

function Enemy:render()
	--render de los asteroides
	for i, asteroide in pairs(self.asteroides) do
		asteroide:render()
	end
	for i, cazaBasic in pairs(self.navesBasic) do
		cazaBasic:render()
	end
	self.engineShot:render()
end

function Enemy:ajuste_nivel(dt)
	if self.nivel == 1 then
		self.chance_asteroides = 99
		self.chance_naveBasic = 98
	elseif self.nivel == 2 then
		self.chance_asteroides = 98
		self.chance_naveBasic = 96
	elseif self.nivel == 3 then
		self.chance_asteroides = 96
		self.chance_naveBasic = 92
	elseif self.nivel == 4 then
		self.chance_asteroides = 92
		self.chance_naveBasic = 84
	elseif self.nivel == 5 then
		self.chance_asteroides = 84
		self.chance_naveBasic = 84
	elseif self.nivel == 6 then
		self.chance_asteroides = 92
		self.chance_naveBasic = 84
	end

	self:create_enemy(dt)
end

function Enemy:create_enemy(dt)
	enemy_timer = enemy_timer - dt
	if enemy_timer <= 0 then
		if math.random(0,100) >= self.chance_asteroides and self.nivel < 6 then
			table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
		elseif math.random(0,100) >= self.chance_asteroides then
			table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-100, 100), math.random(40, 200)))
		end
		if math.random(0,100) >= self.chance_naveBasic and self.nivel < 6 then
			table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 50))
		elseif math.random(0,100) >= self.chance_naveBasic then
			table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 100))
		end
		enemy_timer = 0.05
	end
end

function Enemy:updateShots(dt, player)
	shot_timer = shot_timer - dt
	if shot_timer <= 0 then
		if math.random(0,100) >= 80 then
			if table.getn(self.navesBasic) > 0 then
				target = math.random(1,table.getn(self.navesBasic))
				self.engineShot:setCannon(self.navesBasic[target].x + 25, self.navesBasic[target].y + 40)
				target = 0 
			end
		end
		shot_timer = 0.05
	end
	self.engineShot:update(dt)
	self.engineShot:collidesShots(player)
end

return Enemy
