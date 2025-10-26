extends Node

func _on_button_pressed() -> void:
	call_deferred("_trocar_de_tela")

# Função para mudar de cena de forma segura
func _trocar_de_tela():
	print("Carregando cena de jogo...")
	var error = get_tree().change_scene_to_file("res://Jogo/Os Reinos Perdidos/Level 2/História Pós Jogo/Tela 3/Tela.tscn")
	if error != OK:
		print("ERRO: Não foi possível carregar a cena. Verifique se o caminho 'res://Jogo/Os Reinos Perdidos/História Pós Jogo/Tela 3/Tela.tscn")
