extends Control

onready var check_auto = $autoFight

func _ready():
	check_auto.pressed = ConfigScript.getBoolSetting("fight","auto_fight")
	visible = false

func UIchange(change):
	visible = change

#战斗开始点击
func _on_startFight_pressed():
	pass # Replace with function body.

func _on_autoFight_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","auto_fight",button_pressed)
