extends Control

func _ready():
	$Button.connect("pressed", Callable(self, "_on_play_pressed"))

func _on_play_pressed():
	var nome = $LineEdit.text
	var idade_texto = $LineEdit2.text
	

	if nome.is_empty() or idade_texto.is_empty():
		print("Preencha os dados antes de jogar!")
		return
		

	if not idade_texto.is_valid_int():
		print("Idade inválida! Por favor, insira apenas números.")
		return
		
	var idade = int(idade_texto)
	
	PlayerData.player_name = nome
	PlayerData.player_age = idade
	
	# Muda para a cena principal do jogo (o lobby ou a tela inicial)
	get_tree().change_scene_to_file("res://Telas De Menu/Tela inicial/TelaInicial.tscn") # troca pra cena principal do jogo
