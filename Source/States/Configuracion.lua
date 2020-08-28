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
    self.pantallaControles = false
    self.timerControler = TIMER_CONTROLES
    self.contador = 0
    self.pantallaSonido = false
    self.tagPrincipal1 = Escribir("Menu")
    self.tagPrincipal2 = Escribir("de")
    self.tagPrincipal3 = Escribir("Configuraciones")
    self.tagSonido = Escribir("Controles de Sonido")
    self.tagControles = Escribir("Controles de juego")
    self.textoControles1 = ""
    self.textoControles2 = ""
    self.textoControles3 = ""

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
	self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.opc = 'puntajes'
    self.targetY = 480

    --Cargar Selector de menu de audio
    self.target_audio_sheet = love.graphics.newImage('Imagen/Menus/Target small.png')
    self.target_audio_sprite = love.graphics.newQuad(0, 0, 30, 30, self.target_audio_sheet:getDimensions())
    self.target_audio = Anim(0,0,30,30,4,4,10)
    self.targetX1 = 912 - ((1 - VOLUMEN_MUSICA) * 250)
    self.targetX2 = 912 - ((1 - VOLUMEN_EFECTOS) * 250)
    self.targetY2 = 242

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
        self.timerControler = self.timerControler - dt
        if self.timerControler <= 0 then
            self.timerControler = TIMER_CONTROLES
            self.contador = self.contador + 1
            if 1 == self.contador then
                self.menu_sprite:setViewport(WINDOW_WIDTH * 3, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                self.textoControles1 = "Usa este boton para"
                self.textoControles2 = "hacer los disparos normales."
                self.textoControles3 = "Su poder depende de tus pickups"
            elseif 2 == self.contador then
                self.menu_sprite:setViewport(WINDOW_WIDTH * 4, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                self.textoControles1 = "Usa este boton para"
                self.textoControles2 = "disparar tu arma secundaria."
                self.textoControles3 = "Hay diferentes, y su poder varia"
            elseif 3 == self.contador then
                self.menu_sprite:setViewport(WINDOW_WIDTH * 5, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                self.textoControles1 = "Usa este boton para"
                self.textoControles2 = "activar y desactivar tu escudo."
                self.textoControles3 = "tiene cierta energia solamente"
            elseif 4 == self.contador then
                self.menu_sprite:setViewport(WINDOW_WIDTH * 6, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                self.textoControles1 = "El movimiento de la nave"
                self.textoControles2 = "se hace mediante las flechas"
                self.textoControles3 = "en tu teclado"
                self.contador = 0
            end
        end
    end

    if self.pantallaSonido then
        self.target_audio:update(dt, self.target_audio_sprite)
        if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
            if 242 == self.targetY2 then
                self.targetY2 = 348
            else
                self.targetY2 = 242
            end
        end

        if 242 == self.targetY2 then
            if love.keyboard.wasPressed('left') then
                self.targetX1 = self.targetX1 - 25
                if self.targetX1 < 662 then
                    self.targetX1 = 662
                end

                VOLUMEN_MUSICA = VOLUMEN_MUSICA - 0.1
                if VOLUMEN_MUSICA <= 0 then VOLUMEN_MUSICA = 0 end

                TEsound.volume('musica_menu', VOLUMEN_MUSICA)
            end
            if love.keyboard.wasPressed('right') then
                self.targetX1 = self.targetX1 + 25
                if self.targetX1 > 912 then
                    self.targetX1 = 912
                end
                VOLUMEN_MUSICA = VOLUMEN_MUSICA + 0.1
                if VOLUMEN_MUSICA >= 1 then VOLUMEN_MUSICA = 1 end
                TEsound.volume('musica_menu', VOLUMEN_MUSICA)
            end
        else
            if love.keyboard.wasPressed('left') then
                self.targetX2 = self.targetX2 - 25
                if self.targetX2 < 662 then
                    self.targetX2 = 662
                end
                VOLUMEN_EFECTOS = VOLUMEN_EFECTOS - 0.1
                if VOLUMEN_EFECTOS <= 0 then VOLUMEN_EFECTOS = 0 end
            end
            if love.keyboard.wasPressed('right') then
                self.targetX2 = self.targetX2 + 25
                if self.targetX2 > 912 then
                    self.targetX2 = 912
                end
                VOLUMEN_EFECTOS = VOLUMEN_EFECTOS + 0.1
                if VOLUMEN_EFECTOS >= 1 then VOLUMEN_EFECTOS = 1 end
            end
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
            self.contador = 0
            self.textoControles1 = "Usa las flechas y ASD"
            self.textoControles2 = "Destruye enemigos y gana puntos"
            self.textoControles3 = "Obten el mayor puntaje"
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
        self.tagControles:render(440, 130)
        love.graphics.setFont(gFonts['small'])
        love.graphics.print(self.textoControles1, 500, 200)
        love.graphics.print(self.textoControles2, 500, 250)
        love.graphics.print(self.textoControles3, 500, 300)
        love.graphics.setFont(gFonts['large'])
    elseif self.pantallaSonido then
        self.tagSonido:render(430, 130)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.print("Volumen de Musica", 330, 205)
        if 242 == self.targetY2 then
            love.graphics.draw(self.target_audio_sheet, self.target_audio_sprite, self.targetX1 - 15, self.targetY2)
        else
            love.graphics.draw(self.target_audio_sheet, self.target_audio_sprite, self.targetX2 - 15, self.targetY2)
        end
        love.graphics.print("Volumen de Efectos", 330, 315)
        love.graphics.setFont(gFonts['large'])
    else
        self.tagPrincipal1:render(540, 150, 2)
        self.tagPrincipal2:render(580, 220, 2)
        self.tagPrincipal3:render(330, 290, 2)
    end

end