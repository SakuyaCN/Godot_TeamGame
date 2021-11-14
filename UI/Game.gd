extends Node2D

onready var UiLayer = $UILayer
onready var UiCotrol = $UILayer/Control
onready var px_bg = $PxBg
onready var gameMain = $GameMain
onready var light = $Light

onready var game_main = $GameMain

func _ready():
	#var buff = load("res://Role/Skill/BaseState/Buff.gd").new()
	#buff._create(StateEnum.BuffEnum.BUFF_ATK,30,5)
	pass

func start_game():
	$PxBg.hide()
	game_main.load_map()
	UiCotrol.main_ui.showui()
	game_main.go_position()
	ConstantsValue.showMessage("点击人物可以展示属性面板",3)

