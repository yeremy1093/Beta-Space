
Pause = Class{__includes = BaseState}


function Pause:enter(params)
--Agregamos parametro para evitar que se reinicie Play
self.play = params.state

end



function Pause:update(dt)
   
end

function Pause:render()
self.play:render()
	

end

