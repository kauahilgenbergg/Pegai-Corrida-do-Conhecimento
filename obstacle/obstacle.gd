extends Node2D

@export var map_speed: float = 400.0
@export var horizontal_speed: float = 50.0
var direction: int = 1  # 1 = direita, -1 = esquerda

func _ready():
	# Decide aleatoriamente se começa indo para direita ou esquerda
	direction = 1 if randi() % 2 == 0 else -1

func _process(delta):
	# Movimento vertical com o mapa
	position.y += map_speed * delta
	
	# Movimento horizontal vai-e-vem
	position.x += horizontal_speed * direction * delta

# Função para inverter a direção quando colidir com limites
func invert_direction():
	direction *= -1
