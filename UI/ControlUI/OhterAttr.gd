extends Control

func _ready():
	$NinePatchRect/RichTextLabel.get_v_scroll().set("custom_styles/scroll",StyleBoxTexture.new())

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

func showAttr(node,hero_attr:HeroAttrBean):
	node.add_child(self)
	var all_attr = hero_attr.toDict()
	for item in all_attr:
		$NinePatchRect/RichTextLabel.append_bbcode(EquUtils.get_attr_string(item))
		$NinePatchRect/RichTextLabel.append_bbcode(" %s" %[all_attr[item]])
		$NinePatchRect/RichTextLabel.append_bbcode("\n")
