class_name AnkouMelee
extends melee_attack

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	_damage = 60000
	_cooldown = 0.5
	_channelling = 0

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Ankoumelee"
