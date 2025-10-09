extends CharacterBody2D

@export var speed = 300.0
@onready var animated_sprite = $AnimatedSprite2D
# O player_collider não é usado na lógica de vitória/derrota.
# @onready var player_collider = $CollisionShape2D

# Referências CORRIGIDAS para os nós Area2D.
# O caminho '..' sobe para o nó pai (Main) e desce para o nó correto.
@onready var win_area = get_node("../limitesdacamera/vitoria")
@onready var lose_area = get_node("../limitesdacamera/derrota")

var game_ended = false # Variável para garantir que o jogo termine apenas uma vez

func _ready():
	# Conecta o sinal 'body_entered' dos Area2D.
	# O erro de 'null instance' deve ter sumido com a correção do caminho acima.
	win_area.body_entered.connect(_on_win_area_body_entered)
	lose_area.body_entered.connect(_on_lose_area_body_entered)

func _physics_process(delta):
	# Se o jogo já terminou, não faz mais nada
	if game_ended:
		return

	# --- Seu código de movimento (sem alterações) ---
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal_direction * speed
	velocity.y = -40
	update_animation()
	move_and_slide()
	# ----------------------------------------------

	# A colisão agora é feita por sinais.

func _on_lose_area_body_entered(body: Node2D):
	# Verifica se o corpo que entrou é o Player (o próprio script)
	# e se o jogo ainda não terminou.
	if body == self and not game_ended:
		print("Colidiu com a zona de derrota!")
		game_ended = true
		get_parent().game_over(false) # Chama a função no Main, avisando que perdeu

func _on_win_area_body_entered(body: Node2D):
	# Verifica se o corpo que entrou é o Player (o próprio script)
	# e se o jogo ainda não terminou.
	if body == self and not game_ended:
		print("Colidiu com a zona de vitória!")
		game_ended = true
		get_parent().game_over(true) # Chama a função no Main, avisando que venceu

func update_animation():
	if velocity.x < 0:
		animated_sprite.play("run_left")
	elif velocity.x > 0:
		animated_sprite.play("run_right")
	else:
		animated_sprite.play("run_up")
