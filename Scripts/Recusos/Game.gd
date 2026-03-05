extends RefCounted
class_name Game

const DEBUG: bool = false

const TOTAL_SLOTS: int = 5

const SAVE_PATH: String = "res://chapter"
const CONF_PATH: String = "user://configures.tres"

const PLAYERS_STRING: Array[String] = ["Variante", "Zeno"]

const CAPITULOS_PATH: Dictionary[int, String] = {
	1: "uid://dpha1sksrho0x" }

enum Players {
	Variante = 0,
	Zeno = 1 }

enum States {
	MAP = 0,
	BATTLE = 1,
	DIALOGUE = 2,
	MENU = 3,
	INTRO_MENU = 4 }

static func get_time() -> String:
	var data: String = Time.get_date_string_from_system()
	var hora: String = Time.get_time_string_from_system().substr(0, 5)
	var data_hora: String = "%s %sh%s" % [data.replace("-", "/"), hora.substr(0, 2), hora.substr(3, 2)]
	return data_hora

static func is_slot_valid(slot: int) -> bool:
	if slot < 1 or slot > Game.TOTAL_SLOTS:
		push_error("❌ Slot inválido: %d" % slot)
		return false
	return true
