--Declaramos que es una clase
Nave = Class{}

local sprite1 = love.graphics.newImage('Imagen/Sprites/D-10.png')
local sprite2 = love.graphics.newImage('Imagen/Sprites/AX-2.png')
local sprite3 = love.graphics.newImage('Imagen/Sprites/Y9-2.png')
local sprite_sheet_explosion = love.graphics.newImage('Imagen/Sprites/Explosion.png')
local sprite_sheet_stun = love.graphics.newImage('Imagen/SpritesEnemys/Celda-Stun.png')


local quad_util = love.graphics.newImage('Imagen/Sprites/Quad-util.png')
local quad_level = love.graphics.newImage('Imagen/Menus/QuadLvlarma.png')

--Aqui van variables de control del escudo, una global para saber en el resto del programa si el escudo esta activo
escudo_nave = false

--Escribimos las funciones, primero la de inicio
function Nave:init(x, y, player)
	self.nave = player
	--Elementos necesarios para animar
	if player == 1 then
		self.sprite_sheet = sprite1
		self.offset_hp = 120
	elseif player == 2 then	
		self.sprite_sheet = sprite2
		self.offset_hp = 0
	elseif player == 3 then	
		self.sprite_sheet = sprite3
		self.offset_hp = 60
	end
--Agregamos explosion de nave--
	self.sprite_ex = love.graphics.newQuad(0, 0, 76, 76, sprite_sheet_explosion:getDimensions())
	self.frame_ex = 1
	self.sprite = love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet:getDimensions())
	self.anim = {['idle'] = Anim(0, 0, 58, 40, 2, 2, 10),
				['izq'] = Anim(116, 0, 58, 40, 2, 2, 10),
				['der'] = Anim(232, 0, 58, 40, 2, 2, 10),
				['explosion'] = Anim(0, 0, 76, 76, 5, 5, 10),
				['arma1'] = Anim(0, 300, 60, 60, 4, 4, 10),
				['arma2'] = Anim(240, 300, 60, 60, 4, 4, 10),
				['arma3'] = Anim(480, 300, 60, 60, 4, 4, 10)}

	--elementos de posicion y tamaño para otras funciones
	self.x = x
	self.y = y
	self.width = 58
	self.height = 40
	self.dirX = 0
	self.dirY = 0

	--Por si estamos stuneados
	self.stun = false
	self.stun_timer = STUN_TIMER
	self.stun_sprite = love.graphics.newQuad(0, 0, 70, 70, sprite_sheet_stun:getDimensions())
	self.stun_anim = Anim(0, 0, 70, 70, 12, 12, 12)

	--La nave tiene un objeto tipo escudo
	self.escudo = Escudo(20, 100)
	--Agregamos la cantidad de vidas iniciales
	self.numvidas = Escribir("3")
	--Agregamos el tipo de arma que tenemos equipada
	self.power_up = 'tercer_disparo'
	--Las armas tienen niveles, que se trackean en esta variable
	self.power_level = 1
	self.power_state = 0 --Que tan llena esta el arma, de 0 a 12
	self.power_up_timer = POWER_UP_TIMER
	self.power_laser = 1
	self.sprite_lvl2 = love.graphics.newQuad(420, 0, 70, 25, quad_level:getDimensions())
	self.sprite_lvl3 = love.graphics.newQuad(420, 25, 70, 25, quad_level:getDimensions())

	--creamos los quads para la interfaz de usuario
	self.escudo_quad = love.graphics.newQuad(0, 180, 60, 60, quad_util:getDimensions())
	self.hp_quad = love.graphics.newQuad(0, self.offset_hp , 60, 60, quad_util:getDimensions())
	self.equip_quad = love.graphics.newQuad(0, 300, 60, 60, quad_util:getDimensions())
end

function Nave:update(dt)
	--Checamos las teclas oprimidas
	if love.keyboard.isDown('up') or control:isDown("up") or control:isDown("up-left") or control:isDown("up-right")
		and not self.stun then
		--Se le agrega la velocidad de la nave, por el dt para que el numero sea escalable, y negativo que es hacia arriba
		self.dirY = math.max(self.dirY - (SHIP_SPEED * 2) * dt, -SHIP_SPEED)
	elseif love.keyboard.isDown('down') or control:isDown("down") or control:isDown("down-left") or control:isDown("down-right")
		and not self.stun then
		self.dirY = math.min(self.dirY+  (SHIP_SPEED * 2) * dt, SHIP_SPEED)
	else
		self.dirY = self.dirY + ((0 - self.dirY) * 5 * dt)
	end

	--Hacemos lo mismo con el eje de las x 
	if love.keyboard.isDown('right') or control:isDown("right") or control:isDown("down-right") or control:isDown("up-right")
		and not self.stun then
		self.dirX = math.min(self.dirX +  (SHIP_SPEED * 2) * dt, SHIP_SPEED)
	elseif love.keyboard.isDown('left') or control:isDown("left") or control:isDown("down-left") or control:isDown("up-left")
		and not self.stun then
		self.dirX = math.max(self.dirX - (SHIP_SPEED * 2) * dt, -SHIP_SPEED)
	else
		self.dirX = self.dirX + ((0 - self.dirX) * 5 * dt)
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

	if self.stun then
		self.stun_anim:update(dt, self.stun_sprite)
		self.stun_timer = self.stun_timer - dt
		if self.stun_timer <= 0 then
			self.stun_timer = STUN_TIMER
			self.stun = false
		end
	end

	--Funcion para animar la nave
	if HPnave <= 8 then
		if self.dirX > 80 then
			self.anim['der']:update(dt, self.sprite)
		elseif self.dirX < -80 then
			self.anim['izq']:update(dt, self.sprite)
		else
			self.anim['idle']:update(dt, self.sprite)
		end
	else
		self.frame_ex = self.anim['explosion']:update(dt, self.sprite_ex)
		if self.frame_ex == 5 then
			TEsound.play({'Soundtrack/Effect/Explosion Medium.wav'},
				'static',
				{'effect'},	VOLUMEN_EFECTOS)
			HPnave = 0
			Numvidas = Numvidas - 1
			self.stun_timer = STUN_TIMER
			self.stun = false
			self.power_level = 1
			self.power_state = 0
			self.power_laser = 1
			self.power_up_timer = POWER_UP_TIMER
			self.frame_ex = 1
			self.x = WINDOW_WIDTH / 2
			self.y = WINDOW_HEIGHT /2
			if Numvidas == 1 then
				TEsound.stop('musica_menu')
				TEsound.stop('musica_play')
				TEsound.playLooping('Soundtrack/Songs/BattleMusic1.mp3', "stream", {'musica_play'})
				TEsound.volume({'musica_menu', 'musica_play'}, VOLUMEN_MUSICA)
			end
		end

	end
	--Reducimos el poder del arma con el tiempo, caso especial con el arma 2
	if self.power_level > 1 then
		if self.power_up == 'pulsar' or self.power_up == 'tercer_disparo' then
			self.power_up_timer = self.power_up_timer - dt/2

		else
			self.power_up_timer = self.power_up_timer - dt
		end
		if self.power_up_timer <= 0 then
			self.power_state = self.power_state - 1
			self.power_up_timer = POWER_UP_TIMER
		end
	end

	if self.power_state <= 0 then
		self.power_level = 1
	elseif self.power_state <= 6 then
		self.power_level = 2
	end

	--Ponemos la animacion del tipo de arma que tenemos
	if self.power_up == 'direccional' then
		self.anim['arma1']:update(dt, self.equip_quad)
	elseif self.power_up == 'pulsar' then
		self.anim['arma2']:update(dt, self.equip_quad)
	elseif self.power_up == 'tercer_disparo' then
		self.anim['arma3']:update(dt, self.equip_quad)
	end

	self:update_power_level_quad()
	
	self:manager_escudo(dt)
	self:check_hp ()

end

function Nave:render()
	if HPnave <= 9 then
		love.graphics.draw(self.sprite_sheet, self.sprite, self.x, self.y)
	else
		love.graphics.draw(sprite_sheet_explosion, self.sprite_ex, self.x, self.y)
	end
	if escudo_nave == true then
		self.escudo:render(self.x - 3, self.y - 7)
	end
	if self.stun then
		love.graphics.draw(sprite_sheet_stun, self.stun_sprite, self.x - 6, self.y - 15)
	end
end

function Nave:manager_escudo(dt)
	if love.keyboard.wasPressed('d') or love.keyboard.wasPressed('D') or control:isDown("shield") then
		if escudo_nave == false and self.escudo.estado == 'disponible' then
			escudo_nave = true
			self.escudo:iniciar_escudo()
		elseif self.escudo.estado ~= 'desactivado' then
			self.escudo:desactivar_escudo()
		end
	end

	if escudo_nave == true then
		self.escudo:update_activo(dt)
		if self.escudo.estado == 'desactivado' then escudo_nave = false end
	else
		self.escudo:update_inactivo(dt)
	end


	--seleccionamos el quad del icono del escudo
	self.escudo_quad:setViewport(self.escudo:checar_escudo() * 60, 180, 60, 60)
end

function Nave:check_hp()

	if Numvidas == 9 then
		self.numvidas = Escribir("9")
	elseif Numvidas == 8 then
		self.numvidas = Escribir("8")
	elseif Numvidas == 7 then
		self.numvidas = Escribir("7")
	elseif Numvidas == 6 then
		self.numvidas = Escribir("6")
	elseif Numvidas == 5 then
		self.numvidas = Escribir("5")
	elseif Numvidas == 4 then
		self.numvidas = Escribir("4")
	elseif Numvidas == 3 then
		self.numvidas = Escribir("3")
	elseif Numvidas == 2 then
		self.numvidas = Escribir("2")
	elseif Numvidas == 1 then
		self.numvidas = Escribir("1")
	end

	self.hp_quad:setViewport(HPnave * 60, self.offset_hp, 60, 60)
	-- body
end

function Nave:update_power_up(power_up)
	if power_up == 'direccional' and self.power_up == 'direccional' and self.power_level < 3 then
		self.power_level = self.power_level + 1
		self:update_power_level()
	elseif power_up == 'pulsar' and self.power_up == 'pulsar' and self.power_level < 3 then
		self.power_level = self.power_level + 1
		self:update_power_level()
	elseif power_up == 'tercer_disparo' and self.power_up == 'tercer_disparo' and self.power_level < 3 then
		self.power_level = self.power_level + 1
		self:update_power_level()
	elseif power_up == 'laser' and self.power_laser < 3 then
		self.power_laser = self.power_laser + 1
	elseif power_up == 'direccional' and self.power_up ~= 'direccional' then
		self.power_up = power_up
	elseif power_up == 'pulsar' and self.power_up ~= 'pulsar' then
		self.power_up = power_up
	elseif power_up == 'tercer_disparo' and self.power_up ~= 'tercer_disparo' then
		self.power_up = power_up
	elseif power_up == 'salud' then
		HPnave = 0
	elseif power_up == 'vida' and Numvidas <= 9 then
		Numvidas = Numvidas + 1
		if Numvidas == 2 then
			TEsound.stop('musica_menu')
			TEsound.stop('musica_play')
			TEsound.playLooping({'Soundtrack/Songs/Menu1.wav', 'Soundtrack/Songs/Menu2.wav'}, "stream", {'musica_menu'})
			TEsound.volume({'musica_menu', 'musica_play'}, VOLUMEN_MUSICA)
		end
	elseif power_up == 'escudo' then
		self.escudo:boost_escudo(100)
		self.escudo.timer_react = 0
	end
end

function Nave:update_power_level()
	if self.power_level == 2 then
		self.power_state = 6
	elseif self.power_level == 3 then
		self.power_state = 12
	end
end

function Nave:update_power_level_quad()
	if self.power_state == 12 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(0, 25, 70, 25)
	elseif self.power_state == 11 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(70, 25, 70, 25)
	elseif self.power_state == 10 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(140, 25, 70, 25)
	elseif self.power_state == 9 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(210, 25, 70, 25)
	elseif self.power_state == 8 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(280, 25, 70, 25)
	elseif self.power_state == 7 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(350, 25, 70, 25)
	elseif self.power_state == 6 then
		self.sprite_lvl2:setViewport(0, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	elseif self.power_state == 5 then
		self.sprite_lvl2:setViewport(70, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	elseif self.power_state == 4 then
		self.sprite_lvl2:setViewport(140, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	elseif self.power_state == 3 then
		self.sprite_lvl2:setViewport(210, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	elseif self.power_state == 2 then
		self.sprite_lvl2:setViewport(280, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	elseif self.power_state == 1 then
		self.sprite_lvl2:setViewport(350, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	else
		self.sprite_lvl2:setViewport(420, 0, 70, 25)
		self.sprite_lvl3:setViewport(420, 25, 70, 25)
	end
end