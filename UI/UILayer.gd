extends CanvasLayer

onready var msg = $msg
onready var msgTimer = $msg/Timer
onready var effect_click = preload("res://Effect/ClickEffect.tscn")

onready var ui = $Control

# Called when the node enters the scene tree for the first time.
func _ready():
	ConstantsValue.ui_layer = self
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
	
func fight_win():
	$GameResult.visible = true
	$GameResult/win.visible = true

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$GameResult/Timer.stop()
		$GameResult.visible = false
		$GameResult/win.visible = false
		$GameResult/fail.visible = false
		get_tree().call_group("game_main","game_reset")

