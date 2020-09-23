Enemy = Class{}

local MAX_CHANCE = 100

function Enemy:init()
	self.nivel = 1
	self.tipos_enemigos = {'asteroide_small'}

	self.asteroides = {}
	self.max_on_screen_asteroides = 0
	self.chance_asteroides = 0
	self.checkpoint_asteroides = 0

	self.navesBasic = {}
	self.max_on_screen_naveBasic = 0
	self.chance_naveBasic = 0
	self.checkpoint_naveBasic = 0

	self.drones = {}
	self.max_on_screen_drones = 0
	self.chance_drones = 0
	self.checkpoint_drones = 0

	self.huntersMasters = {}
	self.max_on_screen_huntersMasters = 0
	self.chance_huntersMasters = 0
	self.checkpoint_huntersMasters = 0

	self.engineShot = EngineShot()

end

function Enemy:update(dt, puntuacion, balas, player)
	if puntuacion >= 150000 then
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
	if update_asteroides(dt, self.asteroides, balas, player) then
		self.checkpoint_asteroides = self.checkpoint_asteroides - 1
	end

	--Checamos cuando debemos remover o mover los cazas
	if update_cazas_basicos(dt, self.navesBasic, balas, player) then
		self.checkpoint_naveBasic = self.checkpoint_naveBasic - 1
	end

	--Checamos cuando debemos remover or mover los drones
	if update_drones(dt, self.drones, balas, player) then
		self.checkpoint_drones = self.checkpoint_drones - 1
	end

	--Checamos cuando debemos remover or mover los hunterMaster
	if update_hunterMaster(dt, self.huntersMasters, balas, player) then
		self.checkpoint_huntersMasters = self.checkpoint_huntersMasters - 1
	end

	self:updateShots(dt, player, balas)

	--Funcion encargada de ver que solo se creen enemigos que falten por completar, y si ya no hay, cambia el stage regresando true
	return self:check_stage(dt, player)
	
end

function Enemy:check_stage(dt, player)
	if self.checkpoint_asteroides <= 0 and self.checkpoint_naveBasic <= 0 and self.checkpoint_drones <= 0 and 
		self.checkpoint_huntersMasters <= 0 then
		return true
	else
		if self.checkpoint_asteroides > 0 then
			self:create_enemy(dt, player, 'asteroide')
		end
		if self.checkpoint_naveBasic > 0 then
			self:create_enemy(dt, player, 'naveBasic')
		end
		if self.checkpoint_drones > 0 then
			self:create_enemy(dt, player, 'dron')
		end
		if self.checkpoint_huntersMasters > 0 then
			self:create_enemy(dt, player, 'HunterMaster')
		end
	end
	return false
end

function Enemy:cambio_stage(stage)
	--Falta la parte que crea stage especiales
	self.checkpoint_naveBasic = love.math.random(5, stage * 5)

	self.checkpoint_drones = love.math.random(3, stage * 10)

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
	for i, HunterMaster in pairs(self.huntersMasters) do
		HunterMaster:render()
	end
	self.engineShot:render()

	love.graphics.print(tostring(self.checkpoint_asteroides), WINDOW_WIDTH - 100, 20)
	love.graphics.print(tostring(self.checkpoint_naveBasic), WINDOW_WIDTH - 100, 80)
	love.graphics.print(tostring(self.checkpoint_drones), WINDOW_WIDTH - 100, 140)
end

function Enemy:ajuste_nivel(dt)
	if self.nivel == 1 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 10
		self.max_on_screen_naveBasic = 5
		self.chance_naveBasic = 10
		self.max_on_screen_drones = 10
		self.chance_drones = 10
		self.max_on_screen_huntersMasters = 1
		self.chance_huntersMasters = 100
	elseif self.nivel == 2 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 20
		self.max_on_screen_naveBasic = 10
		self.chance_naveBasic = 20
		self.max_on_screen_drones = 10
		self.chance_drones = 10
		self.max_on_screen_huntersMasters = 0
		self.chance_huntersMasters = 0
	elseif self.nivel == 3 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 30
		self.max_on_screen_naveBasic = 10
		self.chance_naveBasic = 20
		self.max_on_screen_drones = 15
		self.chance_drones = 20
		self.max_on_screen_huntersMasters = 0
		self.chance_huntersMasters = 0
	elseif self.nivel == 4 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 30
		self.max_on_screen_naveBasic = 15
		self.chance_naveBasic = 30
		self.max_on_screen_drones = 10
		self.chance_drones = 30
		self.max_on_screen_huntersMasters = 0
		self.chance_huntersMasters = 0
	elseif self.nivel == 5 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 30
		self.max_on_screen_naveBasic = 15
		self.max_on_screen_drones = 15
		self.chance_drones = 30
		self.max_on_screen_huntersMasters = 1
		self.chance_huntersMasters = 20
	elseif self.nivel == 6 then
		self.max_on_screen_asteroides = 10
		self.chance_asteroides = 30
		self.max_on_screen_naveBasic = 15
		self.chance_naveBasic = 40
		self.max_on_screen_drones = 15
		self.chance_drones = 40
		self.max_on_screen_huntersMasters = 3
		self.chance_huntersMasters = 35
	end
end

function Enemy:create_enemy(dt, player, tipo)
	enemy_timer = enemy_timer - dt
	if enemy_timer <= 0 then
		--Creacion de Asteroides
		if tipo == 'asteroide' then
			if table.getn(self.asteroides) <= self.max_on_screen_asteroides and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_asteroides) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
				end
			elseif table.getn(self.asteroides) <= self.max_on_screen_asteroides then
				if (MAX_CHANCE - self.chance_asteroides) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-100, 100), math.random(40, 200)))
				end
			end
		end
		--Creacion de Naves Basicas
		if tipo == 'naveBasic' then
			if table.getn(self.navesBasic) <= self.max_on_screen_naveBasic and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_naveBasic) < love.math.random(MAX_CHANCE) then
					table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 50))
				end
			elseif table.getn(self.navesBasic) <= self.max_on_screen_naveBasic then
				if (MAX_CHANCE - self.chance_naveBasic) < love.math.random(MAX_CHANCE) then
					table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 100))
				end
			end
		end
		--Creacion de Drones
		if tipo == 'dron' then
			if table.getn(self.drones) <= self.max_on_screen_drones and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_drones) < love.math.random(MAX_CHANCE) then
					table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player))
				end
			elseif math.random(0,100) <= self.max_on_screen_drones then
				if (MAX_CHANCE - self.chance_drones) < love.math.random(MAX_CHANCE) then
					table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player))
				end
			end
		end
		--Creacion de HunterMaster ya se la pelaron muajaja
		if tipo == 'HunterMaster' then
			if table.getn(self.huntersMasters) <= self.max_on_screen_huntersMasters then
				if (MAX_CHANCE - self.chance_huntersMasters) < love.math.random(MAX_CHANCE) then
					table.insert(self.huntersMasters, HunterMaster(math.random(0, WINDOW_WIDTH -50), -34, player, WINDOW_WIDTH, WINDOW_HEIGHT, 300))
				end
			end
		end
		enemy_timer = 0.25
	end
end

function Enemy:updateShots(dt, player, balas)
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
	self.engineShot:collidesShots(player, balas)
end

return Enemy
