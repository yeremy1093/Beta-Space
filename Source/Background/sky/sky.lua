Sky = Class{}


function Sky:init(sizex, sizey, population, dx, dy)
    self.sizex = sizex
    self.sizey = sizey
    self.population = population
    self.dx = dx
    self.dy = dy
    self.stars = {}
    --Rellena la pantalla de manera inicial
    for cont = 1, self.population do
        table.insert(self.stars, Star(math.random(0, self.sizex), math.random(0, self.sizey), self.dx, self.dy))
    end
end

function Sky:update(dt)
    --Actualiza el comportamiento de cada estrella segun sus atributos individuales
    for s, Star in pairs(self.stars) do
		Star:update(dt)
    end
    
    --Elimina las estrellas que han salido del rango sizex y sizey
    for s, Star in pairs(self.stars) do
        if ((Star.x < 0 or Star.x > self.sizex) or 
            (Star.y < 0 or Star.y > self.sizey)) then
            table.remove(self.stars,s)
        end
    end

    --Agrega nuevas estrellas una vez eliminadas las que hayan salido de rango
    for s=1, (self.population - table.getn(self.stars)) do
        table.insert(self.stars, Star(math.random(0, self.sizex), 0, self.dx, self.dy))
    end

end

function Sky:render()
    for s, Star in pairs(self.stars) do
		Star:render()
	end
end