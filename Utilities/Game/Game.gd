extends RefCounted
class_name Game

const DEBUG: bool = false

const TOTAL_SLOTS: int = 5

const SAVE_PATH: String = "res://chapter"
const CONF_PATH: String = "user://configures.tres"

const PLAYERS_STRING: Array[String] = ["Variante", "Zeta"]

const CAPITULOS_PATH: Dictionary[int, String] = {
	1: "uid://dpha1sksrho0x" }

enum Players {
	Variante = 0,
	Zeta = 1 }

enum States {
	NONE = -1,
	MAP = 0,
	BATTLE = 1,
	DIALOGUE = 2,
	MENU = 3,
	INTRO_MENU = 4 }

static func is_slot_valid(slot: int) -> bool:
	if slot < 1 or slot > Game.TOTAL_SLOTS:
		push_error("❌ Slot inválido: %d" % slot)
		return false
	return true
