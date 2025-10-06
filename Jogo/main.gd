extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var spawn_x: float = 1300
@export var min_y: float = 50
@export var max_y: float = 400

# Nó pai onde os obstáculos serão adicionados (Layer0)
@export var layer0_node: Node2D  # arrasta o Layer0 aqui no Inspector

var timer: Timer

func _ready():
	randomize()
	
	# Cria Timer via código
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	spawn_obstacle()

func spawn_obstacle():
	if not layer0_node:
		return  # evita erro caso não tenha sido arrastado no Inspector

	var obstacle = obstacle_scene.instantiate()
	
	# Posição aleatória vertical
	obstacle.position = Vector2(spawn_x, randf_range(min_y, max_y))
	obstacle.z_index = 1
	
	# Adiciona como filho do Layer0 de forma segura
	layer0_node.call_deferred("add_child", obstacle)
