extends Node2D

@onready var spawn_point = $SpawnPoint 
# Idéalement, rajoute un Marker2D dans ta scène principale nommé "SpawnPointBot" pour ne pas qu'ils apparaissent l'un sur l'autre
@onready var spawn_point_bot = $SpawnPointBot 

const SETTINGS_MENU_GAME = preload("res://scenes/menu/settings_menu_game.tscn")
const BOT_CONTROLLER_SCRIPT = preload("res://bot/bot_controller.gd")

var player_instance: BaseCharacter
var bot_instance: BaseCharacter

func _ready() -> void:
	spawn_game()

func spawn_game() -> void:
	# 1. Déterminer les chemins des scènes des personnages
	var ankou_path = "res://characters/L'Ankou/Ankou.tscn"
	var arthuria_path = "res://characters/arthuria/Arthuria.tscn"
	
	# Par sécurité, si aucun personnage n'est sélectionné, on met l'Ankou par défaut
	if Global.selected_character_path == "":
		Global.selected_character_path = arthuria_path
		
	var player_scene_path = Global.selected_character_path
	var bot_scene_path = ""
	
	# --- LOGIQUE D'INVERSION JOUEUR / ENNEMI ---
	# Si le joueur a choisi l'Ankou, le bot devient Arthuria, et inversement
	if player_scene_path.to_lower().contains("Arthuria"):
		bot_scene_path = arthuria_path
	else:
		bot_scene_path = ankou_path

	# 2. Spawn du Joueur
	var character_scene = load(player_scene_path)
	if character_scene:
		player_instance = character_scene.instantiate() as BaseCharacter
		player_instance.global_position = spawn_point.global_position
		player_instance.is_bot = false # Contrôlé par le joueur
		add_child(player_instance)
	else:
		print("Erreur : Impossible de charger la scène du joueur ! (", player_scene_path, ")")
		return

	# 3. Spawn du Bot adverse
	var bot_scene = load(bot_scene_path)
	if bot_scene:
		bot_instance = bot_scene.instantiate() as BaseCharacter
		if spawn_point_bot:
			bot_instance.global_position = spawn_point_bot.global_position
		else:
			bot_instance.global_position = spawn_point.global_position + Vector2(200, 0)
		
		bot_instance.is_bot = true # Contrôlé par l'IA
		add_child(bot_instance)
		
		# 4. Attacher le BotController au personnage du bot
		var controller_node = Node.new()
		controller_node.name = "BotController"
		controller_node.set_script(BOT_CONTROLLER_SCRIPT)
		bot_instance.add_child(controller_node)
		
		# 5. Définir le joueur comme cible du Bot
		controller_node.target = player_instance
		
	else:
		print("Erreur : Impossible de charger la scène du Bot ! (", bot_scene_path, ")")

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
