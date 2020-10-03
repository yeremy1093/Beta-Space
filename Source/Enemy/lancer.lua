Lancer = Class{}

local sprite_sheet_lancer_izquierda = love.graphics.newImage('Imagen/SpritesEnemys/Ln-D.png')
local sprite_sheet_lancer_derecha = love.graphics.newImage('Imagen/SpritesEnemys/Ln-I.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion2.png')

function Lancer:init(x, y, vel, izquierda)
    self.izquierda = izquierda
    self.hp = 1
    self.x = x
    self.y = y
    self.vel = vel
    self.hp = 2
    self.clase = 'Lancer'
    if self.izquierda then
        self.vel = -self.vel
        self.sprite = love.graphics.newQuad(0, 0, 58, 40, sprite_sheet_lancer_izquierda:getDimensions())
    else
        self.sprite = love.graphics.newQuad(0, 0, 58, 40, sprite_sheet_lancer_derecha:getDimensions())
    end
    self.width = 58
    self.height = 40   
    self.spriteExplotion = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
    self.destruible = false

    self.anim = {['idle'] = Anim(0, 0, 58, 40, 2, 2, 10),
                 ['explotion'] = Anim(0, 0, 76, 76, 7, 7, 10)}
end

function Lancer:update(dt, nave)
    self.x = self.x + self.vel * dt 

    if self.hp <= 0 then
        self.destruible = true
    end

    if self.destruible == true then 
		if 7 == self.anim['explotion']:update(dt, self.spriteExplotion) then
			return false
        end
    else
        self.anim['idle']:update(dt, self.sprite)
	end
	return true
end

function Lancer:collides(objeto)
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



function Lancer:render()
    if self.destruible == false then
        if self.izquierda == false then
            love.graphics.draw(sprite_sheet_lancer_derecha, self.sprite, self.x, self.y)
        else
            love.graphics.draw(sprite_sheet_lancer_izquierda, self.sprite, self.x, self.y)
        end
	else
		love.graphics.draw(sprite_sheet_explosion, self.spriteExplotion, self.x, self.y)
	end

end