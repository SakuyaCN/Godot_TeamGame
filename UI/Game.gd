extends Node2D

onready var UiLayer = $UILayer
onready var UiCotrol = $UILayer/Control
onready var px_bg = $PxBg
onready var gameMain = $GameMain
onready var light = $Light

onready var game_main = $GameMain

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_game():
	$PxBg.hide()
	game_main.load_map()
	UiCotrol.main_ui.showui()
	game_main.go_position()
