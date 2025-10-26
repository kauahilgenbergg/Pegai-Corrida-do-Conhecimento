extends Control

var contagem = 3

# Função chamada quando a cena está pronta
func _ready():
	$ContagemLabel.visible = false

# Função conectada ao sinal 'pressed' do seu botão
func _on_button_pressed() -> void:
	print("O botão foi pressionado! Iniciando contagem...")
	# Reseta a contagem para o valor inicial
	contagem = 3
	# Torna o rótulo visível
	$ContagemLabel.visible = true
	$Sprite2D2.visible = false;
	$Label.visible = false;
	# Opcional: Desabilita o botão para evitar múltiplos cliques
	$Button.visible = false
	# Inicia o processo da contagem pela primeira vez
	_processar_contagem()

# Função que controla a lógica da contagem regressiva
func _processar_contagem() -> void:
	# Verifica se a contagem ainda está acima de zero
	if contagem > 0:
		# 1. Atualiza o texto do rótulo com o número atual
		$ContagemLabel.text = "Partida iniciando em %d..." % contagem
		
		# 2. Decrementa o contador para a próxima chamada
		contagem -= 1
		
		# 3. CRIA O TIMER: Cria um timer de 1 segundo que, ao terminar,
		# chamará esta mesma função novamente, criando um loop.
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(_processar_contagem)
	else:
		# A contagem terminou
		$ContagemLabel.text = "Iniciando!"
		call_deferred("_trocar_de_tela")

# Função para mudar de cena de forma segura
func _trocar_de_tela():
	print("Carregando cena de jogo...")
	var error = get_tree().change_scene_to_file("res://Jogo/Os Reinos Perdidos/Jogo/main.tscn")
	if error != OK:
		print("ERRO: Não foi possível carregar a cena. Verifique se o caminho 'res://Jogo/Os Reinos Perdidos/Jogo/main.tscn' está correto.")
