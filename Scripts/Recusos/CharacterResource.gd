extends Resource
class_name CharacterResource

enum BuffableStats {
	MAX_HEALTH,
	DEFENSE,
	ATTACK, }

const BASE_LEVEL_EXP: float = 100.0

signal health_depleted
signal health_changed(cur_health: int, max_health: int)

@export var stat_curves: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://c0kat1ve5usjx"),
	BuffableStats.DEFENSE: preload("uid://dym2u6xcecuc1"),
	BuffableStats.ATTACK: preload("uid://cm1vd73wspvan") }
@export var base_max_health: int = 100
@export var base_defense: int = 10 
@export var base_attack: int = 10
@export var experience: int = 0: set = _on_experience_set
@export var stat_buffs: Array[StatBuff] = []

var level: int = 1:
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_EXP ) + 0.75))
var current_max_health: int = 100
var current_defense: int = 10
var current_attack: int = 10
var health: int = 100: set = _on_health_set

func _init() -> void:
	setup_stats.call_deferred()

func setup_stats() -> void:
	recalculate_stats()
	health = current_max_health

func recalculate_stats() -> void:
	var stat_multiply: Dictionary[String, float] = {}
	var stat_addends: Dictionary[String, float] = {}
	
	for buff in stat_buffs:
		var stat_name: String = BuffableStats.keys().get(buff.stat)
		stat_name = stat_name.to_lower()
		match buff.buff_type:
			StatBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount
			
			StatBuff.BuffType.MULTIPLY:
				if not stat_multiply.has(stat_name):
					stat_multiply[stat_name] = 1.0
				stat_multiply[stat_name] += buff.buff_amount
				
				if stat_multiply[stat_name] < 0.0:
					stat_multiply[stat_name] = 0.0
	
	var stat_sample_pos: float = (float(level) / 100.0) - 0.01
	current_max_health = int(base_max_health * stat_curves[BuffableStats.MAX_HEALTH].sample(stat_sample_pos))
	current_defense = int(base_defense * stat_curves[BuffableStats.DEFENSE].sample(stat_sample_pos))
	current_attack = int(base_attack * max(stat_curves[BuffableStats.ATTACK].sample(stat_sample_pos), -1.0))
	
	for stat_name in stat_multiply:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, int(get(cur_property_name) * stat_multiply[stat_name]))
	
	for stat_name in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, int(get(cur_property_name) + stat_addends[stat_name]))

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	recalculate_stats.call_deferred()

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	recalculate_stats.call_deferred()

func _on_health_set(new_value: int) -> void:
	health = clampi(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()

func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value
	if not old_level == level:
		recalculate_stats()
