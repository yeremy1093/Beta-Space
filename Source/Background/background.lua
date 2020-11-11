--imagenes de fondo
Background = Class{}

local blackhole = 'Imagen/Background/Black Hole.png'
local azul = 'Imagen/Background/Azul.png'
local bigeye = 'Imagen/Background/Gran OJO.png'
local disco = 'Imagen/Background/Disco.png'
--Numero para saber cual imagen se queda hasta el final
local Num = love.math.random(1, 4)

function Background:init()
	if Num == 1 then 
		self.loopingStars = love.graphics.newImage(blackhole)
	elseif Num == 2 then
		self.loopingStars = love.graphics.newImage(azul)
	elseif Num == 3 then
		self.loopingStars = love.graphics.newImage(bigeye)
	elseif Num == 4 then
		self.loopingStars = love.graphics.newImage(disco)
	end

	self.planetas = {}
	self.timer_planetas = 3

	self.estrellas = {}
	self.timer_estrellas = 1

end	

function Background:change_background()
	local random = love.math.random(1, 4)
	if random == 1 then 
		self.loopingStars = love.graphics.newImage(blackhole)
	elseif random == 2 then
		self.loopingStars = love.graphics.newImage(azul)
	elseif random == 3 then
		self.loopingStars = love.graphics.newImage(bigeye)
	elseif random == 4 then
		self.loopingStars = love.graphics.newImage(disco)
	end
	for i, planeta in pairs(self.planetas) do
        table.remove(self.planetas, i)
	end
end

function Background:update(dt)
	if #self.planetas <= 1 then
		self.timer_planetas = self.timer_planetas - dt
		if self.timer_planetas <= 0 then
			self.timer_planetas = 3
			table.insert(self.planetas, Planeta(love.math.random(10, 50)))
		end
	end
	if #self.estrellas <= 10 then
		self.timer_estrellas = self.timer_estrellas - dt
		if self.timer_estrellas <= 0 then
			self.timer_estrellas = 3
			table.insert(self.estrellas, Estrella(love.math.random(5, 30)))
		end
	end
	for i, planeta in pairs(self.planetas) do
		planeta:update(dt)
		if planeta.y < 0 - planeta.height or planeta.y > WINDOW_HEIGHT or planeta.x < 0 - planeta.width or planeta.x > WINDOW_WIDTH then
            table.remove(self.planetas, i)
        end
	end
	for i, estrella in pairs(self.estrellas) do
		estrella:update(dt)
		if estrella.y < 0 - estrella.height or estrella.y > WINDOW_HEIGHT or estrella.x < 0 - estrella.width or estrella.x > WINDOW_WIDTH then
            table.remove(self.estrellas, i)
        end
	end
end

function Background:render_background()
	--rendereamos las estrellas sobre el fondo
	love.graphics.draw(self.loopingStars, 0, 0)
	for i, estrella in pairs(self.estrellas) do
		estrella:render(dt)
	end
	for i, planeta in pairs(self.planetas) do
		planeta:render(dt)
	end
end


