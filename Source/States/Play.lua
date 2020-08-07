
Play = Class{__includes = BaseState}


function Play:enter(params)

    self.pickup_timer = PICKUP_TIMER
    self.pickups = {}

    Numvidas = 3

    --Agregamos el fondo unico de play
    self.ui = love.graphics.newImage('Imagen/Menus/Play.png')

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

    --hacemos lo de los pickups para las armas y poderes
    self:generar_pickup(dt)
    self:update_pickups(dt)

    --Agregamos la boton para pausar el juego
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('Pause', {state = self})
    end

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
            TEsound.play({'Soundtrack/Effect/PowerUp1.wav', 'Soundtrack/Effect/PowerUp2.wav', 'Soundtrack/Effect/PowerUp3.wav'}, 'static')
        end
    end
end