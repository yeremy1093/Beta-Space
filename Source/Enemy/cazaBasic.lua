CazaBasic = Class{}

local sprite_sheet_caz = love.graphics.newImage('Imagen/SpritesEnemys/caza1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function CazaBasic:init(x, y, dx, dy)
	self.clase = 'caza'
	self.hp = 1
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.width = 58
	self.height = 40
	self.sprite = love.graphics.newQuad(0, 0, 58, 40, sprite_sheet_caz:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
	self.fps = 12

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 2, 2, self.fps),
				['explosion'] = Anim(0, 0, 76, 76, 7, 7, self.fps)}
end

--Funcion de update
function CazaBasic:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	if self.hp <= 0 then
	 	self.destruible = true
	end

	if self.destruible == false then 
		self.anim['idle']:update(dt, self.sprite)
	else
		if 7 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function CazaBasic:collides(objeto)
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

function CazaBasic:render()
	if self.destruible == false then
		love.graphics.draw(sprite_sheet_caz, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x - 20, self.y - 20, 0, 1.5, 1.5)
	end
end