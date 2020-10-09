Crucero = Class{}

local img_crucero_core = love.graphics.newImage('Imagen/SpritesEnemys/CR-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/SuperExp.png')

function Crucero:init(dy)
	self.clase = 'crucero'
	self.hp = 8
	self.x = love.math.random(50, WINDOW_WIDTH - 100)
	self.y = -260
	self.corex = self.x + 13
	self.corey = self.y + 105
	self.dy = dy
	self.width = 60
	self.height = 261
	self.corewidth = 34
	self.coreheight = 34
	self.sprite = love.graphics.newQuad(0, 0, 60, 261, img_crucero_core:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 200, 200, sprite_sheet_explosion:getDimensions())
	self.fps = 12

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, 60, 261, 8, 8, self.fps),
				['explosion'] = Anim(0, 0, 200, 200, 9, 9, self.fps)}


	self.piezas = {}
	table.insert(self.piezas, Pieza(self.x - 14, self.y + 4, 0, self.dy, 'back'))
	table.insert(self.piezas, Pieza(self.x, self.y + 93, 0, self.dy, 'mid'))
	table.insert(self.piezas, Pieza(self.x - 20, self.y + 152, 0, self.dy, 'front'))
end

--Funcion de update
function Crucero:update(dt)
	self.y = self.y + self.dy * dt

	self.corex = self.x + 13
	self.corey = self.y + 105

	for i, pieza in pairs(self.piezas) do
		
		if false == pieza:update(dt) then
			table.remove(self.piezas, i)
		end
		
		if pieza.y > WINDOW_HEIGHT or pieza.x > WINDOW_WIDTH or pieza.x + pieza.width < 0 or pieza.y + self.height < 0 then
			table.remove(self.piezas, i)
		end
	end 

	if self.hp <= 0 then
	 	self.destruible = true
	end

	if self.destruible == false then 
		self.anim['idle']:update(dt, self.sprite)
	else
		local anim_frame = self.anim['explosion']:update(dt, self.sprite_ex)
		if 1 == anim_frame then
			TEsound.play({'Soundtrack/Effect/Explosion Large.wav'},
					'static',
					{'effect'},	VOLUMEN_EFECTOS / 2)
		elseif 9 == anim_frame then
			return false
		end
	end
	return true
end

function Crucero:collides(objeto)

	for i, pieza in pairs(self.piezas) do
		if pieza:collides(objeto) and pieza.destruible == false and objeto.destruible == false then
			pieza.hp = pieza.hp - objeto.damage
			if objeto.clase ~= 'pulsar' and objeto.clase ~= 'pulso' and objeto.clase ~= 'rayo' then
				objeto.destruible = true
			end
		end
	end
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.corex > objeto.x + objeto.width or objeto.x > self.corex + self.corewidth then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.corey > objeto.y + objeto.height or objeto.y > self.corey + self.coreheight then
        return false
	end 
	
	if self.destruible then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

function Crucero:render()
	if self.destruible == false then
		love.graphics.draw(img_crucero_core, self.sprite, self.x, self.y)

		for i, pieza in pairs(self.piezas) do
			pieza:render()
		end 
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x - 100, self.y, 0, 1.5, 1.5)
	end
end