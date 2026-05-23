extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Perso_1/Btn_select_arthuria.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_select_arthuria_pressed() -> void:
	Global.selected_character_path = Global.CHARACTERS["arthuria"]
	Global.player1_character = "Arthuria"
	Global.player2_character = "Ankou"
	_start_game()


func _on_btn_select_ankou_pressed() -> void:
	Global.selected_character_path = Global.CHARACTERS["ankou"]
	Global.player1_character = "Ankou"
	Global.player2_character = "Arthuria"
	_start_game()
	
func _start_game() -> void:
	if Global.selected_character_path != "":
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _input(event: InputEvent) -> void:
	if not event is InputEventJoypadButton or not event.pressed:
		return
	if event.button_index != JOY_BUTTON_A:
		return
	
	var viewport = get_viewport()
	if viewport == null:
		return
		
	var focused = viewport.gui_get_focus_owner()
	if focused == null:
		return
	
	if focused == $HBoxContainer/Perso_2/Btn_select_ankou:
		Global.selected_character_path = Global.CHARACTERS["ankou"]
		Global.player1_character = "Ankou"
		Global.player2_character = "Arthuria"
		_start_game()
	elif focused == $HBoxContainer/Perso_1/Btn_select_arthuria:
		Global.selected_character_path = Global.CHARACTERS["arthuria"]
		Global.player1_character = "Arthuria"
		Global.player2_character = "Ankou"
		_start_game()
