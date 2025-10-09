extends CharacterBody2D

@export var speed = 300.0
@onready var animated_sprite = $AnimatedSprite2D
# Pega uma referência para o próprio colisor do player
@onready var player_collider = $CollisionShape2D

# Referências para as áreas de vitória e derrota
@onready var lose_zone = get_node("/root/Main/limitesdacamera/CollisionShape2D3")
@onready var win_zone = get_node("/root/Main/limitesdacamera/CollisionShape2D4")

var game_ended = false # Variável para garantir que o jogo termine apenas uma vez

func _physics_process(delta):
	# Se o jogo já terminou, não faz mais nada
	if game_ended:
		return

	# --- Seu código de movimento (sem alterações) ---
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y = -20
	update_animation()
	move_and_slide()
	# ----------------------------------------------

	# --- NOVA LÓGICA DE COLISÃO MANUAL ---
	check_manual_collision()

func check_manual_collision():
	# Pega o "retângulo" que delimita o player no mundo do jogo
	var player_rect = player_collider.get_global_transform() * player_collider.shape.get_rect()

	# Pega o "retângulo" da zona de derrota
	var lose_rect = lose_zone.get_global_transform() * lose_zone.shape.get_rect()

	# Pega o "retângulo" da zona de vitória
	var win_rect = win_zone.get_global_transform() * win_zone.shape.get_rect()

	# Verifica se o retângulo do player se cruza com o da zona de derrota
	if player_rect.intersects(lose_rect):
		print("Colidiu com a zona de derrota!")
		game_ended = true # Avisa que o jogo acabou
		get_parent().game_over(false) # Chama a função no Main, avisando que perdeu

	# Verifica se o retângulo do player se cruza com o da zona de vitória
	if player_rect.intersects(win_rect):
		print("Colidiu com a zona de vitória!")
		game_ended = true # Avisa que o jogo acabou
		get_parent().game_over(true) # Chama a função no Main, avisando que venceu

func update_animation():
	if velocity.x < 0:
		animated_sprite.play("run_left")
	elif velocity.x > 0:
		animated_sprite.play("run_right")
	else:
		animated_sprite.play("run_up")
