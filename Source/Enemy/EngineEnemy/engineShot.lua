EngineShot = Class{}

function EngineShot:init()
    self.listCannon = {}
    self.listSmartCannon = {}
    self.listDiscEnergy = {}
    self.listWissil = {}
    self.listPhEnemy = {}
    self.listStella = {}
end

--Actualizacion de los proyectiles y eliminacion de proyectiles fuera de pantalla o por impacto
function EngineShot:update(dt, player)
    for i, Cannon in pairs(self.listCannon) do
        if (Cannon:update(dt) == false) or 
        ((Cannon.x > WINDOW_WIDTH or Cannon.x < 0) or
        (Cannon.y > WINDOW_HEIGHT or Cannon.y < 0)) then
            table.remove(self.listCannon, i)
        end
    end
    for i, SmartCannon in pairs(self.listSmartCannon) do
        if (SmartCannon:update(dt) == false) or 
        ((SmartCannon.x > WINDOW_WIDTH or SmartCannon.x < 0) or
        (SmartCannon.y > WINDOW_HEIGHT or SmartCannon.y < 0)) then
            table.remove(self.listSmartCannon, i)
        end
    end
    for i, DiscEnergy in pairs(self.listDiscEnergy) do
        DiscEnergy:update(dt)
        if (DiscEnergy.x > WINDOW_WIDTH or DiscEnergy.x < 0) or
        (DiscEnergy.y > WINDOW_HEIGHT or DiscEnergy.y < 0) then
            table.remove(self.listDiscEnergy, i)
        end
    end
    for i, Wissil in pairs(self.listWissil) do
        if not Wissil:update(dt, player) or 
        (Wissil.x > WINDOW_WIDTH or Wissil.x < 0) or
        (Wissil.y > WINDOW_HEIGHT or Wissil.y < 0) then
            table.remove(self.listWissil, i)
        end
    end
    for i, PhEnemy in pairs(self.listPhEnemy) do
        PhEnemy:update(dt, player)
        if (PhEnemy.x > WINDOW_WIDTH or PhEnemy.x < 0) or
        (PhEnemy.y > WINDOW_HEIGHT or PhEnemy.y < 0) then
            table.remove(self.listPhEnemy, i)
        end
    end
    for i, Stella in pairs(self.listStella) do
        Stella:update(dt)
        if (Stella.x > WINDOW_WIDTH or Stella.x < 0) or
        (Stella.y > WINDOW_HEIGHT or Stella.y < 0) then
            table.remove(self.listStella, i)
        end
	end
end

function EngineShot:render()
    for i, Cannon in pairs(self.listCannon) do
		Cannon:render()
    end
    for i, smartCannon in pairs(self.listSmartCannon) do
		smartCannon:render()
    end
    for i, DiscEnergy in pairs(self.listDiscEnergy) do
		DiscEnergy:render()
    end
    for i, Wisil in pairs(self.listWissil) do
		Wisil:render()
    end
    for i, PhEnemy in pairs(self.listPhEnemy) do
		PhEnemy:render()
    end
    for i, Stella in pairs(self.listStella) do
		Stella:render()
	end
end

--Creacion de proyectiles
function EngineShot:setCannon(x, y)
    table.insert(self.listCannon, Cannon(x,y))
    TEsound.play('Soundtrack/Effect/Bullet Principal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS/2)
end

function EngineShot:setSmartCannon(x, y, player, velocity)
    table.insert(self.listSmartCannon, SmartCannon(x,y,player,velocity))
    TEsound.play('Soundtrack/Effect/Bullet Principal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS/2)
end

function EngineShot:setDiscEnergy(x, y)
    table.insert(self.listDiscEnergy, DiscEnergy(x,y))
end

function EngineShot:setWissil(x, y, speedx, speedy, player)
    table.insert(self.listWissil, Wisil(x, y, speedx, speedy, player))
end

function EngineShot:setPhEnemy(x, y, player, velocity)
    table.insert(self.listPhEnemy, EnemyPhoton(x,y,player,velocity))
    TEsound.play('Soundtrack/Effect/Bullet Principal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS/2)
end

function EngineShot:setStella(x, y)
    table.insert(self.listStella, Stella(x,y))
end

--Funcion para dectectar colision con jugador y eliminar objecto
function EngineShot:collidesShots(player, balas)
    for i, Cannon in pairs(self.listCannon) do
        if Cannon:collides(player) then
            --Animacion final de objecto
            if escudo_nave == false then
				puntaje = puntaje - 10
				HPnave = HPnave + 1
				TEsound.play('Soundtrack/Effect/HIT normal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS)
			else
				player.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},  VOLUMEN_EFECTOS)
			end
            Cannon.destruible = true
            return true
        end
        for i, bala in pairs(balas) do
            if Cannon:collides(bala) and bala.clase == 'pulso' then
                Cannon.destruible = true
                return true
            end
        end
    end
    for i, SmartCannon in pairs(self.listSmartCannon) do
        if SmartCannon:collides(player) then
            --Animacion final de objecto
            if escudo_nave == false then
				puntaje = puntaje - 10
				HPnave = HPnave + 1
				TEsound.play('Soundtrack/Effect/HIT normal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS)
			else
				player.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},  VOLUMEN_EFECTOS)
			end
            SmartCannon.destruible = true
            return true
        end
        for i, bala in pairs(balas) do
            if SmartCannon:collides(bala) and bala.clase == 'pulso' then
                SmartCannon.destruible = true
                return true
            end
        end
    end
    for i, DiscEnergy in pairs(self.listDiscEnergy) do
        if DiscEnergy:collides(player) then
            --Animacion final de objecto
            table.remove(self.listDiscEnergy, i)
            return true
        end
        for i, bala in pairs(balas) do
            if DiscEnergy:collides(bala) and bala.clase == 'pulso' then
                DiscEnergy.destruible = true
                return true
            end
        end
    end
    for i, Wisil in pairs(self.listWissil) do
        if Wisil:collides(player) then
            --Animacion final de objecto
            if escudo_nave == false then
				puntaje = puntaje - 10
				HPnave = HPnave + 1
				TEsound.play('Soundtrack/Effect/HIT normal.wav', 'static', {'effect'}, VOLUMEN_EFECTOS)
			else
				player.escudo:golpe_escudo(10)
				TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},  VOLUMEN_EFECTOS)
			end
            table.remove(self.listWissil, i)
            return true
        end
        for i, bala in pairs(balas) do
            if Wisil:collides(bala) then
                Wisil.destruible = true
                TEsound.play({'Soundtrack/Effect/HIT normal.wav'}, 'static', {'effect'},  VOLUMEN_EFECTOS)
                return true
            end
        end
    end
    for i, PhEnemy in pairs(self.listPhEnemy) do
        if PhEnemy:collides(player) then
            --Animacion final de objecto
            table.remove(self.listPhEnemy, i)
            return true
        end
        for i, bala in pairs(balas) do
            if PhEnemy:collides(bala) and bala.clase == 'pulso' then
                PhEnemy.destruible = true
                return true
            end
        end
    end
    for i, Stella in pairs(self.listStella) do
        if Stella:collides(player) then
            --Animacion final de objecto
            table.remove(self.listStella, i)
            return true
        end
        for i, bala in pairs(balas) do
            if Stella:collides(bala) and bala.clase == 'pulso' then
                Stella.destruible = true
                return true
            end
        end
    end
    return false
end
