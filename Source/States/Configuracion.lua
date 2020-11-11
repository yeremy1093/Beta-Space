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
    self.sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0, 1)

    --Cargar Menu
    self.menu_sheet = love.graphics.newImage('Imagen/Menus/ConfiguracionesCELL.png')
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

    --Cargar Selector de menu de audio
    self.target_audio_sheet = love.graphics.newImage('Imagen/Menus/Target small.png')
    self.target_audio_sprite = love.graphics.newQuad(0, 0, 30, 30, self.target_audio_sheet:getDimensions())
    self.target_audio = Anim(0,0,30,30,4,4,10)
    self.targetX1 = 912 - ((1 - VOLUMEN_MUSICA) * 250)
    self.targetX2 = 912 - ((1 - VOLUMEN_EFECTOS) * 250)
    self.targetY1 = 242
    self.targetY2 = 348

    self.tagMenu1 = Escribir("Sonido")
    self.tagMenu2 = Escribir("Botones")
    self.tagMenu3 = Escribir("Salir")

    self.timer_no_touch = 0.3

end


--Lo que se va a calcular frame a frame
function Config:update(dt)

    local x, y = love.mouse.getPosition()
    local mouseX, mouseY = push:toGame(x, y)
	
	--cargamos las estrellas de alex
    self.sky:update (dt)
--[[
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
]]

    if self.pantallaSonido then
        self.target_audio:update(dt, self.target_audio_sprite)
        if mouseY ~= nil and mouseX ~= nil then
            if mouseY >= 190 and mouseY <= 300 then
                if love.mouse.isDown(1) then
                    if mouseX > 650 and mouseX <= 675 then
                        self.targetX1 = 662
                    elseif mouseX > 675 and mouseX <= 700 then
                        self.targetX1 = 687
                    elseif mouseX > 700 and mouseX <= 725 then
                        self.targetX1 = 712
                    elseif mouseX > 725 and mouseX <= 750 then
                        self.targetX1 = 737
                    elseif mouseX > 750 and mouseX <= 775 then
                        self.targetX1 = 762
                    elseif mouseX > 775 and mouseX <= 800 then
                        self.targetX1 = 787
                    elseif mouseX > 800 and mouseX <= 825 then
                        self.targetX1 = 812
                    elseif mouseX > 825 and mouseX <= 850 then
                        self.targetX1 = 837
                    elseif mouseX > 850 and mouseX <= 875 then
                        self.targetX1 = 862
                    elseif mouseX > 875 and mouseX <= 900 then
                        self.targetX1 = 887
                    elseif mouseX > 900 and mouseX <= 925 then
                        self.targetX1 = 912
                    end
                
                    VOLUMEN_MUSICA = (self.targetX1 - 662)/250

                    TEsound.volume('musica_menu', VOLUMEN_MUSICA)
                    TEsound.volume('musica_play', VOLUMEN_MUSICA)

                end

            elseif mouseY >= 295 and mouseY <= 405 then
                if love.mouse.isDown(1) then
                    if mouseX > 650 and mouseX <= 675 then
                        self.targetX2 = 662
                    elseif mouseX > 675 and mouseX <= 700 then
                        self.targetX2 = 687
                    elseif mouseX > 700 and mouseX <= 725 then
                        self.targetX2 = 712
                    elseif mouseX > 725 and mouseX <= 750 then
                        self.targetX2 = 737
                    elseif mouseX > 750 and mouseX <= 775 then
                        self.targetX2 = 762
                    elseif mouseX > 775 and mouseX <= 800 then
                        self.targetX2 = 787
                    elseif mouseX > 800 and mouseX <= 825 then
                        self.targetX2 = 812
                    elseif mouseX > 825 and mouseX <= 850 then
                        self.targetX2 = 837
                    elseif mouseX > 850 and mouseX <= 875 then
                        self.targetX2 = 862
                    elseif mouseX > 875 and mouseX <= 900 then
                        self.targetX2 = 887
                    elseif mouseX > 900 and mouseX <= 925 then
                        self.targetX2 = 912
                    end
                    
                    VOLUMEN_EFECTOS = (self.targetX2 - 662)/250
                end

            end
        end
    end

    if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        --obtenemos la posicion del mouse y reaccionamos al click 
        --los botones estan en x de 545 a 720
        --en y son: 485/540, 545/600, 605/660
        if mouseX ~= nil and mouseY ~= nil then
            if mouseX >= 545 and mouseX <= 720 then
                if mouseY >= 485 and mouseY <= 540 then
                    self.menu_sprite:setViewport(WINDOW_WIDTH, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                    self.pantallaSonido = true
                    self.pantallaControles = false
                elseif mouseY >= 545 and mouseY <= 600 then
                    self.menu_sprite:setViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                    self.pantallaSonido = false
                    self.pantallaControles = true
                    self.contador = 0
                    self.textoControles1 = "Usa la pantalla para tocar el circulo"
                    self.textoControles2 = "de movimiento y controlar la nave"
                    self.textoControles3 = "Toca los iconos en pantalla para disparar"
                elseif mouseY >= 605 and mouseY <= 660 then
                    self.menu_sprite:setViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
                    self.pantallaSonido = false
                    self.pantallaControles = false
                    if love.mouse.isDown(1) then
                        gStateMachine:change(self.ultimoEstado, self.params)
                    end
                end
            end
        end
    end

end

function Config:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    self.sky:render()

    love.graphics.draw(self.menu_sheet, self.menu_sprite, 0, 0)

    --imprimimos las opciones del menu
    self.tagMenu1:render(560, 500)
    self.tagMenu2:render(560, 560)
    self.tagMenu3:render(560, 620)

    if self.pantallaControles then
        self.tagControles:render(440, 130)
        love.graphics.setFont(gFonts['small'])
        love.graphics.print(self.textoControles1, 400, 200)
        love.graphics.print(self.textoControles2, 400, 250)
        love.graphics.print(self.textoControles3, 400, 300)
        love.graphics.setFont(gFonts['large'])
    elseif self.pantallaSonido then
        self.tagSonido:render(430, 130)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.print("Volumen de Musica", 330, 205)
        love.graphics.draw(self.target_audio_sheet, self.target_audio_sprite, self.targetX1 - 15, self.targetY1)
        love.graphics.draw(self.target_audio_sheet, self.target_audio_sprite, self.targetX2 - 15, self.targetY2)
        love.graphics.print("Volumen de Efectos", 330, 315)
        love.graphics.setFont(gFonts['large'])
    else
        self.tagPrincipal1:render(540, 150, 2)
        self.tagPrincipal2:render(580, 220, 2)
        self.tagPrincipal3:render(330, 290, 2)
    end

end