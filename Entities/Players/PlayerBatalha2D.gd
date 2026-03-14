@tool
extends CharacterBody2D
class_name PlayerBatalha2D

const ANGULOS_FOR_STRING: Dictionary[Vector2, StringName] = {
	Vector2(0, 1): "Down",
	Vector2(0, -1): "Up",
	Vector2(1, 1): "Down_Right",
	Vector2(-1, 1): "Down_Left",
	Vector2(1, -1): "Up_Right",
	Vector2(-1, -1): "Up_Left",
	Vector2(1, 0): "Right",
	Vector2(-1, 0): "Left" }

var speed: float = 70.0
var direction: Vector2 = Vector2.ZERO
var last_facing: StringName = "Down"

@export var idle: AnimatedSprite2D
@export var walk: AnimatedSprite2D

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not idle:
		warnings.append("Defina um AnimatedSprite2D para Idle")
	if not walk:
		warnings.append("Defina um AnimatedSprite2D para Walk")
		
	return warnings

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not Manager.is_state(Game.States.MAP):
		_update_animation(Vector2.ZERO)
		velocity = Vector2.ZERO
		return
	
	direction = InputGame.input_direction()
	velocity = direction.normalized() * speed
	
	_update_animation(direction)
	move_and_slide()

func _update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO and ANGULOS_FOR_STRING.has(dir):
		last_facing = ANGULOS_FOR_STRING[dir]

	if velocity.length() < 1:
		_set_sprite(idle)
		if idle.animation != last_facing:
			idle.play(last_facing)
	else:
		_set_sprite(walk)
		if walk.animation != last_facing:
			walk.play(last_facing)

func _set_sprite(active: AnimatedSprite2D):
	idle.visible = active == idle
	walk.visible = active == walk
