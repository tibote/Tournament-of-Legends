class_name AnkouDef
extends def_attack

const SHIELD_SCENE = preload("res://Attack/projectiles/AnkouShield.tscn")

func _init() -> void:
	_damage = 0
	_cooldown = 4
	_channelling = 0.2

func _perform(character: BaseCharacter) -> void:
	character.sprite_2d.play("Ankoudef")
	_spawn_shield(character)

func _spawn_shield(character: BaseCharacter) -> void:
	var shield = SHIELD_SCENE.instantiate()
	character.get_tree().current_scene.add_child(shield)
	var direction: float = -1.0 if character.sprite_2d.flip_h else 1.0
	shield.global_position = character.global_position + Vector2(direction * 40, 0)
	shield.launch(direction)
