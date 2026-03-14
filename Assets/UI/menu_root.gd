@tool
extends Control
class_name PlayerMenuUI

@export var start_focus: Control:
	set(value):
		start_focus = value
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	if not start_focus:
		return ["Defina um Control para ser focado"]
	else:
		return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	visible = false

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return

	if event.is_action_pressed("menu"):
		if Manager.is_state(Game.States.MAP):
			open_menu()
			
		if Manager.is_state(Game.States.MENU):
			close_menu()

func open_menu() -> void:
	visible = true
	GlobalEvents.set_state.emit(Game.States.MENU)

	if start_focus:
		start_focus.focus_mode = Control.FOCUS_ALL
		await get_tree().process_frame
		start_focus.grab_focus()

func close_menu() -> void:
	visible = false
	GlobalEvents.set_state.emit(Game.States.MAP)
	GlobalEvents.save_game.emit()
