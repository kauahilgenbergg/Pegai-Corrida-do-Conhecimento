extends Control

func _on_button_2_pressed() -> void:
	pass # Replace with function body.
	# Este código só roda se o botão for pressionado e o sinal conectado.
	print("O botão foi pressionado! Tentando carregar a cena de jogo...")
	get_tree().change_scene_to_file("res://Jogo/main.tscn")
