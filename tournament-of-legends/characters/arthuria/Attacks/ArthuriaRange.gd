class_name ArthuriaRange
extends range_attack

func _init() -> void:
	_damage = 70000
	_cooldown = 3
	_channelling = 0

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Artrange"
