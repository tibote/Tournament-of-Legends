class_name AnkouDef
extends def_attack

func _init() -> void:
	_damage = 0
	_cooldown = 7
	_channelling = 0.2

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Ankoudef"
