extends Control

func _ready():
	for _data in ConstantsValue.chat_array:
		$chat.bbcode_text += "%s： \n" %[_data.nickname]
		$chat.bbcode_text += "	%s\n" %[_data.msg]
	ConstantsValue.connect("on_chat_message",self,"_on_chat_message")

func _on_chat_message(_data):
	$chat.bbcode_text += "%s： \n" %[_data.nickname]
	$chat.bbcode_text += "	%s\n" %[_data.msg]

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()


func _on_Button_pressed():
	if $TextEdit.text == "":
		ConstantsValue.showMessage("请输入内容！",1)
		return
	if $TextEdit.text.length() > 20:
		ConstantsValue.showMessage("最多输入20个字符",1)
		return
	get_tree().call_group("chat","_on_seedData",$TextEdit.text)
	$TextEdit.text = ""
