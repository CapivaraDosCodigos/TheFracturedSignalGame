extends Node
class_name Manager

static var CurrentState: Game.States = Game.States.MAP

var PlayersAtuais: Dictionary[String, PlayerResource] = {}

var Chapter: ChapterResource
var CurrentCapitulo: int = -1
var CurrentSlot: int = -1

func _ready() -> void:
	GlobalEvents.set_state.connect(set_state)
	GlobalEvents.save_game.connect(Save)
	GlobalEvents.game_over.connect(Game_Over)
	GlobalEvents.return_to_title.connect(Return_To_Title)

func _clear() -> void:
	Chapter = null
	PlayersAtuais.clear()
	CurrentSlot = -1
	CurrentCapitulo = -1

static func is_state(state: Game.States) -> bool:
	return CurrentState == state

func set_state(state: Game.States) -> void:
	await get_tree().process_frame
	CurrentState = state

func Save() -> void:
	await get_tree().process_frame
	Chapter.Save(CurrentSlot)

func Start_Save(slot: int = CurrentSlot, capitulo: int = CurrentCapitulo) -> void:
	await get_tree().process_frame
	_clear()
	
	Chapter = ChapterResource.new()
	var success = Chapter.Load(slot, capitulo)
	
	if Chapter == null or not success:
		Return_To_Title()
		return
	
	CurrentSlot = slot
	CurrentCapitulo = capitulo
	PlayersAtuais = Chapter.get_players()
	
	for player: PlayerResource in PlayersAtuais.values():
		player.setup_stats()
	
	if not Game.DEBUG:
		if not Chapter.chapterLocation.CurrentScene == "":
			SceneManager.load_scene(Chapter.chapterLocation.CurrentScene)
		else:
			SceneManager.load_scene(Chapter.StartScene)

func Game_Over() -> void:
	await get_tree().process_frame 
	
	var chapterPlayers: ChapterPlayersResource = ChapterPlayersResource.new()
	var success = chapterPlayers.Load(CurrentSlot, CurrentCapitulo)
	
	if not success:
		Return_To_Title()
		return
	
	Chapter.set_players_dict(chapterPlayers.Players)
	
	#get_tree().change_scene_to_file("res://Godot/Godot Cenas/dead.tscn")

func Return_To_Title() -> void:
	await get_tree().process_frame
	_clear()
	Global.end_game.call_deferred()
	#get_tree().change_scene_to_file("res://Godot/Godot Cenas/intro.tscn")


#@onready var audios: Dictionary[int , AudioPlayer] = { 1: $AudioPlayerS, 2: $AudioPlayerZ, 3: $AudioPlayer5 }
#@onready var fps_label: Label = %fps_label
#@onready var Menu: CanvasLayer = $MENU

#var NodeVariant: Node
#var textureD: Texture
#var Body: Node

#var ObjectPlayer: ObjectPlayer2D
#var CurrentBatalha: Batalha2D

#func _process(_delta):
	#fps_label.text = "FPS: %s" % [Engine.get_frames_per_second()]
	
#func get_Player(nome: String = CurrentPlayer) -> PlayerData:
	#if PlayersAtuais.has(nome):
		#return PlayersAtuais.get(nome)
	#push_error("Jogador '%s' não encontrado!" % nome)
	#return null
#
#func get_Inventory(nome: String = CurrentPlayer) -> Inventory:
	#var player: PlayerData = get_Player(nome)
	#return player.InventoryPlayer if player != null else null
#
#func add_player(nome: String) -> void:
	#if Data.Players.has(nome) and not PlayersAtuais.has(nome):
		#PlayersAtuais[nome] = Data.Players[nome]
#
#func erese_player(nome: String) -> void:
	#if PlayersAtuais.has(nome):
		#PlayersAtuais.erase(nome)

#func tocar_musica(DataAudio: DataAudioPlayer, canal: int = 1) -> void:
	#if audios.has(canal):
		#audios[canal].tocar(DataAudio)
	#else:
		#push_warning("Canal %s inexistente!" % canal)

#func StartBatalha(batalhaData: DataBatalha, pos: Vector2 = Vector2.ZERO):
	#await get_tree().process_frame
	#var instBatalha: Batalha2D = BATALHA_SCENE.instantiate()
	#tocar_musica(PathsMusic.SOUND_EFFECT_BATTLE_START_JINGLE)
	#batalhaData.dungeons2D.iniciar_batalha()
	#instBatalha.batalha = batalhaData
	#instBatalha.scale = Vector2(0.313, 0.313)
	#
	#instBatalha.global_position = pos - Vector2(576.0, 270.0)
	#CurrentBatalha = instBatalha
	#get_tree().root.add_child(instBatalha)

#func DialogoTexture(texture: String = ""):
	#textureD = load(texture) if texture != "" else null
