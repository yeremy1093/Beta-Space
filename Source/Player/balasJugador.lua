--Funciones que tienen que ver con listas de objetos en distintos estados

function move_bala(dt, balas)
		--Hacemos un ciclo en el que se haga update de todas las balas
	for i, bala in pairs(balas) do
		if bala:update(dt) == false then
            table.remove(balas, i)
        end
		--checamos si la bala salio de la pantalla y la borramos
		if bala.y < 0 or bala.y > WINDOW_HEIGHT or bala.x < 0 or bala.x > WINDOW_WIDTH then
			table.remove(balas, i)
		end
	end
end

function disparo_jugador(balas, player)
	if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('A') then
    	table.insert(balas, Bala(player.x + player.width/2 - 3, player.y, BULLET_SPEED, 0, 0))
    	TEsound.play('Soundtrack/Effect/soundLaser1.wav', 'static')
    end
    if love.keyboard.wasPressed('s') or love.keyboard.wasPressed('S') then
    	if love.keyboard.isDown('up') and  love.keyboard.isDown('left')then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 8))
    	elseif love.keyboard.isDown('up') and  love.keyboard.isDown('right') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 5))
    	elseif love.keyboard.isDown('down') and  love.keyboard.isDown('left') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 7))
    	elseif love.keyboard.isDown('down') and  love.keyboard.isDown('right') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 6))
    	elseif love.keyboard.isDown('up') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 1))
    	elseif love.keyboard.isDown('down') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 2))
    	elseif love.keyboard.isDown('left') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 4))
    	elseif love.keyboard.isDown('right') then
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 3))
    	else
    		table.insert(balas, Bala(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1, 1))
    	end
    	TEsound.play('Soundtrack/Effect/soundLaser2.wav', 'static')

    end
end