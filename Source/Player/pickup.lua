--Declaramos la clase

Pickup = Class{}

--Variables para guardar los sprite sheet de las animaciones
local sprite_sheet = love.graphics.newImage('Imagen/Sprites/Quad-util.png')

function Pickup:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.sprite = love.graphics.newQuad(0, 300, 60, 60, sprite_sheet:getDimensions())
	self.width = 60
	self.height = 60
	self.fps = math.random(6, 10)
	if love.math.random(1, 2) == 1 then
		self.tipo = 'direccional'
	else
		self.tipo = 'pulsar'
	end
	--Aqui van todas las animaciones posibles
	self.anim = {['arma1'] = Anim(0, 300, self.width, self.height, 4, 4, self.fps),
				['arma2'] = Anim(240, 300, self.width, self.height, 4, 4, self.fps)}
end

--Funcion de update
function Pickup:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	if self.tipo == 'direccional' then 
		self.anim['arma1']:update(dt, self.sprite)
	elseif self.tipo == 'pulsar' then 
		self.anim['arma2']:update(dt, self.sprite)
	end
end

function Pickup:collides(objeto)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > objeto.x + objeto.width or objeto.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > objeto.y + objeto.height or objeto.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end


function Pickup:render()
	love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y)
end