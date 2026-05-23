class_name SpecialCutscene
extends CanvasLayer

signal cutscene_finished

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var explosion: AnimatedSprite2D = $Explosion

func play_cutscene() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	video_player.set_anchors_preset(Control.PRESET_FULL_RECT)
	video_player.size = screen_size
	layer = 10
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	video_player.process_mode = Node.PROCESS_MODE_ALWAYS
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS

	explosion.visible = false
	explosion.position = screen_size / 2  # Centre de l'écran

	video_player.play()
	await video_player.finished

	video_player.visible = false
	explosion.visible = true
	explosion.play("Explosion")

	await explosion.animation_finished

	get_tree().paused = false
	cutscene_finished.emit()
	queue_free()
