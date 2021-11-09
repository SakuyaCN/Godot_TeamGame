extends Node2D

onready var UiLayer = $UILayer
onready var UiCotrol = $UILayer/Control
onready var px_bg = $PxBg
onready var gameMain = $GameMain
onready var light = $Light

onready var game_main = $GameMain

func _ready():
	pass

func start_game():
	$PxBg.hide()
	game_main.load_map()
	UiCotrol.main_ui.showui()
	game_main.go_position()
	ConstantsValue.ui_layer.showMessage("点击人物可以展示属性面板",5)
