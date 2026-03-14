extends Resource
class_name StatBuff

enum BuffType {
	MULTIPLY,
	ADD
}

@export var stat: CharacterResource.BuffableStats
@export var buff_amount: float = 0.0
@export var buff_type: BuffType
