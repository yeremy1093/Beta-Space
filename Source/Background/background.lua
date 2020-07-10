--imagenes de fondo

function load_background()
	loopingStars = love.graphics.newImage('Imagen/Background/Space-2.png')
	scrollspeed = 10
	loopingpoint = 0
	backgroundscroll = -2880
end

function animate_background(dt)
	if backgroundscroll <= loopingpoint then 
		backgroundscroll = (backgroundscroll + scrollspeed * dt)
	else
		backgroundscroll = -2880

	end	
end 

function render_background()
	--rendereamos las estrellas sobre el fondo
	love.graphics.draw(loopingStars, 0, backgroundscroll)
end


