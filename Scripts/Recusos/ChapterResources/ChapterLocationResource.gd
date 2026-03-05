extends ChapterBaseResource
class_name ChapterLocationResource

const FILE_EXTENSION: String = ".tres"
const PATH_FORMAT: String = "_location_%d" + FILE_EXTENSION

@export var PlayersSpawnerId: int = 0
@export_file("*.tscn") var CurrentScene: String

func Save(slot: int) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	var err := ResourceSaver.save(self.duplicate(true), path)
	
	if err != OK:
		push_error("❌ Falha ao salvar Location slot %d. Código: %s" % [slot, err])
		return false
	
	return true

func Load(slot: int, capítulo: int = -1) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	
	if not FileAccess.file_exists(path):
		return _load_default_capitulo(capítulo)
	
	var loaded_data: ChapterLocationResource = ResourceLoader.load(path) as ChapterLocationResource
	
	if loaded_data == null:
		push_error("❌ Falha ao carregar Location: " + path)
		return false
	
	_copy_from(loaded_data)
	return true

func _get_path(slot: int) -> String:
	return Game.SAVE_PATH + PATH_FORMAT % slot

func _load_default_capitulo(capitulo_id: int) -> bool:
	if not Game.CAPITULOS_PATH.has(capitulo_id):
		push_warning("⚠️ Capítulo inexistente: %d" % capitulo_id)
		return false
	
	var capitulo_path: String = Game.CAPITULOS_PATH[capitulo_id]
	var capitulo_load: ChapterResource = ResourceLoader.load(capitulo_path) as ChapterResource
	
	if capitulo_load == null:
		push_error("❌ Falha ao carregar capítulo: " + capitulo_path)
		return false
	
	var location: ChapterLocationResource = capitulo_load.chapterLocation
	
	_copy_from(location)
	
	return true

func _copy_from(data: ChapterLocationResource) -> void:
	PlayersSpawnerId = data.PlayersSpawnerId
	CurrentScene = data.CurrentScene
