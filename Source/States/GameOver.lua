
GameOver = Class{__includes = BaseState}


function GameOver:enter(params)

    --cargamos los puntajes altos
    self.highScores = params.highScores

    --Guardamos el puntaje obtenido y borramos el puntaje global para la siguiente partida
    self.puntos = Escribir(tostring(params.puntos))
    self.score = params.puntos
    puntaje = 0

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu de Estado
    self.menu = love.graphics.newImage('Imagen/Menus/GameOver.png')

    TEsound.stop('musica_play')
    TEsound.stop('musica_menu')
    TEsound.playLooping({'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}, "stream", {'musica_menu'})
    TEsound.volume({'musica_menu', 'musica_play'}, VOLUMEN_MUSICA)

    self.timer_no_touch = 0.3

end


--Lo que se va a calcular frame a frame
function GameOver:update(dt)

	
	--cargamos las estrellas de alex
    sky:update (dt)


    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        TEsound.stop('musica_menu')

        gStateMachine:change('inicio', {highScores = self.highScores})

    end

    if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        --obtenemos la posicion del mouse y reaccionamos al click 
        --los botones estan en x de 545 a 720
        --en y son: 485/540, 545/600, 605/660
        local x, y = love.mouse.getPosition()
        local mouseX, mouseY = push:toGame(x, y)
        if love.mouse.isDown(1) then
            if mouseX >= 575 and mouseX <= 750 then
                if mouseY >= 565 and mouseY <= 620 then
                    gStateMachine:change('inicio', {highScores = self.highScores})
                end
            end
        end
    end

end

function GameOver:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    --Dibujamos el menu de fondo
    love.graphics.draw(self.menu, 0, 0)

    --Dibujamos los puntos en pantalla
    self.puntos:render(480, 400, 2, 2)


end