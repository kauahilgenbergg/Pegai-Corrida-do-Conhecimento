extends CharacterBody2D

@export var speed = 300.0

@onready var animated_sprite = $AnimatedSprite2D

# A variável 'last_direction' não é mais necessária para esta lógica simplificada

func _physics_process(delta):
	# Pega o input APENAS para a direção horizontal
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	
	# A velocidade vertical (Y) agora é sempre zero
	velocity.x = horizontal_direction * speed
	velocity.y = 0

	# Chama a função de animação
	update_animation()

	# Move o personagem
	move_and_slide()


func update_animation():
	# Verifica se há movimento horizontal
	if velocity.x < 0:
		# Se a velocidade X é negativa, está se movendo para a esquerda
		animated_sprite.play("run_left")
	elif velocity.x > 0:
		# Se a velocidade X é positiva, está se movendo para a direita
		animated_sprite.play("run_right")
	else:
		# Se a velocidade X é zero (sem input para os lados),
		# o personagem está correndo para frente.
		animated_sprite.play("run_up")
