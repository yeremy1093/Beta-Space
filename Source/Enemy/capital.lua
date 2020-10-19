Capital = Class{}

local img_capital_core = love.graphics.newImage('Imagen/SpritesEnemys/Capital-R1.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/SuperExp.png')

function Capital:init(dy)
	self.clase = 'capital'
	self.hp = 20
	self.x = love.math.random(-100, WINDOW_WIDTH - 476)
	self.y = -599
	self.corex = self.x + 232
	self.corey = self.y + 242
	self.dy = dy
	self.width = 576
	self.height = 600
	self.corewidth = 111
	self.coreheight = 115
	self.sprite = love.graphics.newQuad(0, 0, self.width, self.height, img_capital_core:getDimensions())
	self.sprite_ex = love.graphics.newQuad(0, 0, 200, 200, sprite_sheet_explosion:getDimensions())
	self.fps = 12

	--variable para saber cuando el asteroide explotó y se puede borrar
	self.destruible = false
	--Aqui van todas las animaciones posibles
	self.anim = {['idle'] = Anim(0, 0, self.width, self.height, 6, 6, self.fps),
				['explosion'] = Anim(0, 0, 200, 200, 9, 9, self.fps)}


	self.piezas = {}
	table.insert(self.piezas, Pieza(self.x + 164, self.y + 300, 0, self.dy, 'C-front'))
	table.insert(self.piezas, Pieza(self.x - 5, self.y + 80, 0, self.dy, 'C-D'))
	table.insert(self.piezas, Pieza(self.x + 387, self.y + 80, 0, self.dy, 'C-I'))
	table.insert(self.piezas, Pieza(self.x + 167, self.y + 55, 0, self.dy, 'C-back'))

	self.torretas = {}
	table.insert(self.torretas, Torreta(self.x + 88, self.y + 160, 0, self.dy, 'torreta_cannon', 'C-D'))
	table.insert(self.torretas, Torreta(self.x + 108, self.y + 140, 0, self.dy, 'torreta_cannon', 'C-D'))
	table.insert(self.torretas, Torreta(self.x + 108, self.y + 180, 0, self.dy, 'torreta_cannon', 'C-D'))
	table.insert(self.torretas, Torreta(self.x + 128, self.y + 380, 0, self.dy, 'torreta_cannon', 'C-D'))
	table.insert(self.torretas, Torreta(self.x + 148, self.y + 400, 0, self.dy, 'torreta_cannon', 'C-D'))
	table.insert(self.torretas, Torreta(self.x + 208, self.y + 120, 0, self.dy, 'torreta_cannon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 208, self.y + 160, 0, self.dy, 'torreta_cannon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 348, self.y + 120, 0, self.dy, 'torreta_cannon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 348, self.y + 160, 0, self.dy, 'torreta_cannon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 468, self.y + 160, 0, self.dy, 'torreta_cannon', 'C-I'))
	table.insert(self.torretas, Torreta(self.x + 448, self.y + 140, 0, self.dy, 'torreta_cannon', 'C-I'))
	table.insert(self.torretas, Torreta(self.x + 448, self.y + 180, 0, self.dy, 'torreta_cannon', 'C-I'))
	table.insert(self.torretas, Torreta(self.x + 428, self.y + 380, 0, self.dy, 'torreta_cannon', 'C-I'))
	table.insert(self.torretas, Torreta(self.x + 408, self.y + 400, 0, self.dy, 'torreta_cannon', 'C-I'))
	table.insert(self.torretas, Torreta(self.x + 228, self.y + 140, 0, self.dy, 'torreta_photon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 328, self.y + 140, 0, self.dy, 'torreta_photon', 'C-back'))
	table.insert(self.torretas, Torreta(self.x + 248, self.y + 320, 0, self.dy, 'torreta_photon', 'C-front'))
	table.insert(self.torretas, Torreta(self.x + 308, self.y + 320, 0, self.dy, 'torreta_photon', 'C-front'))
	table.insert(self.torretas, Torreta(self.x + 268, self.y + 400, 0, self.dy, 'torreta_photon', 'C-front'))
	table.insert(self.torretas, Torreta(self.x + 288, self.y + 400, 0, self.dy, 'torreta_photon', 'C-front'))
	table.insert(self.torretas, Torreta(self.x + 228, self.y + 200, 0, self.dy, 'torreta_disco', 'core'))
	table.insert(self.torretas, Torreta(self.x + 308, self.y + 200, 0, self.dy, 'torreta_disco', 'core'))
	table.insert(self.torretas, Torreta(self.x + 148, self.y + 320, 0, self.dy, 'torreta_disco', 'core'))
	table.insert(self.torretas, Torreta(self.x + 388, self.y + 320, 0, self.dy, 'torreta_disco', 'core'))
	
end

--Funcion de update
function Capital:update(dt)
	self.y = self.y + self.dy * dt

	self.corex = self.x + 232
	self.corey = self.y + 242

	for i, pieza in pairs(self.piezas) do
		if pieza.hp <= 0 then
			for j, torreta in pairs(self.torretas) do
				if torreta.pieza == pieza.tipo then
					torreta.hp = 0
				end
			end
		end
		
		if false == pieza:update(dt) then
			table.remove(self.piezas, i)
		end
		
		if pieza.y > WINDOW_HEIGHT or pieza.x > WINDOW_WIDTH or pieza.x + pieza.width < 0 or pieza.y + self.height < 0 then
			table.remove(self.piezas, i)
		end
	end 

	for i, torreta in pairs(self.torretas) do
		
		if false == torreta:update(dt) then
			table.remove(self.torretas, i)
		end
		
		if torreta.y > WINDOW_HEIGHT or torreta.x > WINDOW_WIDTH or torreta.x + torreta.width < 0 or torreta.y + self.height < 0 then
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

function Capital:collides(objeto)

	for i, pieza in pairs(self.piezas) do
		if pieza:collides(objeto) and pieza.destruible == false and objeto.destruible == false then
			pieza.hp = pieza.hp - objeto.damage
			pieza.wasCollides = true
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

function Capital:render()
	if self.destruible == false then
		love.graphics.draw(img_capital_core, self.sprite, self.x, self.y)

		for i, pieza in pairs(self.piezas) do
			pieza:render()
		end 
		for i, torreta in pairs(self.torretas) do
			torreta:render()
		end 
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y, 0, 3, 3)
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x + 200, self.y + 200)
	end
end