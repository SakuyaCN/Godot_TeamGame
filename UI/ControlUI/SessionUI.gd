extends Control

var session = null

func _ready():
	reload()

func reload():
	session = ConstantsValue.GodotNakama.isExpired()
	if session != null:
		$Label.text = "已登录账号：\n \n%s" %session.username
		$Button.text = "退出登录"
		$pwd.visible = false
		$email.visible = false
	else:
		$Label.text = "账号登录"
		$Button.text = "注册/登录"
		$pwd.visible = true
		$email.visible = true

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()

func _on_Button_pressed():
	if session != null:
		logout()
		return
	if $email.text == "":
		ConstantsValue.showMessage("请输入邮箱",2)
		return
	if $pwd.text == "":
		ConstantsValue.showMessage("请输入密码",2)
		return
	if $pwd.text.length() < 6:
		ConstantsValue.showMessage("密码长度不得低于6位",2)
		return
	var session :NakamaSession= yield(ConstantsValue.GodotNakama.registerOrLogin($email.text,$pwd.text),"completed")
	if session.exception != null:
		match session.exception.grpc_status_code:
			3:ConstantsValue.showMessage("邮箱格式不正确或密码长度太低！",2)
			16:ConstantsValue.showMessage("邮箱或密码不正确！",2)
	else:
		ConfigScript.setValueSetting("user","username",session.username)
		ConfigScript.setValueSetting("user","user_id",session.user_id)
		ConfigScript.setValueSetting("user","token",session.token)
		ConstantsValue.configUserReload()
		ConstantsValue.showMessage("账号登录成功！",2)
		get_parent().auto_login()
		queue_free()

func logout():
	ConfigScript.setValueSetting("user","username",null)
	ConfigScript.setValueSetting("user","user_id",null)
	ConfigScript.setValueSetting("user","token",null)
	ConstantsValue.configUserReload()
	ConstantsValue.showMessage("退出成功！",2)
	get_parent().auto_login()
	reload()

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
