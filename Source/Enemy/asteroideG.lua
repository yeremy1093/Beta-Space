--Declaramos la clase

AsteroideG = Class{}

--Variables para guardar los sprite sheet de las animaciones
local sprite_sheet_ast = love.graphics.newImage('Imagen/Sprites/GigaAsteroide.png')

function AsteroideG:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.sprite = sprite_sheet_ast
	self.width = 360
	self.height = 360
	self.fps = 12
	--Aqui van todas las animaciones posibles
	self.deg = 0
end

--Funcion de update
function AsteroideG:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	self.deg = self.deg + 1;
	if self.deg >= 360 then
		self.deg = 0
	end

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
	love.graphics.draw(self.sprite, self.x + self.width/2 + 20, self.y + self.height/2 + 20, math.rad(self.deg), 1, 1, self.width/2, self.height/2)
end