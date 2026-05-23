class_name ArthuriaDef
extends def_attack

func _init() -> void:
	_damage = 0
	_cooldown = 6
	_channelling = 1

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Artdef"
