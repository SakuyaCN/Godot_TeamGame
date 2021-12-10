extends Control

var array = [null,null,null]

var is_connect =false

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

#判断是否一件放满了
func isFull():
	for item in array:
		if item == null:
			return false
	return true

#获取任意一件进行对比
func getAny():
	for item in array:
		if item != null:
			return item
	return null

#进行等级对比
func isLvHas(_equ_data):
	var any = getAny()
	if any == null:
		return true
	elif any.lv == _equ_data.lv:
		return true
	else:
		return false

func is_inArray(_equ_data):
	for item in array:
		if _equ_data == item:
			return true
	return false

func addEqu(_equ_data):
	if is_inArray(_equ_data):
		ConstantsValue.showMessage("这件装备已经放入融合装置了！",2)
		return
	if !isLvHas(_equ_data):
		ConstantsValue.showMessage("请放入相同等级的装备！",2)
		return
	var is_max = true
	for i in range(array.size()):
		if array[i] == null:
			array[i] = _equ_data
			is_max = false
			reload()
			return
	if is_max:
		ConstantsValue.showMessage("已经放满了！",1)

func reload():
	for i in range(array.size()):
		if !is_connect:
			$NinePatchRect/GridContainer.get_children()[i].connect("pressed",self,"_remove_equ",[i])
		$NinePatchRect/GridContainer.get_children()[i].setData(array[i])
	is_connect = true

func _remove_equ(_index):
	array[_index] = null
	reload()

func _remove_all():
	for i in range(array.size()):
		array[i] = null
	reload()

func _on_Button_pressed():
	if isFull():
		$ColorMax.visible = true
		var any = getAny()
		for item in array:
			StorageData.get_player_equipment().erase(item.id)
		var build_data = LocalData.build_data["build_data"][any.build_type][any.build_id]
		var equ = EquUtils.createNewEqu(any.build_id,any.build_type,build_data,build_data.type,true,true)
		$NinePatchRect/Main.setData(equ)
		_remove_all()
		reload()
		$NinePatchRect/Main/Name.text += "【%s】"%equ.quality
		yield(get_tree().create_timer(0.3),"timeout")
		$ColorMax.visible = false
	else:
		ConstantsValue.showMessage("请放满3件装备!",2)
