extends Control

var invItem = preload("res://UI/ItemUI/invItem.tscn")

var equ_data

var discard_count = 0
var choose_id = null
var choose_seal = null

signal seal_choose()

func _ready():
	$NinePatchRect/ScrollContainer.get_v_scrollbar().set("custom_styles/scroll",StyleBoxTexture.new())
	$Item.visible = false

func showBox(_equ_data = null):
	equ_data = _equ_data
	if _equ_data == null:
		$Item/Button.visible = false
		$Label.visible = false
		$Item2.visible = false
	else:
		loadEquSeal()
	loadBox()
	if StorageData.get_player_seal().size() == 0:
		$Label.visible = true
		$Label.text = "你还没有任何一个刻印"

func loadEquSeal():
	$Item2/RichTextLabel.clear()
	if equ_data != null && equ_data.keys().has("seal"):
		for attr in equ_data.seal:
			$Item2/RichTextLabel.append_bbcode(EquUtils.get_attr_string(attr.keys()[0]))
			$Item2/RichTextLabel.append_bbcode(" %s" %[attr.values()[0]])
			$Item2/RichTextLabel.append_bbcode("\n")

func loadBox():
	for item in $NinePatchRect/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	$NinePatchRect/ScrollContainer/GridContainer.get_children().clear()
	for item in StorageData.get_player_seal():
		var data = StorageData.get_player_seal()[item]
		if data != null:
			var inv = invItem.instance()
			inv.setSeal(data.img)
			inv.connect("pressed",self,"item_pressed",[item,data])
			$NinePatchRect/ScrollContainer/GridContainer.add_child(inv)

func item_pressed(_id,_data):
	choose_id = _id
	choose_seal = _data
	if !$Item.visible:
		$AnimationPlayer.play("show")
	$Item/RichTextLabel.clear()
	$Item/RichTextLabel.append_bbcode(_data.info+"\n")
	if _data.keys().has("attr"):
		for attr in _data.attr:
			$Item/RichTextLabel.append_bbcode(EquUtils.get_attr_string(attr))
			$Item/RichTextLabel.append_bbcode(" %s - %s" %[_data.attr[attr][0],(_data.attr[attr][1])as int])
			$Item/RichTextLabel.append_bbcode("\n")

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

#丢弃刻印
func _on_Button2_pressed():
	discard_count += 1
	if discard_count == 2:
		if choose_id != null:
			$Item.visible = false
			StorageData.get_player_seal().erase(choose_id)
			StorageData._save_storage()
			showBox(equ_data)
	else:
		ConstantsValue.showMessage("再点一次确认丢弃刻印",1)
	yield(get_tree().create_timer(1),"timeout")
	discard_count = 0

#添加刻印
func _on_Button_pressed():
	if StorageData.get_player_seal().has(choose_id):
		if equ_data != null && choose_seal != null:
			if equ_data.seal.size() == 2:
				ConstantsValue.showMessage("装备最多添加2条刻印",2)
				return
			if equ_data.lv >= choose_seal.lv:
				if choose_seal.keys().has("attr"):
					$Item.visible = false
					StorageData.get_player_seal().erase(choose_id)
					var randnum = randi()%choose_seal.attr.size()
					var base = choose_seal.attr.keys()[randnum]
					equ_data.seal.append({
							base:(rand_range(choose_seal.attr[base][0],choose_seal.attr[base][1])) as int
						})
					StorageData._save_storage()
					showBox(equ_data)
					emit_signal("seal_choose")
			else:
				ConstantsValue.showMessage("装备等级不足，无法安装刻印",1)

#移除刻印
func _on_Button3_pressed():
	discard_count += 1
	if discard_count == 2:
		if equ_data != null:
			equ_data.seal = []
			StorageData._save_storage()
			ConstantsValue.showMessage("已将装备刻印属性擦除",1)
			emit_signal("seal_choose")
			loadEquSeal()
	else:
		ConstantsValue.showMessage("再点一次确认擦除刻印",1)
	yield(get_tree().create_timer(1),"timeout")
	discard_count = 0
