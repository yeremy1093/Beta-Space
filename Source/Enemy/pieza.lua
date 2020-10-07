Pieza = Class{}

local img_crucero_front = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Frontal C-1.png')
local img_crucero_mid = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Mid C-1.png')
local img_crucero_back = love.graphics.newImage('Imagen/SpritesEnemys/Cubierta Back C-1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function Pieza:init(x, y, dx, dy, tipo)
	self.clase = 'pieza'
	self.hp = 12
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.tipo = tipo
	if tipo == 'front' then
		self.sprite = love.graphics.newQuad(0, 0, 100, 120, img_crucero_front:getDimensions())
		self.width = 100
		self.height = 120
	elseif tipo == 'mid' then
		self.sprite = love.graphics.newQuad(0, 0, 60, 98, img_crucero_mid:getDimensions())
		self.width = 60
		self.height = 98
	elseif tipo == 'back' then
		self.sprite = love.graphics.newQuad(0, 0, 88, 89, img_crucero_back:getDimensions())
		self.width = 88
		self.height = 89
	end

	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
	self.anim = Anim(0, 0, 76, 76, 7, 7, 12)

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	
end

--Funcion de update
function Pieza:update(dt)

	if self.hp <= 0 then
	 	self.destruible = true
	end


	if self.destruible == false then 
		self.y = self.y + self.dy * dt
		self.x = self.x + self.dx * dt

		if self.hp >= 9 then
			self.sprite:setViewport(0, 0, self.width, self.height)
		elseif self.hp >= 6 then
			self.sprite:setViewport(self.width, 0, self.width, self.height)
		elseif self.hp >= 3 then
			self.sprite:setViewport(self.width * 2, 0, self.width, self.height)
		elseif self.hp > 0 then
			self.sprite:setViewport(self.width * 3, 0, self.width, self.height)
		end

	else
		local anim_frame = self.anim:update(dt, self.sprite_ex)

		if 1 == anim_frame then
			TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
		
		elseif 7 == anim_frame then
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
		if self.tipo == 'front' then
			love.graphics.draw(img_crucero_front, self.sprite, self.x, self.y)
		elseif self.tipo == 'mid' then
			love.graphics.draw(img_crucero_mid, self.sprite, self.x, self.y)
		elseif self.tipo == 'back' then
			love.graphics.draw(img_crucero_back, self.sprite, self.x, self.y)
		end
		
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x - 50, self.y, 0, 2, 2)
	end
end