extends Resource
class_name ChapterResource

signal save_location
signal save_players
signal save_world

@export var chapterConfig: ChapterConfigResource
@export var chapterWorld: ChapterWorldResource
@export var chapterLocation: ChapterLocationResource
@export var chapterPlayers: ChapterPlayersResource

var world_thread: Thread
var location_thread: Thread
var players_thread: Thread

func _init() -> void:
	chapterConfig = ChapterConfigResource.new()
	chapterWorld = ChapterWorldResource.new()
	chapterLocation = ChapterLocationResource.new()
	chapterPlayers = ChapterPlayersResource.new()
	
	world_thread = Thread.new()
	location_thread = Thread.new()
	players_thread = Thread.new()
	
	save_world.connect(_save_world_thread)
	save_location.connect(_save_location_thread)
	save_players.connect(_save_players_thread)

func Save(slot: int = get_slot()) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var success: bool = true
	
	success = chapterConfig.Save(slot) and success
	success = chapterLocation.Save(slot) and success
	success = chapterPlayers.Save(slot) and success
	success = chapterWorld.Save(slot) and success
	
	return success

func Load(slot: int, capitulo: int = -1) -> bool:
	if not Game.is_slot_valid(slot):
		push_warning("⚠️ Slot inválido: %d" % slot)
		return false
	
	var success: bool = true
	
	success = chapterConfig.Load(slot, capitulo) and success
	success = chapterLocation.Load(slot, capitulo) and success
	success = chapterPlayers.Load(slot, capitulo) and success
	success = chapterWorld.Load(slot, capitulo) and success
	
	return success

#region Get's, Set's, Has's, Add's

func get_nome() -> String:
	return chapterConfig.nome

func get_capitulo() -> int:
	return chapterConfig.capitulo

func get_start_scene() -> String:
	return chapterLocation.StartScene

func get_time_save() -> String:
	return chapterLocation.timeSave

func get_slot() -> int:
	return chapterConfig.slot

func get_current_scene() -> String:
	return chapterLocation.CurrentScene

func set_current_scene(scene: String) -> void:
	chapterLocation.CurrentScene = scene
	_save_location_thread()

func get_players_spawner_id() -> int:
	return chapterLocation.PlayersSpawnerId

func set_players_spawner_id(id: int) -> void:
	chapterLocation.PlayersSpawnerId = id
	_save_location_thread()

func get_players_dict() -> Dictionary[String, PlayerResource]:
	return chapterPlayers.Players

func set_players_dict(value_dict: Dictionary[String, PlayerResource]) -> void:
	chapterPlayers.Players = value_dict
	_save_players_thread()

func get_current_player() -> String:
	return chapterPlayers.CurrentPlayer

func set_current_player(player: String) -> void:
	if not chapterPlayers.PlayersAtuais.has(player):
		chapterPlayers.CurrentPlayer = player
		_save_players_thread()

func get_players_atuais() -> Array[String]:
	return chapterPlayers.PlayersAtuais

func set_players_atuais(players: Array[String]) -> void:
	chapterPlayers.PlayersAtuais = players
	_save_players_thread()

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
		_save_players_thread()

func get_desbloqueios() -> Array[String]:
	return chapterWorld.Desbloqueios

func add_desbloqueio(value: String) -> void:
	if not chapterWorld.Desbloqueios.has(value):
		chapterWorld.Desbloqueios.append(value)
		_save_world_thread()

func has_desbloqueio(value: String) -> bool:
	return chapterWorld.Desbloqueios.has(value)

func get_cenas_vistas() -> Array[String]:
	return chapterWorld.CenasVistas

func add_cena_vista(cena: String) -> void:
	if not chapterWorld.CenasVistas.has(cena):
		chapterWorld.CenasVistas.append(cena)
		_save_world_thread()

func has_cena_vista(cena: String) -> bool:
	return chapterWorld.CenasVistas.has(cena)

func get_enemies_vistos() -> Array[String]:
	return chapterWorld.EnemiesVistos

func add_enemy_visto(enemy: String) -> void:
	if not chapterWorld.EnemiesVistos.has(enemy):
		chapterWorld.EnemiesVistos.append(enemy)
		_save_world_thread()

func has_enemy_visto(enemy: String) -> bool:
	return chapterWorld.EnemiesVistos.has(enemy)

func get_players() -> Dictionary[String, PlayerResource]:
	var players: Dictionary[String, PlayerResource] = {}
	
	for player in chapterPlayers.PlayersAtuais:
		if chapterPlayers.Players.has(player):
			players[player] = chapterPlayers.Players[player]
	
	return players

#endregion

func _save_world_thread() -> void:
	if world_thread.is_started():
		world_thread.wait_to_finish()
	
	world_thread.start(func(): chapterWorld.Save(get_slot()))

func _save_location_thread() -> void:
	if location_thread.is_started():
		location_thread.wait_to_finish()
	
	location_thread.start(func(): chapterLocation.Save(get_slot()))

func _save_players_thread() -> void:
	if players_thread.is_started():
		players_thread.wait_to_finish()
	
	players_thread.start(func(): chapterPlayers.Save(get_slot()))
