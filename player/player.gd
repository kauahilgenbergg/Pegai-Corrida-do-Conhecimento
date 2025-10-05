extends CharacterBody2D

# --- Variáveis ---
@export var speed = 300.0
# A variável 'friction' foi removida.

@onready var animated_sprite = $AnimatedSprite2D

# Guarda a última direção de movimento para a animação 'idle'
var last_direction = Vector2(0, 1) # Começa virado para baixo (down)


# --- Funções do Godot ---
func _physics_process(delta):
	# Pega o input do jogador
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	var vertical_direction = Input.get_axis("move_up", "move_down")
	var direction = Vector2(horizontal_direction, vertical_direction).normalized()

	# --- CORREÇÃO APLICADA AQUI ---
	# A velocidade agora é definida diretamente pela direção do input.
	# Se não há input (direction = Vector2.ZERO), a velocidade se torna zero instantaneamente.
	velocity = direction * speed

	# Chama nossa função para atualizar a animação
	update_animation()

	# Move o personagem
	move_and_slide()


# --- Funções Personalizadas ---
func update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			last_direction = Vector2(sign(velocity.x), 0) # Movimento horizontal
		else:
			last_direction = Vector2(0, sign(velocity.y)) # Movimento vertical

		if last_direction.y < 0:
			animated_sprite.play("run_up")
		elif last_direction.y > 0:
			animated_sprite.play("run_down")
		elif last_direction.x < 0:
			animated_sprite.play("run_left")
		elif last_direction.x > 0:
			animated_sprite.play("run_right")
			
	else:
		if last_direction.y < 0:
			animated_sprite.play("idle_up")
		elif last_direction.y > 0:
			animated_sprite.play("idle_down")
		elif last_direction.x < 0:
			animated_sprite.play("idle_left")
		elif last_direction.x > 0:
			animated_sprite.play("idle_right")
