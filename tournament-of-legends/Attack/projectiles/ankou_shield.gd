class_name AnkouShield
extends CharacterBody2D

var direction: float = 1.0
var speed: float = 150.0
var duration: float = 3.0

func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	get_tree().create_timer(duration).timeout.connect(queue_free)

func launch(dir: float) -> void:
	direction = dir
	$AnimatedSprite2D.flip_h = direction < 0
	$AnimatedSprite2D.play("walk")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = direction * speed
	move_and_slide()

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	queue_free()
