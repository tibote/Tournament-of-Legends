extends Node2D

@onready var spawn_point = $SpawnPoint # Un node Marker2D ou Node2D placé dans votre niveau pour positionner le joueur

const SETTINGS_MENU_GAME = preload("res://scenes/menu/settings_menu_game.tscn")

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	# 1. Vérifier si un personnage a bien été sélectionné
	if Global.selected_character_path == "":
		# Personnage par défaut au cas où (sécurité)
		Global.selected_character_path = "res://characters/L'Ankou/Ankou.tscn"
	
	# 2. Charger la scène du personnage
	var character_scene = load(Global.selected_character_path)
	
	if character_scene:
		# 3. Créer l'instance du personnage
		var player_instance = character_scene.instantiate()
		
		# 4. Positionner le personnage au point de spawn
		player_instance.global_position = spawn_point.global_position
		
		# 5. L'ajouter à la scène pour qu'il apparaisse et s'active
		add_child(player_instance)
	else:
		print("Erreur : Impossible de charger la scène du personnage !")

func _input(event: InputEvent) -> void:
	# Remplace "ui_cancel" par ton action personnalisée (ex: "pause") si tu en as une dans l'Input Map
	# Par défaut, "ui_cancel" correspond à la touche Échap et au bouton Retour/Start
	if event.is_action_pressed("ui_cancel"):
		open_pause_menu()

func open_pause_menu() -> void:
	if get_node_or_null("PauseLayer") != null:
		return

	# Créer un CanvasLayer pour que le menu s'affiche par-dessus le jeu
	var canvas = CanvasLayer.new()
	canvas.name = "PauseLayer"
	canvas.layer = 10
	add_child(canvas)

	var menu = SETTINGS_MENU_GAME.instantiate()
	canvas.add_child(menu)  # ← dans le CanvasLayer, pas dans le Node2D

	get_tree().paused = true
