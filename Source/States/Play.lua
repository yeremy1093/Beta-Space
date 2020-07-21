
Play = Class{__includes = BaseState}
puntaje = 0
HPnave = 0
Numvidas = 3

function Play:enter(params)
    --Agregamos el fondo unico de play
    self.ui = love.graphics.newImage('Imagen/Sprites States/Play.png')

    self.player = Nave(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, params.player)
    self.balas = {}

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
	move_bala(dt, self.balas)

	--Hacemos el update de los enemigos
	self.enemyManager:update(dt, puntaje, self.balas, self.player)

    --checamos si es game over
    if Numvidas <= 0 then
        gStateMachine:change('gameOver', {puntos = puntaje})
    end

	if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('A') then
    	table.insert(self.balas, Bala(self.player.x + self.player.width/2 - 3, self.player.y, BULLET_SPEED, 0, 0))
    	TEsound.play('Soundtrack/Effect/soundLaser1.wav', 'static')
    end
    if love.keyboard.wasPressed('s') or love.keyboard.wasPressed('S') then
    	if love.keyboard.isDown('up') and  love.keyboard.isDown('left')then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 8))
    	elseif love.keyboard.isDown('up') and  love.keyboard.isDown('right') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 5))
    	elseif love.keyboard.isDown('down') and  love.keyboard.isDown('left') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 7))
    	elseif love.keyboard.isDown('down') and  love.keyboard.isDown('right') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 6))
    	elseif love.keyboard.isDown('up') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 1))
    	elseif love.keyboard.isDown('down') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 2))
    	elseif love.keyboard.isDown('left') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 4))
    	elseif love.keyboard.isDown('right') then
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 3))
    	else
    		table.insert(self.balas, Bala(self.player.x + self.player.width/2 -10, self.player.y, BULLET_SPEED, 1, 1))
    	end
    	TEsound.play('Soundtrack/Effect/soundLaser2.wav', 'static')

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
	for i, bala in pairs(self.balas) do
		bala:render()
	end

	self.enemyManager:render()

end