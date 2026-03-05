## Classe que armazena as configurações do jogo.
##
## Inclui volume de efeitos, música, preferências de jogabilidade
## e idioma selecionado.
class_name ConfigResource extends Resource

## Volume dos efeitos sonoros (0-100).
var sound_effects: float = 100.0

## Volume da música (0-100).
var music: float = 100.0

## Se verdadeiro, o jogo executa automaticamente (auto-run).
var auto_run: bool = false

## Se verdadeiro, mostra o fps na tela.
var fps_bool: bool = false

## Porcentagem de visibilidade do hub.
var hub: int = 100

## Idioma selecionado no jogo (por padrão "pt").
var idioma: String = "pt"

## Dicionário dos saves atuais do jogo.
var saves: Dictionary[int, String] = {
	1: "",
	2: "",
	3: "",
	4: "",
	5: "" }

## Lista de conquistas desbloqueadas.
var Conquistas: Array[StringName] = []
