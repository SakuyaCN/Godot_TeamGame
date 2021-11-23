extends Control

onready var check_auto = $Fight_btn/autoFight

func _ready():
	check_auto.pressed = ConfigScript.getBoolSetting("fight","auto_fight")
	visible = false

func UIchange(change):
	visible = change
	$Fight_btn.visible = change
	if visible && check_auto.pressed:
		_on_startFight_pressed()

#战斗开始点击
func _on_startFight_pressed():
	get_tree().call_group("player_role","start_fight")
	get_tree().call_group("moster_role","start_fight")
	$Fight_btn.visible = false

func _on_autoFight_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","auto_fight",button_pressed)

