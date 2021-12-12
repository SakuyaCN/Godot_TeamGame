extends Control

onready var hero_item = preload("res://UI/ItemUI/HeroItem.tscn")
var role = preload("res://Role/Level_1Role.tscn")

func _ready():
	loadAllHero()

#载入小队成员
func loadAllHero():
	for ins in $ScrollContainer/HSlider.get_children():
		ins.queue_free()
	var array = StorageData.get_all_team().values()
	$ScrollContainer/HSlider.get_children().clear()
	array.sort_custom(self, "customComparison")
	for item in array:
		var ins = hero_item.instance()
		ins.setData(item)
		ins.setLv()
		ins.connect("pressed",self,"_select",[item,ins])
		$ScrollContainer/HSlider.add_child(ins)

func _select(_item,_ins):
	var ins = role.instance()
	get_parent().get_parent().player_array[0] = ins
	get_parent().get_parent().find_node("Position2D").add_child(ins)
	ins.set_role(_item)
	visible = false
	get_parent().get_parent().game_start()
	
