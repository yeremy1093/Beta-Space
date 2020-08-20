
PuntajeAlto = Class{__includes = BaseState}


-- individual chars of our string
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

local sprite1 = love.graphics.newImage('Imagen/Sprites/D-10.png')
local sprite2 = love.graphics.newImage('Imagen/Sprites/AX-2.png')
local sprite3 = love.graphics.newImage('Imagen/Sprites/Y9-2.png')

function PuntajeAlto:enter(params)

    --cargamos los puntajes altos
    self.highScores = params.highScores

    --Guardamos el puntaje obtenido y borramos el puntaje global para la siguiente partida
    self.puntos = Escribir(tostring(params.score))
    self.score = params.score

    self.scoreIndex = params.scoreIndex

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargar Menu de Estado
    self.menu = love.graphics.newImage('Imagen/Menus/Clean Menu.png')

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
    self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.targetY = 480

    self.mensaje_puntos = Escribir("Puntaje Alto")
    self.mensaje_escribir = Escribir("Selecciona tus siglas")
    self.siglas = Escribir(string.char(chars[1]) .. string.char(chars[2]).. string.char(chars[3]))
    self.highlightedChar = 1
    self.sigla1 = Escribir(string.char(chars[1]))
    self.sigla2 = Escribir(string.char(chars[2]))
    self.sigla3 = Escribir(string.char(chars[3]))

    self.nave = params.nave
    --Elementos necesarios para animar
    if self.nave == 1 then
        self.sprite_sheet = sprite1
    elseif self.nave == 2 then 
        self.sprite_sheet = sprite2
    elseif self.nave == 3 then 
        self.sprite_sheet = sprite3
    end

    self.sprite = love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet:getDimensions())
    self.animNave = Anim(0, 0, 58, 40, 2, 2, 10)
end


--Lo que se va a calcular frame a frame
function PuntajeAlto:update(dt)

	--calculamos el loop de las estrellas de fondo
	self.background:animate_background(dt)

	--cargamos las estrellas de alex
    sky:update (dt)

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
        self.highlightedChar = 1
    elseif self.targetY == 540 then
        self.highlightedChar = 2
    elseif self.targetY == 600 then
        self.highlightedChar = 3
    end

    -- scroll through characters
    if love.keyboard.wasPressed('right') then
        chars[self.highlightedChar] = chars[self.highlightedChar] + 1
        if chars[self.highlightedChar] > 90 then
            chars[self.highlightedChar] = 65
        end
    elseif love.keyboard.wasPressed('left') then
        chars[self.highlightedChar] = chars[self.highlightedChar] - 1
        if chars[self.highlightedChar] < 65 then
            chars[self.highlightedChar] = 90
        end
    end

    self.siglas = Escribir(string.char(chars[1]) .. string.char(chars[2]).. string.char(chars[3]))
    self.sigla1 = Escribir(string.char(chars[1]))
    self.sigla2 = Escribir(string.char(chars[2]))
    self.sigla3 = Escribir(string.char(chars[3]))

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
         -- update scores table
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3]) .. tostring(self.nave)

        -- go backwards through high scores table till this score, shifting scores
        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        -- write scores to file
        local scoresStr = ''

        for i = 1, 10 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('betaSpace.lst', scoresStr)

        TEsound.stop('musica_menu')
        gStateMachine:change('inicio', {highScores = self.highScores})
    end

    self.animNave:update(dt, self.sprite)

end

function PuntajeAlto:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    --Dibujamos el menu de fondo
    love.graphics.draw(self.menu, 0, 0)

    self.mensaje_puntos:render(500, 160)

    --Dibujamos los puntos en pantalla
    self.puntos:render(540, 200, 2, 2)

    self.mensaje_escribir:render(420, 260)

    self.siglas:render(560, 320, 2, 2)
    self.sigla1:render(600, 490, 2, 2)
    self.sigla2:render(600, 550, 2, 2)
    self.sigla3:render(600, 610, 2, 2)

    --Dibujamos el target
    love.graphics.draw(self.target_sheet, self.target_sprite, 410, self.targetY)

    --Dibujamos la nave del jugador
    love.graphics.draw(self.sprite_sheet, self.sprite, 720, 320)

end