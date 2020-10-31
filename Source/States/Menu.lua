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

    self.timer_no_touch = 0.3

end


--Lo que se va a calcular frame a frame
function Menu:update(dt)

	
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
        if mouseX ~= nil and mouseX ~= nil then
            if mouseX >= 545 and mouseX <= 720 then
                if mouseY >= 485 and mouseY <= 540 then
                    if love.mouse.isDown(1) then
                        gStateMachine:change('lista_puntajes', {highScores = self.highScores})
                    end
                elseif mouseY >= 545 and mouseY <= 600 then
                    if love.mouse.isDown(1) then
                        gStateMachine:change('config', {highScores = self.highScores, ultimoEstado = 'menu'})
                    end
                elseif mouseY >= 605 and mouseY <= 660 then
                    if love.mouse.isDown(1) then
                        TEsound.stop('musica_menu')
                        TEsound.stop('musica_play')
                        gStateMachine:change('inicio', {highScores = self.highScores})
                    end
                end
            end
        end
    end

end

function Menu:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

end