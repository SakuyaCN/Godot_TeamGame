extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_first = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect/bgm.pressed = ConfigScript.getBoolSetting("setting","audio")
	$NinePatchRect/auto_fight.pressed = ConfigScript.getBoolSetting("fight","auto_fight")
	$NinePatchRect/fight_num.pressed = ConfigScript.getBoolSetting("fight","fight_num")
	$NinePatchRect/equ_c.pressed = ConstantsValue.fight_array.has("C级")
	$NinePatchRect/equ_b.pressed = ConstantsValue.fight_array.has("B级")
	$NinePatchRect/equ_a.pressed = ConstantsValue.fight_array.has("A级")
	$NinePatchRect/equ_s.pressed = ConstantsValue.fight_array.has("S级")
	is_first = true


func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

#bgm
func _on_bgm_toggled(button_pressed):
	ConfigScript.setBoolSetting("setting","audio",button_pressed)
	if is_first:
		get_tree().call_group("Game","isPlayMusic")

#自动战斗
func _on_auto_fight_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","auto_fight",button_pressed)


func _on_fight_num_toggled(button_pressed):
	ConfigScript.setBoolSetting("fight","fight_num",button_pressed)
	ConstantsValue.updateFightNum()


func _on_equ_toggled(button_pressed, extra_arg_0):
	if is_first:
		if ConstantsValue.fight_array.has(extra_arg_0):
			ConstantsValue.fight_array.erase(extra_arg_0)
		else:
			ConstantsValue.fight_array.append(extra_arg_0)
		ConfigScript.setArraySetting("fight","fight_array",ConstantsValue.fight_array)
