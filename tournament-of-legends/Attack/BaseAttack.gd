class_name BaseAttack
extends Resource

var _damage: int = 0
var _cooldown: float = 0
var _decaying_cd: float = 0
var _channelling: float = 0

	
func execute(character: BaseCharacter) -> void:
	if _decaying_cd > 0:
		return
	_decaying_cd = _cooldown
	_perform(character)

func _perform(charcater: BaseCharacter) -> void:
	pass
func tick(delta: float) -> void:
	_decaying_cd = max(0, _decaying_cd - delta)

# Called when the node enters the scene tree for the first time.
