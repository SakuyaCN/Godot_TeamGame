extends NinePatchRect

func setData(_name,image):
	$name.text = _name
	$TextureRect.texture = load(image)
	$AnimationPlayer.play("show")


func _on_Timer_timeout():
	$AnimationPlayer.play_backwards("show")
	yield($AnimationPlayer,"animation_finished")
	queue_free()
