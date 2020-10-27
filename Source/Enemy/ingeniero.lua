--queria ser ingeniero, pero me abortaron, oajala hubiera nacido en mi pais tercermundista con mi familia de bajos recursos, eduacion y 
--sin servicio medico porque la rifa del avion es mas importante

Ingeniero = Class{}

local sprite_sheet_inge = love.graphics.newImage('Imagen/SpritesEnemys/Enginier.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

local lineaRecta = 0
local lineaCurva = 1

function Ingeniero:init(x, y, velocity)
    self.clase = 'ingeniero'
    self.hp = 4
	self.x = x
    self.y = y
	self.width = 94
    self.height = 66
    self.velx = 0
    self.vely = 0
	self.sprite = love.graphics.newQuad(0, 0, 94, 66, sprite_sheet_inge:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 94, 66, sprite_sheet_explosion:getDimensions())
    self.fps = love.math.random(6, 10)
    self.comportamiento = love.math.random(lineaRecta, lineaCurva)

    if lineaRecta == self.comportamiento then
        local angle = (math.pi / 180) * love.math.random(20, 150)
        self.velx = velocity * math.cos(angle)
        self.vely = velocity * math.sin(angle)
    else
        self.velx = (velocity / 4) * love.math.random(-1,1)
        self.vely = velocity
    end
    --variable para saber cuando el asteroide explotó y se puede borrar
    self.destruible = false

	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 6, 6, self.fps),
                ['explosion'] = Anim(0, 0, 25, 25, 4, 4, self.fps)} 
end

--Funcion de update
function Ingeniero:update(dt)
    if self.hp <= 0 then
        self.destruible = true
    end
    if self.destruible == false then
        self.anim['idle']:update(dt, self.sprite)

        if self.comportamiento == lineaCurva then
            self.vely = self.vely - 50 * dt
        end
        self.y = self.y + self.vely * dt 
        self.x = self.x + self.velx * dt
	else
		if 4 == self.anim['explosion']:update(dt, self.sprite_ex) then
			return false
		end
	end
	return true
end

function Ingeniero:collides(objeto)
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

function Ingeniero:render()
	if self.destruible == false then
        love.graphics.draw(sprite_sheet_inge, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
    end
end