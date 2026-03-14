extends Resource
class_name ChapterPlayersResource

const FILE_EXTENSION: String = ".tres"
const PATH_FORMAT: String = "_players_%d" + FILE_EXTENSION

@export var Players: Dictionary[String, PlayerResource] = {}
@export_enum("Zeta") var PlayersAtuais: Array[String] = []
@export_enum("Zeta") var CurrentPlayer: String = "Zeta"

func Save(slot: int) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	var err := ResourceSaver.save(self.duplicate_deep(Resource.DEEP_DUPLICATE_ALL), path)
	
	if err != OK:
		push_error("❌ Falha ao salvar Players slot %d. Código: %s" % [slot, err])
		return false
	
	return true

func Load(slot: int, capitulo: int = -1) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var path: String = _get_path(slot)
	
	if not FileAccess.file_exists(path):
		return _load_default_capitulo(capitulo)
	
	var loaded_data: ChapterPlayersResource = ResourceLoader.load(path) as ChapterPlayersResource
	
	if loaded_data == null:
		push_error("❌ Falha ao carregar Players: " + path)
		return false
	
	_copy_from(loaded_data)
	return true

func _copy_from(data: ChapterPlayersResource) -> void:
	Players = data.Players.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	PlayersAtuais = data.PlayersAtuais.duplicate()
	CurrentPlayer = data.CurrentPlayer

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
	
	var players: ChapterPlayersResource = capitulo_load.chapterPlayers
	
	_copy_from(players)
	
	return true
