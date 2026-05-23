extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Perso_1/Btn_select_arthuria.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_select_arthuria_pressed() -> void:
	Global.selected_character_path = Global.CHARACTERS["arthuria"]
	_start_game()


func _on_btn_select_ankou_pressed() -> void:
	Global.selected_character_path = Global.CHARACTERS["ankou"]
	_start_game()
	
func _start_game() -> void:
	if Global.selected_character_path != "":
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A and event.pressed:
			if get_viewport().gui_get_focus_owner() == $HBoxContainer/Perso_1/Btn_select_ankou:
				Global.selected_character_path = Global.CHARACTERS["ankou"]
				_start_game()
			if get_viewport().gui_get_focus_owner() == $HBoxContainer/Perso_1/Btn_select_arthuria:
				Global.selected_character_path = Global.CHARACTERS["arthuria"]
				_start_game()
