class_name AnkouRange
extends range_attack

func _init() -> void:
	_damage = 120000
	_cooldown = 10
	_channelling = 0

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Ankourange"
