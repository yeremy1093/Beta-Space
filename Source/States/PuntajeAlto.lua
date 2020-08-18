
PuntajeAlto = Class{__includes = BaseState}


function PuntajeAlto:enter(params)

    --cargamos los puntajes altos
    self.highScores = params.highScores

    --Guardamos el puntaje obtenido y borramos el puntaje global para la siguiente partida
    self.puntos = Escribir(tostring(params.score))
    self.score = params.score

    self.scoreIndex = params.scoreIndex

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu de Estado
    self.menu = love.graphics.newImage('Imagen/Menus/GameOver.png')

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
    self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)

end


--Lo que se va a calcular frame a frame
function PuntajeAlto:update(dt)

	--calculamos el loop de las estrellas de fondo
	self.background:animate_background(dt)

	--cargamos las estrellas de alex
    sky:update (dt)

    self.target:update(dt, self.target_sprite)

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        TEsound.stop('musica_menu')
        gStateMachine:change('inicio', {highScores = self.highScores})
    end

end

function PuntajeAlto:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    --Dibujamos el menu de fondo
    love.graphics.draw(self.menu, 0, 0)

    --Dibujamos los puntos en pantalla
    self.puntos:render(480, 400, 2, 2)

    love.graphics.print("PuntajeAlto!!!!", 30, 25)

    --Dibujamos el target
    love.graphics.draw(self.target_sheet, self.target_sprite, 440, 560)

end