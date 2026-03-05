extends ChapterBaseResource
class_name ChapterWorldResource

const FILE_EXTENSION: String = ".tres"
const PATH_FORMAT: String = "_world_%d" + FILE_EXTENSION

@export var Desbloqueios: Array[String] = []
@export var CenasVistas: Array[String] = []
@export var EnemiesVistos: Array[String] = []

func Save(slot: int) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	var err := ResourceSaver.save(self.duplicate(true), path)
	
	if err != OK:
		push_error("❌ Falha ao salvar World slot %d. Código: %s" % [slot, err])
		return false
	
	return true

func Load(slot: int, capitulo: int = -1) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	
	if not FileAccess.file_exists(path):
		return _load_default_capitulo(capitulo)
	
	var loaded_data: ChapterWorldResource = ResourceLoader.load(path) as ChapterWorldResource
	
	if loaded_data == null:
		push_error("❌ Falha ao carregar World: " + path)
		return false
	
	_copy_from(loaded_data)
	return true

func _get_path(slot: int) -> String:
	return Game.SAVE_PATH + PATH_FORMAT % slot

func _copy_from(data: ChapterWorldResource) -> void:
	Desbloqueios = data.Desbloqueios.duplicate()
	CenasVistas = data.CenasVistas.duplicate()
	EnemiesVistos = data.EnemiesVistos.duplicate()

func _load_default_capitulo(capitulo_id: int) -> bool:
	if not Game.CAPITULOS_PATH.has(capitulo_id):
		push_warning("⚠️ Capítulo inexistente: %d" % capitulo_id)
		return false
	
	var capitulo_path: String = Game.CAPITULOS_PATH[capitulo_id]
	var capitulo_load: ChapterResource = ResourceLoader.load(capitulo_path) as ChapterResource
	
	if capitulo_load == null:
		push_error("❌ Falha ao carregar capítulo: " + capitulo_path)
		return false
	
	var world: ChapterWorldResource = capitulo_load.chapterWorld
	
	_copy_from(world)
	
	return true
