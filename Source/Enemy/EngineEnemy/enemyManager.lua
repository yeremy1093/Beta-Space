Enemy = Class{}

local MAX_CHANCE = 100

function Enemy:init()
	self.nivel = 1

	self.asteroides = {}
	self.max_on_screen_asteroides = 0
	self.chance_asteroides = 0
	self.checkpoint_asteroides = 0

	self.asteroidesG = {}
	self.max_on_screen_asteroidesG = 0
	self.chance_asteroidesG = 0

	self.asteroidesM = {}
	self.max_on_screen_asteroidesM = 0
	self.chance_asteroidesM = 0
	self.checkpoint_asteroidesM = 0

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

	--Tags para los tipos de stage: cint_ast, hunters, enjambre, nebulosa, normal
	self.tag_stage = 'cint_ast'

end

function Enemy:update(dt, puntuacion, balas, player)

	if puntuacion >= 1024000 then
		self.nivel = 11
	elseif puntuacion >= 512000 then
		self.nivel = 10
	elseif puntuacion >= 256000 then
		self.nivel = 9
	elseif puntuacion >= 128000 then
		self.nivel = 8
	elseif puntuacion >= 64000 then
		self.nivel = 7
	elseif puntuacion >= 32000 then
		self.nivel = 6
	elseif puntuacion >= 16000 then
		self.nivel = 5
	elseif puntuacion >= 8000 then
		self.nivel = 4
	elseif puntuacion >= 4000 then
		self.nivel = 3
	elseif puntuacion >= 2000 then
		self.nivel = 2
	end
	
	--Checamos cuando debemos remover o mover los asteroides
	if update_asteroides(dt, self.asteroides, balas, player) then
		self.checkpoint_asteroides = self.checkpoint_asteroides - 1
	end

	if update_asteroidesM(dt, self.asteroidesM, balas, player, self.asteroides) then
		self.checkpoint_asteroidesM = self.checkpoint_asteroidesM - 1
	end

	update_asteroidesG(dt, self.asteroidesG, balas, player)

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
	if self.checkpoint_asteroides <= 0 
		and self.checkpoint_huntersMasters <= 0
		and self.checkpoint_asteroidesM <= 0 
		and self.checkpoint_naveBasic <= 0 
		and self.checkpoint_drones <= 0 then

		return true
	else
		if self.checkpoint_asteroides > 0 then
			self:create_enemy(dt, player, 'asteroide')
		end
		if self.checkpoint_asteroidesM > 0 then
			self:create_enemy(dt, player, 'asteroideM')
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
		if self.tag_stage == 'cint_ast' then
			self:create_enemy(dt, player, 'asteroideG')
		end
	end
	return false
end

function Enemy:cambio_stage()

	--dependiendo del tipo de stage, asignamos los enemigos que se van a crear
	if self.tag_stage == 'normal' then
		--Los tres valores de las naves normales
		self.checkpoint_naveBasic = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_naveBasic = 5 + self.nivel * 2
		self.chance_naveBasic = 8 + self.nivel * 2
		--Los tres valores de los drones
		self.checkpoint_drones = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_drones = 3 + self.nivel * 2
		self.chance_drones = 8 + self.nivel * 2

	elseif self.tag_stage == 'cint_ast' then
		self.checkpoint_asteroides = love.math.random(self.nivel * 5, self.nivel * 10)
		self.max_on_screen_asteroides = 5 + self.nivel * 5
		self.chance_asteroides = 10 + self.nivel * 2

		self.checkpoint_asteroidesM = love.math.random(self.nivel, self.nivel * 3)
		self.max_on_screen_asteroidesM = 2 + self.nivel * 5
		self.chance_asteroidesM = 4 + self.nivel * 2

		self.max_on_screen_asteroidesG = 3
		self.chance_asteroidesG = 5 + self.nivel

	elseif self.tag_stage == 'enjambre' then
		self.checkpoint_drones = love.math.random(self.nivel * 5, self.nivel * 10)
		self.max_on_screen_drones = 10 + self.nivel * 2
		self.chance_drones = 15 + self.nivel * 2

	elseif self.tag_stage == 'hunters' then
		--Los tres valores de las hunters
		self.checkpoint_huntersMasters = love.math.random(self.nivel, self.nivel * 2)
		self.max_on_screen_huntersMasters = self.nivel
		self.chance_huntersMasters = 10 + self.nivel * 2

	elseif self.tag_stage == 'nebulosa' then
		--Los tres valores de las naves normales
		self.checkpoint_naveBasic = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_naveBasic = 5 + self.nivel * 2
		self.chance_naveBasic = 8 + self.nivel * 2
		--Los tres valores de los drones
		self.checkpoint_drones = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_drones = 3 + self.nivel * 2
		self.chance_drones = 8 + self.nivel * 2
	end

	return self.tag_stage

end

function Enemy:create_enemy(dt, player, tipo)
	enemy_timer = enemy_timer - dt
	if enemy_timer <= 0 then
		--Creacion de Asteroides
		if tipo == 'asteroide' then
			if table.getn(self.asteroides) < self.max_on_screen_asteroides and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_asteroides) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
				end
			elseif table.getn(self.asteroides) < self.max_on_screen_asteroides then
				if (MAX_CHANCE - self.chance_asteroides) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroides, Asteroide(math.random(0, WINDOW_WIDTH -50), -34, math.random(-100, 100), math.random(40, 200)))
				end
			end
		end
		--Creacion de Asteroides Medianos
		if tipo == 'asteroideM' then
			if table.getn(self.asteroidesM) < self.max_on_screen_asteroidesM and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_asteroidesM) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesM, AsteroideM(math.random(0, WINDOW_WIDTH -110), -110, math.random(-50, 50), math.random(20, 100)))
				end
			elseif table.getn(self.asteroidesM) < self.max_on_screen_asteroidesM then
				if (MAX_CHANCE - self.chance_asteroidesM) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesM, AsteroideM(math.random(0, WINDOW_WIDTH -110), -110, math.random(-100, 100), math.random(40, 200)))
				end
			end
		end
		--Creacion de Asteroides Grandes
		if tipo == 'asteroideG' then
			if table.getn(self.asteroidesG) < self.max_on_screen_asteroidesG and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_asteroidesG) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesG, AsteroideG(math.random(0, WINDOW_WIDTH -220), -360, math.random(-50, 50), math.random(10, 80)))
				end
			elseif table.getn(self.asteroidesG) < self.max_on_screen_asteroidesG then
				if (MAX_CHANCE - self.chance_asteroidesG) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesG, AsteroideG(math.random(0, WINDOW_WIDTH -220), -360, math.random(-100, 100), math.random(20, 120)))
				end
			end
		end
		--Creacion de Naves Basicas
		if tipo == 'naveBasic' then
			if table.getn(self.navesBasic) < self.max_on_screen_naveBasic and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_naveBasic) < love.math.random(MAX_CHANCE) then
					table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 50))
				end
			elseif table.getn(self.navesBasic) < self.max_on_screen_naveBasic then
				if (MAX_CHANCE - self.chance_naveBasic) < love.math.random(MAX_CHANCE) then
					table.insert(self.navesBasic, CazaBasic(math.random(0, WINDOW_WIDTH -50), -34, 0, 100))
				end
			end
		end
		--Creacion de Drones
		if tipo == 'dron' then
			if table.getn(self.drones) < self.max_on_screen_drones and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_drones) < love.math.random(MAX_CHANCE) then
					table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player))
				end
			elseif math.random(0,100) < self.max_on_screen_drones then
				if (MAX_CHANCE - self.chance_drones) < love.math.random(MAX_CHANCE) then
					table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -34, 80, player))
				end
			end
		end
		--Creacion de HunterMaster ya se la pelaron muajaja
		if tipo == 'HunterMaster' then
			if table.getn(self.huntersMasters) < self.max_on_screen_huntersMasters then
				if (MAX_CHANCE - self.chance_huntersMasters) < love.math.random(MAX_CHANCE) then
					table.insert(self.huntersMasters, HunterMaster(math.random(0, WINDOW_WIDTH -50), -34, player, WINDOW_WIDTH, WINDOW_HEIGHT, 300))
				end
			end
		end
		enemy_timer = 0.25
	end
end

function Enemy:updateShots(dt, player, balas)
	local target = 0
	shot_timer = shot_timer - dt
	if shot_timer <= 0 then
		if table.getn(self.navesBasic) > 0 then
			for i, naveBasic in pairs(self.navesBasic) do
				if math.random(0,100) >= 90 and naveBasic.destruible == false then
					self.engineShot:setCannon(naveBasic.x + 25, naveBasic.y + 40)
				end
			end
		end
		
		if table.getn(self.huntersMasters) > 0 then
			for i, hunter in pairs(self.huntersMasters) do
				if math.random(0,100) >= 90 and hunter.destruible == false then
					self.engineShot:setSmartCannon(hunter.x + (hunter.width/2), hunter.y + (hunter.height/2), player, 400)
				end
			end
		end
		shot_timer = 0.05
	end
	self.engineShot:update(dt)
	self.engineShot:collidesShots(player, balas)
end

function Enemy:render()
	for i, asteroideG in pairs(self.asteroidesG) do
		asteroideG:render()
	end
	for i, asteroideM in pairs(self.asteroidesM) do
		asteroideM:render()
	end
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
	
end
return Enemy
