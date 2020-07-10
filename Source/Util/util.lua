--Funciones que tienen que ver con listas de objetos en distintos estados

function move_bala(dt, balas)
		--Hacemos un ciclo en el que se haga update de todas las balas
	for i, bala in pairs(balas) do
		bala:update(dt)
		--checamos si la bala salio de la pantalla y la borramos
		if bala.y < 0 or bala.y > WINDOW_HEIGHT or bala.x < 0 or bala.x > WINDOW_WIDTH then
			table.remove(balas, i)
		end
	end
end
