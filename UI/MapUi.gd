extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func show_map():
	visible = true
	$AnimationPlayer.play("show")

func close_map():
	$AnimationPlayer.play_backwards("show")
	yield($AnimationPlayer,"animation_finished")
	visible = false


func _on_TextureButton_pressed():
	close_map()
