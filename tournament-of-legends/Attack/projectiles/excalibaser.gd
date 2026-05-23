class_name Excalibaser
extends Area2D

var speed: float = 700.0
var damage: int = 0          # Assigné par fireball.gd au moment du lancement
var direction: float = 1.0
var _destroyed := false

@onready var fire_boll_sound: AudioStreamPlayer = $FireBollSound

func _ready() -> void:
	# Connecte les signaux
	body_entered.connect(_on_body_entered)
	await get_tree().process_frame
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func launch(dir: float, dmg: int) -> void:
	print("Launch appelé, direction : ", dir)
	direction = dir
	damage = dmg
	$BouleFeu.flip_h = direction < 0
	fire_boll_sound.play()

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.take_damage(damage)

func _on_screen_exited() -> void:
	_destroy()

func _destroy() -> void:
	if _destroyed:
		return
	_destroyed = true
	
	set_physics_process(false)
	if body_entered.is_connected(_on_body_entered):
		body_entered.disconnect(_on_body_entered)
	
	$BouleFeu.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	await fire_boll_sound.finished
	queue_free()
