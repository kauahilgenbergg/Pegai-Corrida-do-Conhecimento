# scrolling_world.gd
extends Node2D

## A velocidade com que o cenário se move para baixo, em pixels por segundo.
@export var scroll_speed = 150.0

## A altura de UM "pedaço" do seu mapa (ex: 1280).
@export var chunk_height = 900


func _process(delta):
	# Garante que o script não faça nada se a altura não for configurada.
	if chunk_height == 0:
		return

	# CORREÇÃO DEFINITIVA: Usamos '+=' para mover o nó World para BAIXO no espaço do jogo.
	# Isso faz o cenário parecer que está se movendo PARA BAIXO na tela.
	position.y += scroll_speed * delta

	# CORREÇÃO DEFINITIVA: A lógica do loop foi ajustada para o movimento para baixo.
	# Verificamos se a posição Y do nó se tornou maior ou igual à altura de um pedaço.
	# Isso significa que o primeiro "pedaço" do mapa (Chunk A) já saiu completamente da tela por cima.
	if position.y >= chunk_height:
		# Quando isso acontece, nós subtraímos a altura de um chunk da posição atual.
		# Isso "teletransporta" o mapa de volta para o início do loop de forma imperceptível.
		position.y -= chunk_height
