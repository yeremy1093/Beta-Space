Star = Class{}

local MAX_FPS_COLOR = 10
local FPS_SYSTEM = 1/10
local WHITE = {1, 1, 1, 0.9}
local RED = {1, 0, 0, 0.8}
local BLUE = {0, 0, 1, 0.8}

function Star:init(x, y, dx, dy)
    self.x = x
    self.y = y
    self.dx = dx * love.math.random(1,3)
    self.dy = dy * love.math.random(1,3)
    self.animation_timer = FPS_SYSTEM
    self.current_fps = love.math.random(1, MAX_FPS_COLOR)
    self.white = love.math.random(5, MAX_FPS_COLOR)
    self.red = love.math.random(0, (MAX_FPS_COLOR - self.white))
    self.blue = MAX_FPS_COLOR - (self.white + self.red)
    self.currentColor = WHITE
end

function Star:update(dt)
    --Seleccion de color por tiempo de frame
    self.animation_timer = self.animation_timer - dt
    if self.animation_timer <= 0 then
        self.animation_timer = FPS_SYSTEM
        if (self.current_fps >= 1 and self.current_fps <= self.white) then
            self.currentColor = WHITE
        elseif (self.current_fps > self.white and self.current_fps <= (self.red + self.white)) then
            self.currentColor = RED
        elseif (self.current_fps > (self.red + self.white) and self.current_fps <= MAX_FPS_COLOR) then
            self.currentColor = BLUE
        end
        self.current_fps = self.current_fps + 1
        if self.current_fps > MAX_FPS_COLOR then
            self.current_fps = 1
        end
    end

    --Movimiento de estrella a traves del espacio en x y con velocidades dx dy
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end

function Star:render()
    love.graphics.setColor(self.currentColor)
    love.graphics.rectangle("fill", self.x, self.y, 2, 2)
    love.graphics.setColor(WHITE)
end