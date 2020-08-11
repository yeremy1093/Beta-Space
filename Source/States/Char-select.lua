
Charselect = Class{__includes = BaseState}

local player1 = 1
local player2 = 2
local player3 = 3
local sprite1 = love.graphics.newImage('Imagen/Sprites/D-10.png')
local sprite2 = love.graphics.newImage('Imagen/Sprites/AX-2.png')
local sprite3 = love.graphics.newImage('Imagen/Sprites/Y9-2.png')

function Charselect:enter(params)

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu Inicio
    self.menu = love.graphics.newImage('Imagen/Menus/charselect.png')

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
	self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.opc = jugar
    self.targetY = 480
    -- Agregamos las naves como seleccionables
    self.sprite_sheet = sprite1
    self.sprite = love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet:getDimensions())
    self.nave = Anim(0, 0, 58, 40, 2, 2, 10)

    self.player = player1

    --creamos una lista de letras para poner en pantalla
    self.player_name = Escribir("D10")

end


--Lo que se va a calcular frame a frame
function Charselect:update(dt)

	--calculamos el loop de las estrellas de fondo
	self.background:animate_background(dt)

	--cargamos las estrellas de alex
    sky:update (dt)

    --Cargamos las animaciones de las naves
    self.nave:update (dt,self.sprite)
    
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
        self.sprite_sheet = sprite1
        self.player = player1
        self.player_name = Escribir("D10")
    elseif self.targetY == 540 then
        self.sprite_sheet = sprite2
        self.player = player2
        self.player_name = Escribir("AX2")
    elseif self.targetY == 600 then
        self.sprite_sheet = sprite3
        self.player = player3
        self.player_name = Escribir("YM9")
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        gStateMachine:change('play', {type=self.player})
        
    end

end

function Charselect:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(self.menu, 0, 0)

    love.graphics.draw(self.target_sheet, self.target_sprite, 420, self.targetY)
    love.graphics.draw(self.sprite_sheet, self.sprite, 540, 200, 0, 3, 3)

    --dibujamos las letras del nombre sobre la nave
    self.player_name:render(600, 165)
end