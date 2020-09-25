--Declaramos la clase

AsteroideG = Class{}

--Variables para guardar los sprite sheet de las animaciones
local sprite_sheet_ast = love.graphics.newImage('Imagen/Sprites/MaxAt.png')

function AsteroideG:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.sprite = love.graphics.newQuad(0, 0, 120, 120, sprite_sheet_ast:getDimensions())
	self.width = 240
	self.height = 240
	self.fps = 12
	--Aqui van todas las animaciones posibles
	self.anim = Anim(0, 0, self.width, self.height, 8, 8, self.fps)
end

--Funcion de update
function AsteroideG:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	self.anim:update(dt, self.sprite)

	return true
end

function AsteroideG:collides(objeto)
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


function AsteroideG:render()
	love.graphics.draw(sprite_sheet_ast, self.sprite, self.x, self.y, 0, 2, 2)
end