
Play = Class{__includes = BaseState}

local quad_util = love.graphics.newImage('Imagen/Sprites/Quad-util.png')
local quad_level = love.graphics.newImage('Imagen/Menus/QuadLvlarma.png')


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
    self.cambio_stage = false
    self.mensaje_stage = Escribir('Nuevo Nivel')
    self.mensaje_stage2 = Escribir('Vienen Enemigos')
    self.mensaje2X = 400

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
            self.enemyManager:cambio_stage(self.stage)
        end
    end

	--Hacemos el update de los enemigos
	if self.enemyManager:update(dt, puntaje, self.shotManager.balas, self.player) and self.cambio_stage == false then
        self.cambio_stage = true
        --Asignamos un nuevo tipo de stage
        local random_stage = love.math.random(1, 100)
        if random_stage <= 50 then
            self.enemyManager.tag_stage = 'normal'
            self.mensaje_stage2 = Escribir('Vienen Enemigos')
            self.mensaje2X = 340
        elseif random_stage <= 65 then
            self.enemyManager.tag_stage = 'cint_ast'
            self.mensaje_stage2 = Escribir('Cinturon de Asteroides')
            self.mensaje2X = 200
        elseif random_stage <= 80 then
            self.enemyManager.tag_stage = 'enjambre'
            self.mensaje_stage2 = Escribir('Enjambre de Drones')
            self.mensaje2X = 300
        elseif random_stage <= 90 then
            self.enemyManager.tag_stage = 'hunters'
            self.mensaje_stage2 = Escribir('Escuadron Elite')
            self.mensaje2X = 340
        else
            self.enemyManager.tag_stage = 'nebulosa'
            self.mensaje_stage2 = Escribir('Entrando a Nebulosa')
            self.mensaje2X = 280
        end
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

    --Dibujamos las balas del jugador
    self.shotManager:render()

    for i, pickup in pairs(self.pickups) do
        pickup:render()
    end

    --Dibujamos la nave dependiendo de su posicion
    self.player:render()

    self.enemyManager:render()

    --Ponemos el puntaje en la pantalla
    love.graphics.print(tostring(puntaje), 30, 25)

    --Dibujamos la interfaz de usuario
    self:UI_render()

     --Ponemos en pantalla el stage en el que vamos
    if self.cambio_stage then
        self.mensaje_stage:render(400, 300, 2, 2)
        self.mensaje_stage2:render(self.mensaje2X, 400, 2, 2)
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

function Play:UI_render()

    --Dibujamos la interfaz de usuario
    love.graphics.draw(self.ui, 0, 0)
    --Dibujamos el icono del estatus de escudo
    love.graphics.draw(quad_util, self.player.escudo_quad, 1080, 600)
    if self.player.escudo.estado == 'desactivado' then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        love.graphics.rectangle('fill', 1080, 600, 60, 60 )
        love.graphics.setColor(1, 1, 1, 1)
    end

    --Dibujamos el HP de la nave--
    love.graphics.draw(quad_util, self.player.hp_quad, 960, 600)
    --Dibujamos la cantidad de vidas--
    self.player.numvidas:render(840, 600, 3, 3)
    --Dibujamos el icono del tipo de arma
    love.graphics.draw(quad_util, self.player.equip_quad, 1200, 600)

    --Dibujamos el nivel de poder de las armas secundarias
    love.graphics.draw(quad_level, self.player.sprite_lvl2, 1195, 570)
    love.graphics.draw(quad_level, self.player.sprite_lvl3, 1195, 545)
end