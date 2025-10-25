extends Node

@onready var name_label = $jogador
@onready var level_label = $level

func _ready():
	var current_player_name = PlayerData.player_name
	
	if not current_player_name.is_empty():
		name_label.text = current_player_name
	else:
		name_label.text = "Jogador"
		
	var current_player_level = PlayerData.player_level
	level_label.text = "Lv. " + str(current_player_level)

func _on_button_2_pressed() -> void:
	call_deferred("_trocar_de_tela")

# Função para mudar de cena de forma segura
func _trocar_de_tela():
	print("Carregando cena de jogo...")
	var error = get_tree().change_scene_to_file("res://Jogo/Os Reinos Perdidos/História Pré Jogo/Tela 1/Tela.tscn")
	if error != OK:
		print("ERRO: Não foi possível carregar a cena. Verifique se o caminho 'res://Jogo/Os Reinos Perdidos/História Pré Jogo/Tela 1/Tela.tscn")
