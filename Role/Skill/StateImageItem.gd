extends TextureRect

signal item_delete()

var time_out

func setData(state:SkillStateBean):
	set_meta("id",state.state_id)
	texture = load(state.state_img)
	time_out = state.state_time
	$Timer.start()
	
func updateTime(state:SkillStateBean):
	if state.state_over:
		time_out += state.state_time
	else:
		time_out = state.state_time
	$Timer.stop()
	$Timer.start()

func _on_Timer_timeout():
	time_out -= 1
	if time_out <= 0:
		emit_signal("item_delete",get_meta("id"))
		print("aaaa")
