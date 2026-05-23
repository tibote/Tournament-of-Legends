class_name SpecialCutscene
extends CanvasLayer

signal cutscene_finished

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var epic_music: AudioStreamPlayer = $EpicMusic

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
	explosion.position = screen_size / 2

	video_player.play()
	epic_music.play()
	Input.start_joy_vibration(0, 0.3, 0.3, 999.0)
	await video_player.finished

	video_player.visible = false
	explosion.visible = true
	explosion.play("Explosion")
	epic_music.stop()
	explosion_sound.play()
	
	Input.start_joy_vibration(0, 1.0, 1.0, 999.0)

	await explosion.animation_finished

	Input.start_joy_vibration(0, 0.4, 0.4, 1.5)
	get_tree().paused = false
	Input.stop_joy_vibration(0)
	cutscene_finished.emit()
	queue_free()
