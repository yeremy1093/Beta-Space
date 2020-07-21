
GameOver = Class{__includes = BaseState}


function GameOver:enter(params)
    --Guardamos el puntaje obtenido y borramos el puntaje global para la siguiente partida
    self.puntos = params.puntos
    puntaje = 0

    --Cargamos el fondo
    load_background()

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
function GameOver:update(dt)

	--calculamos el loop de las estrellas de fondo
	animate_background(dt)

	--cargamos las estrellas de alex
    sky:update (dt)

    self.target:update(dt, self.target_sprite)

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        TEsound.stop('musica_menu')
        gStateMachine:change('inicio', {})
    end

end

function GameOver:render()
	render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    --Dibujamos el menu de fondo
    love.graphics.draw(self.menu, 0, 0)

    --Dibujamos los puntos en pantalla
    love.graphics.print(tostring(self.puntos), 540, 400)

    --Dibujamos el target
    love.graphics.draw(self.target_sheet, self.target_sprite, 440, 560)

end