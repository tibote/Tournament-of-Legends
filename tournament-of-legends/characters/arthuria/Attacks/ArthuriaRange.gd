class_name ArthuriaRange
extends range_attack

func _init() -> void:
	_damage = 70000
	_cooldown = 3
	_channelling = 0
	projectile_speed = 400
	projectile_scene = preload("res://Attack/projectiles/Excalibaser.tscn")


func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.animation = "Artrange"
	var projectile = projectile_scene.instantiate()
	character.get_tree().current_scene.add_child(projectile)
	projectile.global_position = character.global_position
	var direction: float = -1.0 if character.sprite_2d.flip_h else 1.0
	projectile.launch(direction, _damage)
	
