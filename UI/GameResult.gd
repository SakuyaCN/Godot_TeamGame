extends Control


func _on_Timer_timeout():
	$fail.visible = false
	$win.visible = false
	visible = false
	get_tree().call_group("game_main","game_reset")
