extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Btn_play.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_quit_pressed() -> void:
	get_tree().quit()


func _on_btn_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_btn_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/settings_menu.tscn")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		get_viewport().gui_release_focus()

	if event is InputEventJoypadButton or event is InputEventJoypadMotion or event is InputEventKey:
		if get_viewport().gui_get_focus_owner() == null:
			$VBoxContainer/Btn_play.grab_focus()

	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A and event.pressed:
			if get_viewport().gui_get_focus_owner() == $VBoxContainer/Btn_play:
				get_tree().change_scene_to_file("res://scenes/main.tscn")
			elif get_viewport().gui_get_focus_owner() == $VBoxContainer/Btn_settings:
				get_tree().change_scene_to_file("res://scenes/menu/settings_menu.tscn")
			elif get_viewport().gui_get_focus_owner() == $VBoxContainer/Btn_quit:
				get_tree().quit()
