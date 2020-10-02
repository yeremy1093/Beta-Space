--Aqui van las funsiones que checan colisiones entre objetos como asteroides, enemigos, balas, etc.

function update_asteroides(dt, asteroides, balas, nave)
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do
		if false == asteroide:update(dt) then
			table.remove(asteroides, i)
		end
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x < -asteroide.width or asteroide.y < -asteroide.height then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and asteroide.destruible == false and bala.destruible == false then
				puntaje = puntaje + 10
				stage_checkpoint = stage_checkpoint - 10
				asteroide.hp = asteroide.hp - bala.damage
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},
					VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	colision_entre_asteroides(asteroides)

	--Checamos si el asteroide choca con la nave
	for j, asteroide in pairs(asteroides) do
		if asteroide:collides(nave) and asteroide.destruible == false then
			asteroide.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 20
				stage_checkpoint = stage_checkpoint + 20
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
end

function update_asteroidesM(dt, asteroides, balas, nave, asteroides_small)
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do
		if asteroide.destruible == true and asteroide.spawn_asteroides == true then
			asteroide.spawn_asteroides = false
			table.insert(asteroides_small, Asteroide(asteroide.x, asteroide.y, math.random(-100, 100), math.random(-200, 200)))
			table.insert(asteroides_small, Asteroide(asteroide.x + 60, asteroide.y + 60, math.random(-100, 100), math.random(-200, 200)))
			table.insert(asteroides_small, Asteroide(asteroide.x + 120, asteroide.y + 120, math.random(-100, 100), math.random(-200, 200)))
		end
		if false == asteroide:update(dt) then
			table.remove(asteroides, i)
		end
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x < -asteroide.width or asteroide.y < -asteroide.height then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and asteroide.destruible == false and bala.destruible == false then
				puntaje = puntaje + 100
				stage_checkpoint = stage_checkpoint - 100
				asteroide.hp = asteroide.hp - bala.damage
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},
					VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	colision_entre_asteroides(asteroides)

	--Checamos si el asteroide choca con la nave
	for j, asteroide in pairs(asteroides) do
		if asteroide:collides(nave) and asteroide.destruible == false then
			asteroide.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 50
				stage_checkpoint = stage_checkpoint + 50
				HPnave = HPnave + 5
				asteroide.hp = asteroide.hp - 5
				TEsound.play('Soundtrack/Effect/Explosion Small.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(50)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
					VOLUMEN_EFECTOS)
			end
			if nave.x + nave.width < asteroide.x then --La nave esta a la izquierda
				nave.dirX = -SHIP_SPEED / 3
			else --La nave esta a la derecha
				nave.dirX = SHIP_SPEED / 3
			end
			if nave.y + nave.height < asteroide.y then --La nave esta arriba
				nave.dirY = -SHIP_SPEED / 3
			else --La nave abajo
				nave.dirY = SHIP_SPEED / 3
			end
			break
		end
	end
end

function update_asteroidesG(dt, asteroides, balas, nave)
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do

		asteroide:update(dt)
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x < -asteroide.width or asteroide.y < -asteroide.height then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and bala.destruible == false then
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},
					VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	colision_entre_asteroides(asteroides)

	--Checamos si el asteroide choca con la nave
	for j, asteroide in pairs(asteroides) do
		if asteroide:collides(nave) then
			if escudo_nave == false then
				puntaje = puntaje - 100
				stage_checkpoint = stage_checkpoint + 100
				HPnave = HPnave + 5
				TEsound.play('Soundtrack/Effect/Explosion Small.wav', 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
					VOLUMEN_EFECTOS)
			end

			if nave.x + nave.width < asteroide.x then --La nave esta a la izquierda
				nave.dirX = -SHIP_SPEED /2
			else --La nave esta a la derecha
				nave.dirX = SHIP_SPEED /2
			end
			if nave.y + nave.height < asteroide.y then --La nave esta arriba
				nave.dirY = -SHIP_SPEED /2
			else --La nave abajo
				nave.dirY = SHIP_SPEED /2
			end
			break
		end
	end
end

function update_nave_enemiga(dt, enemigos, balas, nave)
	--checamos si el enemigo salio de la pantalla y la borramos
	for i, enemigo in pairs(enemigos) do
		
		if false == enemigo:update(dt, nave, balas) then
			table.remove(enemigos, i)
		end
		
		if enemigo.y > WINDOW_HEIGHT or enemigo.x > WINDOW_WIDTH or enemigo.x < -enemigo.width or enemigo.y < -35 then
			table.remove(enemigos, i)
		end
	end

	--Aqui checamos las colisiones entre el enemigo y balas del jugador
	for i, bala in pairs(balas) do
		for j, enemigo in pairs(enemigos) do
			if enemigo:collides(bala) and enemigo.destruible == false and bala.destruible == false then
				if enemigo.clase == 'caza' or enemigo.clase == 'hunter' or enemigo.clase == 'Lancer' then
					puntaje = puntaje + 100
					stage_checkpoint = stage_checkpoint - 100
				elseif enemigo.clase == 'dron' then
					puntaje = puntaje + 150
					stage_checkpoint = stage_checkpoint - 150
				end
				enemigo.hp = enemigo.hp - bala.damage
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
				
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				break
			end
		end
	end

	--Checamos si el enemigo choca con la nave
	for j, enemigo in pairs(enemigos) do
		if enemigo:collides(nave) and enemigo.destruible == false then
			enemigo.destruible = true
			if escudo_nave == false then
				puntaje = puntaje - 50
				stage_checkpoint = stage_checkpoint + 50
				HPnave = HPnave + 2
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			else
				nave.escudo:golpe_escudo(20)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},	VOLUMEN_EFECTOS)
			end
			break
		end
	end
end


function colision_entre_asteroides(asteroides)
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
end