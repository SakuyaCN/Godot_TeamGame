extends Position2D

var text = ""

var velocity = Vector2.ZERO
var graavity = Vector2.ZERO
var mass = 20

func _ready():
	graavity = Vector2(0,rand_range(1.0,1.5))
	$Tween.interpolate_property(self,"modulate",
	Color(self.modulate.r,self.modulate.g,self.modulate.b,self.modulate.a),
	Color(self.modulate.r,self.modulate.g,self.modulate.b,0),
	0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT,0.7)
	
	$Tween.interpolate_property(self,"scale",
	Vector2(0,0),
	Vector2(1,1),
	0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	
	$Tween.interpolate_property(self,"scale",
	Vector2(1,1),
	Vector2(0.3,0.3),
	0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT,0.7)
	
	$Tween.start()
func _process(delta):
	velocity += graavity * mass * delta
	position += velocity * delta

func set_number(number,type):
	$Label.text = str(number)
	match type:
		0:$Label.set("custom_colors/font_outline_modulate",Color.brown)
		1:$Label.set("custom_colors/font_outline_modulate",Color.darkturquoise)
		2:$Label.set("custom_colors/font_outline_modulate",Color.black)

func _on_Tween_tween_all_completed():
	get_tree().queue_delete(self)
