extends Resource
class_name ChapterResource


@export var chapterConfig: ChapterConfigResource
@export var chapterWorld: ChapterWorldResource
@export var chapterLocation: ChapterLocationResource
@export var chapterPlayers: ChapterPlayersResource

func _init() -> void:
	chapterConfig = ChapterConfigResource.new()
	chapterWorld = ChapterWorldResource.new()
	chapterLocation = ChapterLocationResource.new()
	chapterPlayers = ChapterPlayersResource.new()

func Save(slot: int = get_slot()) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var success := true
	
	success = chapterConfig.Save(slot) and success
	success = chapterLocation.Save(slot) and success
	success = chapterPlayers.Save(slot) and success
	success = chapterWorld.Save(slot) and success
	
	return success

func Load(slot: int, capitulo: int = -1) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var success := true
	
	success = chapterConfig.Load(slot, capitulo) and success
	success = chapterLocation.Load(slot, capitulo) and success
	success = chapterPlayers.Load(slot, capitulo) and success
	success = chapterWorld.Load(slot, capitulo) and success
	
	return success

#region Get's, Set's, Has's

func get_nome() -> String:
	return chapterConfig.nome

func set_nome(value: String) -> void:
	chapterConfig.nome = value
	chapterConfig.Save()

func get_capitulo() -> int:
	return chapterConfig.capitulo

func set_capitulo(value: int) -> void:
	chapterConfig.capitulo = value
	chapterConfig.Save()

func get_start_scene() -> String:
	return chapterConfig.StartScene

func get_time_save() -> String:
	return chapterConfig.timeSave

func get_slot() -> int:
	return chapterConfig.slot

func set_slot(value: int) -> void:
	chapterConfig.slot = value
	chapterConfig.Save()

func get_current_scene() -> String:
	return chapterLocation.CurrentScene

func set_current_scene(scene: String) -> void:
	chapterLocation.CurrentScene = scene
	chapterLocation.Save(chapterConfig.slot)

func get_players_spawner_id() -> int:
	return chapterLocation.PlayersSpawnerId

func set_players_spawner_id(id: int) -> void:
	chapterLocation.PlayersSpawnerId = id
	chapterLocation.Save(chapterConfig.slot)

func get_players_dict() -> Dictionary[String, PlayerResource]:
	return chapterPlayers.Players

func get_current_player() -> String:
	return chapterPlayers.CurrentPlayer

func set_current_player(player: String) -> void:
	if not chapterPlayers.PlayersAtuais.has(player):
		chapterPlayers.CurrentPlayer = player
		chapterPlayers.Save(chapterConfig.slot)

func get_players_atuais() -> Array[String]:
	return chapterPlayers.PlayersAtuais

func set_players_atuais(players: Array[String]) -> void:
	chapterPlayers.PlayersAtuais = players
	chapterPlayers.Save(chapterConfig.slot)

func get_player(player: String) -> PlayerResource:
	if chapterPlayers.Players.has(player):
		return chapterPlayers.Players[player]
	
	push_warning("⚠️ Player não encontrado: %s" % player)
	return null

func has_player(player: String) -> bool:
	return chapterPlayers.PlayersAtuais.has(player)

func add_player(player: String) -> void:
	if not chapterPlayers.PlayersAtuais.has(player):
		chapterPlayers.PlayersAtuais.append(player)
		chapterPlayers.Save(chapterConfig.slot)

func get_desbloqueios() -> Array[String]:
	return chapterWorld.Desbloqueios

func add_desbloqueio(value: String) -> void:
	if not chapterWorld.Desbloqueios.has(value):
		chapterWorld.Desbloqueios.append(value)
		chapterWorld.Save(chapterConfig.slot)

func has_desbloqueio(value: String) -> bool:
	return chapterWorld.Desbloqueios.has(value)

func get_cenas_vistas() -> Array[String]:
	return chapterWorld.CenasVistas

func add_cena_vista(cena: String) -> void:
	if not chapterWorld.CenasVistas.has(cena):
		chapterWorld.CenasVistas.append(cena)
		chapterWorld.Save(chapterConfig.slot)

func has_cena_vista(cena: String) -> bool:
	return chapterWorld.CenasVistas.has(cena)

func get_enemies_vistos() -> Array[String]:
	return chapterWorld.EnemiesVistos

func add_enemy_visto(enemy: String) -> void:
	if not chapterWorld.EnemiesVistos.has(enemy):
		chapterWorld.EnemiesVistos.append(enemy)
		chapterWorld.Save(chapterConfig.slot)

func has_enemy_visto(enemy: String) -> bool:
	return chapterWorld.EnemiesVistos.has(enemy)

func get_players() -> Dictionary[String, PlayerResource]:
	var players: Dictionary[String, PlayerResource] = {}
	
	for player in chapterPlayers.PlayersAtuais:
		if chapterPlayers.Players.has(player):
			players[player] = chapterPlayers.Players[player]
	
	return players

#endregion
