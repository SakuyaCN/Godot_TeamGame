extends TextureRect

signal item_delete()

var time_out

func setData(res,id,time):
	set_meta("id",id)
	texture = load(res)
	time_out = time
	$Timer.start()
	
func updateTime(time):
	time_out += time
	$Timer.stop()
	$Timer.start()

func _on_Timer_timeout():
	time_out -= 1
	if time_out <= 0:
		emit_signal("item_delete",get_meta("id"))
		print("aaaa")
