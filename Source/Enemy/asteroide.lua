--Declaramos la clase

Asteroide = Class{}

local sprite_sheet_ast = love.graphics.newImage('Imagen/Sprites/asteroideAnimado.png')

function Asteroide:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.width = 41
	self.height = 41
	self.sprite = love.graphics.newQuad(0, 0, 41, 41, sprite_sheet_ast:getDimensions())
	self.fps = math.random(6, 10)

	self.anim = Anim(0, 0, self.width, self.height, 6, 6, self.fps)
end

--Funcion de update
function Asteroide:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	self.anim:update(dt, self.sprite)
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
	love.graphics.draw(sprite_sheet_ast, self.sprite, self.x, self.y)
end