CazaBasic = Class{}

local sprite_sheet_caz = love.graphics.newImage('Imagen/SpritesEnemys/caza1.png')

function CazaBasic:init(x, y, dx, dy)
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.width = 58
	self.height = 40
	self.sprite = love.graphics.newQuad(0, 0, 58, 40, sprite_sheet_caz:getDimensions())
	self.fps = math.random(6, 10)

	self.anim = Anim(0, 0, self.width, self.height, 2, 2, self.fps)
end

--Funcion de update
function CazaBasic:update(dt)
	self.y = self.y + self.dy * dt
	self.x = self.x + self.dx * dt

	self.anim:update(dt, self.sprite)
end

function CazaBasic:collides(objeto)
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

    -- if the above aren't true, they're overlapping
    return true
end


function CazaBasic:render()
	love.graphics.draw(sprite_sheet_caz, self.sprite, self.x, self.y)
end