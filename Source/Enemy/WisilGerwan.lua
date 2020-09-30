--Declaramos la clase
Wisil = Class{}

--Hacemos la funcion inicial

local sprite_sheet = love.graphics.newImage('Imagen/SpritesEnemys/Missil.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Wisil:init(x, y, speed, xspeed)
	self.clase = 'misil'
	self.damage = 2
	self.x = x
	self.y = y
	self.speed = speed
	self.speedChange = speed * 6
	self.newx = x
	self.newy = y - 200
	self.xspeed = xspeed
	self.yspeed = -speed
	self.angulo = 0
	self.sprite = love.graphics.newQuad(0, 0, 6, 15, sprite_sheet:getDimensions())
	self.width = 6
	self.height = 15
    self.spriteExplotion = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.destruible = false
    self.anim = {['explotando'] = Anim(0, 0, 25, 25, 4, 4, 10),
    			['idle'] = Anim(0, 0, 6, 15, 2, 2, 10)}

    self.enemy_min_x = 0


end

--Funcion de update
function Wisil:update(dt, player)
	local new_distance = 1
	if self.destruible == true then 
		if 4 == self.anim['explotando']:update(dt, self.spriteExplotion) then
			return false
		end
	else
        self.newx = player.x
        self.newy = player.y

        if self.y <= self.newy then -- Misil esta arriba del enemigo
            self.yspeed = math.min(self.yspeed + self.speedChange * dt, self.speed)
        else -- Misil esta abajo del enemigo
            self.yspeed = math.max(self.yspeed - self.speedChange * dt, -self.speed)
        end

        if self.x <= self.newx then -- Misil esta a la izquierda del enemigo
            self.xspeed = math.min(self.xspeed + self.speedChange * dt, self.speed)
        else -- Misil esta a la derecha del enemigo
            self.xspeed = math.max(self.xspeed - self.speedChange * dt, -self.speed)
        end

        self.y = self.y + self.yspeed * dt
        self.x = self.x + self.xspeed * dt

		if self.xspeed == 0 then
			self.angulo = 0
		else
			if self.xspeed > 0 then
				self.angulo = math.deg(math.atan(self.yspeed/self.xspeed)) + 90
			else
				self.angulo = math.deg(math.atan(self.yspeed/self.xspeed)) - 90
			end
		end

		self.anim['idle']:update(dt, self.sprite)
	end

	return true	
end

function Wisil:collides(objeto)
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

function Wisil:render()
	if self.destruible == true then
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet, self.sprite, self.x, self.y, math.rad(self.angulo), 1, 1, self.width/2, self.height-7)
	end

end