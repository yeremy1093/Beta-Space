--Declaramos la clase

Planeta = Class{}

--Cosas que pueden aparecer a veces
local img_planeta1 = love.graphics.newImage('Imagen/Background/Planeta 1.png')
local img_planeta2 = love.graphics.newImage('Imagen/Background/Planeta 2.png')
local img_planeta3 = love.graphics.newImage('Imagen/Background/Planeta 3.png')

function Planeta:init(dy)
	self.num = love.math.random(1, 3)
	if self.num == 3 then
		self.sprite = img_planeta3
	elseif self.num == 2 then
		self.sprite = img_planeta2
	elseif self.num == 1 then
		self.sprite = love.graphics.newQuad(0, 0, 200, 200, img_planeta1:getDimensions())
		self.anim = Anim(0, 0, 200, 200, 8, 8, 8)
	end
	self.dy = dy

	self.scale = love.math.random(1, 5)

	self.width = 200 * self.scale
	self.height = 200 * self.scale

	self.x = love.math.random(0 - (self.width - 80), WINDOW_WIDTH - 80)
	self.y = -(self.height - 5)



end

--Funcion de update
function Planeta:update(dt)
	self.y = self.y + self.dy * dt
	if self.num == 1 then
		self.anim:update(dt, self.sprite)
	end
end

function Planeta:render()
	if self.num == 1 then
		love.graphics.draw(img_planeta1, self.sprite, self.x, self.y , 0, self.scale, self.scale)
	else
		love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
	end
end