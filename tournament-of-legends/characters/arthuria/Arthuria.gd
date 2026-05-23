class_name Arthuria
extends BaseCharacter

func _ready() -> void:
	sprite_2d = $Sprite2D
	super._ready() 

func setup_attacks() -> void:
	attacks = [
		ArthuriaMelee.new(),
		ArthuriaRange.new(),
		ArthuriaDef.new(),
		ArthuriaSpe.new()
		
	]
