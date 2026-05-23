extends Control

const CHARACTERS = {
	"Arthuria": {
		"avatar": preload("res://assets/arthuria/Arthuria.png"),
		"name": "Arthuria"
	},
	"Ankou": {
		"avatar": preload("res://assets/l'Ankou/Ankou.png"),
		"name": "Ankou"
	}
}

var player: BaseCharacter
var bot: BaseCharacter

func _ready():
	# Setup visuel (nom + avatar) comme avant
	_setup_visuals(Global.player1_character, Global.player2_character)

func _setup_visuals(p1_name: String, p2_name: String) -> void:
	if CHARACTERS.has(p1_name):
		var data = CHARACTERS[p1_name]
		$HBoxContainer/TextureRect.texture = data["avatar"]
		$HBoxContainer/VBoxContainer/Label.text = data["name"]

	if CHARACTERS.has(p2_name):
		var data = CHARACTERS[p2_name]
		$HBoxContainer/TextureRect2.texture = data["avatar"]
		$HBoxContainer/VBoxContainer2/Label.text = data["name"]

func setup_characters(p: BaseCharacter, b: BaseCharacter) -> void:
	player = p
	bot = b
	$HBoxContainer/VBoxContainer/ProgressBar.max_value = p.hp
	$HBoxContainer/VBoxContainer2/ProgressBar.max_value = b.hp
	$HBoxContainer/VBoxContainer/ProgressBar.value = p.hp
	$HBoxContainer/VBoxContainer2/ProgressBar.value = b.hp
	$HBoxContainer/VBoxContainer/GaugeBar.max_value = 1000
	$HBoxContainer/VBoxContainer2/GaugeBar.max_value = 1000
	$HBoxContainer/VBoxContainer/GaugeBar.value = 0
	$HBoxContainer/VBoxContainer2/GaugeBar.value = 0

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		$HBoxContainer/VBoxContainer/ProgressBar.value = player.hp
		$HBoxContainer/VBoxContainer/GaugeBar.value = player.jauge_spe
	if is_instance_valid(bot):
		$HBoxContainer/VBoxContainer2/ProgressBar.value = bot.hp
		$HBoxContainer/VBoxContainer2/GaugeBar.value = bot.jauge_spe 
