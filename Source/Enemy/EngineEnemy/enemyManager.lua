Enemy = Class{}

local MAX_CHANCE = 100

function Enemy:init()
	self.nivel = 1

	stage_checkpoint = 0;

	self.asteroides = {}
	self.max_on_screen_asteroides = 0
	self.chance_asteroides = 0

	self.asteroidesG = {}
	self.max_on_screen_asteroidesG = 0
	self.chance_asteroidesG = 0

	self.asteroidesM = {}
	self.max_on_screen_asteroidesM = 0
	self.chance_asteroidesM = 0

	self.nebulosas = {}
	self.max_on_screen_nebulosas = 0
	self.chance_nebulosas= 0

	self.navesBasic = {}
	self.max_on_screen_naveBasic = 0
	self.chance_naveBasic = 0

	self.drones = {}
	self.max_on_screen_drones = 0
	self.chance_drones = 0
	self.velodron = 0

	self.huntersMasters = {}
	self.max_on_screen_huntersMasters = 0
	self.chance_huntersMasters = 0

	self.huntersSlaves = {}
	self.max_on_screen_huntersSlaves = 0
	self.chance_huntersSlaves = 0

	self.lancers = {}
	self.max_on_screen_lancers = 0
	self.chance_lancers = 0

	self.cruceros = {}
	self.max_on_screen_cruceros = 0
	self.chance_cruceros = 0

	self.capitales = {}
	self.max_on_screen_capital = 0
	self.chance_capital = 0

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
	update_asteroides(dt, self.asteroides, balas, player)

	update_asteroidesM(dt, self.asteroidesM, balas, player, self.asteroides)

	update_asteroidesG(dt, self.asteroidesG, balas, player)

	--Si hay nubes de nebulosa, hacemos su update
	update_nebulosas(dt, self.nebulosas, player, self.navesBasic, self.drones)

	--Checamos cuando debemos remover o mover los cazas
	update_nave_enemiga(dt, self.navesBasic, balas, player)

	--Checamos cuando debemos remover or mover los drones
	update_nave_enemiga(dt, self.drones, balas, player)

	--Checamos cuando debemos remover or mover los hunterMaster
	update_nave_enemiga(dt, self.huntersMasters, balas, player)

	--Checamos cuando debemos remover or mover los hunterSlaves
	update_nave_enemiga(dt, self.huntersSlaves, balas, player)

	--Checamos cuando debemos remover or mover los lancers
	update_nave_enemiga(dt, self.lancers, balas, player)

	--Checamos cuando debemos remover or mover los cruceros
	update_nave_enemiga(dt, self.cruceros, balas, player)

	--Checamos cuando debemos remover or mover la nave capital
	update_nave_enemiga(dt, self.capitales, balas, player)

	self:updateShots(dt, player, balas)

	--Funcion encargada de ver que solo se creen enemigos que falten por completar, y si ya no hay, cambia el stage regresando true
	return self:check_stage(dt, player)
	
end

function Enemy:check_stage(dt, player)
	if stage_checkpoint <= 0 or stage_checkpoint == nil  then
		return true
	else
		if self.tag_stage == 'normal' then
			self:create_enemy(dt, player, 'naveBasic')
			self:create_enemy(dt, player, 'dron')
			self:create_enemy(dt, player, 'Lancer')
			self:create_enemy(dt, player, 'HunterSlave')
			self:create_enemy(dt, player, 'crucero')
			self:create_enemy(dt, player, 'capital')
		elseif self.tag_stage == 'enjambre' then
			self:create_enemy(dt, player, 'dron')
		elseif self.tag_stage == 'cint_ast' then
			self:create_enemy(dt, player, 'asteroide')
			self:create_enemy(dt, player, 'asteroideM')
			self:create_enemy(dt, player, 'asteroideG')
		elseif self.tag_stage == 'hunters' then
			self:create_enemy(dt, player, 'HunterMaster')
		elseif self.tag_stage == 'nebulosa' then
			self:create_enemy(dt, player, 'nebulosa')
			self:create_enemy(dt, player, 'naveBasic')
			self:create_enemy(dt, player, 'dron')
		end
	end
	return false
end

function Enemy:cambio_stage()

	--Asignamos un nuevo puntaje que tenemos que alcanzar para cambiar de stage
	stage_checkpoint = 5000 * self.nivel

	--dependiendo del tipo de stage, asignamos los enemigos que se van a crear
	if self.tag_stage == 'normal' then
		self.max_on_screen_naveBasic = 5 + love.math.random(self.nivel, self.nivel * 2)
		self.chance_naveBasic = 10 + self.nivel * 2

		self.max_on_screen_drones = 5 + love.math.random(self.nivel, self.nivel * 2)
		self.chance_drones = 5 + self.nivel * 2
		self.velodron = 80 + self.nivel * 10

		if self.nivel >= 2 then
			self.max_on_screen_lancers = 2 + self.nivel
			self.chance_lancers = 5 + self.nivel * 2
		end

		if self.nivel >= 3 then
			self.max_on_screen_cruceros = 3 - (#self.capitales * 2)
			self.chance_cruceros = 10 + self.nivel * 2
		end

		if self.nivel >= 5 then
			self.max_on_screen_capital = 1
			self.chance_capital = 5
		end
		

		if self.nivel >= 6 then
			self.max_on_screen_huntersSlaves = self.nivel - 5
			self.chance_huntersSlaves = 10 + self.nivel * 2
		end

		
	elseif self.tag_stage == 'cint_ast' then
		self.max_on_screen_asteroides = 5 + self.nivel * 5
		self.chance_asteroides = 15 + self.nivel * 2

		self.max_on_screen_asteroidesM = 2 + self.nivel * 2
		self.chance_asteroidesM = 10 + self.nivel * 2

		self.max_on_screen_asteroidesG = 3
		self.chance_asteroidesG = 5 + self.nivel

	elseif self.tag_stage == 'enjambre' then
		self.max_on_screen_drones = 20 + self.nivel * 2
		self.chance_drones = 80 + self.nivel * 2
		self.velodron = 160 + self.nivel * 10

	elseif self.tag_stage == 'hunters' then
		self.max_on_screen_huntersMasters = self.nivel
		self.chance_huntersMasters = 10 + self.nivel * 2

	elseif self.tag_stage == 'nebulosa' then
		self.max_on_screen_nebulosas = 4
		self.chance_nebulosas = 15 + self.nivel * 2

		self.max_on_screen_naveBasic = 5 + love.math.random(self.nivel, self.nivel * 2)
		self.chance_naveBasic = 10 + self.nivel * 2

		self.max_on_screen_drones = 5 + love.math.random(self.nivel, self.nivel * 2)
		self.chance_drones = 5 + self.nivel * 2
		self.velodron = 80 + self.nivel * 10
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
		--Creacion de nebulosas
		if tipo == 'nebulosa' then
			if table.getn(self.nebulosas) < self.max_on_screen_nebulosas and self.nivel < 6 then
				if (MAX_CHANCE - self.chance_nebulosas) < love.math.random(MAX_CHANCE) then
					table.insert(self.nebulosas, Nebulosa(math.random(0, WINDOW_WIDTH -250), -495, math.random(-50, 50), math.random(20, 100)))
				end
			elseif table.getn(self.nebulosas) < self.max_on_screen_nebulosas then
				if (MAX_CHANCE - self.chance_nebulosas) < love.math.random(MAX_CHANCE) then
					table.insert(self.nebulosas, Nebulosa(math.random(0, WINDOW_WIDTH -250), -495, math.random(-100, 100), math.random(40, 200)))
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
			if table.getn(self.drones) < self.max_on_screen_drones then
				if (MAX_CHANCE - self.chance_drones) < love.math.random(MAX_CHANCE) then
					table.insert(self.drones, Drone(math.random(0, WINDOW_WIDTH -50), -15, self.velodron, player))
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
		--Creacion de HunterSalves todos mensos jaja xddd
		if tipo == 'HunterSlave' then
			if table.getn(self.huntersSlaves) < self.max_on_screen_huntersSlaves then
				if (MAX_CHANCE - self.chance_huntersSlaves) < love.math.random(MAX_CHANCE) then
					table.insert(self.huntersSlaves, HunterSlave(math.random(0, WINDOW_WIDTH), -34, 200, WINDOW_WIDTH, WINDOW_HEIGHT))
				end
			end
		end
		--Creacion de Lancer
		if tipo == 'Lancer' then
			if table.getn(self.lancers) < self.max_on_screen_lancers then
				if (MAX_CHANCE - self.chance_lancers) < love.math.random(MAX_CHANCE) then
					if love.math.random(1,2) == 1 then
						table.insert(self.lancers, Lancer(WINDOW_WIDTH , player.y, 600, true)) --izquierda
					else
						table.insert(self.lancers, Lancer(-50 , player.y, 600, false)) --derecha
					end
				end
			end
		end
		--Creacion de Crucero
		if tipo == 'crucero' then
			if table.getn(self.cruceros) < self.max_on_screen_cruceros then
				if (MAX_CHANCE - self.chance_cruceros) < love.math.random(MAX_CHANCE) then
					table.insert(self.cruceros, Crucero(love.math.random(10, 50)))
				end
			end
		end
		--Creacion de Nave Capital
		if tipo == 'capital' then
			if table.getn(self.capitales) < self.max_on_screen_capital then
				if (MAX_CHANCE - self.chance_capital) < love.math.random(MAX_CHANCE) then
					table.insert(self.capitales, Capital(love.math.random(10, 30)))
				end
			end
		end
		enemy_timer = 0.25
	end
end

function Enemy:updateShots(dt, player, balas)
	local target = 0
	for i, crucero in pairs(self.cruceros) do
		for j, torreta in pairs(crucero.torretas) do
			if torreta.disparo == true and torreta.tipo == 'torreta_cannon' then
				self.engineShot:setSmartCannon(torreta.x + (torreta.width/2), torreta.y + (torreta.height/2), player, 400)
				torreta.cooldown = true
				torreta.disparo = false
			end
			if torreta.disparo == true and torreta.tipo == 'torreta_photon' then
				self.engineShot:setPhEnemy(torreta.x + (torreta.width/2), torreta.y + (torreta.height/2), player, 600)
				torreta.cooldown = true
				torreta.disparo = false
			end
		end
	end
	for i, capital in pairs(self.capitales) do
		for j, torreta in pairs(capital.torretas) do
			if torreta.disparo == true and torreta.tipo == 'torreta_cannon' then
				self.engineShot:setSmartCannon(torreta.x + (torreta.width/2), torreta.y + (torreta.height/2), player, 400)
				torreta.cooldown = true
				torreta.disparo = false
			end
			if torreta.disparo == true and torreta.tipo == 'torreta_photon' then
				self.engineShot:setPhEnemy(torreta.x + (torreta.width/2), torreta.y + (torreta.height/2), player, 600)
				torreta.cooldown = true
				torreta.disparo = false
			end
			if torreta.disparo == true and torreta.tipo == 'torreta_disco' then
				self.engineShot:setDiscEnergy(torreta.x + (torreta.width/2), torreta.y + (torreta.height/2), player, 300)
				torreta.cooldown = true
				torreta.disparo = false
			end
		end
	end
	shot_timer = shot_timer - dt
	if shot_timer <= 0 then
		if table.getn(self.navesBasic) > 0 then
			for i, naveBasic in pairs(self.navesBasic) do
				if love.math.random(0,100) >= 90 and naveBasic.destruible == false then
					self.engineShot:setCannon(naveBasic.x + 25, naveBasic.y + 40)
				end
			end
		end
		
		if table.getn(self.huntersMasters) > 0 then
			for i, hunter in pairs(self.huntersMasters) do
				if love.math.random(0,100) >= 80 and hunter.destruible == false then
					if love.math.random(1,10) >= 9 then
						self.engineShot:setWissil(hunter.x + (hunter.width/2), hunter.y + (hunter.height/2), BULLET_SPEED/2, love.math.random(-100, 100)) 
						TEsound.play('Soundtrack/Effect/Launch Missil.wav', 'static', {'effect'}, VOLUMEN_EFECTOS)
					else
						self.engineShot:setSmartCannon(hunter.x + (hunter.width/2), hunter.y + (hunter.height/2), player, 400)
					end
				end
			end
		end
		if table.getn(self.huntersSlaves) > 0 then
			for i, hunter in pairs(self.huntersSlaves) do
				if love.math.random(0,100) >= 80 and hunter.destruible == false then
					if hunter.tipo == 'tipoMisil' then
						self.engineShot:setWissil(hunter.x + (hunter.width/2), hunter.y + (hunter.height/2), BULLET_SPEED/2, love.math.random(-100, 100)) 
						TEsound.play('Soundtrack/Effect/Launch Missil.wav', 'static', {'effect'}, VOLUMEN_EFECTOS)
					else
						self.engineShot:setSmartCannon(hunter.x + (hunter.width/2), hunter.y + (hunter.height/2), player, 400)
					end
				end
			end
		end

		shot_timer = 0.05
	end
	self.engineShot:update(dt, player)
	self.engineShot:collidesShots(player, balas)
end

function Enemy:vaciar_enemigos()
	for i, asteroide in pairs(self.asteroides) do
		table.remove(self.asteroides, i)
	end
	for i, asteroideG in pairs(self.asteroidesG) do
		table.remove(self.asteroidesG, i)
	end
	for i, asteroideM in pairs(self.asteroidesM) do
		table.remove(self.asteroidesM, i)
	end
	for i, nebulosas in pairs(self.nebulosas) do
		table.remove(self.nebulosas, i)
	end
	for i, navesBasic in pairs(self.navesBasic) do
		table.remove(self.navesBasic, i)
	end
	for i, drones in pairs(self.drones) do
		table.remove(self.drones, i)
	end
	for i, huntersMasters in pairs(self.huntersMasters) do
		table.remove(self.huntersMasters, i)
	end
	for i, huntersSlaves in pairs(self.huntersSlaves) do
		table.remove(self.huntersSlaves, i)
	end
	for i, lancers in pairs(self.lancers) do
		table.remove(self.lancers, i)
	end
	for i, crucero in pairs(self.cruceros) do
		table.remove(self.cruceros, i)
	end
	for i, capital in pairs(self.capitales) do
		table.remove(self.capital, i)
	end

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
	for i, capital in pairs(self.capitales) do
		capital:render()
	end
	for i, crucero in pairs(self.cruceros) do
		crucero:render()
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
	for i, HunterSlave in pairs(self.huntersSlaves) do
		HunterSlave:render()
	end
	for i, Lancer in pairs(self.lancers) do
		Lancer:render()
	end

	self.engineShot:render()

end

function Enemy:render_nebulosas()
	for i, nebulosa in pairs(self.nebulosas) do
		nebulosa:render()
	end
end


return Enemy
