extends Button

onready var _label = $Sprite/Label

func setSeal(_data):
	$Sprite/Label.text = _data.name
	$Sprite/TextureRect.frames = load(_data.res)
