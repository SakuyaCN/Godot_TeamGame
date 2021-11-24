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
	ConstantsValue.showMessage("点击人物可以展示属性面板",3)
	#StorageData.AddGoodsNum([["红色陨铁",10000],["神秘之石",10000],["暗蓝星矿",10000],["青岚铁矿",10000],["秘银矿石",10000],["绿色陨铁",10000]])
