class_name ArthuriaDef
extends def_attack

func _init() -> void:
	_damage = 0
	_cooldown = 6
	_channelling = 1

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Artdef"
	character.defense_multiplicator = 0
	await character.get_tree().create_timer(_channelling).timeout
	if is_instance_valid(character):
		character.defense_multiplicator = 1
