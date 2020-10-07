Pieza = Class{}

local img_crucero_front = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Frontal C-1.png')
local img_crucero_mid = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Mid C-1.png')
local img_crucero_back = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Back C-1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function Pieza:init(x, y, dx, dy, tipo)
	self.clase = 'pieza'
	self.hp = 4
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy



	self.width = 60
	self.height = 261
	self.sprite = love.graphics.newQuad(0, 0, self.width, self.height, img_crucero_core:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	
end

--Funcion de update
function Pieza:update(dt)
	self.y = self.y + self.dy * dt

	if self.hp <= 0 then
	 	self.destruible = true
	end

	if self.destruible == false then 
		self.anim['idle']:update(dt, self.sprite)
	else
		if 9 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function Pieza:collides(objeto)
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
	
	if self.destruible then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Pieza:render()
	if self.destruible == false then
		love.graphics.draw(img_crucero_core, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x - 70, self.y)
	end
end