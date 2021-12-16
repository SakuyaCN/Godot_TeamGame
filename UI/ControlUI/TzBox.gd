extends Control

var invItem = preload("res://UI/ItemUI/invItem.tscn")

var equ_data

var discard_count = 0
var choose_id = null
var choose_seal = null
var choose_tz = null

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
	if StorageData.get_player_tz().size() == 0:
		$Label.visible = true
		$Label.text = "你还没有任何一个套装"

func loadEquSeal():
	$Item2/RichTextLabel.clear()
	if equ_data != null && equ_data.keys().has("tz"):
		$Item2/RichTextLabel.append_bbcode(equ_data.tz.name)

func loadBox():
	for item in $NinePatchRect/ScrollContainer/GridContainer.get_children():
		item.queue_free()
	$NinePatchRect/ScrollContainer/GridContainer.get_children().clear()
	for item in StorageData.get_player_tz():
		var data = LocalData.tz_data[StorageData.get_player_tz()[item].id]
		if data != null:
			var inv = invItem.instance()
			inv.setSeal(data.img)
			inv.connect("pressed",self,"item_pressed",[item,data,])
			$NinePatchRect/ScrollContainer/GridContainer.add_child(inv)

func item_pressed(_id,_data):
	choose_id = _id
	choose_seal = _data
	if !$Item.visible:
		$AnimationPlayer.play("show")
	$Item/RichTextLabel.clear()
	if _data.has("attr"):
		$Item/RichTextLabel.append_bbcode("%s\n" %_data.name)
		$Item/RichTextLabel.append_bbcode(EquUtils.getTzInfo(_data.attr))
			

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().queue_delete(self)

#丢弃刻印
func _on_Button2_pressed():
	discard_count += 1
	if discard_count == 2:
		if choose_id != null:
			$Item.visible = false
			StorageData.get_player_tz().erase(choose_id)
			StorageData._save_storage()
			showBox(equ_data)
	else:
		ConstantsValue.showMessage("再点一次确认丢弃套装",1)
	yield(get_tree().create_timer(1),"timeout")
	discard_count = 0

#添加刻印
func _on_Button_pressed():
	if StorageData.get_player_tz().has(choose_id):
		if equ_data != null && choose_seal != null:
			if equ_data.lv >= choose_seal.lv:
				if choose_seal.has("attr"):
					$Item.visible = false
					equ_data.tz = StorageData.get_player_tz()[choose_id]
					StorageData.get_player_tz().erase(choose_id)
					StorageData._save_storage()
					showBox(equ_data)
					emit_signal("seal_choose")
			else:
				ConstantsValue.showMessage("装备等级不足，无法附魔套装",1)
