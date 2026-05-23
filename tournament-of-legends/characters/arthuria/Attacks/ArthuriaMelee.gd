class_name ArthuriaMelee
extends melee_attack

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	_damage = 50000
	_cooldown = 0.3
	_channelling = 0

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Artmelee"
	var direction = -1 if character.sprite_2d.flip_h else 1
	character.melee_hit(_damage)
	
