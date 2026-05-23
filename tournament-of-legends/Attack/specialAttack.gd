class_name special_attack
extends BaseAttack

func _perform(charcater: BaseCharacter) -> void:
	if charcater.jauge_spe < 1000:
		return
