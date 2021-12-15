extends Node

var is_showing = false
var singleton = null
signal AdSuccess()

func _ready():
	if Engine.has_singleton("GodotUtils"):
		singleton = Engine.get_singleton("GodotUtils")
		singleton.connect("onAdResult",self,"onAdResult")

func onAdResult(result):
	match result:
		"Show":
			pass
			get_tree().paused = true
		"Closed":
			is_showing = false
			get_tree().paused = false
		"Failed":
			ConstantsValue.showMessage("广告正在加载失败",2)
			is_showing = false
		"Success":
			emit_signal("AdSuccess")
			is_showing = false

func showAd():
	if is_showing || singleton == null:
		ConstantsValue.showMessage("广告正在加载",2)
		return
	singleton.showRewardVideoAD()
	is_showing = true
