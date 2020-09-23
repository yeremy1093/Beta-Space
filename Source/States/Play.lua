
Play = Class{__includes = BaseState}


function Play:enter(params)
    --cargamos los puntajes altos
    self.highScores = params.highScores

    if params.pickup_timer then
        self.pickup_timer = params.pickup_timer
    else
        self.pickup_timer = PICKUP_TIMER
    end
    if params.pickups then
        self.pickups =  params.pickups
    else
        self.pickups = {}
    end

    if params.vidas then
        Numvidas = params.vidas
    else
        Numvidas = 3
    end

    --Agregamos el fondo unico de play
    self.ui = love.graphics.newImage('Imagen/Menus/Play.png')

    if params.player then
        self.player = params.player
    else
        self.player = Nave(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, params.type)
    end
    if params.shotManager then
        self.shotManager = params.shotManager
    else
        self.shotManager = PlayerShot()
    end

    --Agregar listas vacías para enemigos, powerups, etc.
    if params.enemyManager then
        self.enemyManager = params.enemyManager
    else
        self.enemyManager = Enemy()
    end

    --Cargamos el fondo
    if params.background then
        self.background = params.background
    else
        self.background = Background()
    end

    --cargamos estellas de alex
    if params.sky then
        self.sky = params.sky
    else
        self.sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 500, 0, 10)
    end

    TEsound.stop('musica_menu')
    TEsound.stop('musica_play')
    TEsound.playLooping({'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}, "stream", {'musica_menu'})
    TEsound.volume({'musica_menu', 'musica_play'}, VOLUMEN_MUSICA)

    --Manejo del sistema de enemigos por stages
    self.stage = 0
    self.cambio_stage = false
    self.mensaje_stage = Escribir('Nuevo Stage')

end


--Lo que se va a calcular frame a frame
function Play:update(dt)

	
	--cargamos las estrellas de alex
	self.sky:update (dt)

	--Funcion con el codigo para mover y animar la nave
	self.player:update(dt)

	--Funcion con el codigo para mover la bala
	self.shotManager:disparo_jugador(self.player, dt)

    --Mostramos el mensaje de cambio de stage
    if self.cambio_stage then
        TIMER_CAMBIO_STAGE = TIMER_CAMBIO_STAGE - dt
        if TIMER_CAMBIO_STAGE <= 0 then
            TIMER_CAMBIO_STAGE = 3
            self.cambio_stage = false
        end
        return
    end

	--Hacemos el update de los enemigos
	if self.enemyManager:update(dt, puntaje, self.shotManager.balas, self.player) then
        self.stage = self.stage + 1
        self.cambio_stage = true
        self.enemyManager:cambio_stage(self.stage)
    end

    --checamos si es game over
    if Numvidas <= 0 then

         -- see if score is higher than any in the high scores table
        local highScore = false

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if puntaje > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gStateMachine:change('puntaje_alto', {
                highScores = self.highScores,
                score = puntaje,
                scoreIndex = highScoreIndex,
                nave = self.player.nave
            }) 
        else 
            gStateMachine:change('gameOver', {puntos = puntaje, highScores = self.highScores})
        end
    end

    --Checamos si debemos crear balas del jugador
	self.shotManager:mover_balas_jugador(dt, self.player, self.enemyManager)

    --hacemos lo de los pickups para las armas y poderes
    self:generar_pickup(dt)
    self:update_pickups(dt)

    --Agregamos la boton para pausar el juego
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('pause', {state = self})
    end

end

function Play:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
	self.sky:render()

    --Ponemos el puntaje en la pantalla
    love.graphics.print(tostring(puntaje), 30, 25)

    --Ponemos en pantalla el stage en el que vamos

    love.graphics.print(tostring(self.stage), 200, 25)

    if self.cambio_stage then
        self.mensaje_stage:render(480, 400, 2, 2)
    end

    --Dibujamos la interfaz de usuario
    love.graphics.draw(self.ui, 0, 0)

    --Dibujamos la nave dependiendo de su posicion
    self.player:render()

	--Dibujamos las balas en un ciclo
	self.shotManager:render()

	self.enemyManager:render()

    for i, pickup in pairs(self.pickups) do
        pickup:render()
    end

end

function Play:generar_pickup(dt)
    self.pickup_timer = self.pickup_timer - dt

    if self.pickup_timer <= 0 then
        table.insert(self.pickups, Pickup(math.random(0, WINDOW_WIDTH -50), -34, math.random(-50, 50), math.random(20, 100)))
        self.pickup_timer = PICKUP_TIMER
    end
end

function Play:update_pickups(dt)
    for i, pickup in pairs(self.pickups) do
        pickup:update(dt)
        --checamos si la bala salio de la pantalla y la borramos
        if pickup.y < 0 - pickup.height or pickup.y > WINDOW_HEIGHT or pickup.x < 0 - pickup.width or pickup.x > WINDOW_WIDTH then
            table.remove(self.pickups, i)
        end
    end

    for i, pickup in pairs(self.pickups) do
        if pickup:collides(self.player) then
            self.player:update_power_up(pickup.tipo)
            table.remove(self.pickups, i)
            TEsound.play({'Soundtrack/Effect/Power UP.wav','Soundtrack/Effect/Heal or Life.wav'}, 'static', {'effect'},  VOLUMEN_EFECTOS)
        end
    end
end