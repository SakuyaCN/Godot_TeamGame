extends CanvasLayer

onready var msg = $msg
onready var msgTimer = $msg/Timer
onready var effect_click = preload("res://Effect/ClickEffect.tscn")
onready var get_new_item = preload("res://UI/ItemUI/GetNewItem.tscn")

onready var add_box = $addBox
onready var ui = find_node("Control")

func _init():
	ConstantsValue.ui_layer = self
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	$ItemShow.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	msg.hide()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var ins = effect_click.instance()
		ins.global_position = event.position
		add_child(ins)

func showMessage(text:String,time = 2):
	if !msgTimer.is_stopped():
		msgTimer.stop()
	msgTimer.start(time)
	msg.text = text
	msg.show()

func _on_Timer_timeout():
	msg.hide()

func fight_fail():
	$GameResult.visible = true
	$GameResult/fail.visible = true
	$GameResult/Timer.start()
	
func fight_win(_label):
	$GameResult.visible = true
	$GameResult/win.visible = true
	$GameResult/win/Label2.text = _label
	$GameResult/Timer.start()

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$GameResult/Timer.stop()
		$GameResult.visible = false
		$GameResult/win.visible = false
		$GameResult/fail.visible = false
		get_tree().call_group("game_main","game_reset")

#展示物品简介
func showTips(node:Node,tv):
	$Tips.text = tv
	$Tips.visible = true
	$Tips.set_global_position(Vector2(node.get_global_position().x - ($Tips.rect_size.x / 2) + (node.rect_size.x/2),node.get_global_position().y - $Tips.rect_size.y))

func closeTips():
	$Tips.visible = false
	
#获取新物品时提示
func getNewItem(_name,img,q = ""):
	print("aaaaaaaaa")
	var ins = get_new_item.instance()
	ins.setData(_name,img,q)
	$ItemShow/VBoxContainer.add_child_below_node($ItemShow/VBoxContainer/Label,ins)

#=================================

var item_count = 0
var new_count = 0
var loader:ResourceInteractiveLoader

func change_scene(res):
	$GameProgress.visible = true
	loader =  ResourceLoader.load_interactive(res)
	item_count = loader.get_stage_count()
	set_process(true)
	#$GameProgress/pg.text = str(pg) +"%"

func _process(time):
	new_count = loader.get_stage()
	loader.poll()
	
	$GameProgress/pg.text = str(new_count % item_count)
	
	if loader.get_resource():
		set_process(false)
		#ConstantsValue.online_data = get_parent().gameMain.player_array[0].role_data
		#ConstantsValue.online_attr = HeroAttrUtils.reloadHeroAttr(null,get_parent().gameMain.player_array[0].role_data)
		loader.get_resource()
		$GameProgress.visible = false
		get_tree().change_scene_to(loader.get_resource())
