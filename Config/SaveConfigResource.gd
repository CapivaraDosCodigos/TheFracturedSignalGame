extends RefCounted
class_name SaveConfigResource

#static func DeletarChapter(slot: int) -> void:
	#if not _is_slot_valid(slot): return
	#
	#var path: String = Game.SAVE_PATH % slot
	#
	#if FileAccess.file_exists(path):
		#var err = OS.move_to_trash(ProjectSettings.globalize_path(path))
		#if err != OK:
			#push_warning("⚠️ Falha ao excluir slot %d." % slot)
			#return
		#
		#Global.configures.saves[slot] = ""
		#SalvarConfig(Global.configures)

#static func prints_sizes(path: String) -> void:
	#var size_bytes: int = FileAccess.get_size(path)
	#print("Arquivo contem KB: ", bytes_to_kb(size_bytes))
	#print("MB: ", bytes_to_mb(size_bytes))
#
#static func bytes_to_kb(bytes: int) -> float:
	#var kb: float =  bytes / 1024.0
	#return round(kb * 100) / 100
#
#static func bytes_to_mb(bytes: int) -> float:
	#var mb: float = bytes / (1024.0 * 1024.0)
	#return round(mb * 100) / 100

static func Load() -> ConfigResource:
	if not ResourceLoader.exists(Game.CONF_PATH):
		return ConfigResource.new()
	
	var conf = ResourceLoader.load(Game.CONF_PATH)
	
	if conf == null:
		push_error("❌ Falha ao carregar arquivo de conf: " + Game.CONF_PATH)
		return ConfigResource.new()
		
	return conf

static func Save(config: ConfigResource) -> void:
	var err: int = ResourceSaver.save(config, Game.CONF_PATH)
	if err != OK:
		push_error("❌ Falha ao salvar. Código de erro: %s" % [err])

static func Delete() -> void:
	if FileAccess.file_exists(Game.CONF_PATH):
		var err = OS.move_to_trash(ProjectSettings.globalize_path(Game.CONF_PATH))
		if err != OK:
			push_warning("⚠️ Falha ao excluir conf")


#static func CarregarCampo(slot: int, campo: String) -> Variant:
	#if not _is_slot_valid(slot): return ""
	#
	#var path: String = Game.SAVE_PATH % slot
	#
	#if not FileAccess.file_exists(path): return ""
	#
	#var data: ChapterResource = ResourceLoader.load(path)
	#
	#if data == null:
		#return ""
	#
	#return data.get(campo)
