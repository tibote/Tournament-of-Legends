class_name AnkouCutscene
extends CanvasLayer

signal cutscene_finished

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func play_cutscene() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	video_player.set_anchors_preset(Control.PRESET_FULL_RECT)
	video_player.size = screen_size
	layer = 10
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	video_player.process_mode = Node.PROCESS_MODE_ALWAYS

	video_player.play()
	await video_player.finished

	video_player.visible = false

	get_tree().paused = false
	cutscene_finished.emit()
	queue_free()
