class_name Excalibaser
extends Area2D

var speed: float = 700.0
var damage: int = 0          # Assigné par fireball.gd au moment du lancement
var direction: float = 1.0

func _ready() -> void:
	# Connecte les signaux
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func launch(dir: float, dmg: int) -> void:
	direction = dir
	damage = dmg
	# Retourne le sprite si on va à gauche
	$Sprite2D.flip_h = direction < 0

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.take_damage(damage)
	_destroy()

func _on_screen_exited() -> void:
	_destroy()

func _destroy() -> void:
	# Ici tu peux jouer une animation d'explosion avant de détruire
	queue_free()
