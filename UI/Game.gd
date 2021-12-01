extends Node2D

onready var UiLayer = $UILayer
onready var UiCotrol = $UILayer/Control
onready var px_bg = $PxBg
onready var gameMain = $GameMain
onready var light = $Light

onready var chat_room = preload("res://UI/ControlUI/ChatRoom.tscn")

onready var game_main = $GameMain

func _init():
	LocalData.do_load()

func _ready():
	$UILayer/chat.get_v_scroll().set("custom_styles/scroll",StyleBoxTexture.new())
	isPlayMusic()
	ConstantsValue.tree = get_tree()
	var http = GodotHttp.new()
	http.http_get("static")
	http.connect("http_res",self,"http_res")
	#isNewUser()
	OS
	randomize()

func start_game():
	$UILayer/chat.visible = true
	ConstantsValue.connect("on_chat_message",self,"_on_chat_message")
	$Chat.connet_server()
	$PxBg.hide()
	game_main.load_map()
	UiCotrol.main_ui.showui()
	game_main.go_position()
	ConstantsValue.showMessage("点击人物可以展示属性面板",3)
	#StorageData.AddGoodsNum([["招募令碎片",10],["神秘之石",10000],["暗蓝星矿",10000],["青岚铁矿",10000],["秘银矿石",10000],["绿色陨铁",10000]])

func isPlayMusic():
	if ConfigScript.getBoolSetting("setting","audio"):
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()

func isNewUser():
	if !ConfigScript.getBoolSetting("http","is_post_uuid"):
		ConfigScript.setBoolSetting("http","is_post_uuid",true)

func http_res(url,data):
	ConstantsValue.static_goods = data.data

#聊天信息定时变暗
func _on_Timer_timeout():
	$UILayer/chat.modulate.a = 0.2

func _on_chat_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$UILayer.ui.add_child(chat_room.instance())

#接受聊天信息
func _on_chat_message(_data):
	$UILayer/chat.modulate.a = 0.7
	$UILayer/chat/Timer.stop()
	$UILayer/chat/Timer.start()
	$UILayer/chat.bbcode_text += "%s： %s\n" %[_data.nickname,_data.msg]
