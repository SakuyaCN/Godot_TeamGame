extends Button

onready var _label = $Sprite/Label

func setSeal(_data):
	if _data != null:
		$Sprite/Label.text = _data.name
		$Sprite/TextureRect.frames = load(_data.res)
		$Sprite/TextureRect.animation = "Idle"
	else:
		$Sprite/Label.text = "选择助战"
		$Sprite/TextureRect.frames = null

func setLabel(lab):
	$Sprite/Label.text = lab
