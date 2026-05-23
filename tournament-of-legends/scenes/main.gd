extends Node2D

@onready var spawn_point = $SpawnPoint # Un node Marker2D ou Node2D placé dans votre niveau pour positionner le joueur

const SETTINGS_MENU_GAME = preload("res://scenes/menu/settings_menu_game.tscn")

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	if Global.selected_character_path == "":
		Global.selected_character_path = "res://characters/L'Ankou/Ankou.tscn"
	var character_scene = load(Global.selected_character_path)
	
	if character_scene:
		var player_instance = character_scene.instantiate()
		player_instance.global_position = spawn_point.global_position
		player_instance.tree_exiting.connect(_on_player_died)
		add_child(player_instance)
	else:
		print("Erreur : Impossible de charger la scène du personnage !")

func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		open_pause_menu()

func open_pause_menu() -> void:
	if get_node_or_null("PauseLayer") != null:
		return

	var canvas = CanvasLayer.new()
	canvas.name = "PauseLayer"
	canvas.layer = 10
	add_child(canvas)

	var menu = SETTINGS_MENU_GAME.instantiate()
	canvas.add_child(menu)

	get_tree().paused = true
	get_viewport().set_input_as_handled()
