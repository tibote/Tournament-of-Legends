extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var is_attacking := false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready():
	sprite_2d.animation_finished.connect(_on_attack_finished)

func _physics_process(delta: float) -> void:
	
	if not is_attacking:
		if not is_on_floor():
			sprite_2d.animation = "jump"
		elif (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "run"
		else:
			sprite_2d.animation = "idle"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("simple_attack_button") and not is_attacking:
		is_attacking = true
		sprite_2d.play("simple_attack")
	
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func _on_attack_finished():
	is_attacking = false
