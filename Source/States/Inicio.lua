
Inicio = Class{__includes = BaseState}

local jugar = 1
local menu = 2
local salir = 3

function Inicio:enter(params)

    --cargamos los puntajes solo para pasarlos a los otros estados
    self.highScores = params.highScores

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu Inicio
    self.menu = love.graphics.newImage('Imagen/Menus/Inicio.png')

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
	self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.opc = jugar
    self.targetY = 480

    TEsound.playLooping({'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}, 'stream', 'musica_menu')

end


--Lo que se va a calcular frame a frame
function Inicio:update(dt)

	--calculamos el loop de las estrellas de fondo
	self.background:animate_background(dt)

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
        self.opc = jugar
    elseif self.targetY == 540 then
        self.opc = menu
    elseif self.targetY == 600 then
        self.opc = salir
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        if self.opc == jugar then
            gStateMachine:change('charselect', {highScores = self.highScores})
        elseif self.opc == menu then
            --gStateMachine:change('menu', {})
        elseif self.opc == salir then
            love.event.quit()
        end 
    end

    --ponemos la musica del menu

end

function Inicio:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

    love.graphics.draw(self.target_sheet, self.target_sprite, 420, self.targetY)

end