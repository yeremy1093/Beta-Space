Drone = Class{}

local sprite_sheet_drone = love.graphics.newImage('Imagen/SpritesEnemys/Drone.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

function Drone:init(x, y, timeToTarget, player)
	self.x = x
	self.y = y
    self.timeToTarget = 1/timeToTarget
	self.width = 20
	self.height = 16
	self.sprite = love.graphics.newQuad(0, 0, 20, 16, sprite_sheet_drone:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 25, 25, sprite_sheet_explosion:getDimensions())
    self.fps = math.random(6, 10)

    --Define distancia inicial
    self.distancey = 0
    self.distancex = 0 
    if self.y <= (player.y + (player.height/2)) then -- Drone esta arriba del jugador
        self.distancey = player.y + (player.height/2) - self.y
    else -- Drone esta abajo del jugador
        self.distancey = self.y + (player.height/2) - player.y
    end

    if self.x <= (player.x + (player.width/2)) then -- Drone esta a la izquierda del jugador
        self.distancex = player.x + (player.width/2) - self.x
    else -- Drone esta a la derecha del jugador
        self.distancex = self.x + (player.width/2) - player.x
    end
    self.lastDistance = (self.distancex^2 + self.distancey^2)^0.5

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 3, 3, self.fps),
				['explosion'] = Anim(0, 0, 25, 25, 4, 4, self.fps)}
end

--Funcion de update
function Drone:update(dt, player)
    if self.y <= (player.y + (player.height/2)) then -- Drone esta arriba del jugador
        self.distancey = player.y + (player.height/2) - self.y
        self.y = self.y + self.distancey * dt * self.timeToTarget 
    else -- Drone esta abajo del jugador
        self.distancey = self.y + (player.height/2) - player.y
        self.y = self.y - self.distancey * dt * self.timeToTarget 
    end

    if self.x <= (player.x + (player.width/2)) then -- Drone esta a la izquierda del jugador
        self.distancex = player.x + (player.width/2) - self.x
        self.x = self.x + self.distancex * dt * self.timeToTarget 
    else -- Drone esta a la derecha del jugador
        self.distancex = self.x + (player.width/2) - player.x
        self.x = self.x - self.distancex * dt * self.timeToTarget 
    end
    new_distance = (self.distancex^2 + self.distancey^2)^0.5
    self.timeToTarget = (self.lastDistance / new_distance) * self.timeToTarget
    self.lastDistance = new_distance

	if self.destruible == false then 
		self.anim['idle']:update(dt, self.sprite)
	else
		if 4 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function Drone:collides(objeto)
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

function Drone:render()
	if self.destruible == false then
		love.graphics.draw(sprite_sheet_drone, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
	end
end