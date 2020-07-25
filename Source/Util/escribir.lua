Escribir = Class{}

local alfabeto = love.graphics.newImage('Imagen/Menus/AlfabetoSpace.png')

function Escribir:init(texto)
	self.string = texto
	self.xoffset = 0
	self.yoffset = 0

	self.caracteres = {}

	for i = 1, #self.string do
		self:seleccion_caracter(self.string:sub(i, i))
		table.insert(self.caracteres, love.graphics.newQuad(self.xoffset, self.yoffset, 20, 20, alfabeto:getDimensions()))
	end

end

function Escribir:render(x, y, sx, sy)
	if not sx then
		self.sx = 1
	else 
		self.sx = sx
	end

	if not sy then
		self.sy = 1
	else 
		self.sy = sy
	end

	for i = 1, #self.string do
		love.graphics.draw(alfabeto, self.caracteres[i], x, y, 0, self.sx, self.sy)
		x = x + (20 * self.sx)
	end
end

function Escribir:seleccion_caracter(key)
	if key == 'a' or key == 'A' then
		self.xoffset = 0
		self.yoffset = 0
	elseif key == 'b' or key == 'B' then
		self.xoffset = 20
		self.yoffset = 0
	elseif key == 'c' or key == 'C' then
		self.xoffset = 40
		self.yoffset = 0
	elseif key == 'd' or key == 'D' then
		self.xoffset = 60
		self.yoffset = 0
	elseif key == 'e' or key == 'E' then
		self.xoffset = 80
		self.yoffset = 0
	elseif key == 'f' or key == 'F' then
		self.xoffset = 100
		self.yoffset = 0
	elseif key == 'g' or key == 'G' then
		self.xoffset = 120
		self.yoffset = 0
	elseif key == 'h' or key == 'H' then
		self.xoffset = 140
		self.yoffset = 0
	elseif key == 'i' or key == 'I' then
		self.xoffset = 160
		self.yoffset = 0
	elseif key == 'j' or key == 'J' then
		self.xoffset = 180
		self.yoffset = 0
	elseif key == 'k' or key == 'K' then
		self.xoffset = 0
		self.yoffset = 20
	elseif key == 'l' or key == 'L' then
		self.xoffset = 20
		self.yoffset = 20
	elseif key == 'm' or key == 'M' then
		self.xoffset = 40
		self.yoffset = 20
	elseif key == 'n' or key == 'N' then
		self.xoffset = 60
		self.yoffset = 20
	elseif key == 'o' or key == 'O' then
		self.xoffset = 80
		self.yoffset = 20
	elseif key == 'p' or key == 'P' then
		self.xoffset = 100
		self.yoffset = 20
	elseif key == 'q' or key == 'Q' then
		self.xoffset = 120
		self.yoffset = 20
	elseif key == 'r' or key == 'R' then
		self.xoffset = 140
		self.yoffset = 20
	elseif key == 's' or key == 'S' then
		self.xoffset = 160
		self.yoffset = 20
	elseif key == 't' or key == 'T' then
		self.xoffset = 180
		self.yoffset = 20
	elseif key == 'u' or key == 'U' then
		self.xoffset = 0
		self.yoffset = 40
	elseif key == 'v' or key == 'V' then
		self.xoffset = 20
		self.yoffset = 40
	elseif key == 'w' or key == 'W' then
		self.xoffset = 40
		self.yoffset = 40
	elseif key == 'x' or key == 'X' then
		self.xoffset = 60
		self.yoffset = 40
	elseif key == 'y' or key == 'Y' then
		self.xoffset = 80
		self.yoffset = 40
	elseif key == 'z' or key == 'Z' then
		self.xoffset = 100
		self.yoffset = 40
	elseif key == 1 or key == '1' then
		self.xoffset = 0
		self.yoffset = 60
	elseif key == 2 or key == '2' then
		self.xoffset = 20
		self.yoffset = 60
	elseif key == 3 or key == '3' then
		self.xoffset = 40
		self.yoffset = 60
	elseif key == 4 or key == '4' then
		self.xoffset = 60
		self.yoffset = 60
	elseif key == 5 or key == '5' then
		self.xoffset = 80
		self.yoffset = 60
	elseif key == 6 or key == '6' then
		self.xoffset = 100
		self.yoffset = 60
	elseif key == 7 or key == '7' then
		self.xoffset = 120
		self.yoffset = 60
	elseif key == 8 or key == '8' then
		self.xoffset = 140
		self.yoffset = 60
	elseif key == 9 or key == '9' then
		self.xoffset = 160
		self.yoffset = 60
	elseif key == 0  or key == '0' then
		self.xoffset = 180
		self.yoffset = 60
	end
end

return Escribir
