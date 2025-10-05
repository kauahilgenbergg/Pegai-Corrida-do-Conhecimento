extends TextureRect

# A velocidade com que a textura vai rolar.
# O valor pode ser ajustado diretamente no Inspetor do Godot.
# Valores positivos rolam para baixo, negativos para cima.
@export var scroll_speed: float = 100.0

func _process(delta: float) -> void:
	position.y += scroll_speed * delta
