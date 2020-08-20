
Pause = Class{__includes = BaseState}


function Pause:enter(params)
--Agregamos parametro para evitar que se reinicie Play
self.play = params.state

self.pause_msg = Escribir("Pausa")

--Cargar Selector de menu
self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
self.target = Anim(0,0,60,60,5,5,10)
self.targetY = (WINDOW_HEIGHT / 2) + 20

end



function Pause:update(dt)

	self.target:update(dt, self.target_sprite)

	if love.keyboard.wasPressed('up') then
        self.targetY = self.targetY - 60
        if self.targetY < (WINDOW_HEIGHT / 2) + 20 then
            self.targetY = (WINDOW_HEIGHT / 2) + 20
        end
    end
    if love.keyboard.wasPressed('down') then
    	self.targetY = self.targetY + 60
        if self.targetY > (WINDOW_HEIGHT / 2) + 80 then
            self.targetY = (WINDOW_HEIGHT / 2) + 80
        end
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    	if self.targetY == (WINDOW_HEIGHT / 2) + 20 then
	        gStateMachine:change('play', {pickup_timer = self.play.pickup_timer,
	                                      pickups = self.play.pickups,
	                                      vidas = Numvidas,
	                                      player = self.play.player,
	                                      shotManager = self.play.shotManager,
	                                      enemyManager = self.play.enemyManager,
	                                      background = self.play.background,
	                                      sky = self.play.sky,
                                          highScores = self.play.highScores})
	    else
	    	TEsound.stop('musica_menu')
        	gStateMachine:change('inicio', {highScores = self.play.highScores})
        end
    end
end

function Pause:render()
self.play:render()

love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setColor(1, 1, 1, 1)

self.pause_msg:render((WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) - 60, 3, 3)

love.graphics.draw(self.target_sheet, self.target_sprite, 420, self.targetY)

love.graphics.setFont(gFonts['medium'])

love.graphics.print("Continuar Juego", (WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) + 35)

love.graphics.print("Menu Principal", (WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) + 95)

love.graphics.setFont(gFonts['large'])
	

end

