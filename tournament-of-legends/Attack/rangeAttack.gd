class_name range_attack
extends BaseAttack

var projectile_speed: float = 600.0
var projectile_scene: PackedScene

func _perform(character: BaseCharacter) -> void:
	var projectile = projectile_scene.instantiate()
	character.get_parent().add_child(projectile)
	projectile.global_position = character.global_position
