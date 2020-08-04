--Esta clase hace un manager para los disparos y tipos de disparos del jugador
PlayerShot = Class{}


function PlayerShot:init()
    self.balas = {} --lista para hacer seguimiento de las balas
    self.power_up = 'direccional' --variable para saber que tipo de balas tenemos equipadas
    self.pulsar_timer = TIMER_PULSAR
    self.pulsar = 'activado'
end

--Funciones que tienen que ver con listas de objetos en distintos estados
function PlayerShot:mover_balas_jugador(dt, player)
		--Hacemos un ciclo en el que se haga update de todas las balas
	for i, bala in pairs(self.balas) do
        if bala:update(dt, player) == false then
            table.remove(self.balas, i)
        end
		--checamos si la bala salio de la pantalla y la borramos
		if bala.y < 0 - bala.height or bala.y > WINDOW_HEIGHT or bala.x < 0 - bala.width or bala.x > WINDOW_WIDTH then
			table.remove(self.balas, i)
		end
	end
    if self.pulsar == 'desactivado' then
        self.pulsar_timer = self.pulsar_timer - dt
        if self.pulsar_timer <= 0 then 
            self.pulsar = 'activado'
            self.pulsar_timer = TIMER_PULSAR
        end
    end

end

function PlayerShot:disparo_jugador(player)
    self.power_up = player.power_up
	if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('A') then
        self:disparo_normal(player)
    end
    if love.keyboard.wasPressed('s') or love.keyboard.wasPressed('S') then
        if self.power_up == 'direccional' then
            self:disparo_direccional(player)
        elseif self.power_up == 'pulsar' then
             self:disparo_pulsar(player)
        end
    end
end

function PlayerShot:disparo_normal(player)
    if player.power_laser == 1 then
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, 0, BULLET_SPEED))
    elseif player.power_laser == 2 then
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, BULLET_XSPEED, BULLET_SPEED))
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, -BULLET_XSPEED, BULLET_SPEED))
    elseif player.power_laser == 3 then
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, 0, BULLET_SPEED))
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, BULLET_XSPEED, BULLET_SPEED))
        table.insert(self.balas, Bala(player.x + player.width/2 - 3, player.y, -BULLET_XSPEED, BULLET_SPEED))
    end
    TEsound.play('Soundtrack/Effect/soundLaser1.wav', 'static')
end

function PlayerShot:disparo_direccional(player)
    if player.power_level == 1 then
        if love.keyboard.isDown('up') and  love.keyboard.isDown('left')then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 8))
        elseif love.keyboard.isDown('up') and  love.keyboard.isDown('right') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 5))
        elseif love.keyboard.isDown('down') and  love.keyboard.isDown('left') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 7))
        elseif love.keyboard.isDown('down') and  love.keyboard.isDown('right') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 6))
        elseif love.keyboard.isDown('up') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
        elseif love.keyboard.isDown('down') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 2))
        elseif love.keyboard.isDown('left') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 4))
        elseif love.keyboard.isDown('right') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 3))
        else
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
        end
    elseif player.power_level == 2 then
        if (love.keyboard.isDown('up') and  love.keyboard.isDown('left')) or (love.keyboard.isDown('down') and  love.keyboard.isDown('right')) then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 8))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 6))
        elseif (love.keyboard.isDown('up') and  love.keyboard.isDown('right')) or (love.keyboard.isDown('down') and  love.keyboard.isDown('left')) then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 5))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 7))
        elseif love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 2))
        elseif love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 4))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 3))
        else
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 2))
        end
    elseif player.power_level == 3 then
        if (love.keyboard.isDown('up') and  love.keyboard.isDown('left')) or (love.keyboard.isDown('down') and  love.keyboard.isDown('right'))
            or (love.keyboard.isDown('up') and  love.keyboard.isDown('right')) or (love.keyboard.isDown('down') and  love.keyboard.isDown('left')) then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 8))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 6))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 5))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 7))
        elseif love.keyboard.isDown('up') or love.keyboard.isDown('down') or love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 2))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 4))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 3))
        else
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 4))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 3))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 1))
            table.insert(self.balas, Direccional(player.x + player.width/2 -10, player.y, BULLET_SPEED, 2))
        end
    end

    TEsound.play('Soundtrack/Effect/soundLaser2.wav', 'static')
end

function PlayerShot:disparo_pulsar(player)
    if self.pulsar == 'activado' then 
        table.insert(self.balas, Pulsar(player.x + player.width/2, player.y, BULLET_SPEED/2, player.power_level))
        TEsound.play('Soundtrack/Effect/LaserLargo.wav', 'static')
        self.pulsar = 'desactivado'
    end
end

function PlayerShot:render()
    for i, bala in pairs(self.balas) do
        bala:render()
    end

    if  self.pulsar == 'desactivado' then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        love.graphics.rectangle('fill', 1200, 600, 60, 60 )
        love.graphics.setColor(1, 1, 1, 1)
    end
end