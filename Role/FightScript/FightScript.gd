extends Node


var fight_role_array = [] setget setFightRole#战斗对象
var role_data #当前人物属性

func _ready():
	pass # Replace with function body.

func setFightRole(f_r):
	fight_role_array = f_r
	get_parent().changeAnim("Atk")
