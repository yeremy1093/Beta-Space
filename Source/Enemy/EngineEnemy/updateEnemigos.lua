--Aqui van las funsiones que checan colisiones entre objetos como asteroides, enemigos, balas, etc.

function update_asteroides(dt, asteroides, balas, nave)
	--checamos si el asteroide salio de la pantalla y la borramos
	for i, asteroide in pairs(asteroides) do
		if false == asteroide:update(dt) then
			table.remove(asteroides, i)
		end
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x + asteroide.width < 0 or asteroide.y + asteroide.height < 0 then
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
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x + asteroide.width < 0 or asteroide.y + asteroide.height < 0 then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and asteroide.destruible == false and bala.destruible == false then
				local bala_en_lista = false
				for i, bala_usada in pairs(asteroide.balas_usadas) do
					if bala.credential == bala_usada then
						bala_en_lista = true
						break
					end
				end
				if bala_en_lista == false then
					TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
				'static',
				{'effect'},	VOLUMEN_EFECTOS / 2)
					table.insert(asteroide.balas_usadas, bala.credential)
					puntaje = puntaje + 100
					stage_checkpoint = stage_checkpoint - 100
					asteroide.hp = asteroide.hp - bala.damage
				end
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
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
		
		if asteroide.y > WINDOW_HEIGHT or asteroide.x > WINDOW_WIDTH or asteroide.x + asteroide.width < 0 or asteroide.y + asteroide.height < 0 then
			table.remove(asteroides, i)
		end
	end

	--Aqui checamos las colisiones entre asteroides y balas
	for i, bala in pairs(balas) do
		for j, asteroide in pairs(asteroides) do
			if asteroide:collides(bala) and bala.destruible == false then
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
					if bala.y > asteroide.y + asteroide.height-10 then
						asteroide.dy = asteroide.dy - 5
					elseif bala.y < asteroide.y + 10 then
						asteroide.dy = asteroide.dy + 5
					end
					if bala.x > asteroide.x + asteroide.width-10 then
						asteroide.dx = asteroide.dx - 5
					elseif bala.x < asteroide.x + 10 then
						asteroide.dx = asteroide.dx + 5
					end
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

			if nave.x + nave.width <= asteroide.x + 10 then --La nave esta a la izquierda
				nave.x = asteroide.x - nave.width - 2
				nave.dirX = -SHIP_SPEED /2
			elseif nave.x >= asteroide.x + asteroide.width - 10 then --La nave esta a la derecha
				nave.x = asteroide.x + asteroide.width + 2
				nave.dirX = SHIP_SPEED /2
			end
			if nave.y + nave.height <= asteroide.y + 10 then --La nave esta arriba
				nave.y = asteroide.y - nave.height - 2
				nave.dirY = -SHIP_SPEED /2
			elseif nave.y >= asteroide.y + asteroide.height - 10 then --La nave abajo
				nave.y = asteroide.y + asteroide.height + 2
				nave.dirY = SHIP_SPEED /2
			end
			break
		end
	end
end

function update_nave_enemiga(dt, enemigos, balas, nave, pickup)
	--checamos si el enemigo salio de la pantalla y la borramos
	for i, enemigo in pairs(enemigos) do
		
		if false == enemigo:update(dt, nave, balas) then
			if enemigo.clase == 'ingeniero' then
				table.insert(pickup, Pickup((enemigo.x + enemigo.width/2), (enemigo.y + enemigo.height/2), love.math.random(-50, 50), love.math.random(20, 100), love.math.random(2, 4)))
			end
			table.remove(enemigos, i)
		end
		
		if enemigo.y > WINDOW_HEIGHT or enemigo.x > WINDOW_WIDTH or enemigo.x + enemigo.width < 0 or enemigo.y + enemigo.height < 0 then
			table.remove(enemigos, i)
		end
	end

	--Aqui checamos las colisiones entre el enemigo y balas del jugador
	for i, bala in pairs(balas) do
		for j, enemigo in pairs(enemigos) do
			if enemigo:collides(bala) and enemigo.destruible == false and bala.destruible == false then
				if enemigo.clase == 'caza' or enemigo.clase == 'Lancer' 
					or enemigo.clase == 'hunterMenso' or enemigo.clase == 'ingeniero' then
					puntaje = puntaje + 100
					stage_checkpoint = stage_checkpoint - 100
					enemigo.hp = enemigo.hp - bala.damage
					TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				elseif enemigo.clase == 'dron' then
					puntaje = puntaje + 150
					stage_checkpoint = stage_checkpoint - 150
					enemigo.hp = enemigo.hp - bala.damage
					TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
				elseif enemigo.clase == 'capital' then
					local bala_en_lista = false
					for i, bala_usada in pairs(enemigo.balas_usadas) do
						if bala.credential == bala_usada then
							bala_en_lista = true
							break
						end
					end
					if bala_en_lista == false then
						TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
						table.insert(enemigo.balas_usadas, bala.credential)
						puntaje = puntaje + 250
						stage_checkpoint = stage_checkpoint - 250
						local vulnerable = true
						for i, nucleo in pairs(enemigo.nucleos) do
							if nucleo.destruido == false then 
								vulnerable = false
								break
							end
						end

						if vulnerable then 
							enemigo.hp = enemigo.hp - bala.damage
						end
					end
				elseif enemigo.clase == 'crucero' or enemigo.clase == 'hunter' then
					local bala_en_lista = false
					for i, bala_usada in pairs(enemigo.balas_usadas) do
						if bala.credential == bala_usada then
							bala_en_lista = true
							break
						end
					end
					if bala_en_lista == false then
						TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
						table.insert(enemigo.balas_usadas, bala.credential)
						puntaje = puntaje + 100
						stage_checkpoint = stage_checkpoint - 100
						enemigo.hp = enemigo.hp - bala.damage
					end

				end
				if bala.clase ~= 'pulsar' and bala.clase ~= 'pulso' and bala.clase ~= 'rayo' then
					bala.destruible = true
				end
				break
			end
		end
	end

	--Checamos si el enemigo choca con la nave
	for j, enemigo in pairs(enemigos) do
		if enemigo:collides(nave) and enemigo.destruible == false  and enemigo.clase ~= 'crucero' and enemigo.clase ~= 'capital' then
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

function update_nebulosas(dt, nebulosas, nave, cazas, drones)
	--checamos si la nebulosa salio de la pantalla y la borramos
	for i, nebulosa in pairs(nebulosas) do

		nebulosa:update(dt)
		
		if nebulosa.y > WINDOW_HEIGHT or nebulosa.x > WINDOW_WIDTH or nebulosa.x < -nebulosa.width or nebulosa.y < -nebulosa.height then
			table.remove(nebulosas, i)
		end
	end

	--Checamos si la nebulosa choca con la nave
	for j, nebulosa in pairs(nebulosas) do
		if nebulosa:collides(nave) and nebulosa.clase == 'nebulosa_mala' then
			nebulosa.tiempo_damage = nebulosa.tiempo_damage - dt
			if nebulosa.tiempo_damage <= 0 then
				nebulosa.tiempo_damage = 1
				if escudo_nave == false then
					HPnave = HPnave + 1
				else
					nave.escudo:golpe_escudo(10)
				end
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
						VOLUMEN_EFECTOS)
				break
			end
			
		end
	end

	--Checamos si la nebulosa le hace daño a otros enemigos
	nebulosa_enemigos(dt, nebulosas, cazas)
	nebulosa_enemigos(dt, nebulosas, drones)

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

function nebulosa_enemigos(dt , nebulosas ,enemigos)
	for i, nebulosa in pairs(nebulosas) do
		for j, enemigo in pairs(enemigos) do
			if nebulosa:collides(enemigo) and nebulosa.clase == 'nebulosa_mala' then
				nebulosa.tiempo_damage = nebulosa.tiempo_damage - dt
				if nebulosa.tiempo_damage <= 0 then
					nebulosa.tiempo_damage = 1
					enemigo.hp = enemigo.hp - nebulosa.damage
					TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},
							VOLUMEN_EFECTOS)
					break
				end
			end
		end
	end
end