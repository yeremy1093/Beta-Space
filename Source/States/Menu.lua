Menu = Class{__includes = BaseState}

local jugar = 1
local menu = 2
local salir = 3

function Menu:enter(params)

    --cargamos los puntajes solo para pasarlos a los otros estados
    self.highScores = params.highScores

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 500, 0, 0)

    --Cargar Menu Inicio
    self.menu = love.graphics.newImage('Imagen/Menus/menu.png')

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
	self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.opc = 'puntajes'
    self.targetY = 480

end


--Lo que se va a calcular frame a frame
function Menu:update(dt)

	
	--cargamos las estrellas de alex
    sky:update (dt)
    
    --Animacion de target
    self.target:update(dt, self.target_sprite)

	if love.keyboard.wasPressed('up') then
        self.targetY = self.targetY - 60
        if self.targetY < 480 then
            self.targetY = 480
        end
    end
    if love.keyboard.wasPressed('down') then
    	self.targetY = self.targetY + 60
        if self.targetY > 600 then
            self.targetY = 600
        end
    end

    if self.targetY == 480 then
        self.opc = 'puntajes'
    elseif self.targetY == 540 then
        self.opc = 'config'
    elseif self.targetY == 600 then
        self.opc = 'salir'
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        if self.opc == 'puntajes' then
            gStateMachine:change('lista_puntajes', {highScores = self.highScores})
        elseif self.opc == 'config' then
            gStateMachine:change('config', {highScores = self.highScores, ultimoEstado = 'menu'})
        elseif self.opc == 'salir' then
            TEsound.stop('musica_menu')
            gStateMachine:change('inicio', {highScores = self.highScores})
        end 
    end

    --ponemos la musica del menu

end

function Menu:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

    love.graphics.draw(self.target_sheet, self.target_sprite, 420, self.targetY)

end