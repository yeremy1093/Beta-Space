Torreta = Class{}

local img_torreta_cannon = love.graphics.newImage('Imagen/SpritesEnemys/Torret cannon.png')
local img_torreta_disco = love.graphics.newImage('Imagen/SpritesEnemys/Torret-Disc.png')
local img_torreta_photon = love.graphics.newImage('Imagen/SpritesEnemys/Torret Ph-Ball.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Torreta:init(x, y, xoffset, yoffset, tipo, pieza)
	self.clase = 'torreta'
	self.pieza = pieza
	self.hp = 1
	self.x = x
	self.y = y
	self.xoffset = xoffset
	self.yoffset = yoffset
	self.tipo = tipo
	self.disparo = false
	self.cooldown = false
	self.sprite_ex = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
	if tipo == 'torreta_cannon' then
		local frame = love.math.random(0,4)
		local offset = frame * 20
		self.width = 20
		self.height = 20
		self.sprite = love.graphics.newQuad(offset, 0, 20, 20, img_torreta_cannon:getDimensions())
		self.anim = Anim(0, 0, 20, 20, 5, 5, 2)
		self.anim.frame = frame
	elseif tipo == 'torreta_photon' then
		self.width = 20
		self.height = 20
		self.sprite = love.graphics.newQuad(0, 0, 20, 20, img_torreta_photon:getDimensions())
		self.anim = Anim(0, 0, 20, 20, 10, 10, 10)
		self.timer_photon = love.math.random(2,5)
	elseif tipo == 'torreta_disco' then
		self.width = 40
		self.height = 40
		self.sprite = love.graphics.newQuad(0, 0, 40, 40, img_torreta_disco:getDimensions())
		self.anim = Anim(0, 0, 40, 40, 20, 20, 10)
		self.timer_disc = love.math.random(3,6)
	end

	self.anim_ex = Anim(0, 0, 25, 25, 4, 4, 10)

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	
end

--Funcion de update
function Torreta:update(dt, x, y)

	if self.hp <= 0 then
	 	self.destruible = true
	end


	if self.destruible == false then 
		self.y = y + self.yoffset
		self.x = x + self.xoffset

		if self.tipo == 'torreta_cannon' then
			local anim_frame = self.anim:update(dt, self.sprite)
			if 5 == anim_frame and self.cooldown == false then
				self.disparo = true
			elseif 5 ~= anim_frame then
				self.cooldown = false
				self.disparo = false
			end
		elseif self.tipo == 'torreta_photon' then
			if self.timer_photon <= 0 then
				local anim_frame = self.anim:update(dt, self.sprite)
				if 5 == anim_frame and self.cooldown == false then
					self.disparo = true
				elseif 5 ~= anim_frame then
					self.cooldown = false
					self.disparo = false
				end
				if 10 == anim_frame then
					self.timer_photon = love.math.random(2,5)
					self.sprite:setViewport(0, 0, self.width, self.height)
					self.anim.frame = 1
				end

			else
				self.timer_photon = self.timer_photon - dt
			end
			
		elseif self.tipo == 'torreta_disco' then
			if self.timer_disc <= 0 then
				local anim_frame = self.anim:update(dt, self.sprite)
				if 10 == anim_frame and self.cooldown == false then
					self.disparo = true
				elseif 10 ~= anim_frame then
					self.cooldown = false
					self.disparo = false
				end
				if 20 == anim_frame then
					self.timer_disc = love.math.random(3,6)
					self.sprite:setViewport(0, 0, self.width, self.height)
					self.anim.frame = 1
				end

			else
				self.timer_disc = self.timer_disc - dt
			end
		end

	else
		local anim_frame = self.anim_ex:update(dt, self.sprite_ex)
		
		if 4 == anim_frame then
			return false
		end
	end
	return true
end

function Torreta:collides(objeto)
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

function Torreta:render()
	if self.destruible == false then
		if self.tipo == 'torreta_cannon' then
			love.graphics.draw(img_torreta_cannon, self.sprite, self.x, self.y)
		elseif self.tipo == 'torreta_photon' then
			love.graphics.draw(img_torreta_photon, self.sprite, self.x, self.y)
		elseif self.tipo == 'torreta_disco' then
			love.graphics.draw(img_torreta_disco, self.sprite, self.x, self.y)
		end
		
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
	end
end