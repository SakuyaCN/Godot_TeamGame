extends Button

var inv_name = null

func setData(_name,info):
	inv_name = _name
	$Sprite/TextureRect.texture = load(LocalData.all_data["goods"][_name].image)
	if info > 0:
		$Sprite/Label.visible = true
		$Sprite/Label.text = str(info as int)
