extends CanvasLayer

#=================================

var item_count = 0
var new_count = 0
var loader:ResourceInteractiveLoader

func _ready():
	set_process(false)

func change_scene(res):
	$GameProgress.visible = true
	loader =  ResourceLoader.load_interactive(res)
	item_count = loader.get_stage_count()
	set_process(true)

func _process(time):
	new_count = loader.get_stage()
	loader.poll()
	
	$GameProgress/pg.text = str(new_count % item_count)
	
	if loader.get_resource():
		set_process(false)
		loader.get_resource()
		$GameProgress.visible = false
		get_tree().change_scene_to(loader.get_resource())

func _on_Button_pressed():
	change_scene("res://UI/Game.tscn")
