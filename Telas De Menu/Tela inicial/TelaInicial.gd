extends Node

@onready var name_label = $jogador
@onready var level_label = $level

func _ready():
	var current_player_name = PlayerData.player_name
	
	if not current_player_name.is_empty():
		name_label.text = current_player_name
	else:
		name_label.text = "Jogador"
		
	var current_player_level = PlayerData.player_level
	level_label.text = "Lv. " + str(current_player_level)

	# Deixa o aviso invisível no início
	$funcionalidadeinexistente.visible = false
	$funcionalidadeinexistente2.visible = false
	$levelinexistente.visible = false # <-- ADICIONADO (para garantir que comece escondido)
	$ColorRect.visible = false        # <-- ADICIONADO


func _on_button_pressed() -> void:
	# Mostra o aviso
	$funcionalidadeinexistente.visible = true
	$funcionalidadeinexistente2.visible = true
	$ColorRect.visible = true # <-- ADICIONADO


func _on_button_2_pressed() -> void:
	call_deferred("_trocar_de_tela")


func _trocar_de_tela():
	var level = PlayerData.player_level
	var path = "res://Jogo/Os Reinos Perdidos/Level %d/História Pré Jogo/Tela 1/Tela.tscn" % level
	
	print("Tentando carregar cena do Level " + str(level) + ": " + path)
	
	if ResourceLoader.exists(path):
		var error = get_tree().change_scene_to_file(path)
		if error != OK:
			printerr("ERRO: Não foi possível carregar a cena: ", path)
	else:
		printerr("CENA NÃO ENCONTRADA! Caminho inválido: ", path)
		# Mostra o aviso de funcionalidade inexistente
		$levelinexistente.visible = true
		$funcionalidadeinexistente2.visible = true
		$ColorRect.visible = true # <-- ADICIONADO


func _on_funcionalidadeinexistente_2_pressed() -> void:
	print(">>> O BOTÃO 2 DE AVISO FOI PRESSIONADO! <<<") 
	
	# Esconde o aviso novamente
	$funcionalidadeinexistente.visible = false
	$funcionalidadeinexistente2.visible = false
	$levelinexistente.visible = false
	$ColorRect.visible = false # <-- ADICIONADO
