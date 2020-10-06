--imagenes de fondo
Background = Class{}

local blackhole = love.graphics.newImage('Imagen/Background/Black Hole.png')
local azul = love.graphics.newImage('Imagen/Background/Azul.png')
local bigeye = love.graphics.newImage('Imagen/Background/Gran OJO.png')
local disco = love.graphics.newImage('Imagen/Background/Disco.png')

--Numero para saber cual imagen se queda hasta el final
local Num = love.math.random(1, 4)

function Background:init()
	if Num == 1 then 
		self.loopingStars = blackhole
	elseif Num == 2 then
		self.loopingStars = azul
	elseif Num == 3 then
		self.loopingStars = bigeye
	elseif Num == 4 then
		self.loopingStars = disco
	end

	self.planetas = {}
	self.timer_planetas = 3

end	

function Background:change_background()
	local random = love.math.random(1, 4)
	if random == 1 then 
		self.loopingStars = blackhole
	elseif random == 2 then
		self.loopingStars = azul
	elseif random == 3 then
		self.loopingStars = bigeye
	elseif random == 4 then
		self.loopingStars = disco
	end
end

function Background:update(dt)
	if #self.planetas < 3 then
		self.timer_planetas = self.timer_planetas - dt
		if self.timer_planetas <= 0 then
			self.timer_planetas = 3
			table.insert(self.planetas, Planeta(love.math.random(10, 50)))
		end
	end
	for i, planeta in pairs(self.planetas) do
		planeta:update(dt)
		if planeta.y < 0 - planeta.height or planeta.y > WINDOW_HEIGHT or planeta.x < 0 - planeta.width or planeta.x > WINDOW_WIDTH then
            table.remove(self.planetas, i)
        end
	end
end

function Background:render_background()
	--rendereamos las estrellas sobre el fondo
	love.graphics.draw(self.loopingStars, 0, 0)
	for i, planeta in pairs(self.planetas) do
		planeta:render(dt)
	end
end


