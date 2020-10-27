--queria ser ingeniero, pero me abortaron, oajala hubiera nacido en mi pais tercermundista con mi familia de bajos recursos, eduacion y 
--sin servicio medico porque la rifa del avion es mas importante

Ingeniero = Class{}

local sprite_sheet_inge = love.graphics.newImage('Imagen/SpritesEnemys/Enginier.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explo-Bullet.png')

local lineaRecta = 0
local lineaCurva = 1

local Freq = 1/5

function Ingeniero:init(x, y, velocity)
    self.clase = 'ingeniero'
    self.hp = 4
	self.x = x
    self.y = y
	self.width = 94
    self.height = 66
    self.velocity = velocity
    self.velx = 0
    self.vely = 0
    self.orinx = 0
    self.oriny = 0
    self.axisx = 0 
    self.axisy = 0
	self.sprite = love.graphics.newQuad(0, 0, 94, 66, sprite_sheet_inge:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 94, 66, sprite_sheet_explosion:getDimensions())
    self.fps = love.math.random(6, 10)
    --self.comportamiento = love.math.random(lineaRecta, lineaCurva)
    self.comportamiento = lineaRecta

    if lineRecta == self.comportamiento then
        local angle = math.pi / love.math.random(45, 135)
        self.velx = -velocity * math.cos(angle)
        self.vely = -velocity * math.sin(angle)
    else
        self.orinx = self.x
        self.oriny = self.y
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

        if self.comportamiento == lineaRecta then
            self.y = self.y + self.vely * dt 
            self.x = self.x + self.velx * dt
        else -- lineaCurva
            local angle = 2*math.pi*Freq*dt
            local v = self.velocity
            if angle >= math.pi*0.9 and angle <= 2*math.pi*0.1 then
                v = v * 0.2
            end
            self.axisx = self.axisx + v * dt
            self.axisy = self.axisx * math.sin(angle)
            self.x = self.orinx + self.axisx
            self.y = self.oriny + self.axisy
        end
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