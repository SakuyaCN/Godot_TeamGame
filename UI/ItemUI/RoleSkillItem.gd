extends Control

export(String) var type

var local_data = null
var skill_role = null
var is_emp = true

func _ready():
	$Name.text = type

func setData(_local_data):
	local_data = _local_data
	reLoad()
	
func setSkill(_local_data,_skill_role):
	local_data = _local_data
	skill_role = _skill_role
	reLoad()

func reLoad():
	if local_data != null:
		is_emp = false
		$Image.texture = load(local_data["image"])
		$Name.text = local_data["skill_name"]
	else:
		is_emp = true
		$Image.texture = load("res://Texture/Assets-2(Scale-x2)-No-BG_15.png")
		$Name.text = type
