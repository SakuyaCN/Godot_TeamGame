extends Button

var inv_name = null

func setData(_name,info):
	inv_name = _name
	$Sprite/TextureRect.texture = load(info[1])
	if info[0] > 0:
		$Sprite/Label.visible = true
		$Sprite/Label.text = str(info[0] as int)
