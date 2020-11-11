
require 'Source/Util/Include'

function love.load()
	--Por si se ofrece
	math.randomseed(os.time())
	--Ponemos lo de los parametros de la pantalla
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = true
    })

    --Ponemos el titulo de la ventana
    love.window.setTitle('Beta Space Project')

    --Creamos la maquina de estados
    gStateMachine = StateMachine {
        ['inicio'] = function() return Inicio() end,
        ['play'] = function() return Play() end,
        ['charselect'] = function() return Charselect() end,
        ['gameOver'] = function() return GameOver() end,
        ['pause'] = function() return Pause() end,
        ['puntaje_alto'] = function() return PuntajeAlto() end,
        ['lista_puntajes'] = function() return ListaPuntajes() end,
        ['menu'] = function() return Menu() end,
        ['config'] = function() return Config() end
    }

    --Ponemos el primer estado
    gStateMachine:change('inicio', {highScores = loadHighScores()})

    --Creamos una tabla vacía de teclas oprimidas para poder usarlas en otros archivos
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}

    --creamos una lista de efectos de sonido
    list_sounds = {
    	'Soundtrack/Effect/soundLaser1.wav',
    	'Soundtrack/Effect/soundLaser2.wav',
    	'Soundtrack/Effect/soundLaser4.wav',
    	'Soundtrack/Effect/GolpeSimple.wav',
    	'Soundtrack/Effect/soundExplosion1.wav',
    	'Soundtrack/Effect/soundExplosion2.wav',
    	'Soundtrack/Effect/soundExplosion3.wav',
    	'Soundtrack/Effect/EscudoAct.wav',
    	'Soundtrack/Effect/EscudoAct2.wav',
    	'Soundtrack/Effect/EscudoDact.wav',
    	'Soundtrack/Effect/EscudoDact2.wav',
    	'Soundtrack/Effect/hit1.wav',
    	'Soundtrack/Effect/hit2.wav',
    	'Soundtrack/Effect/hit3.wav'
    }

    --creamos una lista con los soundtracks
    menu_soundtrack = {'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}

    --numeros para el puntaje mientras juegas
    gFonts = {
        ['small'] = love.graphics.newFont('Font/font.ttf', 22),
        ['medium'] = love.graphics.newFont('Font/font.ttf', 32),
        ['large'] = love.graphics.newFont('Font/font.ttf', 48)
    }

    love.graphics.setFont(gFonts['large'])
end

function love.update(dt)
	TEsound.cleanup()
    control:update(dt)
	--Hacemos el update segun lo que corresponda del StateMachine
	gStateMachine:update(dt)

	--Vaciamos la lista de teclas orpimidas
	love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function  love.keypressed(key)
	--Ponemos con el valor de true la tecla que fue oprimida
	love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button, isTouch)
    love.mouse.keysPressed[button] = {true, x, y}
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key][1]
end

--Esta funcion puede ser usada en otros archicos para ver si fue oprimida una tecla
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:start()
	gStateMachine:render()
    push:finish()
end

--[[
    Loads high scores from a .lst file, saved in LÖVE2D's default save directory in a subfolder
    called 'betaSpace'.
]]
function loadHighScores()
    love.filesystem.setIdentity('betaSpace')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('betaSpace.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. '0001\n'
            scores = scores .. tostring(i * 100) .. '\n'
        end

        love.filesystem.write('betaSpace.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('betaSpace.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 4)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    for i=1, 10 do
        if scores[i].name:sub(4,4) ~= '1' and scores[i].name:sub(4,4) ~= '2' and scores[i].name:sub(4,4) ~= '3' then
            scores[i].name = scores[i].name .. '1'
        end
    end

    return scores
end