Escribir = Class{}

local alfabeto = love.graphics.newImage('Imagen/Menus/AlfabetoSpace.png')

function Escribir:init(key)
	self.key = key
	self.x = 0
	self.y = 0
	self.xoffset = 0
	self.yoffset = 0
	self:seleccion_caracter(key)
	self.caracter = love.graphics.newQuad(self.xoffset, self.yoffset, 20, 20, alfabeto:getDimensions())
end

function Escribir:update()
	if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('A') then
		self.xoffset = 0
		self.yoffset = 0
	elseif love.keyboard.wasPressed('b') or love.keyboard.wasPressed('B') then
		self.xoffset = 20
		self.yoffset = 0
	elseif love.keyboard.wasPressed('c') or love.keyboard.wasPressed('C') then
		self.xoffset = 40
		self.yoffset = 0
	elseif love.keyboard.wasPressed('d') or love.keyboard.wasPressed('D') then
		self.xoffset = 60
		self.yoffset = 0
	elseif love.keyboard.wasPressed('e') or love.keyboard.wasPressed('E') then
		self.xoffset = 80
		self.yoffset = 0
	elseif love.keyboard.wasPressed('f') or love.keyboard.wasPressed('F') then
		self.xoffset = 100
		self.yoffset = 0
	elseif love.keyboard.wasPressed('g') or love.keyboard.wasPressed('G') then
		self.xoffset = 120
		self.yoffset = 0
	elseif love.keyboard.wasPressed('h') or love.keyboard.wasPressed('H') then
		self.xoffset = 140
		self.yoffset = 0
	elseif love.keyboard.wasPressed('i') or love.keyboard.wasPressed('I') then
		self.xoffset = 160
		self.yoffset = 0
	elseif love.keyboard.wasPressed('j') or love.keyboard.wasPressed('J') then
		self.xoffset = 180
		self.yoffset = 0
	elseif love.keyboard.wasPressed('k') or love.keyboard.wasPressed('K') then
		self.xoffset = 0
		self.yoffset = 20
	elseif love.keyboard.wasPressed('l') or love.keyboard.wasPressed('L') then
		self.xoffset = 20
		self.yoffset = 20
	elseif love.keyboard.wasPressed('m') or love.keyboard.wasPressed('M') then
		self.xoffset = 40
		self.yoffset = 20
	elseif love.keyboard.wasPressed('n') or love.keyboard.wasPressed('N') then
		self.xoffset = 60
		self.yoffset = 20
	elseif love.keyboard.wasPressed('o') or love.keyboard.wasPressed('O') then
		self.xoffset = 80
		self.yoffset = 20
	elseif love.keyboard.wasPressed('p') or love.keyboard.wasPressed('P') then
		self.xoffset = 100
		self.yoffset = 20
	elseif love.keyboard.wasPressed('q') or love.keyboard.wasPressed('Q') then
		self.xoffset = 120
		self.yoffset = 20
	elseif love.keyboard.wasPressed('r') or love.keyboard.wasPressed('R') then
		self.xoffset = 140
		self.yoffset = 20
	elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('S') then
		self.xoffset = 160
		self.yoffset = 20
	elseif love.keyboard.wasPressed('t') or love.keyboard.wasPressed('T') then
		self.xoffset = 180
		self.yoffset = 20
	elseif love.keyboard.wasPressed('u') or love.keyboard.wasPressed('U') then
		self.xoffset = 0
		self.yoffset = 40
	elseif love.keyboard.wasPressed('v') or love.keyboard.wasPressed('V') then
		self.xoffset = 20
		self.yoffset = 40
	elseif love.keyboard.wasPressed('w') or love.keyboard.wasPressed('W') then
		self.xoffset = 40
		self.yoffset = 40
	elseif love.keyboard.wasPressed('x') or love.keyboard.wasPressed('X') then
		self.xoffset = 60
		self.yoffset = 40
	elseif love.keyboard.wasPressed('y') or love.keyboard.wasPressed('Y') then
		self.xoffset = 80
		self.yoffset = 40
	elseif love.keyboard.wasPressed('z') or love.keyboard.wasPressed('Z') then
		self.xoffset = 100
		self.yoffset = 40
	elseif love.keyboard.wasPressed('1') then
		self.xoffset = 0
		self.yoffset = 60
	elseif love.keyboard.wasPressed('2') then
		self.xoffset = 20
		self.yoffset = 60
	elseif love.keyboard.wasPressed('3') then
		self.xoffset = 40
		self.yoffset = 60
	elseif love.keyboard.wasPressed('4') then
		self.xoffset = 60
		self.yoffset = 60
	elseif love.keyboard.wasPressed('5') then
		self.xoffset = 80
		self.yoffset = 60
	elseif love.keyboard.wasPressed('6') then
		self.xoffset = 100
		self.yoffset = 60
	elseif love.keyboard.wasPressed('7') then
		self.xoffset = 120
		self.yoffset = 60
	elseif love.keyboard.wasPressed('8') then
		self.xoffset = 140
		self.yoffset = 60
	elseif love.keyboard.wasPressed('9') then
		self.xoffset = 160
		self.yoffset = 60
	elseif love.keyboard.wasPressed('0') then
		self.xoffset = 180
		self.yoffset = 60
	end

	self.caracter:setViewport(self.xoffset, self.yoffset, 20, 20)
end


function Escribir:render(x, y, sx, sy)
	self.x = x
	self.y = y
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

	love.graphics.draw(alfabeto, self.caracter, self.x, self.y, 0, self.sx, self.sy)
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
	elseif key == 1 then
		self.xoffset = 0
		self.yoffset = 60
	elseif key == 2 then
		self.xoffset = 20
		self.yoffset = 60
	elseif key == 3 then
		self.xoffset = 40
		self.yoffset = 60
	elseif key == 4 then
		self.xoffset = 60
		self.yoffset = 60
	elseif key == 5 then
		self.xoffset = 80
		self.yoffset = 60
	elseif key == 6 then
		self.xoffset = 100
		self.yoffset = 60
	elseif key == 7 then
		self.xoffset = 120
		self.yoffset = 60
	elseif key == 8 then
		self.xoffset = 140
		self.yoffset = 60
	elseif key == 9 then
		self.xoffset = 160
		self.yoffset = 60
	elseif key == 0 then
		self.xoffset = 180
		self.yoffset = 60
	end
end

return Escribir
