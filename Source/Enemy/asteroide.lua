--Declaramos la clase

Asteroide = Class{}

--Variables para guardar los sprite sheet de las animaciones
local sprite_sheet_ast = love.graphics.newImage('Imagen/Sprites/asteroideAnimado.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function Asteroide:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.sprite = love.graphics.newQuad(0, 0, 41, 41, sprite_sheet_ast:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
	self.width = 41
	self.height = 41
	self.fps = 12
	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 6, 6, self.fps),
				['explosion'] = Anim(0, 0, 76, 76, 7, 7, self.fps)}
end

--Funcion de update
function Asteroide:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	if self.destruible == false then 
		self.anim['idle']:update(dt, self.sprite)
	else
		if 7 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function Asteroide:collides(objeto)
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


function Asteroide:render()
	if self.destruible == false then
		love.graphics.draw(sprite_sheet_ast, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
	end
end