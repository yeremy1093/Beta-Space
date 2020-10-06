--imagenes de fondo
Background = Class{}

local blackhole = love.graphics.newImage('Imagen/Background/Black Hole.png')
local azul = love.graphics.newImage('Imagen/Background/Azul.png')
local bigeye = love.graphics.newImage('Imagen/Background/Gran OJO.png')
local disco = love.graphics.newImage('Imagen/Background/Disco.png')

--Numero para saber cual imagen se queda hasta el final
local Num = love.math.random(1, 4)

function Background:init()
	if Num == 1 then 
		self.loopingStars = blackhole
	elseif Num == 2 then
		self.loopingStars = azul
	elseif Num == 3 then
		self.loopingStars = bigeye
	elseif Num == 4 then
		self.loopingStars = disco
	end

end	

function Background:render_background()
	--rendereamos las estrellas sobre el fondo
	love.graphics.draw(self.loopingStars, 0, 0)
end


