class_name ArthuriaDef
extends def_attack

func _init() -> void:
	_damage = 0
	_cooldown = 6
	_channelling = 1

func _perform(character: BaseCharacter) -> void:
	character.defense_multiplicator = 0
	character.sprite_2d.animation = "Artdef"
	await character.get_tree().create_timer(_channelling).timeout
	character.defense_multiplicator = 1
	character.sprite_2d.animation = "idle"
