extends Button

var inv_name = null

func setData(_name,info):
	$AnimationPlayer.play("show")
	inv_name = _name
	if inv_name != null:
		$Label2.text = inv_name
		$Sprite/TextureRect.texture = load(LocalData.all_data["goods"][_name].image)
	else:
		$Sprite/TextureRect.texture = null
	if info > 0:
		$Sprite/Label.visible = true
		$Sprite/Label.text = str(info as int)
	else:
		$Sprite/Label.visible = false

func setSeal(img):
	$Sprite/TextureRect.texture = load(img)
