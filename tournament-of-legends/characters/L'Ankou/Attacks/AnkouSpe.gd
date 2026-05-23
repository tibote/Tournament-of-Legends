class_name AnkouSpe
extends special_attack

const CUTSCENE_SCENE = preload("res://characters/L'Ankou/AnkouCutscene.tscn")

func _init() -> void:
	_damage = 3000000000
	_cooldown = 10.0
	_channelling = 1.5

func _perform(character: BaseCharacter) -> void:
	super(character)
	if character.jauge_spe < 1000:
		return

	character.jauge_spe = 0
	character.sprite_2d.play("Ankouspe")
	_launch_cutscene(character)

func _launch_cutscene(character: BaseCharacter) -> void:
	var cutscene = CUTSCENE_SCENE.instantiate()
	character.get_tree().current_scene.add_child(cutscene)
	cutscene.play_cutscene()
	await cutscene.cutscene_finished
	_deal_damage(character)

func _deal_damage(character: BaseCharacter) -> void:
	for body in character.get_tree().get_nodes_in_group("player"):
		if body == character:
			continue
		if body is BaseCharacter:
			body.take_damage(_damage)
