extends TileMap
## A velocidade com que o cenário se move para cima, em pixels por segundo.
## Você pode ajustar este valor diretamente no Inspector do Godot.
@export var scroll_speed = 150.0

## A altura de UM "pedaço" do seu mapa.
## Este valor DEVE ser igual à altura de uma tela do seu jogo (Viewport Height).
## Ex: 1280 pixels. Você precisa configurar este valor no Inspector.
@export var chunk_height = 900.0


# A função _process é chamada a cada frame.
func _process(delta):
	if chunk_height == 0:
		return

	# CORREÇÃO: Usamos '+=' para mover o mapa para BAIXO.
	position.y += scroll_speed * delta

	# CORREÇÃO: A lógica do loop infinito foi invertida.
	# Verificamos se a posição Y do nó se tornou maior ou igual à altura de um pedaço.
	# Isso significa que o primeiro "pedaço" do mapa já saiu completamente da tela por cima.
	if position.y >= chunk_height:
		# Quando isso acontece, nós instantaneamente reposicionamos o mapa para o início do loop.
		# A transição é imperceptível, criando a ilusão de um caminho infinito.
		position.y -= chunk_height
