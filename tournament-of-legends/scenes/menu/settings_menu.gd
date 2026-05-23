extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Window_settings/btn/Btn_window_settings_fullscreen.grab_focus()
	$VBoxContainer/Vibration/CheckButton.set_pressed_no_signal(Global.vibration_enable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_B and event.pressed:
			get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
		if event.button_index == JOY_BUTTON_A and event.pressed:
			if get_viewport().gui_get_focus_owner() == $VBoxContainer/Window_settings/btn/Btn_window_settings_fullscreen:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			elif get_viewport().gui_get_focus_owner() == $VBoxContainer/Window_settings/btn/Btn_window_settings_windowed:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			elif get_viewport().gui_get_focus_owner() == $VBoxContainer/Vibration/CheckButton:
				Global.vibration_enable = !Global.vibration_enable
				$VBoxContainer/Vibration/CheckButton.set_pressed_no_signal(Global.vibration_enable)
				if Global.vibration_enable:
					Input.start_joy_vibration(0, 0.5, 1.0, 0.3)


func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_btn_window_settings_fullscreen_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_btn_window_settings_windowed_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(Vector2i(1152, 648))


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.vibration_enable = toggled_on
	if Global.vibration_enable:
		Input.start_joy_vibration(0, 0.5, 1.0, 0.3)
