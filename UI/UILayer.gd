extends CanvasLayer

onready var msg = $msg
onready var msgTimer = $msg/Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	ConstantsValue.ui_layer = self
	msg.hide()

func showMessage(text:String,time = 2):
	if !msgTimer.is_stopped():
		msgTimer.stop()
	msgTimer.start(time)
	msg.text = text
	msg.show()

func _on_Timer_timeout():
	msg.hide()
