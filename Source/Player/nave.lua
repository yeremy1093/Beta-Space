--Declaramos que es una clase
Nave = Class{}

local sprite1 = love.graphics.newImage('Imagen/Sprites/D-10.png')
local sprite2 = love.graphics.newImage('Imagen/Sprites/AX-2.png')
local sprite3 = love.graphics.newImage('Imagen/Sprites/Y9-2.png')

local quad_util = love.graphics.newImage('Imagen/Sprites/Quad-util.png')

escudo_nave = false

--Escribimos las funciones, primero la de inicio
function Nave:init(x, y, player)
	--Elementos necesarios para animar
	if player == 1 then
		self.sprite_sheet = sprite1
	elseif player == 2 then	
		self.sprite_sheet = sprite2
	elseif player == 3 then	
		self.sprite_sheet = sprite3
	end

	self.sprite = love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet:getDimensions())
	self.anim = {['idle'] = Anim(0, 0, 58, 40, 2, 2, 10),
				['izq'] = Anim(116, 0, 58, 40, 2, 2, 10),
				['der'] = Anim(232, 0, 58, 40, 2, 2, 10)}

	--elementos de posicion y tamaño para otras funciones
	self.x = x
	self.y = y
	self.width = 58
	self.height = 40
	self.dirX = 0
	self.dirY = 0

	self.escudo = Escudo(self.x, self.y, 20, 100)

	--creamos los quads para la interfaz de usuario
	self.escudo_quad = love.graphics.newQuad(0, 180, 60, 60, quad_util:getDimensions())
end

function Nave:update(dt)
	--Checamos las teclas oprimidas
	if love.keyboard.isDown('up') then
		--Se le agrega la velocidad de la nave, por el dt para que el numero sea escalable, y negativo que es hacia arriba
		self.dirY = -SHIP_SPEED
	elseif love.keyboard.isDown('down') then
		self.dirY = SHIP_SPEED
	else
		self.dirY = 0
	end

	--Hacemos lo mismo con el eje de las x 
	if love.keyboard.isDown('right') then
		self.dirX = SHIP_SPEED
	elseif love.keyboard.isDown('left') then
		self.dirX = -SHIP_SPEED
	else
		self.dirX = 0
	end

	--checamos el valor de la direccion en X 
	if self.dirX > 0 then
		self.x = math.min(WINDOW_WIDTH - self.width, self.x + self.dirX * dt)
	elseif self.dirX < 0 then
		self.x = math.max(0, self.x + self.dirX * dt)
	end

	--Checamos lo mismo para Y 
	if self.dirY < 0 then
		self.y = math.max(0, self.y + self.dirY * dt)
	elseif self.dirY > 0 then
		self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.dirY * dt)
	end

	--Funcion para animar la nave
	if self.dirX > 0 then
		self.anim['der']:update(dt, self.sprite)
	elseif self.dirX < 0 then
		self.anim['izq']:update(dt, self.sprite)
	else
		self.anim['idle']:update(dt, self.sprite)
	end
	
	self:manager_escudo(dt)
	


end

function Nave:render()
	love.graphics.draw(self.sprite_sheet, self.sprite, self.x, self.y)
	if escudo_nave == true then
		self.escudo:render(self.x - 3, self.y - 7)
		love.graphics.print('Escudo Activado', 500, 25)
	else
		love.graphics.print('Escudo Desactivado', 500, 25)
	end
	--Dibujamos el icono del estatus de escudo
	love.graphics.draw(quad_util, self.escudo_quad, 1080, 600)
end

function Nave:manager_escudo(dt)
	if love.keyboard.wasPressed('d') or love.keyboard.wasPressed('D') then
		if escudo_nave == false then
			escudo_nave = true
		else
			escudo_nave = false
			self.escudo:desactivar_escudo()
		end
	end

	if escudo_nave == true then
		if true == self.escudo:update_activo(dt) then
			escudo_nave = false
		end
	else
		self.escudo:update_inactivo(dt)
	end

	--seleccionamos el quad del icono del escudo
	self.escudo_quad:setViewport(self.escudo:checar_escudo() * 60, 180, 60, 60)
end