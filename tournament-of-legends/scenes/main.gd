extends Node2D

@onready var spawn_point = $SpawnPoint 
# Idéalement, rajoute un Marker2D dans ta scène principale nommé "SpawnPointBot" pour ne pas qu'ils apparaissent l'un sur l'autre
@onready var spawn_point_bot = $SpawnPointBot 

# --- CORRECTION 1 : On déclare et récupère le nœud du HUD ---
# Remplace "Hud" par le nom exact de ton instance de HUD dans ta scène principale
@onready var hud = $Hud 

const SETTINGS_MENU_GAME = preload("res://scenes/menu/settings_menu_game.tscn")
const BOT_CONTROLLER_SCRIPT = preload("res://bot/bot_controller.gd")

var player_instance: BaseCharacter
var bot_instance: BaseCharacter

func _ready() -> void:
	spawn_game()
	
	# --- CORRECTION 2 : On utilise les bonnes instances après le spawn ---
	if player_instance and hud:
		player_instance.hp_changed.connect(hud.update_player1_hp)
	if bot_instance and hud:
		bot_instance.hp_changed.connect(hud.update_player2_hp)

func spawn_game() -> void:
	# 1. Déterminer les chemins des scènes des personnages
	var ankou_path = "res://characters/L'Ankou/Ankou.tscn"
	var arthuria_path = "res://characters/arthuria/Arthuria.tscn"
	
	# Par sécurité, si aucun personnage n'est sélectionné, on met Arthuria par défaut
	if Global.selected_character_path == "":
		Global.selected_character_path = arthuria_path
		
	var player_scene_path = Global.selected_character_path
	var bot_scene_path = ""
	
	# --- LOGIQUE D'INVERSION JOUEUR / ENNEMI ---
	if player_scene_path.to_lower().contains("arthuria"):
		bot_scene_path = ankou_path
	else:
		bot_scene_path = arthuria_path

	# 2. Spawn du Joueur
	var character_scene = load(player_scene_path)
	if character_scene:
		player_instance = character_scene.instantiate() as BaseCharacter
		player_instance.global_position = spawn_point.global_position
		player_instance.is_bot = false # Contrôlé par le joueur
		player_instance.tree_exiting.connect(_on_player_died)
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
	
	var hud = $CanvasLayer/Hud as Control
	if hud and hud.has_method("setup_characters"):
		hud.setup_characters(player_instance, bot_instance)

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
