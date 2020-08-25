Config = Class{__includes = BaseState}

local jugar = 1
local menu = 2
local salir = 3

function Config:enter(params)

    --cargamos los puntajes solo para pasarlos a los otros estados
    self.highScores = params.highScores
    self.ultimoEstado = params.ultimoEstado
    self.params = params
    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu
    self.menu_sheet = love.graphics.newImage('Imagen/Menus/Configuraciones.png')
    self.menu_sprite = love.graphics.newQuad(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, self.menu_sheet:getDimensions())
    self.menuAnim = Anim(WINDOW_WIDTH * 3, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 4, 4, 0.5)
    self.pantallaControles = false
    self.pantallaSonido = false
    self.tagPrincipal = Escribir("Menu de Configuraciones")
    self.tagSonido = Escribir("Controles de Sonido")
    self.tagControles = Escribir("Controles de juego")

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
	self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.opc = 'puntajes'
    self.targetY = 480

    self.tagMenu1 = Escribir("Sonido")
    self.tagMenu2 = Escribir("Botones")
    self.tagMenu3 = Escribir("Salir")

end


--Lo que se va a calcular frame a frame
function Config:update(dt)

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
        self.opc = 'sonido'
    elseif self.targetY == 540 then
        self.opc = 'controles'
    elseif self.targetY == 600 then
        self.opc = 'regresar'
    end

    if self.pantallaControles then
        if 1 == self.menuAnim:update(dt, self.menu_sprite) then
        end
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        if self.opc == 'sonido' then
           self.menu_sprite:setViewport(WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
           self.pantallaSonido = true
           self.pantallaControles = false
        elseif self.opc == 'controles' then
            self.menu_sprite:setViewport(WINDOW_WIDTH * 2, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
            self.pantallaSonido = false
            self.pantallaControles = true
        elseif self.opc == 'regresar' then
            self.pantallaSonido = false
            self.pantallaControles = false
            gStateMachine:change(self.ultimoEstado, self.params)
        end 
    end

    --ponemos la musica del menu

end

function Config:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu_sheet, self.menu_sprite, 0, 0)

    love.graphics.draw(self.target_sheet, self.target_sprite, 420, self.targetY)

    --imprimimos las opciones del menu
    self.tagMenu1:render(560, 500)
    self.tagMenu2:render(560, 560)
    self.tagMenu3:render(560, 620)

    if self.pantallaControles then
        self.tagControles:render(500, 300)
    end

end