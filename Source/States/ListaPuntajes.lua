
ListaPuntajes = Class{__includes = BaseState}


local img_menu = love.graphics.newImage('Imagen/Menus/Highscore.png')

function ListaPuntajes:enter(params)

    --cargamos los puntajes altos
    self.highScores = params.highScores

    --Cargamos el fondo
    self.background = Background()

    --cargamos estellas de alex
    sky = Sky (WINDOW_WIDTH, WINDOW_HEIGHT, 2000, 0, 0)

    --Cargamos lo de la animacion del Menu
    self.menu_sprite = love.graphics.newQuad(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, img_menu:getDimensions())
    self.menu_anim = Anim(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 4, 4, 10)

    --Titulo de la pantalla
    self.titulo = Escribir("Puntajes Altos")

    self.sprite_sheet = {}
    self.sprite_nave = {}
    self.naves_anim = {}

    --Ponemos las naves usadas en una Lista
    for i=1, 10 do
        if self.highScores[i].name then
            if self.highScores[i].name:sub(4,4) == '1' then
                table.insert(self.sprite_sheet, love.graphics.newImage('Imagen/Sprites/D-10.png'))
            elseif self.highScores[i].name:sub(4,4) == '2' then 
                table.insert(self.sprite_sheet, love.graphics.newImage('Imagen/Sprites/AX-2.png'))
            elseif self.highScores[i].name:sub(4,4) == '3' then 
                table.insert(self.sprite_sheet, love.graphics.newImage('Imagen/Sprites/Y9-2.png'))
            end

            table.insert(self.sprite_nave, love.graphics.newQuad(0, 0, 58, 40, self.sprite_sheet[i]:getDimensions()))
            table.insert(self.naves_anim, Anim(0, 0, 58, 40, 2, 2, 10))
        end
    end

    self.siglas = {}
    --Hacemos la lista de siglas
    for i=1, 10 do
        if self.highScores[i].name then
            table.insert(self.siglas, Escribir(string.sub(self.highScores[i].name, 1, 3)))
        else
            table.insert(self.siglas, Escribir("000"))
        end
    end

    self.numeros = {}
    for i=1, 10 do
        table.insert(self.numeros, Escribir(tostring(i)))
    end

end


--Lo que se va a calcular frame a frame
function ListaPuntajes:update(dt)

	--calculamos el loop de las estrellas de fondo
	self.background:animate_background(dt)

	--cargamos las estrellas de alex
    sky:update (dt)

    --Hacemos la animacion del menu
    self.menu_anim:update(dt, self.menu_sprite)

    --animamos las naves de la Lista
    for i=1, 10 do
        self.naves_anim[i]:update(dt, self.sprite_nave[i])
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')then
        TEsound.stop('musica_menu')
        gStateMachine:change('inicio', {highScores = loadHighScores()})
    end
end

function ListaPuntajes:render()
	self.background:render_background()

	--Dibujamos las estrellas de alex
    sky:render()

    love.graphics.draw(img_menu, self.menu_sprite, 0, 0)

    self.titulo:render(WINDOW_WIDTH/2 -140, 120)

    for i=1, 5 do
        self.numeros[i]:render(280, 240 + ((i-1) * 60))
        self.siglas[i]:render(320, 240 + ((i-1) * 60))
        love.graphics.draw(self.sprite_sheet[i], self.sprite_nave[i], 400, 240 + ((i-1) * 60),0 , 0.7, 0.7)
    end

    for i=6, 10 do
        self.numeros[i]:render(650, 240 + ((i-6) * 60))
        self.siglas[i]:render(690, 240 + ((i-6) * 60))
        love.graphics.draw(self.sprite_sheet[i], self.sprite_nave[i], 770, 240 + ((i-6) * 60),0 , 0.7, 0.7)
    end

end