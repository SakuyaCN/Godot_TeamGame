extends Control

onready var progress = $progress_hp
onready var progress_tv = $progress_hp/label_hp 

func _ready():
	visible = false

func showui():
	visible = true
	$AnimationPlayer.play("show")

func _on_map_pressed():
	if !get_parent().map_ui.visible:
		get_parent().map_ui.show_map()

func _on_chest_pressed():
	if !get_parent().bag_ui.visible:
		get_parent().bag_ui.bagChange(true)

func _on_party_pressed():
	if !get_parent().party_ui.visible:
		get_parent().party_ui.partyChange(true)


func _on_build_pressed():
	if !get_parent().build_ui.visible:
		get_parent().build_ui.buildChange(true)
