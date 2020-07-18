Escudo = Class{}

local img_escudo_act = love.graphics.newImage('Imagen/Sprites/ActShield.png')
local img_escudo_idle = love.graphics.newImage('Imagen/Sprites/SBshield.png')
local img_escudo_dact = love.graphics.newImage('Imagen/Sprites/DactShield.png')

function Escudo:init(x, y, timer, health)
	self.x = x
	self.y = y
	self.timer = timer/6
	self.timer_total = timer
	self.health = health
	self.total_health = health
	self.idle = false
	self.desactivando = false
	self.done = false
	self.frame = 1

	self.sprite_sheet = img_escudo_act

	self.sprite_act = love.graphics.newQuad(0, 0, 64, 64, img_escudo_act:getDimensions())
	self.sprite_idle = love.graphics.newQuad(0, 0, 64, 64, img_escudo_idle:getDimensions())
	self.sprite_dact = love.graphics.newQuad(0, 0, 64, 64, img_escudo_dact:getDimensions())

	self.animations = {['act'] = Anim(0, 0, 64, 64, 4, 4, 10), ['idle'] = Anim(0, 0, 64, 64, 15, 15, 10), ['dact'] = Anim(0, 0, 64, 64, 4, 4, 10)}

	self.act_sound = true
	self.dact_sound = true

end

function Escudo:activar(dt)
	if self.act_sound == true then
		TEsound.play({'Soundtrack/Effect/EscudoAct.wav',
    	'Soundtrack/Effect/EscudoAct2.wav'}, 'static', {'escudo'}, 0.3)
    	self.act_sound = false
	end
	self.frame = self.animations['act']:update(dt, self.sprite_act)
	if self.frame == 4 then self.idle = true end
end

function Escudo:desactivar(dt)
	if self.dact_sound == true then
		TEsound.play({'Soundtrack/Effect/EscudoDact.wav',
    	'Soundtrack/Effect/EscudoDact2.wav'}, 'static', {'escudo'}, 0.3)
    	self.dact_sound = false
	end
	self.frame = self.animations['dact']:update(dt, self.sprite_dact)
	if self.frame == 4 then self.done = true end
end

function Escudo:idle_anim(dt)
	self.animations['idle']:update(dt, self.sprite_idle)
end

function Escudo:update_activo(dt)
	self.timer = self.timer - dt

	if self.timer <= 0 then
		self:golpe_escudo(self.total_health / 6)
		self.timer = self.timer_total/6
	end

	if self.done == false then

		if self.desactivando == true then
			self.sprite_sheet = img_escudo_dact
			self:desactivar(dt)
		elseif self.idle == false then
			self.sprite_sheet = img_escudo_act
			self:activar(dt)
		else
			self.sprite_sheet = img_escudo_idle
			self:idle_anim(dt)
		end

	
		if self.health <= 0 then
			self.desactivando = true
		end
	end
	return self.done
end

function Escudo:update_inactivo(dt)
	self.timer = self.timer - dt

	if self.timer <= 0 then
		if self.health < self.total_health then
			self.health = self:boost_escudo(self.total_health / 6)
		end
		self.timer = self.timer_total/6
	end

	if self.health then
		if self.health > self.total_health / 6 then
			self.done = false
			self.idle = false
			self.desactivando = false
			self.act_sound = true
			self.dact_sound = true
			self.frame = 1
			self.animations['dact']:reset()
			self.animations['act']:reset()

		end
	end
end

function Escudo:desactivar_escudo()
	self.desactivando = true
end

--funcion para disminuir la vida del escudo
function Escudo:golpe_escudo(damage)
	self.health = self.health - damage
end

--funcion para aumentar la vida del escudo
function Escudo:boost_escudo(boost)
	self.health = self.health + boost
end

--funcion para ver cuanta vida tiene este escudo, solo devuelve cuantos cuartos de vida le quedan
function Escudo:checar_escudo()
	if self.health then
		if self.health <= self.total_health/6 then
			return 5
		elseif self.health <= 2 * self.total_health/6 then
			return 4
		elseif self.health <= self.total_health/3 then
			return 3
		elseif self.health <= 2 * self.total_health/3 then
			return 2
		elseif self.health <= 5 * self.total_health/6 then
			return 1
		else
			return 0
		end
	end
end

function Escudo:render(x, y)
	if self.desactivando == true then
		love.graphics.draw(self.sprite_sheet, self.sprite_dact, x, y)
	elseif self.idle == false then
		love.graphics.draw(self.sprite_sheet, self.sprite_act, x, y)
	else
		love.graphics.draw(self.sprite_sheet, self.sprite_idle, x, y)
	end
end