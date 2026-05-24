class_name Crawstorm
extends Area2D

var speed: float = 500.0
var damage: int = 150000
var direction: float = 1.0

func _ready() -> void:
	# Connecte les signaux
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func launch(dir: float, dmg: int) -> void:
	direction = dir
	damage = dmg
	# Retourne le sprite si on va à gauche
	$crawstorm.flip_h = direction < 0

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.take_damage(damage)

func _on_screen_exited() -> void:
	_destroy()

func _destroy() -> void:
	# Ici tu peux jouer une animation d'explosion avant de détruire
	queue_free()
