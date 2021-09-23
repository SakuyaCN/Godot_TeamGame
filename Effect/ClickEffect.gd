extends Node2D

func _ready():
	$AnimatedSprite.play("default")
	yield($AnimatedSprite,"animation_finished")
	queue_free()
