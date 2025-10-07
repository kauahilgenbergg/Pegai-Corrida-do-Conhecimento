extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var map_speed: float = 400.0


var timer: Timer

func _ready():
	# Spawn inicial garantido no primeiro frame
	call_deferred("_spawn_initial_obstacles")
	
	# Timer para spawn contínuo
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.start()
	timer.connect("timeout", Callable(self, "_spawn_obstacle"))


func _spawn_initial_obstacles():
	var screen_top = 0
	var screen_bottom = 600 # ou a altura da sua tela
	var spacing = 150       # distância vertical entre os obstáculos

	for i in range(3):
		var obstacle = obstacle_scene.instantiate()
		add_child(obstacle)
		# Posiciona dentro da tela, mas com espaçamento
		obstacle.position = Vector2(randf_range(50, 550), screen_top + spacing * i + 50)
		obstacle.map_speed = map_speed
		obstacle.z_index = 1


func _spawn_obstacle(offset_y = 0):
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	# Spawn acima da tela, para ir descendo
	obstacle.position = Vector2(randf_range(50, 550), -50 + offset_y)
	obstacle.map_speed = map_speed
	obstacle.z_index = 1
