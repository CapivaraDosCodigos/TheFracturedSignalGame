@abstract
extends Resource
class_name EquipmentBaseResource

@export var inventory: Array[ItemResource] = []:
	get = get_inventory, set = set_inventory

@export_file("*.tscn") var player_menu: String

@export var player_id: String
var stat_buffs: Array[StatBuff] = []

func get_inventory() -> Array[ItemResource]:
	return inventory

func set_inventory(items: Array[ItemResource]) -> void:
	inventory = items

func equip_item(_item: ItemResource, _slot: StringName) -> void:
	push_warning("equip_item() não implementado em: " + str(get_class()))

func equip_item_index(_index: int, _slot: StringName) -> void:
	push_warning("equip_item_index() não implementado em: " + str(get_class()))

func add_item(item: ItemResource) -> void:
	inventory.append(item)

func remove_item(item: ItemResource) -> void:
	if inventory.has(item):
		inventory.erase(item)

func remove_item_index(index: int) -> void:
	if 0 > index and index < inventory.size():
		inventory.remove_at(index)
