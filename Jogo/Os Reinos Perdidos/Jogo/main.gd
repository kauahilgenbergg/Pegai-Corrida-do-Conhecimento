extends Node2D

static var saved_elapsed_time: float = 0.0

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 0.3
@export var map_speed: float = 400.0

var spawn_timer: Timer

const INITIAL_TIME: float = 30.0
var elapsed_time: float = 0.0
var is_game_active: bool = true
var level_atual: int = 1

var countdown: int = 3

func _ready():
	if saved_elapsed_time > 0.0:
		elapsed_time = saved_elapsed_time
		saved_elapsed_time = 0.0
	else:
		elapsed_time = INITIAL_TIME
	
	$Label.visible = false
	if has_node("Button"):
		$Button.visible = false
	if has_node("Button2"):
		$Button2.visible = false
	if has_node("Button3"):
		$Button3.visible = false
	if has_node("Pergunta"):
		$Pergunta.visible = false
	
	$Label2.text = "Restante: %.3f" % elapsed_time
	
	call_deferred("_spawn_initial_obstacles")
	
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.start()
	spawn_timer.connect("timeout", Callable(self, "_spawn_obstacle"))

func _process(delta: float) -> void:
	if is_game_active:
		elapsed_time -= delta
		$Label2.text = "Restante: %.3f" % max(0.0, elapsed_time)
		
		if elapsed_time <= 0.0:
			elapsed_time = 0.0
			game_over(true)
			is_game_active = false

func _spawn_initial_obstacles():
	var screen_top = 0
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

func game_over(venceu: bool):
	is_game_active = false
	get_tree().paused = true
	
	if venceu:
		$Label.text = "Parabéns! Você venceu!"
		$Button2.visible = true
		
		# Salva o level atual antes de aumentar
		level_atual = PlayerData.player_level
		
		# Aumenta o level do jogador
		PlayerData.player_level += 1
		print("Nível atual: ", level_atual, " -> Novo nível: ", PlayerData.player_level)
		
				
	else:
		$Label.text = "Você perdeu..."
		if has_node("Button3"):
			$Button3.visible = true
	
	$Label.visible = true
	$Button.visible = true


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	
	# Monta o caminho automático da tela pós-jogo
	var path = "res://Jogo/Os Reinos Perdidos/Level %d/História Pós Jogo/Tela 1/Tela.tscn" % level_atual
	
	print("Tentando carregar cena do Level " + str(level_atual) + ": " + path)
	
	if ResourceLoader.exists(path):
		var error = get_tree().change_scene_to_file(path)
		if error != OK:
			printerr("ERRO: Não foi possível carregar a cena: ", path)
	else:
		printerr("CENA NÃO ENCONTRADA! Caminho inválido: ", path)


func _on_button_3_pressed() -> void:
	if has_node("Button"):
		$Button.visible = false
	if has_node("Label"):
		$Label.visible = false
	if has_node("Button3"):
		$Button3.visible = false
		
	if has_node("Pergunta"):
		$Pergunta.visible = true
		
	countdown = 3
	
	$Pergunta/pergunta.text = "Qual é o objetivo de Elyon em sua jornada?"
	$Pergunta/resp1.disabled = false
	$Pergunta/resp2.disabled = false
	$Pergunta/resp3.disabled = false
	$Pergunta/resp4.disabled = false


func _handle_incorrect_answer(button: Button) -> void:
	button.disabled = true


func _on_resp_3_pressed() -> void:
	$Pergunta/resp1.disabled = true
	$Pergunta/resp2.disabled = true
	$Pergunta/resp3.disabled = true
	$Pergunta/resp4.disabled = true
	
	saved_elapsed_time = elapsed_time
	_update_continuation_countdown()


func _update_continuation_countdown() -> void:
	if countdown > 0:
		$Pergunta/pergunta.text = "Acertou, continuando em %d..." % countdown
		countdown -= 1
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(_update_continuation_countdown)
	else:
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_resp_1_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp1)

func _on_resp_2_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp2)

func _on_resp_4_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp4)
