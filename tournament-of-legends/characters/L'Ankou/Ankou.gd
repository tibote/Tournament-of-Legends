class_name Ankou
extends BaseCharacter




func _ready() -> void:
	sprite_2d = $Sprite2D
	super._ready() 

func setup_attacks() -> void:
	attacks = [
		AnkouMelee.new(),
		AnkouRange.new(),
		AnkouDef.new(),
		AnkouSpe.new()
		
	]
