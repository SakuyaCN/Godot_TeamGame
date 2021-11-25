extends Control

var local_data:Dictionary
var skill_data


func setData(_local_data):
	local_data = _local_data
	reLoad()
	
func reLoad():
	$Image.texture = load(local_data["image"])
	$Name.text = local_data["skill_name"]
