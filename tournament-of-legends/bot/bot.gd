class_name BaseBot
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var sprite_2d: AnimatedSprite2D
var attacks: Array[BaseAttack] = []

var is_in_action := false

func setup_attacks() -> void:
	pass

func _ready() -> void:
	setup_attacks()

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_attack_inputs()

func _handle_movement(delta: float) -> void:
	# Animation
	if not is_in_action:
		if not is_on_floor():
			sprite_2d.animation = "jump"
		elif absf(velocity.x) > 1.0:
			sprite_2d.animation = "run"
		else:
			sprite_2d.animation = "idle"

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	move_and_slide()

	# Flip sprite to face movement direction
	if absf(velocity.x) > 1.0:
		sprite_2d.flip_h = velocity.x < 0

func _handle_attack_inputs() -> void:
	for i in attacks.size():
		var action := "attack_%d" % (i + 1)
		if Input.is_action_just_pressed(action):
			attacks[i].execute(self)

func _process(delta: float) -> void:
	for attack in attacks:
		attack.tick(delta)

func jump() -> void:
	velocity.y = JUMP_VELOCITY
