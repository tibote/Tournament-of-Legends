class_name ArthuriaSpe
extends special_attack

func _init() -> void:
	_damage = 300000
	
func _perform(charcater: BaseCharacter) -> void:
	charcater.sprite_2d.animation = "Artspe"
