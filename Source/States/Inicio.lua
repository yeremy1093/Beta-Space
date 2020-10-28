
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


    TEsound.playLooping({'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}, "stream", {'musica_menu'})
    TEsound.volume({'musica_menu', 'musica_play'}, VOLUMEN_MUSICA)

    self.timer_no_touch = 0.3

end


--Lo que se va a calcular frame a frame
function Inicio:update(dt)

	

	--cargamos las estrellas de alex
    sky:update (dt)
    
    if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        --obtenemos la posicion del mouse y reaccionamos al click 
        --los botones estan en x de 545 a 720
        --en y son: 485/540, 545/600, 605/660
        local x, y = love.mouse.getPosition()
        local mouseX, mouseY = push:toGame(x, y)
        if love.mouse.isDown(1) then
            if mouseX >= 545 and mouseX <= 720 then
                if mouseY >= 485 and mouseY <= 540 then
                    gStateMachine:change('charselect', {highScores = self.highScores})
                elseif mouseY >= 545 and mouseY <= 600 then
                    gStateMachine:change('menu', {highScores = self.highScores})
                elseif mouseY >= 605 and mouseY <= 660 then
                    love.event.quit()
                end
            end
        end
    end

end

function Inicio:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

end