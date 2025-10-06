extends Control

func _ready():
	# Este código roda assim que a cena é iniciada.
	print("A cena 'BemVindo' foi iniciada.")
	
	# Vamos ter certeza de que o botão foi encontrado
	if $Button:
		print("Nó 'Button' encontrado. Conectando o sinal...")
		$Button.connect("pressed", Callable(self, "_on_start_pressed"))
	else:
		print("ERRO: O nó chamado 'Button' não foi encontrado!")

func _on_start_pressed():
	# Este código só roda se o botão for pressionado e o sinal conectado.
	print("O botão foi pressionado! Tentando carregar a cena 'Login'...")
	get_tree().change_scene_to_file("res://Telas De Menu/Login.tscn")
