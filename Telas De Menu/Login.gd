extends Control

func _ready():
	$Button.connect("pressed", Callable(self, "_on_play_pressed"))

func _on_play_pressed():
	var nome = $LineEdit.text
	var idade = $LineEdit2.text
	
	if nome == "" or idade == "":
		print("Preencha os dados antes de jogar!")
		return
	
	print("Jogador:", nome, "| Idade:", idade)
	get_tree().change_scene_to_file("res://Telas De Menu/TelaInicial.tscn") # troca pra cena principal do jogo
