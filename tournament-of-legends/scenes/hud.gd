extends Control

# Dictionnaire des personnages
const CHARACTERS = {
	"Arthuria": {
		"avatar": preload("res://assets/arthuria/Arthuria.png"),
		"max_hp": 1000000,
		"name": "Arthuria"
	},
	"Ankou": {
		"avatar": preload("res://assets/Ninja Frog/Jump (32x32).png"),
		"max_hp": 800000,
		"name": "Ankou"
	}
}

func _ready():
	setup_player1(Global.player1_character)
	setup_player2(Global.player2_character)

func setup_player1(character_name: String):
	if not CHARACTERS.has(character_name): return
	var data = CHARACTERS[character_name]
	
	# Récupération via les chemins réels de ta scène actuelle
	$HBoxContainer/TextureRect.texture = data["avatar"]
	$HBoxContainer/VBoxContainer/Label.text = data["name"]
	$HBoxContainer/VBoxContainer/ProgressBar.max_value = data["max_hp"]
	$HBoxContainer/VBoxContainer/ProgressBar.value = data["max_hp"]
	# Note: Tu n'as pas de HPLabel (ex: "500 / 500") dans ton .tscn actuel, 
	# donc on ne l'assigne pas pour éviter un crash.

func setup_player2(character_name: String):
	if not CHARACTERS.has(character_name): return
	var data = CHARACTERS[character_name]
	
	# Récupération pour le joueur 2
	$HBoxContainer/TextureRect2.texture = data["avatar"]
	$HBoxContainer/VBoxContainer2/Label.text = data["name"]
	$HBoxContainer/VBoxContainer2/ProgressBar.max_value = data["max_hp"]
	$HBoxContainer/VBoxContainer2/ProgressBar.value = data["max_hp"]
