
--Tenemos que incluir las librerias para las clases

Class = require 'Source/Util/class'

--Archivos que tienen que ver con la nave del jugador, sus balas y poderes
require 'Source/Player/bala'
require 'Source/Player/disparoDireccional'
require 'Source/Player/pulsar'
require 'Source/Player/nave'
require 'Source/Player/playerShotManager'
require 'Source/Player/pickup'
require 'Source/Player/PulsoDiego'
require 'Source/Player/MisilGerman'
require 'Source/Player/RayoAlex'

--Archivos de los enemigos, de distintos tipos
require 'Source/Enemy/asteroide'
require 'Source/Enemy/asteroideM'
require 'Source/Enemy/asteroideG'
require 'Source/Enemy/cazaBasic'
require 'Source/Enemy/drone'
require 'Source/Enemy/hunterMaster'
require 'Source/Enemy/hunterSlave'
require 'Source/Enemy/lancer'
require 'Source/Enemy/crucero'
require 'Source/Enemy/capital'
require 'Source/Enemy/pieza'
require 'Source/Enemy/torreta'
require 'Source/Enemy/nucleo'
require 'Source/Enemy/ingeniero'
require 'Source/Enemy/cannon'
require 'Source/Enemy/smartCannon'
require 'Source/Enemy/discEnergy'
require 'Source/Enemy/enemyPhoton'
require 'Source/Enemy/WisilGerwan'
require 'Source/Enemy/nubeNebulosa'
require 'Source/Enemy/EngineEnemy/enemyManager'
require 'Source/Enemy/EngineEnemy/updateEnemigos'
require 'Source/Enemy/EngineEnemy/engineShot'

--Archivos de fondo de pantalla
require 'Source/Background/background'
require 'Source/Background/planetas'
require 'Source/Background/estrellas'
require 'Source/Background/sky/sky'
require 'Source/Background/sky/star'

--Archivos de funciones varias, o que unen muchas clases diferentes
require 'Source/Util/constantes'
require 'Source/Util/animacion'
require 'Source/Util/escudos'
require 'Source/Util/tesound'
require 'Source/Util/escribir'
require 'Source/Util/dpad'
push = require 'Source/Util/push'

--Archivos de la maquina de estados
require 'Source/States/StateMachine'
require 'Source/States/BaseState'
require 'Source/States/Play'
require 'Source/States/Pause'
require 'Source/States/Inicio'
require 'Source/States/Char-select'
require 'Source/States/GameOver'
require 'Source/States/PuntajeAlto'
require 'Source/States/ListaPuntajes'
require 'Source/States/Menu'
require 'Source/States/Configuracion'
