HunterSlave = Class{}
--Me pidieron la version chafa y pos yo la voy a hacer

local sprite_sheet_hunter = love.graphics.newImage('Imagen/SpritesEnemys/Hunter-1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function HunterSlave:init(x, y, velocity, izquierda)
    self.clase = 'hunterMenso'
    self.hp = 4
	self.x = x
    self.y = y
    self.velx = velocity
    self.vely = velocity * (math.random(1,10)/10)
	self.width = 58
    self.height = 40
    self.spacex = spacex
    self.spacey = spacey
    self.velocity = velocity
	self.sprite = love.graphics.newQuad(0, 0, 58, 40, sprite_sheet_hunter:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.fps = math.random(6, 10)
    --variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
    if izquierda then
        self.vely = -self.vely
    end

    self.conty = 1

	--Aqui van todas las animaciones posibles
	self.anim = {['no_damage'] = Anim(0, 0, self.width, self.height, 2, 2, self.fps),
                ['small_damage'] = Anim(116, 0, self.width, self.height, 2, 2, self.fps),
                ['medium_damage'] = Anim(232, 0, self.width, self.height, 2, 2, self.fps),
                ['high_damage'] = Anim(348, 0, self.width, self.height, 2, 2, self.fps),
                ['explosion'] = Anim(0, 0, 25, 25, 4, 4, self.fps)} 
end

--Funcion de update
function HunterSlave:update(dt)
    if self.hp <= 0 then
        self.destruible = true
    end
    if self.destruible == false then
        if self.hp > 3 then
            self.anim['no_damage']:update(dt, self.sprite)
        elseif self.hp > 2 then
            self.anim['small_damage']:update(dt, self.sprite)
        elseif self.hp > 1 then
            self.anim['medium_damage']:update(dt, self.sprite)
        elseif self.hp > 0 then
            self.anim['high_damage']:update(dt, self.sprite)
        end
        --Comportamiento
        self.x = self.x + self.velx * dt
        self.y = self.y + self.vely * dt
        self.conty = self.conty - dt
        if self.conty <= 0 then
            self.conty = 1
            self.vely = (-1) * self.vely
        end
	else
		if 4 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function HunterSlave:collides(objeto)
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

function HunterSlave:render()
	if self.destruible == false then
        love.graphics.draw(sprite_sheet_hunter, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
	end
end