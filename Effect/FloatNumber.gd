extends Position2D

var text = ""

var velocity = Vector2.ZERO
var graavity = Vector2.ZERO
var mass = 20
var is_skill = false

func _ready():
	if is_skill:
		$Label.rect_scale = Vector2(1.8,1.8)
		z_index = 1
	graavity = Vector2(0,rand_range(1.0,1.3))
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

func setSkill(_is_skill):
	is_skill = _is_skill

func set_number(number,color):
	$Label.text = str(number)
	$Label.set("custom_colors/font_outline_modulate",color)

func _on_Tween_tween_all_completed():
	get_tree().queue_delete(self)
