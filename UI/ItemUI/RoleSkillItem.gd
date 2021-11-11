extends Control

export(String) var type

var local_data:Dictionary

var is_emp = true

func _ready():
	pass

func setData(_local_data):
	local_data = _local_data
	reLoad()
	
func reLoad():
	if !local_data.empty():
		is_emp = false
		$Image.texture = load(local_data["image"])
		$Name.text = local_data["name"]
	else:
		is_emp = true
		$Image.texture = load("res://Texture/Assets-2(Scale-x2)-No-BG_15.png")
		$Name.text = "空技能"
