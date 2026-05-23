extends Node2D

@onready var spawn_point = $SpawnPoint # Un node Marker2D ou Node2D placé dans votre niveau pour positionner le joueur

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
