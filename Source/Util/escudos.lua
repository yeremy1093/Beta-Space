Escudo = Class{}

local img_escudo_act = love.graphics.newImage('Imagen/Sprites/ActShield.png')
local img_escudo_idle = love.graphics.newImage('Imagen/Sprites/SBshield.png')
local img_escudo_dact = love.graphics.newImage('Imagen/Sprites/DactShield.png')

function Escudo:init(x, y, timer, health)
	self.x = x
	self.y = y
	self.timer = timer
	self.health = health
	self.idle = false
	self.desactivando = false
	self.done = false
	self.frame = 1

	self.sprite_sheet = img_escudo_act

	self.sprite_act = love.graphics.newQuad(0, 0, 64, 64, img_escudo_act:getDimensions())
	self.sprite_idle = love.graphics.newQuad(0, 0, 64, 64, img_escudo_idle:getDimensions())
	self.sprite_dact = love.graphics.newQuad(0, 0, 64, 64, img_escudo_dact:getDimensions())

	self.animations = {['act'] = Anim(0, 0, 64, 64, 4, 4, 10), ['idle'] = Anim(0, 0, 64, 64, 15, 15, 10), ['dact'] = Anim(0, 0, 64, 64, 4, 4, 10)}

	TEsound.play({'Soundtrack/Effect/EscudoAct.wav',
    	'Soundtrack/Effect/EscudoAct2.wav'}, 'static', {'escudo'}, 0.3)

end

function Escudo:activar(dt)
	self.frame = self.animations['act']:update(dt, self.sprite_act)
	if self.frame == 4 then self.idle = true end
end

function Escudo:desactivar(dt)
	self.frame = self.animations['dact']:update(dt, self.sprite_dact)
	if self.frame == 4 then self.done = true end
end

function Escudo:idle_anim(dt)
	self.animations['idle']:update(dt, self.sprite_idle)
end

function Escudo:update(dt)
	self.timer = self.timer - dt

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

	if self.done == false then
		if self.health <= 0 or self.timer <= 0 then
			self.desactivando = true
		end
	else
		TEsound.play({'Soundtrack/Effect/EscudoDact.wav',
    	'Soundtrack/Effect/EscudoDact2.wav'}, 'static', {'escudo'}, 0.3)
	end
	return self.done
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