extends Node2D

# Variável estática para guardar o tempo entre reinícios de cena.
static var saved_elapsed_time: float = 0.0

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 0.3
@export var map_speed: float = 400.0

var spawn_timer: Timer

# --- VARIÁVEIS PARA O CRONÔMETRO E JOGO ---
var elapsed_time: float = 0.0 # Guarda o tempo decorrido em segundos
var is_game_active: bool = true # Controla se o cronômetro deve rodar

# --- NOVAS VARIÁVEIS PARA A PERGUNTA ---
var countdown: int = 3 # Contador para a regressiva

func _ready():
	# RESTAURAÇÃO: Pega o tempo salvo e restaura na variável de instância.
	if saved_elapsed_time > 0.0:
		elapsed_time = saved_elapsed_time
		# Limpa o salvo para que um próximo Game Over normal comece do zero.
		saved_elapsed_time = 0.0 
	else:
		elapsed_time = 0.0
	
	# Garante que o texto e os botões comecem escondidos
	$Label.visible = false
	if has_node("Button"):
		$Button.visible = false
	if has_node("Button2"):
		$Button2.visible = false
	if has_node("Button3"):
		$Button3.visible = false
	if has_node("Pergunta"):
		$Pergunta.visible = false
	
	# Inicia o texto do cronômetro, usando o tempo restaurado
	$Label2.text = "Tempo: %.3f" % elapsed_time
	
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

# --- FUNÇÃO MODIFICADA PARA MOSTRAR O BUTTON3 NA DERROTA ---
func game_over(venceu: bool):
	is_game_active = false
	get_tree().paused = true
	
	if venceu:
		$Label.text = "Parabéns! Seu tempo: %.3f" % elapsed_time
		$Button2.visible = true
	else:
		$Label.text = "Você perdeu..."
		# Apenas se perdeu, mostra o Button3 para a segunda chance
		if has_node("Button3"):
			$Button3.visible = true
	
	$Label.visible = true
	$Button.visible = true

func _on_button_pressed() -> void:
	# Botão de reiniciar o jogo
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_button_2_pressed() -> void:
	# Botão para avançar na história (Menu)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Jogo/Os Reinos Perdidos/História Pós Jogo/Tela 1/Tela.tscn")

# --- NOVA FUNÇÃO PARA O BUTTON 3 (INICIAR PERGUNTA) ---
func _on_button_3_pressed() -> void:
	# Esconde os botões de game over
	if has_node("Button"):
		$Button.visible = false
	if has_node("Label"):
		$Label.visible = false
	if has_node("Button3"):
		$Button3.visible = false
		
	# Mostra o Control Pergunta
	if has_node("Pergunta"):
		$Pergunta.visible = true
		
	# Reseta o contador
	countdown = 3
		
	# Certifica-se de que todas as respostas estão habilitadas ao iniciar
	# Também redefine o texto da pergunta
	$Pergunta/pergunta.text = "Qual é o objetivo de Elyon em sua jornada?"
	$Pergunta/resp1.disabled = false
	$Pergunta/resp2.disabled = false
	$Pergunta/resp3.disabled = false
	$Pergunta/resp4.disabled = false

# --- FUNÇÃO PARA TRATAR RESPOSTAS INCORRETAS ---
func _handle_incorrect_answer(button: Button) -> void:
	# Desabilita o botão para que não possa ser apertado novamente
	button.disabled = true

# --- FUNÇÃO PARA TRATAR RESPOSTA CORRETA (resp3) ---
func _on_resp_3_pressed() -> void:
	# Resposta correta: Inicia a contagem regressiva
	
	# Desabilita todas as respostas
	$Pergunta/resp1.disabled = true
	$Pergunta/resp2.disabled = true
	$Pergunta/resp3.disabled = true
	$Pergunta/resp4.disabled = true
	
	# GUARDAR: Salva o tempo atual na variável estática. (CORRIGIDO: Removido o 'main.')
	saved_elapsed_time = elapsed_time 
	
	# Inicia a contagem
	_update_continuation_countdown()


# --- FUNÇÃO ATUALIZADA PARA O CONTADOR DE CONTINUAÇÃO (Método Recursivo de Timer) ---
func _update_continuation_countdown() -> void:
	if countdown > 0:
		# 1. Atualiza o texto do rótulo com o número atual
		$Pergunta/pergunta.text = "Acertou, continuando em %d..." % countdown
		
		# 2. Decrementa o contador para a próxima chamada
		countdown -= 1
		
		# 3. CRIA O TIMER
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(_update_continuation_countdown)
	else:
		# Fim da contagem: Reinicia a cena. O _ready() pegará o tempo salvo.
		get_tree().paused = false
		get_tree().reload_current_scene()

# --- FUNÇÕES PARA RESPOSTAS INCORRETAS ---
func _on_resp_1_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp1)

func _on_resp_2_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp2)

func _on_resp_4_pressed() -> void:
	_handle_incorrect_answer($Pergunta/resp4)
