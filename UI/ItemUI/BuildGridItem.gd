extends Button

func setData(data):
	$TextureRect.texture = load(data.img)
	$Label.text = data.name
