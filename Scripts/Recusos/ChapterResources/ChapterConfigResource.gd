extends ChapterBaseResource
class_name ChapterConfigResource

const FILE_EXTENSION: String = ".tres"
const PATH_FORMAT: String= "_config_%d" + FILE_EXTENSION

@export var nome: String = "Season"
@export var capitulo: int = 1
@export_file("*.tscn") var StartScene: String

var timeSave: String = "00/00/0000 00h00"
var slot: int = 0

func Save(slot_p: int = slot) -> bool:
	if not Game.is_slot_valid(slot_p):
		push_warning("⚠️ Slot inválido: %d" % slot_p)
		return false
	
	timeSave = Game.get_time()
	
	var path: String = _get_path(slot_p)
	var err := ResourceSaver.save(self.duplicate(true), path)
	
	if err != OK:
		push_error("❌ Falha ao salvar slot %d. Código: %s" % [slot_p, err])
		return false
	
	slot = slot_p
	
	Global.configures.saves[slot_p] = "%s %s" % [nome, timeSave]
	SaveResource.SalvarConfig(Global.configures)
	
	return true

func Load(slot_p: int = slot, capitulo_p: int = capitulo) -> bool:
	if not Game.is_slot_valid(slot_p):
		push_warning("⚠️ Slot inválido: %d" % slot_p)
		return false
	
	var path : String = _get_path(slot_p)
	
	if not FileAccess.file_exists(path):
		return _load_default_capitulo(capitulo_p, slot_p)
	
	var loaded_data: ChapterConfigResource = ResourceLoader.load(path) as ChapterConfigResource
	
	if loaded_data == null:
		push_error("❌ Falha ao carregar arquivo: " + path)
		return false
	
	_copy_from(loaded_data)
	slot = slot_p
	
	return true

func _get_path(slot_id: int) -> String:
	return Game.SAVE_PATH + PATH_FORMAT % slot_id

func _copy_from(data: ChapterConfigResource) -> void:
	nome = data.nome
	capitulo = data.capitulo
	StartScene = data.StartScene
	timeSave = data.timeSave

func _load_default_capitulo(capitulo_id: int, slot_id: int) -> bool:
	if not Game.CAPITULOS_PATH.has(capitulo_id):
		push_warning("⚠️ Capítulo inexistente: %d" % capitulo_id)
		return false
	
	var capitulo_path: String = Game.CAPITULOS_PATH[capitulo_id]
	var capitulo_load: ChapterResource = ResourceLoader.load(capitulo_path) as ChapterResource
	
	if capitulo_load == null:
		push_error("❌ Falha ao carregar capítulo: " + capitulo_path)
		return false
	
	var config: ChapterConfigResource = capitulo_load.chapterConfig.duplicate()
	
	_copy_from(config)
	slot = slot_id
	
	return true
