extends CanvasLayer

signal loading_screen_ready

@export var animation: AnimationPlayer

func _ready() -> void:
	await animation.animation_finished
	loading_screen_ready.emit()
	
func _on_progress_changed(_new_value: float) -> void:
	pass

func _on_load_finished() -> void:
	animation.play_backwards("transition")
	await animation.animation_finished
	queue_free()
