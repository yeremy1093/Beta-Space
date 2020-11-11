
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
    puntaje = 0

    self.scoreIndex = params.scoreIndex

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    self.sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0, 1)

    --Cargar Menu de Estado
    self.menu = love.graphics.newImage('Imagen/Menus/Clean menu.png')

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
    self.timer_no_touch = 0.3
end


--Lo que se va a calcular frame a frame
function PuntajeAlto:update(dt)
    local x, y = love.mouse.getPosition()
    local mouseX, mouseY = push:toGame(x, y)

	
	--cargamos las estrellas de alex
    self.sky:update (dt)

    self.target:update(dt, self.target_sprite)

    if mouseY ~= nil and mouseX ~= nil then
        if mouseY >= 480 and mouseY < 540 then
            self.highlightedChar = 1
        elseif mouseY >= 540 and mouseY < 600 then
            self.highlightedChar = 2
        elseif mouseY >= 600 and mouseY < 660 then
            self.highlightedChar = 3
        else
            self.highlightedChar = 0
        end
    end

    -- scroll through characters
    if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        if mouseY ~= nil and mouseX ~= nil then
            if mouseX >= 410 and mouseX <= 480 and love.mouse.isDown(1) then
                self.timer_no_touch = 0.1
                chars[self.highlightedChar] = chars[self.highlightedChar] + 1
                if chars[self.highlightedChar] > 90 then
                    chars[self.highlightedChar] = 65
                end
            elseif mouseX >= 785 and mouseX <= 855 and love.mouse.isDown(1) then
                self.timer_no_touch = 0.1
                chars[self.highlightedChar] = chars[self.highlightedChar] - 1
                if chars[self.highlightedChar] < 65 then
                    chars[self.highlightedChar] = 90
                end
            end
        end
    end
    

    self.siglas = Escribir(string.char(chars[1]) .. string.char(chars[2]).. string.char(chars[3]))
    self.sigla1 = Escribir(string.char(chars[1]))
    self.sigla2 = Escribir(string.char(chars[2]))
    self.sigla3 = Escribir(string.char(chars[3]))

    if love.mouse.isDown(1) and mouseX ~= nil and mouseY ~= nil then
        if mouseX >= 1130 and mouseX <= 1230 and mouseY >= 580 and mouseY <= 680 then
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

                gStateMachine:change('lista_puntajes', {highScores = self.highScores})
            end
        end

    self.animNave:update(dt, self.sprite)

end

function PuntajeAlto:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    self.sky:render()

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
    love.graphics.draw(self.target_sheet, self.target_sprite, 410, 480)
    love.graphics.draw(self.target_sheet, self.target_sprite, 855, 480, 0, -1, 1)
    love.graphics.draw(self.target_sheet, self.target_sprite, 410, 540)
    love.graphics.draw(self.target_sheet, self.target_sprite, 855, 540, 0, -1, 1)
    love.graphics.draw(self.target_sheet, self.target_sprite, 410, 600)
    love.graphics.draw(self.target_sheet, self.target_sprite, 855, 600, 0, -1, 1)

    love.graphics.draw(self.target_sheet, self.target_sprite, 1150, 600)

    --Dibujamos la nave del jugador
    love.graphics.draw(self.sprite_sheet, self.sprite, 720, 320)

end