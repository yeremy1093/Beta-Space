
require 'Source/Util/Include'

function love.load()
	--Por si se ofrece
	math.randomseed(os.time())
	--Ponemos lo de los parametros de la pantalla
	love.window.setMode( WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --Creamos la maquina de estados
    gStateMachine = StateMachine {
        ['inicio'] = function() return Inicio() end,
        ['play'] = function() return Play() end
    }

    --Ponemos el primer estado
    gStateMachine:change('inicio', {})

    --Creamos una tabla vacía de teclas oprimidas para poder usarlas en otros archivos
    love.keyboard.keysPressed = {}

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
        ['small'] = love.graphics.newFont('Font/font.ttf', 8),
        ['medium'] = love.graphics.newFont('Font/font.ttf', 16),
        ['large'] = love.graphics.newFont('Font/font.ttf', 32)
    }

    love.graphics.setFont(gFonts['large'])
end

function love.update(dt)
	TEsound.cleanup()
	--Hacemos el update segun lo que corresponda del StateMachine
	gStateMachine:update(dt)

	--Vaciamos la lista de teclas orpimidas
	love.keyboard.keysPressed = {}
end

function  love.keypressed(key)
	--Ponemos con el valor de true la tecla que fue oprimida
	love.keyboard.keysPressed[key] = true
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

	gStateMachine:render()

end