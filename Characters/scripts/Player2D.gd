extends CharacterBody2D
class_name CharacterPlayer2D

const ANGULOS_FOR_STRING: Dictionary[Vector2, StringName] = {
	Vector2(0, 1): "_Down",
	Vector2(0, -1): "_Up",
	Vector2(1, 1): "_Down_Right",
	Vector2(-1, 1): "_Down_Left",
	Vector2(1, -1): "_Up_Right",
	Vector2(-1, -1): "_Up_Left",
	Vector2(1, 0): "_Right",
	Vector2(-1, 0): "_Left" }
const SPEED: float = 70.0

var direction: Vector2 = Vector2.ZERO
var last_facing: StringName = "_Down"
var run: float = 1.0

@export var animationFrame: AnimationPlayer
@export var alvo: RayCast2D

func _physics_process(_delta: float) -> void:
	if not Global.call_manager("is_state", Game.States.MAP):
		_update_animation(Vector2.ZERO)
		velocity = Vector2.ZERO
		return
	
	direction = _input_direction()
	
	run = 1.75 if Input.is_action_pressed("ui_cancel") else 1.0
	velocity = direction.normalized() * SPEED * run
	alvo.rotation = Vector2(direction.y, -direction.x).normalized().angle() if direction != Vector2.ZERO else alvo.rotation
	
	_update_animation(direction)
	move_and_slide()

func _input_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

func _update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO and ANGULOS_FOR_STRING.has(dir):
		last_facing = ANGULOS_FOR_STRING[dir]

	if velocity == Vector2.ZERO:
		animationFrame.play("Idle" + last_facing)
	elif run == 1.75:
		animationFrame.play("Run" + last_facing)
	else:
		animationFrame.play("Walk" + last_facing)

func _input(event: InputEvent) -> void:
	if not Global.call_manager("is_state", Game.States.MAP):
		return
		
	if event.is_action_pressed("ui_accept"):
		if alvo.get_collider() is CharacterNPC:
			alvo.get_collider().call("open_dialogue", last_facing)
