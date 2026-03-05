@tool
extends Control
class_name Menu

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
	visible = Global.manager.is_state(Game.States.MENU)

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	visible = Global.manager.is_state(Game.States.MENU)
	
	if event.is_action_pressed("menu"):
		if Global.manager.is_state(Game.States.MAP):
			open_menu()
			
		if Global.manager.is_state(Game.States.MENU):
			close_menu()

func open_menu() -> void:
	Global.manager.set_state(Game.States.MENU)
	await get_tree().process_frame
	if start_focus:
		start_focus.grab_focus.call_deferred()

func close_menu() -> void:
	Global.manager.set_state(Game.States.MAP)
	Global.manager.Save()
