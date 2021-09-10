extends CanvasLayer

onready var msg = $msg
onready var msgTimer = $msg/Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	msg.hide()

func showMessage(text:String):
	msgTimer.start()
	msg.text = text
	msg.show()


func _on_Timer_timeout():
	msg.hide()
