## Classe que armazena informações extras sobre o progresso do jogo.
##
## Inclui desbloqueios, cenas já vistas e conquistas obtidas.
class_name ExtrasResource extends Resource

## Lista de desbloqueios do jogador (strings que representam chaves únicas).
@export var Desbloqueios: Array[StringName] = []

## Lista de inimigos vistos pelo jogador (strings que representam chaves únicas).
@export var EnemiesVistos: Array[StringName] = []

## Lista de cenas já visualizadas pelo jogador (strings que representam chaves únicas).
@export var CenasVistas: Array[StringName] = []

func hasCenasVistas(cena: StringName) -> bool:
	return CenasVistas.has(cena)

func appendCenasVistas(cena: StringName) -> void:
	CenasVistas.append(cena)
