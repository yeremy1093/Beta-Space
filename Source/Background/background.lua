--imagenes de fondo
Background = Class{}

local scrollspeed = 10
local loopingpoint = 0

function Background:init()
	self.loopingStars = love.graphics.newImage('Imagen/Background/Space-2.png')
	self.backgroundscroll = -2880
end

function Background:animate_background(dt)
	if self.backgroundscroll <= loopingpoint then 
		self.backgroundscroll = (self.backgroundscroll + scrollspeed * dt)
	else
		self.backgroundscroll = -2880
	end	
end 

function Background:render_background()
	--rendereamos las estrellas sobre el fondo
	love.graphics.draw(self.loopingStars, 0, self.backgroundscroll)
end


