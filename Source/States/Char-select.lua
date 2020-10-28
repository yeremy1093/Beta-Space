
Charselect = Class{__includes = BaseState}

local player1 = 1
local player2 = 2
local player3 = 3
local sprite1 = love.graphics.newImage('Imagen/Sprites/D-10.png')
local sprite2 = love.graphics.newImage('Imagen/Sprites/AX-2.png')
local sprite3 = love.graphics.newImage('Imagen/Sprites/Y9-2.png')

function Charselect:enter(params)

    --cargamos los puntajes altos para pasarlos al siguiente estado
    self.highScores = params.highScores

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu Inicio
    self.menu = love.graphics.newImage('Imagen/Menus/charselect.png')

    
    -- Agregamos las naves como seleccionables
    self.sprite_sheet = sprite1
    self.sprite = love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet:getDimensions())
    self.nave = Anim(0, 0, 58, 40, 2, 2, 10)

    self.player = player1

    --creamos una lista de letras para poner en pantalla
    self.player_name = Escribir("D10")

    self.timer_no_touch = 0.3

end


--Lo que se va a calcular frame a frame
function Charselect:update(dt)

	
	--cargamos las estrellas de alex
    sky:update (dt)

    --Cargamos las animaciones de las naves
    self.nave:update (dt,self.sprite)

    if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        --obtenemos la posicion del mouse y reaccionamos al click 
        --los botones estan en x de 545 a 720
        --en y son: 485/540, 545/600, 605/660
        local x, y = love.mouse.getPosition()
        local mouseX, mouseY = push:toGame(x, y)
        if mouseX >= 545 and mouseX <= 720 then
            if mouseY >= 485 and mouseY <= 540 then
                self.sprite_sheet = sprite1
                self.player = player1
                self.player_name = Escribir("D10")
                if love.mouse.isDown(1) then
                    gStateMachine:change('play', {type=self.player, highScores=self.highScores})
                end
            elseif mouseY >= 545 and mouseY <= 600 then
                self.sprite_sheet = sprite2
                self.player = player2
                self.player_name = Escribir("AX2")
                if love.mouse.isDown(1) then
                    gStateMachine:change('play', {type=self.player, highScores=self.highScores})
                end
            elseif mouseY >= 605 and mouseY <= 660 then
                self.sprite_sheet = sprite3
                self.player = player3
                self.player_name = Escribir("YM9")
                if love.mouse.isDown(1) then
                    gStateMachine:change('play', {type=self.player, highScores=self.highScores})
                end
            end
        end


    end

end

function Charselect:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

    love.graphics.draw(self.sprite_sheet, self.sprite, 540, 200, 0, 3, 3)

    --dibujamos las letras del nombre sobre la nave
    self.player_name:render(600, 165)
end