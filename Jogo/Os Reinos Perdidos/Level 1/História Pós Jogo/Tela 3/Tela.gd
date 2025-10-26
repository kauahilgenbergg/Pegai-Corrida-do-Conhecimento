extends Node

func _on_button_pressed() -> void:
	call_deferred("_trocar_de_tela")

# Função para mudar de cena de forma segura
func _trocar_de_tela():
	print("Carregando cena de jogo...")
	var error = get_tree().change_scene_to_file("res://Telas De Menu/Tela inicial/TelaInicial.tscn")
	if error != OK:
		print("ERRO: Não foi possível carregar a cena. Verifique se o caminho 'res://Telas De Menu/Tela inicial/TelaInicial.tscn")
