extends Node

static var manager_scene: PackedScene = null:
	get():
		if not manager_scene:
			manager_scene = load("uid://dojjall5yp65n")
		return manager_scene

var manager: Manager = null
var configures: ConfigResource = ConfigResource.new()
var game: bool = false

func _ready() -> void:
	SaveConfigResource.Delete()
	configures = SaveConfigResource.Load()
	TranslationServer.set_locale(configures.idioma)
	start_game(1, 1)

func _exit_tree() -> void:
	SaveConfigResource.Save(configures)

func call_manager(method: StringName, ...args) -> Variant:
	if not manager:
		push_warning("Manager não definido")
		return null
	
	if manager.has_method(method):
		return manager.callv(method, args)
	
	push_warning("Método ", method, " não existe em manager")
	return null

func start_game(slot: int, capitulo: int) -> void:
	manager = manager_scene.instantiate()
	add_child(manager)
	
	manager.Start_Save(slot, capitulo)
	game = true

func end_game() -> void:
	if manager:
		manager.queue_free()
	manager = null
	game = false
