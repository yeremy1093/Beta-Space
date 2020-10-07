--Declaramos la clase

Estrella = Class{}

--Cosas que pueden aparecer a veces
local img_estrella = love.graphics.newImage('Imagen/Background/Estrella 1.png')

function Estrella:init(dy)
	self.sprite = love.graphics.newQuad(0, 0, 60, 60, img_estrella:getDimensions())
	self.anim = Anim(0, 0, 60, 60, 6, 6, 10)
	self.dy = dy

	self.width = 60
	self.height = 60

	self.x = love.math.random(0 - (self.width - 80), WINDOW_WIDTH - 80)
	self.y = -(self.height - 5)



end

--Funcion de update
function Estrella:update(dt)
	self.y = self.y + self.dy * dt

	self.anim:update(dt, self.sprite)
	
end

function Estrella:render()
	
	love.graphics.draw(img_estrella, self.sprite, self.x, self.y, 0, 0.5, 0.5)
	
end