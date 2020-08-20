Enemy = Class{}

function Enemy:init()
	self.nivel = 1
	self.tipos_enemigos = {'asteroide_small'}

	self.asteroides = {}
	self.populate_asteroides = 0

	self.navesBasic = {}
	self.populate_naveBasic = 0

	self.drones = {}
	self.populate_drones = 0

	self.engineShot = EngineShot()

	self.hunter = 0

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

	self:create_enemy(dt, player)
	
	--Checamos cuando debemos remover o mover los asteroides
	update_asteroides(dt, self.asteroides, balas, player)

	--Checamos cuando debemos remover o mover los cazas
	update_cazas_basicos(dt, self.navesBasic, balas, player)

	--Checamos cuando debemos remover or mover los drones
	update_drones(dt, self.drones, balas, player)

	self:updateShots(dt, player)
	
	if self.hunter == 0 then
		self.hunter = HunterMaster(WINDOW_WIDTH/2,0,player,50,WINDOW_WIDTH,WINDOW_HEIGHT,300)
	else
		self.hunter:update(dt,player)
	end
	
end

function Enemy:render()
	--render de los asteroides
	for i, asteroide in pairs(self.asteroides) do
		asteroide:render()
	end
	for i, cazaBasic in pairs(self.navesBasic) do
		cazaBasic:render()
	end
	for i, Drone in pairs(self.drones) do
		Drone:render()
	end
	self.engineShot:render()
	if self.hunter ~= 0 then
		self.hunter:render()
	end
end

function Enemy:ajuste_nivel(dt)
	if self.nivel == 1 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 5
		self.populate_drones = 0
	elseif self.nivel == 2 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 10
		self.populate_drones = 0
	elseif self.nivel == 3 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 20
		self.populate_drones = 5
	elseif self.nivel == 4 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 25
		self.populate_drones = 10
	elseif self.nivel == 5 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 30
		self.populate_drones = 15
	elseif self.nivel == 6 then
		self.populate_asteroides = 10
		self.populate_naveBasic = 30
		self.populate_drones = 15
	end
end

function Enemy:create_enemy(dt, player)
	enemy_timer = enemy_timer - dt
	if enemy_timer <= 0 then
		--Creacion de Asteroides
		if table.getn(self.asteroides) <= self.populate_asteroides and self.nivel < 6 then
			table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
		elseif table.getn(self.asteroides) <= self.populate_asteroides then
			table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-100, 100), math.random(40, 200)))
		end
		--Creacion de Naves Basicas
		if table.getn(self.navesBasic) <= self.populate_naveBasic and self.nivel < 6 then
			table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 50))
		elseif table.getn(self.navesBasic) <= self.populate_naveBasic then
			table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 100))
		end
		--Creacion de Drones
		if table.getn(self.drones) <= self.populate_drones and self.nivel < 6 then
			table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player)) 
		elseif math.random(0,100) <= self.populate_drones then
			table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player))
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
