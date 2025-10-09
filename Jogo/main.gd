extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 0.3
@export var map_speed: float = 400.0

var spawn_timer: Timer

# --- NOVAS VARIÁVEIS PARA O CRONÔMETRO ---
var elapsed_time: float = 0.0      # Guarda o tempo decorrido em segundos
var is_game_active: bool = true    # Controla se o cronômetro deve rodar

func _ready():
	# Garante que o texto e os botões comecem escondidos
	$Label.visible = false
	if has_node("Button"):
		$Button.visible = false
	# NOVO: Garante que o Button2 também comece escondido
	if has_node("Button2"):
		$Button2.visible = false
	
	# Inicia o texto do cronômetro
	$Label2.text = "Tempo: 0.000"
	
	# Spawn inicial garantido no primeiro frame
	call_deferred("_spawn_initial_obstacles")
	
	# Timer para spawn contínuo de obstáculos
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.start()
	spawn_timer.connect("timeout", Callable(self, "_spawn_obstacle"))

func _process(delta: float) -> void:
	if is_game_active:
		elapsed_time += delta
		$Label2.text = "Tempo: %.3f" % elapsed_time

func _spawn_initial_obstacles():
	var screen_top = 0
	var screen_bottom = 600
	var spacing = 150

	for i in range(10):
		var obstacle = obstacle_scene.instantiate()
		add_child(obstacle)
		obstacle.position = Vector2(randf_range(50, 550), screen_top + spacing * i + 50)
		obstacle.map_speed = map_speed
		obstacle.z_index = 1

func _spawn_obstacle(offset_y = 0):
	var obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	obstacle.position = Vector2(randf_range(50, 550), -50 + offset_y)
	obstacle.map_speed = map_speed
	obstacle.z_index = 1

# --- FUNÇÃO MODIFICADA ---
func game_over(venceu: bool):
	is_game_active = false
	get_tree().paused = true
	
	if venceu:
		$Label.text = "Parabéns! Seu tempo: %.3f" % elapsed_time
		$Button.visible = false # O botão de reiniciar não aparece na vitória
	else:
		$Label.text = "Você perdeu..."
		$Button.visible = true # O botão de reiniciar aparece na derrota
	
	$Label.visible = true
	# NOVO: O Button2 (Voltar ao Menu) aparece em ambos os casos (vitória ou derrota)
	$Button2.visible = true

func _on_button_pressed() -> void:
	# Botão de reiniciar o jogo
	get_tree().paused = false
	get_tree().reload_current_scene()

# --- NOVA FUNÇÃO PARA O Button2 ---
func _on_button_2_pressed() -> void:
	# Botão para voltar à tela inicial
	# É importante despausar o jogo antes de trocar de cena
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Telas De Menu/Tela inicial/TelaInicial.tscn")
