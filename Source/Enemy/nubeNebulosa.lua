Nebulosa = Class{}

local img_nebulosa1 = love.graphics.newImage('Imagen/Background/Nebulosa Rosa 1.png')
local img_nebulosa2 = love.graphics.newImage('Imagen/Background/Nebulosa Rosa 2.png')
local img_nebulosa3 = love.graphics.newImage('Imagen/Background/Nebulosa Rosa 3.png')
local img_nebulosaRoja = love.graphics.newImage('Imagen/Background/Curse Nebula.png')


function Nebulosa:init(x, y, dx, dy)
	local tipo_nebulosa = love.math.random(1, 4)
	if tipo_nebulosa == 1 then
		self.clase = 'nebulosa_normal'
		self.sprite = img_nebulosa1
	elseif tipo_nebulosa == 2 then
		self.clase = 'nebulosa_normal'
		self.sprite = img_nebulosa2
	elseif tipo_nebulosa == 3 then
		self.clase = 'nebulosa_normal'
		self.sprite = img_nebulosa3
	elseif tipo_nebulosa == 4 then
		self.clase = 'nebulosa_mala'
		self.sprite = love.graphics.newQuad(0, 0, 500, 250, img_nebulosaRoja:getDimensions())
		self.anim = Anim(0, 0, 500, 250, 6, 6, 10)
		self.damage = 1
		self.tiempo_damage = 1
	end
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.width = 1000
	self.height = 500
end

--Funcion de update
function Nebulosa:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	if self.clase == 'nebulosa_mala' then
		self.anim:update(dt, self.sprite)
	end

end

function Nebulosa:collides(objeto)
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

function Nebulosa:render()
	if self.clase == 'nebulosa_mala' then
		love.graphics.draw(img_nebulosaRoja, self.sprite, self.x, self.y, 0, 2, 2)
	else
		love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
	end
end