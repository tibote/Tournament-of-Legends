class_name BaseCharacter
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var sprite_2d: AnimatedSprite2D
var attacks: Array[BaseAttack] = []
var hp: int
var lvl_multiplicator: float = 1
var defense_multiplicator: float = 1
var jauge_spe: int = 500
var is_in_action := false

var input_direction: float = 0.0
var wants_jump: bool = false
var wants_attack: Array[bool] = [false, false, false, false]
var is_bot: bool = false

signal hp_changed(new_hp: int)

func setup_attacks() -> void:
	pass

func _ready() -> void:
	add_to_group("player")
	setup_attacks()

@onready var hitbox: Area2D = $HitboxArea

func _physics_process(delta: float) -> void:
	_update_action_state()
	
	if not is_bot:
		input_direction = Input.get_axis("ui_left", "ui_right")
		wants_jump = Input.is_action_just_pressed("jump")
		for i in attacks.size():
			var action = "attack_%d" % (i + 1)
			wants_attack[i] = Input.is_action_just_pressed(action)

	_handle_attack_inputs()
	_handle_movement(delta)

	wants_jump = false
	for i in wants_attack.size():
		wants_attack[i] = false

func _handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_in_action:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	if not is_on_floor():
		sprite_2d.animation = "jump"
	elif abs(velocity.x) > 1:
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"

	if wants_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if input_direction != 0:
		velocity.x = input_direction * SPEED
		
		sprite_2d.flip_h = (input_direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func charge_gauge(amount: int) -> void:
	jauge_spe = min(jauge_spe + amount, 1000)

func decharge_gauge(amount: int) -> void:
	jauge_spe = max(jauge_spe - amount, 0)

func _handle_attack_inputs() -> void:
	for i in attacks.size():
		if wants_attack[i]:
			attacks[i].execute(self)

func melee_hit(dmg: int) -> void:
	# Chercher directement les corps proches plutôt que la hitbox
	var space = get_world_2d().direct_space_state
	var shape_query = PhysicsShapeQueryParameters2D.new()
	shape_query.shape = hitbox.get_child(0).shape  # la CollisionShape
	
	# Orienter la hitbox selon la direction du sprite
	var direction = -1.0 if sprite_2d.flip_h else 1.0
	shape_query.transform = Transform2D(0, global_position + Vector2(direction * 50, 0))
	shape_query.collision_mask = 1
	
	var results = space.intersect_shape(shape_query)
	for result in results:
		var body = result["collider"]
		if body == self:
			continue
		if body is BaseCharacter:
			body.take_damage(dmg)
			charge_gauge(50)
			body.decharge_gauge(50)

func take_damage(dmg: int) -> void:
	hp -= dmg * defense_multiplicator
	hp_changed.emit(hp)
	if hp <= 0:
		hp = 0
		_die()

func _heal(heal: int) -> void:
	hp += heal

var is_dying := false	

func _die() -> void:
	is_dying = true
	is_in_action = true
	sprite_2d.play("death")
	await sprite_2d.animation_finished
	queue_free()

func _process(delta: float) -> void:
	for i in attacks.size():
		attacks[i].tick(delta)

func _update_action_state() -> void:
	if not is_in_action or is_dying:
		return
	var still_channelling = attacks.any(func(a): return a._decaying_channelling > 0)
	if not still_channelling:
		sprite_2d.play("idle") 
	is_in_action = still_channelling
