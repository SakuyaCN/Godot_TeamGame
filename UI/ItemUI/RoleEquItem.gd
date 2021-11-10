extends Control

export(String) var type

var local_data

var is_emp = true
var is_vis = true

func _ready():
	$Name.text = type

func _process(delta):
	pass
	#print("mouse",get_global_mouse_position())

func setData(_local_data):
	local_data = _local_data
	reLoad()

func setNameVis(is_vis):
	self.is_vis = is_vis
	
func reLoad():
	if local_data != null && !local_data.empty():
		is_emp = false
		$Image.texture = load(local_data["image"])
		$Name.text = local_data["name"]
	else:
		is_emp = true
		$Image.texture = load("res://Texture/Assets-2(Scale-x2)-No-BG_15.png")
		$Name.text = type
	if !is_vis:
		$Name.visible = false
		
