extends NinePatchRect

func setData(_name,image,q):
	if q != "":
		$name.set('custom_colors/font_color', EquUtils.get_quality_color(q))
	$name.text = _name
	$TextureRect.texture = load(image)
	$AnimationPlayer.play("show")

func _on_Timer_timeout():
	$AnimationPlayer.play_backwards("show")
	yield($AnimationPlayer,"animation_finished")
	get_tree().queue_delete(self)
