class_name BaseCharacter
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var sprite_2d: AnimatedSprite2D
var attacks: Array[BaseAttack] = []


var is_in_action := false

func setup_attacks() -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_attacks()



func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_attack_inputs()


func _handle_movement(delta: float) -> void:
	if not is_in_action:
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
		print("test")
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func _handle_attack_inputs() -> void:
	for i in attacks.size():
		var action = "attack_%d" % (i + 1)
		if Input.is_action_just_pressed(action):
			attacks[i].execute(self)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in attacks.size():
		var action = "attack_%d" % (i +1)
		attacks[i].tick(delta)
	print(Input.get_connected_joypads())
