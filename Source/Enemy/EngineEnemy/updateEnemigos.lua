--Aqui van las funsiones que checan colisiones entre objetos como asteroides, enemigos, balas, etc.

function update_asteroides(dt, asteroides, balas, nave)
	local cambiar_checkpoint = false
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do
		if false == asteroide:update(dt) then
			table.remove(asteroides, i)
		end
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x < -asteroide.width or asteroide.y < -35 then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and asteroide.destruible == false then
				cambiar_checkpoint = true
				puntaje = puntaje + 10
				asteroide.destruible = true
				bala.destruible = true
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},
					VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Aqui checamos las colisiones entre asteroides y otros asteroides
	for i, ast1 in pairs(asteroides) do
		for j, ast2 in pairs(asteroides) do
			if ast2:collides(ast1) then
				--Primero movemos el asteroide para que dejen de chocar
				if ast1.x < ast2.x then
					ast1.x = ast1.x - 1
					ast2.x = ast2.x + 1
				else
					ast1.x = ast1.x + 1
					ast2.x = ast2.x - 1
				end
				if ast1.y < ast2.y then
					ast1.y = ast1.y - 1
					ast2.y = ast2.y + 1
				else
					ast1.y = ast1.y + 1
					ast2.y = ast2.y - 1
				end

				--Ahora calculamos la nueva dirección de los asteroides
				tempx = ast1.dx
				tempy = ast1.dy
				ast1.dx = ast2.dx
				ast1.dy = ast2.dy
				ast2.dx = tempx
				ast2.dy = tempy
				break
			end
		end
	end

	--Checamos si el asteroide choca con la nave
	for j, asteroide in pairs(asteroides) do
		if asteroide:collides(nave) and asteroide.destruible == false then
			asteroide.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 5
				HPnave = HPnave + 2
				TEsound.play('Soundtrack/Effect/Explosion Small.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(20)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
					VOLUMEN_EFECTOS)
			end
			break
		end
	end
	return cambiar_checkpoint
end

function update_asteroidesM(dt, asteroides, balas, nave)
	local cambiar_checkpoint = false
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do
		if false == asteroide:update(dt) then
			table.remove(asteroides, i)
			cambiar_checkpoint = true
		end
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x < -asteroide.width or asteroide.y < -35 then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and asteroide.destruible == false and bala.destruible == false then
				
				puntaje = puntaje + 10
				if bala.clase == 'pulsar' or bala.clase == 'pulso' then
					asteroide.hp = asteroide.hp - 5
				elseif bala.clase == 'direccional' or bala.clase == 'misil' then
					asteroide.hp = asteroide.hp - 2
				elseif bala.clase == 'rayo' then
					asteroide.hp = asteroide.hp - 10
				else
					asteroide.hp = asteroide.hp - 1
				end
				bala.destruible = true
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav'},
					'static',
					{'effect'},
					VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Aqui checamos las colisiones entre asteroides y otros asteroides
	for i, ast1 in pairs(asteroides) do
		for j, ast2 in pairs(asteroides) do
			if ast2:collides(ast1) then
				--Primero movemos el asteroide para que dejen de chocar
				if ast1.x < ast2.x then
					ast1.x = ast1.x - 1
					ast2.x = ast2.x + 1
				else
					ast1.x = ast1.x + 1
					ast2.x = ast2.x - 1
				end
				if ast1.y < ast2.y then
					ast1.y = ast1.y - 1
					ast2.y = ast2.y + 1
				else
					ast1.y = ast1.y + 1
					ast2.y = ast2.y - 1
				end

				--Ahora calculamos la nueva dirección de los asteroides
				tempx = ast1.dx
				tempy = ast1.dy
				ast1.dx = ast2.dx
				ast1.dy = ast2.dy
				ast2.dx = tempx
				ast2.dy = tempy
				break
			end
		end
	end

	--Checamos si el asteroide choca con la nave
	for j, asteroide in pairs(asteroides) do
		if asteroide:collides(nave) and asteroide.destruible == false then
			asteroide.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 5
				HPnave = HPnave + 10
				TEsound.play('Soundtrack/Effect/Explosion Small.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(100)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
					VOLUMEN_EFECTOS)
			end
			break
		end
	end
	return cambiar_checkpoint
end
function update_cazas_basicos(dt, cazas, balas, nave)
	local cambiar_checkpoint = false
	--checamos si el cazaBasic salio de la pantalla y la borramos
	for i, cazaBasic in pairs(cazas) do
		if false == cazaBasic:update(dt) then
			table.remove(cazas, i)
		end
		
		if cazaBasic.y > WINDOW_HEIGHT or cazaBasic.x > WINDOW_WIDTH or cazaBasic.x < -cazaBasic.width or cazaBasic.y < -35 then
			table.remove(cazas, i)
		end
	end

	--Aqui checamos las colisiones entre cazas y balas del jugador
	for i, bala in pairs(balas) do
		for j, cazaBasic in pairs(cazas) do
			if cazaBasic:collides(bala) and cazaBasic.destruible == false then
				cambiar_checkpoint = true
				puntaje = puntaje + 100
				cazaBasic.destruible = true
				bala.destruible = true
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Checamos si el caza choca con la nave
	for j, cazaBasic in pairs(cazas) do
		if cazaBasic:collides(nave) and cazaBasic.destruible == false then
			cazaBasic.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 50
				HPnave = HPnave + 2
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(20)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			end
			break
		end
	end
	return cambiar_checkpoint
end

function update_drones(dt, drones, balas, nave)
	local cambiar_checkpoint = false
	--Checamos si el drone ha salido de pantalla o a colisionado con la nave
	for i, Drone in pairs(drones) do
		if false == Drone:update(dt, nave) then
			table.remove(drones, i)
		end
		
		if Drone.y > WINDOW_HEIGHT or Drone.x > WINDOW_WIDTH or Drone.x < -Drone.width or Drone.y < -35 then
			table.remove(drones, i)
		end
	end

	--Aqui checamos las colisiones entre drone y balas del jugador
	for i, bala in pairs(balas) do
		for j, Drone in pairs(drones) do
			if Drone:collides(bala) and Drone.destruible == false then
				cambiar_checkpoint = true
				puntaje = puntaje + 150
				Drone.destruible = true
				bala.destruible = true
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Checamos si el drone choca con la nave
	for j, Drone in pairs(drones) do
		if Drone:collides(nave) and Drone.destruible == false then
			Drone.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 20
				HPnave = HPnave + 2
				TEsound.play('Soundtrack/Effect/HIT normal.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			end
			break
		end
	end
	return cambiar_checkpoint
end

function update_hunterMaster(dt, huntersMasters, balas, nave)
	local cambiar_checkpoint = false
	--Checamos si el hunterMaster ha salido de pantalla o a colisionado con la nave
	for i, HunterMaster in pairs(huntersMasters) do
		if false == HunterMaster:update(dt, nave, balas) then
			table.remove(huntersMasters, i)
		end
		
		if HunterMaster.y > WINDOW_HEIGHT or HunterMaster.x > WINDOW_WIDTH or HunterMaster.x < -HunterMaster.width or HunterMaster.y < -35 then
			table.remove(huntersMasters, i)
		end
	end

	--Aqui checamos las colisiones entre hunterMaster y balas del jugador
	for i, bala in pairs(balas) do
		for j, HunterMaster in pairs(huntersMasters) do
			if HunterMaster:collides(bala) and HunterMaster.destruible == false then
				cambiar_checkpoint = true
				puntaje = puntaje + 150
				HunterMaster.destruible = true
				bala.destruible = true
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Checamos si el hunterMaster choca con la nave
	for j, HunterMaster in pairs(huntersMasters) do
		if HunterMaster:collides(nave) and HunterMaster.destruible == false then
			HunterMaster.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 20
				HPnave = HPnave + 2
				TEsound.play('Soundtrack/Effect/HIT normal.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			end
			break
		end
	end
	return cambiar_checkpoint
end