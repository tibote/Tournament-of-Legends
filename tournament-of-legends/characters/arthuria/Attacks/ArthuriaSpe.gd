class_name ArthuriaSpe
extends special_attack

func _init() -> void:
	_damage = 300000
	_cooldown = 10.0
	_channelling = 1.5 
	
func _perform(charcater: BaseCharacter) -> void:
	charcater.sprite_2d.play("Artspe")
