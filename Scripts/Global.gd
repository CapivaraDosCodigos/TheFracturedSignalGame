extends Node

static var manager_scene: PackedScene = null:
	get():
		if not manager_scene:
			manager_scene = load("uid://dojjall5yp65n")
		return manager_scene

var manager: Manager = null
var configures: ConfigResource = ConfigResource.new()
var game: bool = false

#region Load Scenes 
const loading_screen: PackedScene = preload("uid://dp3hjnmnfokbw")

signal progress_changed(progress)
signal load_finished

var loaded_resource: PackedScene
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true
var load_scene_bool: bool = false
#endregion

func _ready() -> void:
	configures = SaveResource.CarregarConfig()
	start_game(1, 1)

func _process(_delta: float) -> void:
	if load:
		_process_load_status()

func _process_load_status() -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	progress_changed.emit(progress[0])
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			load_scene_bool = false
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			get_tree().change_scene_to_packed(loaded_resource)
			load_finished.emit()

func _start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		load_scene_bool = true

func _exit_tree() -> void:
	SaveResource.SalvarConfig(configures)

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

func load_scene(_scene_path: String, _use_sub_threads: bool = true) -> void:
	scene_path = _scene_path
	use_sub_threads = _use_sub_threads
	
	var new_load_screen = loading_screen.instantiate()
	add_child(new_load_screen)
	progress_changed.connect(new_load_screen._on_progress_changed)
	load_finished.connect(new_load_screen._on_load_finished)
	
	await new_load_screen.loading_screen_ready
	
	_start_load()
