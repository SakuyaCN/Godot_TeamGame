extends ScrollContainer



var v = Vector2(0,0) #current velocity
var just_stop_under = 1
var multi = -2 #speed of one input
var is_grabbed = false

func _process(delta):
	v *= 0.3
	$HSlider.rect_position += v

func _on_ScrollContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			is_grabbed = event.pressed

	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_RIGHT: v.x += multi
			BUTTON_WHEEL_LEFT:  v.x -= multi
