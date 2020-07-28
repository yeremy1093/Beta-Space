
Play = Class{__includes = BaseState}


function Play:enter(params)

    Numvidas = 3

    --Agregamos el fondo unico de play
    self.ui = love.graphics.newImage('Imagen/Sprites States/Play.png')

    self.player = Nave(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, params.player)
    self.shotManager = PlayerShot()

    --Agregar listas vacías para enemigos, powerups, etc.
    self.enemyManager = Enemy()

    --Cargamos el fondo
    load_background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 10)


end


--Lo que se va a calcular frame a frame
function Play:update(dt)

	--calculamos el loop de las estrellas de fondo
	animate_background(dt)

	--cargamos las estrellas de alex
	sky:update (dt)

	--Funcion con el codigo para mover y animar la nave
	self.player:update(dt)

	--Funcion con el codigo para mover la bala
	self.shotManager:disparo_jugador(self.player)

	--Hacemos el update de los enemigos
	self.enemyManager:update(dt, puntaje, self.shotManager.balas, self.player)

    --checamos si es game over
    if Numvidas <= 0 then
        gStateMachine:change('gameOver', {puntos = puntaje})
    end

    --Checamos si debemos crear balas del jugador
	self.shotManager:mover_balas_jugador(dt, self.player)

end

function Play:render()
	render_background()

	--Dibujamos las estrellas de alex
	sky:render()

    --Ponemos el puntaje en la pantalla
    love.graphics.print(tostring(puntaje), 30, 25)

    --Dibujamos la interfaz de usuario
    love.graphics.draw(self.ui, 0, 0)

    --Dibujamos la nave dependiendo de su posicion
    self.player:render()

	--Dibujamos las balas en un ciclo
	self.shotManager:render()

	self.enemyManager:render()

end