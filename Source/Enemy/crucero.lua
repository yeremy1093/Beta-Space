Crucero = Class{}

local img_crucero_core = love.graphics.newImage('Imagen/SpritesEnemys/CR-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/SuperExp.png')

function Crucero:init(dy)
	self.clase = 'crucero'
	self.hp = 8
	self.x = love.math.random(50, WINDOW_WIDTH - 100)
	self.y = -155
	self.imagex = self.x - 13
	self.imagey = self.y - 105
	self.dy = dy
	self.width = 34
	self.height = 34
	self.sprite = love.graphics.newQuad(0, 0, self.width, self.height, img_crucero_core:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 200, 200, sprite_sheet_explosion:getDimensions())
	self.fps = 12

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 8, 8, self.fps),
				['explosion'] = Anim(0, 0, 200, 200, 9, 9, self.fps)}
end

--Funcion de update
function Crucero:update(dt)
	self.y = self.y + self.dy * dt

	self.imagex = x - 13
	self.imagey = y - 105

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

function Crucero:collides(objeto)
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

function Crucero:render()
	if self.destruible == false then
		love.graphics.draw(img_crucero_core, self.sprite, self.imagex, self.imagey)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.imagex - 70, self.imagey)
	end
end