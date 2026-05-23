class_name BotController
extends Node

# ── tuneable constants ────────────────────────────────────────────────────────
const CAC_RANGE        := 120.0    # px — distance considérée comme corps à corps
const DANGER_RANGE     := 120.0   # px — distance de danger immédiat
const REACTION_DELAY   := 0.15    # secondes entre chaque décision IA
const AGGRESSION_CD    := 2.0     # secondes avant une attaque CAC agressive hors portée
const DEFEND_DURATION  := 0.6     # secondes max de défense consécutive
const JUMP_HEIGHT_THR  := 100.0    # px — seuil vertical pour sauter vers la cible

# ── actions disponibles ───────────────────────────────────────────────────────
enum Action { WAIT, LONG_ATTACK, CAC_ATTACK, DEFEND, MOVE, JUMP, RETREAT }

# ── état runtime ──────────────────────────────────────────────────────────────
var character: BaseCharacter
var target: BaseCharacter

var _reaction_timer:   float = 0.0
var _aggression_timer: float = 0.0
var _defend_timer:     float = 0.0
var _current_action:   Action = Action.WAIT

func _ready() -> void:
	character = get_parent() as BaseCharacter

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return

	_reaction_timer   -= delta
	_aggression_timer -= delta
	_defend_timer     -= delta

	if _reaction_timer > 0.0:
		return
	_reaction_timer = REACTION_DELAY

	_decide()
	_execute()

# ── arbre de décision ─────────────────────────────────────────────────────────
#
# immediate_danger?
#   YES → enemy_in_range (CAC)?
#           YES → DEFEND (si défense dispo et pas en defend trop longtemps)
#           NO  → JUMP + RETREAT (aléatoire)
#   NO  → enemy_in_range (CAC)?
#           NO  → long_attack_dispo?
#                   YES → LONG_ATTACK
#                   NO  → aggression_timer épuisé?
#                           YES → MOVE vers cible (+ JUMP si cible en hauteur)
#                           NO  → WAIT
#           YES → cac_dispo?
#                   YES → CAC_ATTACK (avec feinte aléatoire 20%)
#                   NO  → long_attack_dispo?
#                           YES → LONG_ATTACK
#                           NO  → MOVE

func _decide() -> void:
	var dist: float = character.global_position.distance_to(target.global_position)

	if _immediate_danger(dist):
		if dist <= CAC_RANGE:
			if _defend_available() and _defend_timer <= 0.0:
				_current_action = Action.DEFEND
				_defend_timer = DEFEND_DURATION
			else:
				_current_action = Action.JUMP
		else:
			_current_action = Action.JUMP if randi() % 2 == 0 else Action.RETREAT
	else:
		if dist > CAC_RANGE:
			if _long_attack_available():
				_current_action = Action.LONG_ATTACK
			elif _aggression_timer <= 0.0:
				if _should_jump_to_reach():
					_current_action = Action.JUMP
				else:
					_current_action = Action.MOVE
			else:
				_current_action = Action.WAIT
		else:
			if _cac_available() and randf() > 0.2:
				_current_action = Action.CAC_ATTACK
				_aggression_timer = AGGRESSION_CD
			elif _long_attack_available():
				_current_action = Action.LONG_ATTACK
			else:
				_current_action = Action.MOVE

# ── exécution ─────────────────────────────────────────────────────────────────
func _execute() -> void:
	if OS.is_debug_build():
		print(_current_action)

	match _current_action:

		Action.LONG_ATTACK:
			_face_target()
			character.wants_attack[1] = true

		Action.CAC_ATTACK:
			_face_target()
			character.wants_attack[0] = true

		Action.DEFEND:
			_face_target()
			character.wants_attack[2] = true
			character.input_direction = 0.0

		Action.MOVE:
			_face_target()
			_move_toward_target()

		Action.RETREAT:
			_move_away_from_target()

		Action.JUMP:
			character.wants_jump = true
			if _immediate_danger(character.global_position.distance_to(target.global_position)):
				_move_away_from_target()
			else:
				# Si on saute pour atteindre la cible, on avance vers elle
				_move_toward_target()

		Action.WAIT:
			_face_target()
			character.input_direction = 0.0

# ── conditions ────────────────────────────────────────────────────────────────

func _immediate_danger(dist: float) -> bool:
	if not target.is_in_action or dist > DANGER_RANGE:
		return false
	var enemy_faces_us: float = sign(character.global_position.x - target.global_position.x)
	var enemy_dir: float = -1.0 if target.sprite_2d.flip_h else 1.0
	return enemy_faces_us == enemy_dir

func _long_attack_available() -> bool:
	if character.attacks.size() <= 1:
		return false
	return character.attacks[1]._decaying_cd <= 0.0

func _cac_available() -> bool:
	if character.attacks.size() == 0:
		return false
	return character.attacks[0]._decaying_cd <= 0.0

func _defend_available() -> bool:
	return character.attacks.size() >= 3

func _should_jump_to_reach() -> bool:
	return target.global_position.y < character.global_position.y - JUMP_HEIGHT_THR

# ── déplacements ──────────────────────────────────────────────────────────────

func _face_target() -> void:
	var dir: float = sign(target.global_position.x - character.global_position.x)
	if dir != 0.0:
		character.sprite_2d.flip_h = dir < 0.0

func _move_toward_target() -> void:
	var dir: float = sign(target.global_position.x - character.global_position.x)
	character.input_direction = dir

func _move_away_from_target() -> void:
	var dir: float = sign(character.global_position.x - target.global_position.x)
	character.input_direction = dir
