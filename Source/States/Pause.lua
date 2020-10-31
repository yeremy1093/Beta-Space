
Pause = Class{__includes = BaseState}


function Pause:enter(params)
    --Agregamos parametro para evitar que se reinicie Play
    self.play = params.state

    self.params = params

    self.params.ultimoEstado = 'pause'

    self.pause_msg = Escribir("Pausa")

    --Cargar Selector de menu
    self.target_sheet = love.graphics.newImage('Imagen/Menus/target.png')
    self.target_sprite = love.graphics.newQuad(0, 0, 60, 60, self.target_sheet:getDimensions())
    self.target = Anim(0,0,60,60,5,5,10)
    self.targetY = (WINDOW_HEIGHT / 2) + 20

    self.timer_no_touch = 0.3

end



function Pause:update(dt)

     if self.timer_no_touch > 0 then
        self.timer_no_touch = self.timer_no_touch - dt
    else
        --obtenemos la posicion del mouse y reaccionamos al click 
        --los botones estan en x de 545 a 720
        --en y son: 485/540, 545/600, 605/660
        local x, y = love.mouse.getPosition()
        local mouseX, mouseY = push:toGame(x, y)
        if mouseX ~= nil and mouseY ~= nil then
            if mouseY >= (WINDOW_HEIGHT / 2) and mouseY <= (WINDOW_HEIGHT / 2) + 60 then
                if love.mouse.isDown(1) then
                    gStateMachine:change('play', {pickup_timer = self.play.pickup_timer,
                                              pickups = self.play.pickups,
                                              vidas = Numvidas,
                                              player = self.play.player,
                                              shotManager = self.play.shotManager,
                                              enemyManager = self.play.enemyManager,
                                              background = self.play.background,
                                              sky = self.play.sky,
                                              highScores = self.play.highScores})
                end
            elseif mouseY >= (WINDOW_HEIGHT / 2) + 70 and mouseY <= (WINDOW_HEIGHT / 2) + 130 then
                if love.mouse.isDown(1) then
                    gStateMachine:change('config', self.params)
                end
            elseif mouseY >= (WINDOW_HEIGHT / 2) + 140 and mouseY <= (WINDOW_HEIGHT / 2) + 200 then
                if love.mouse.isDown(1) then
                    TEsound.stop('musica_menu')
                    TEsound.stop('musica_play')
                    gStateMachine:change('inicio', {highScores = self.highScores})
                end
            end
        end
    end
end

function Pause:render()
self.play:render()

love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
love.graphics.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setColor(1, 1, 1, 1)

self.pause_msg:render((WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) - 60, 3, 3)


love.graphics.setFont(gFonts['medium'])

love.graphics.print("Continuar Juego", (WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) + 35)

love.graphics.print("Configuraciones", (WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) + 95)

love.graphics.print("Menu Principal", (WINDOW_WIDTH / 2) - 150, (WINDOW_HEIGHT / 2) + 155)

love.graphics.setFont(gFonts['large'])
	

end

