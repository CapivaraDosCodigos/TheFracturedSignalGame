class_name PlayerResource
extends CharacterResource

@export var nome: String
@export var nome_id: String:
	set(value):
		nome_id = value
		if equipment:
			equipment.player_id = nome_id

@export var equipment: EquipmentBaseResource:
	set(value):
		equipment = value
		if equipment:
			equipment.player_id = nome_id

func _get_all_buffs() -> Array[StatBuff]:
	var buffs:  Array[StatBuff] = stat_buffs.duplicate()

	if equipment:
		buffs.append_array(equipment.stat_buffs)

	return buffs
