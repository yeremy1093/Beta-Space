--Aqui van las funciones que tienen que ver con las animaciones de todos los objetos, se ponen las cosas como objetos de la clase de animacion.

Anim = Class{}

--xoffset yoffset: donde empieza la imagen original en x y
--width height: alto y ancho del quad
--column_size: por si hay una fila nueva por debajo de la primera, si solo es una fila, poner el mismo dato que num_frames
--num_frames: cuantos quads tiene la imagen en sentido horizontal
--fps: velocidad de animacion
function Anim:init(xoffset, yoffset, width, height, column_size, num_frames, fps)
	self.fps = fps
	self.timer = 1/self.fps
	self.frame = 1
	self.num_frames = num_frames
	self.column_size = column_size
	self.start_xoffset = xoffset
	self.start_yoffset = yoffset
	self.xoffset = 0
	self.yoffset = 0
	self.width = width
	self.height = height
end

function Anim:update(dt, quad)
	self.timer = self.timer - dt

	if self.timer <= 0 then
		self.timer = 1/self.fps
		self.frame = self.frame + 1
		if self.frame > self.num_frames then
			self.frame = 1
		end

		self.xoffset = self.start_xoffset + (self.width * ((self.frame - 1) % (self.column_size)))
		self.yoffset = self.start_yoffset + (self.height * math.floor((self.frame - 1) / self.column_size))
		self:set(quad)
	end
	return self.frame
end

function Anim:set(quad)
	quad:setViewport(self.xoffset, self.yoffset, self.width, self.height)
end

function Anim:reset()
	self.timer = 1/self.fps
	self.frame = 1
end

return Anim

