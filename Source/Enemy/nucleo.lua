Nucleo = Class{}

local img_nucleo = love.graphics.newImage('Imagen/SpritesEnemys/Nodo-shield.png')

local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function Nucleo:init(x, y, xoffset, yoffset)
	self.clase = 'nucleo'
	self.hp = 12
	self.x = x
	self.y = y
	self.xoffset = xoffset
	self.yoffset = yoffset
	self.sprite_sheet = img_nucleo
	self.sprite = love.graphics.newQuad(0, 0, 40, 40, img_nucleo:getDimensions())
	self.width = 40
	self.height = 40


	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
	self.anim_ex = Anim(0, 0, 76, 76, 7, 7, 12)
	self.anim = Anim(0, 0, 40, 40, 3, 3, 12)

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	self.destruido = false
	self.wasCollides = false

	self.balas_usadas = {}
	
end

--Funcion de update
function Nucleo:update(dt, x, y)

	if self.hp <= 0 then
	 	self.destruible = true
	end
	self.y = y + self.yoffset
	self.x = x + self.xoffset


	if self.destruible == false then

		self.anim:update(dt, self.sprite)

	else

		if self.destruido == false then
			local anim_frame = self.anim_ex:update(dt, self.sprite_ex)

			if 1 == anim_frame then
				TEsound.play({'Soundtrack/Effect/Explosion Small.wav','Soundtrack/Effect/Explosion Medium.wav'},
						'static',
						{'effect'},	VOLUMEN_EFECTOS / 2)
			
			elseif 7 == anim_frame then
				self.sprite:setViewport(120, 0, self.width, self.height)
				self.destruido = true
				return false
			end
		end

		
	end
	return true
end

function Nucleo:collides(objeto)
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

function Nucleo:render()
	if self.destruible == false then
		love.graphics.draw(self.sprite_sheet, self.sprite, self.x, self.y)
	else
		if self.destruido then
			love.graphics.draw(self.sprite_sheet, self.sprite, self.x, self.y)
		else
			love.graphics.draw(self.sprite_sheet, self.sprite, self.x, self.y)
			love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x - 50, self.y, 0, 2, 2)
		end
	end
end