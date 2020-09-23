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

	self.asteroidesM = {}
	self.max_on_screen_asteroidesM = 0
	self.chance_asteroidesM = 0
	self.checkpoint_asteroidesM = 0


	self.engineShot = EngineShot()

	--Tags para los tipos de stage: cint_ast, hunters, enjambre, nebulosa, normal
	self.tag_stage = 'normal'

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

	if update_asteroidesM(dt, self.asteroidesM, balas, player) then
		self.checkpoint_asteroidesM = self.checkpoint_asteroidesM - 1
	end

	--Checamos cuando debemos remover o mover los cazas
	if update_cazas_basicos(dt, self.navesBasic, balas, player) then
		self.checkpoint_naveBasic = self.checkpoint_naveBasic - 1
	end

	--Checamos cuando debemos remover or mover los drones
	if update_drones(dt, self.drones, balas, player) then
		self.checkpoint_drones = self.checkpoint_drones - 1
	end

	self:updateShots(dt, player, balas)

	--Funcion encargada de ver que solo se creen enemigos que falten por completar, y si ya no hay, cambia el stage regresando true
	return self:check_stage(dt, player)
	
end

function Enemy:check_stage(dt, player)
	if self.checkpoint_asteroides <= 0 

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
	end
	return false
end

function Enemy:cambio_stage(stage)
	--Asignamos un nuevo tipo de stage
	local random_stage = love.math.random(1, 100)
	if random_stage <= 70 then
		self.tag_stage = 'normal'
	elseif random_stage <= 80 then
		self.tag_stage = 'cint_ast'
	elseif random_stage <= 90 then
		self.tag_stage = 'enjambre'
	elseif random_stage <= 95 then
		self.tag_stage = 'hunters'
	else
		self.tag_stage = 'nebulosa'
	end

	--dependiendo del tipo de stage, asignamos los enemigos que se van a crear
	if self.tag_stage == 'normal' then
		--Los tres valores de las naves normales
		self.checkpoint_naveBasic = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_naveBasic = 5 + self.nivel * 2
		self.chance_naveBasic = 5 + self.nivel * 2
		--Los tres valores de los drones
		self.checkpoint_drones = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_drones = 3 + self.nivel * 2
		self.chance_drones = 3 + self.nivel * 2

	elseif self.tag_stage == 'cint_ast' then
		self.checkpoint_asteroides = love.math.random(self.nivel * 5, self.nivel * 10)
		self.max_on_screen_asteroides = 5 + self.nivel * 5
		self.chance_asteroides = 5 + self.nivel * 2

	elseif self.tag_stage == 'enjambre' then
		self.checkpoint_drones = love.math.random(self.nivel * 5, self.nivel * 10)
		self.max_on_screen_drones = 10 + self.nivel * 2
		self.chance_drones = 10 + self.nivel * 2

	elseif self.tag_stage == 'hunters' then
		--Los tres valores de las naves normales
		self.checkpoint_naveBasic = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_naveBasic = 5 + self.nivel * 2
		self.chance_naveBasic = 5 + self.nivel * 2
		--Los tres valores de los drones
		self.checkpoint_drones = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_drones = 3 + self.nivel * 2
		self.chance_drones = 3 + self.nivel * 2

	elseif self.tag_stage == 'nebulosa' then
		--Los tres valores de las naves normales
		self.checkpoint_naveBasic = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_naveBasic = 5 + self.nivel * 2
		self.chance_naveBasic = 5 + self.nivel * 2
		--Los tres valores de los drones
		self.checkpoint_drones = love.math.random(self.nivel * 2, self.nivel * 5)
		self.max_on_screen_drones = 3 + self.nivel * 2
		self.chance_drones = 3 + self.nivel * 2
	end

	return self.tag_stage

end

function Enemy:render()
	--render de los asteroides
	for i, asteroideM in pairs(self.asteroidesM) do
		asteroideM:render()
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

	love.graphics.print(tostring(self.checkpoint_asteroides), WINDOW_WIDTH - 100, 20)
	love.graphics.print(tostring(self.checkpoint_naveBasic), WINDOW_WIDTH - 100, 80)
	love.graphics.print(tostring(self.checkpoint_drones), WINDOW_WIDTH - 100, 140)
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

		if tipo == 'asteroideM' then
			if table.getn(self.asteroidesM) <= self.max_on_screen_asteroidesM and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_asteroidesM) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesM, AsteroideM(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
				end
			elseif table.getn(self.asteroidesM) <= self.max_on_screen_asteroidesM then
				if (MAX_CHANCE - self.chance_asteroidesM) < love.math.random(MAX_CHANCE) then
					table.insert(self.asteroidesM, AsteroideM(math.random(0, WINDOW_WIDTH -50), -34, math.random(-100, 100), math.random(40, 200)))
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
