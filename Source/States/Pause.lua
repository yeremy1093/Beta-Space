
Pause = Class{__includes = BaseState}


function Pause:enter(params)
--Agregamos parametro para evitar que se reinicie Play
self.play = params.state

end



function Pause:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('play', {pickup_timer = self.play.pickup_timer,
                                      pickups = self.play.pickups,
                                      vidas = Numvidas,
                                      player = self.play.player,
                                      shotManager = self.play.shotManager,
                                      enemyManager = self.play.enemyManager,
                                      background = self.play.background,
                                      sky = self.play.sky})
    end
end

function Pause:render()
self.play:render()
	

end

