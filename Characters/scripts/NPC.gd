extends AnimatableBody2D
class_name CharacterNPC

const ANGULOS: Dictionary[Vector2, StringName] = {
	Vector2(0, 1): "_Down",
	Vector2(0, -1): "_Up",
	Vector2(1, 1): "_Down_Right",
	Vector2(-1, 1): "_Down_Left",
	Vector2(1, -1): "_Up_Right",
	Vector2(-1, -1): "_Up_Left",
	Vector2(1, 0): "_Right",
	Vector2(-1, 0): "_Left" }
const ANGULOS_VECTOR2: Dictionary[StringName, Vector2] = {
		"_Down": Vector2(0, 1),
		"_Up": Vector2(0, -1),
		"_Down_Right": Vector2(1, 1),
		"_Down_Left": Vector2(-1, 1),
		"_Up_Right": Vector2(1, -1),
		"_Up_Left": Vector2(-1, -1),
		"_Right": Vector2(1, 0),
		"_Left": Vector2(-1, 0) }
const SPEED: float = 70.0

var direction: Vector2 = Vector2.ZERO
var last_facing: StringName = "_Down"
var run: float = 1.0
var velocity: Vector2 = Vector2.ZERO

@export var dialogue: DialogueResource
@export_group("Nodes")
@export var animation: AnimationPlayer

func open_dialogue(vertor: StringName) -> void:
	if not dialogue:
		return
	
	animation.play("Idle" + (ANGULOS[ANGULOS_VECTOR2[vertor] * -1]))
	Global.call_manager("set_state", Game.States.DIALOGUE)
	DialogueManager.show_dialogue_balloon_scene(load("res://Cenas/DialogueBalloon.tscn"), dialogue)

#func _physics_process(delta: float) -> void:
	#velocity = direction.normalized() * SPEED * delta
	#
	#_update_animation(direction)
	#move_and_collide(velocity)

func _update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO and ANGULOS.has(dir):
		last_facing = ANGULOS[dir]

	if velocity == Vector2.ZERO:
		animation.play("Idle" + last_facing)
	elif run == 1.75:
		animation.play("Run" + last_facing)
	else:
		animation.play("Walk" + last_facing)
