class_name AnkouMelee
extends melee_attack

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	_damage = 200000
	_cooldown = 0.7
	_channelling = 0.4

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Ankoumelee"
	var direction = -1 if character.sprite_2d.flip_h else 1
	character.melee_hit(_damage)
