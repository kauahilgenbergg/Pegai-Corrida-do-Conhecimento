extends Node2D

# Caminho pra tua cena de obstáculo
@export var obstacle_scene: PackedScene

# Intervalo de tempo entre um obstáculo e outro
@export var spawn_interval: float = 0.5

# Limites verticais de spawn (caso o player pule ou tenha diferentes alturas)
@export var min_y: float = 300
@export var max_y: float = 500

# Posição X inicial dos obstáculos (geralmente fora da tela à direita)
@export var spawn_x: float = 1300

func _ready():
	randomize()
	# Chama a função de spawn repetidamente
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_Timer_timeout():
	spawn_obstacle()

func spawn_obstacle():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = Vector2(spawn_x, randf_range(min_y, max_y))
	add_child(obstacle)
