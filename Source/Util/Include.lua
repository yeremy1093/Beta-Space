
--Tenemos que incluir las librerias para las clases

Class = require 'Source/Util/class'

--Archivos que tienen que ver con la nave del jugador, sus balas y poderes
require 'Source/Player/bala'
require 'Source/Player/nave'

--Archivos de los enemigos, de distintos tipos
require 'Source/Enemy/asteroide'
require 'Source/Enemy/EngineEnemy/enemyManager'

--Archivos de fondo de pantalla
require 'Source/Background/background'
require 'Source/Background/sky/sky'
require 'Source/Background/sky/star'

--Archivos de funciones varias, o que unen muchas clases diferentes
require 'Source/Util/constantes'
require 'Source/Util/util'
require 'Source/Util/colisiones'
require 'Source/Util/animacion'
require 'Source/Util/escudos'
require 'Source/Util/tesound'

--Archivos de la maquina de estados
require 'Source/States/StateMachine'
require 'Source/States/BaseState'
require 'Source/States/Play'
require 'Source/States/Inicio'
require 'Source/States/Char-select'
