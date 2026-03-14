extends Resource
class_name CharacterResource

enum BuffableStats {
	MAX_HEALTH,
	DEFENSE,
	ATTACK, }

const BASE_LEVEL_EXP: float = 100.0

const STATS: Dictionary[BuffableStats, String] = {
	BuffableStats.MAX_HEALTH: "max_health",
	BuffableStats.DEFENSE: "defense",
	BuffableStats.ATTACK: "attack" }

signal health_depleted
signal health_changed(cur_health: int, max_health: int)

@export var stat_curves: Dictionary[BuffableStats, Curve] = {
	BuffableStats.MAX_HEALTH: preload("uid://c0kat1ve5usjx"),
	BuffableStats.DEFENSE: preload("uid://dym2u6xcecuc1"),
	BuffableStats.ATTACK: preload("uid://cm1vd73wspvan") }

@export var base_max_health: int = 100
@export var base_defense: int = 10
@export var base_attack: int = 10

@export var experience: int = 0:
	set = _on_experience_set
@export var stat_buffs: Array[StatBuff] = []

var level: int:
	get(): return floor(max(1.0, sqrt(experience / BASE_LEVEL_EXP) + 0.75))

var current_max_health: int = 100
var current_defense: int = 10
var current_attack: int = 10

var health: int = 100: set = _on_health_set

var stat_add: Dictionary = {}
var stat_multiply: Dictionary = {}
var base_stats: Dictionary = {}

func _init() -> void:
	setup_stats.call_deferred()

func setup_stats() -> void:
	_recalculate_base_stats()
	_rebuild_buff_cache()
	_apply_all_stats()
	health = current_max_health

#region Stats E buffs

func _recalculate_base_stats() -> void:
	var sample_pos: float = (float(level) / 100.0) - 0.01

	for stat in STATS:
		var name: String = STATS[stat]
		var base_value: float = get("base_" + name)
		var curve: Curve = stat_curves.get(stat)
		var value: float = base_value

		if curve:
			value *= curve.sample(sample_pos)
		base_stats[stat] = value

func _rebuild_buff_cache() -> void:
	stat_add.clear()
	stat_multiply.clear()

	for buff in _get_all_buffs():
		_apply_buff_to_cache(buff)

func _apply_buff_to_cache(buff: StatBuff) -> void:
	if not stat_add.has(buff.stat):
		stat_add[buff.stat] = 0.0

	if not stat_multiply.has(buff.stat):
		stat_multiply[buff.stat] = 1.0

	match buff.buff_type:
		StatBuff.BuffType.ADD:
			stat_add[buff.stat] += buff.buff_amount

		StatBuff.BuffType.MULTIPLY:
			stat_multiply[buff.stat] += buff.buff_amount
			stat_multiply[buff.stat] = max(stat_multiply[buff.stat], 0.0)

func _remove_buff_from_cache(buff: StatBuff) -> void:
	match buff.buff_type:
		StatBuff.BuffType.ADD:
			stat_add[buff.stat] -= buff.buff_amount

		StatBuff.BuffType.MULTIPLY:
			stat_multiply[buff.stat] -= buff.buff_amount

func _apply_stat(stat: BuffableStats) -> void:
	var name: String = STATS[stat]

	var value: float = base_stats.get(stat, 0)

	if stat_multiply.has(stat):
		value *= stat_multiply[stat]

	if stat_add.has(stat):
		value += stat_add[stat]

	set("current_" + name, int(value))

func _apply_all_stats() -> void:
	for stat in STATS:
		_apply_stat(stat)

func add_buff(buff: StatBuff) -> void:
	stat_buffs.append(buff)
	_apply_buff_to_cache(buff)
	_apply_stat(buff.stat)

func remove_buff(buff: StatBuff) -> void:
	stat_buffs.erase(buff)
	_remove_buff_from_cache(buff)
	_apply_stat(buff.stat)

#endregion

func _on_health_set(new_value: int) -> void:
	health = clampi(new_value, -999, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()

func _on_experience_set(new_value: int) -> void:
	var old_level: int = level
	experience = new_value
	if old_level != level:
		_recalculate_base_stats()
		_apply_all_stats()

func _get_all_buffs() -> Array[StatBuff]:
	return stat_buffs
