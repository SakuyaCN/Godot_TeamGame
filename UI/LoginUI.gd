extends Control

onready var parent = get_parent()

var save_key = ""

func _ready():
	if !ConstantsValue._is_start:
		visible = true
	yield(get_tree().create_timer(0.2),"timeout")
	auto_login()
	
func auto_login():
	var invalid_authtoken = ConstantsValue.user_info.token
	if invalid_authtoken != null:
		var restored_session = ConstantsValue.GodotNakama.isExpired()
		if restored_session != null:
			ConstantsValue.showMessage("自动登录成功！",2)
			showClound()
		else:
			ConstantsValue.showMessage("登录已过期，请重新登录！",2)
			ConfigScript.setValueSetting("user","username",null)
			ConfigScript.setValueSetting("user","user_id",null)
			ConfigScript.setValueSetting("user","token",null)
			ConstantsValue.configUserReload()
			$NinePatchRect.visible = false

func showClound():
	$NinePatchRect.visible = true
	var list = yield(ConstantsValue.GodotNakama.listStorageKeys(),"completed")
	if list != null:
		var entity = parse_json(list.value)
		$NinePatchRect/clound.text = "当前云端存档：%s\n"%str(entity.size())
		$NinePatchRect/clound.text += "更新时间：%s\n"%list.update_time
		save_key = entity["key_1"]
	else:
		$NinePatchRect/clound.text = "暂无云存档"

func _on_Button2_pressed():
	get_tree().quit(0)

func _on_Button_pressed():
	if StorageData.storage_data["player_state"].empty():
		parent.create_ui.show()
	else:
		parent.get_parent().get_parent().start_game()
	hide()

#创意编辑
func _on_Button3_pressed():
	var login_ui = preload("res://UI/ControlUI/SessionUI.tscn")
	add_child(login_ui.instance())

func _on_NinePatchRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$NinePatchRect.visible = false

func _on_NinePatchRect2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$NinePatchRect2.visible = false

#下载存档
func _on_download_pressed():
	if save_key != "":
		var http = GodotHttp.new()
		http.connect("http_res",self,"_download_result")
		var query = JSON.print({
			"uuid":ConstantsValue.user_info.user_id,
			"save_id": save_key,
			"type":"download"
		})
		http.http_post("/storage/count",query)
	else:
		ConstantsValue.showMessage("没有找到云存档！",2)

#存档上传 
func _on_download2_pressed():
	if StorageData.get_player_state().has("save_id"):
		var http = GodotHttp.new()#检测存档是否属于该账号
		http.connect("http_res",self,"_has_result")
		var query = JSON.print({
			"uuid":ConstantsValue.user_info.user_id,
			"save_id": str(StorageData.get_player_state().save_id)
		})
		http.http_post("/storage/has",query)
	else:
		ConstantsValue.showMessage("当前还没创建存档！",2)

#检测存档是否属于该账号
func _has_result(url,data):
	if data.data.is_save:
		var http = GodotHttp.new()
		http.connect("http_res",self,"_upload_result")
		var query = JSON.print({
			"uuid":ConstantsValue.user_info.user_id,
			"save_id": str(StorageData.get_player_state().save_id),
			"type":"upload"
		})
		http.http_post("/storage/count",query)
	else:
		ConstantsValue.showMessage("此存档已绑定其他账号！",2)

func _upload_result(url,data):
	if data.data.is_save:
		yield(ConstantsValue.GodotNakama.postStorage(),"completed")
		ConstantsValue.showMessage("存档上传成功！",2)
		showClound()
	else:
		ConstantsValue.showMessage("上传次数不足,请隔日再来!",2)

func _download_result(url,data):
	if data.data.is_save:
		$ColorRect2.visible = true
		var result = yield(ConstantsValue.GodotNakama.getStorage(save_key),"completed")
		if result != null:
			StorageData.storage_data = JSON.parse(result).result
			StorageData._save_storage()
			ConstantsValue.showMessage("存档恢复成功",2)
			$ColorRect2/Label.text = "恢复成功，请重新启动游戏！"
			get_tree().paused = true
	else:
		ConstantsValue.showMessage("下载次数不足,请隔日再来!",2)
