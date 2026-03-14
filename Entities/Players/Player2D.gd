@tool
extends CharacterBody2D
class_name Player2D

const ANGULOS_FOR_STRING: Dictionary[Vector2, StringName] = {
	Vector2(0, 1): "Down",
	Vector2(0, -1): "Up",
	Vector2(1, 1): "Down_Right",
	Vector2(-1, 1): "Down_Left",
	Vector2(1, -1): "Up_Right",
	Vector2(-1, -1): "Up_Left",
	Vector2(1, 0): "Right",
	Vector2(-1, 0): "Left" }

const RUN_MULT: float = 1.5

@export var speed: float = 70.0

var direction: Vector2 = Vector2.ZERO
var last_facing: StringName = "Down"
var running: float = 1.0

@export var alvo: RayCast2D
@export_group("Sprite's")
@export var idle: AnimatedSprite2D
@export var walk: AnimatedSprite2D
@export var run: AnimatedSprite2D

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not idle:
		warnings.append("Defina um AnimatedSprite2D para Idle")
	if not walk:
		warnings.append("Defina um AnimatedSprite2D para Walk")
	if not run:
		warnings.append("Defina um AnimatedSprite2D para Run")
	if not alvo:
		warnings.append("Defina um RayCast2D para Alvo")
	
	return warnings

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not Manager.is_state(Game.States.MAP):
		_update_animation(Vector2.ZERO)
		velocity = Vector2.ZERO
		return
	
	direction = InputGame.input_direction()
	
	running = RUN_MULT if Input.is_action_pressed("ui_cancel") else 1.0
	
	velocity = direction.normalized() * speed * running
	
	alvo.rotation = Vector2(direction.y, -direction.x).normalized().angle() if direction != Vector2.ZERO else alvo.rotation
	
	_update_animation(direction)
	move_and_slide()

func _update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO and ANGULOS_FOR_STRING.has(dir):
		last_facing = ANGULOS_FOR_STRING[dir]
		
	if velocity == Vector2.ZERO:
		_set_sprite(idle)
		if idle.animation != last_facing:
			idle.play(last_facing)

	elif running == RUN_MULT:
		_set_sprite(run)
		if run.animation != last_facing:
			run.play(last_facing)

	else:
		_set_sprite(walk)
		if walk.animation != last_facing:
			walk.play(last_facing)

func _set_sprite(active: AnimatedSprite2D):
	idle.visible = active == idle
	walk.visible = active == walk
	run.visible = active == run

func _input(event: InputEvent) -> void:
	if not Manager.is_state(Game.States.MAP):
		return
		
	if event.is_action_pressed("ui_accept"):
		var collider := alvo.get_collider()
		
		if collider is CharacterNPC:
			collider.open_dialogue("_" + last_facing)
