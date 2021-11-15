class_name SkillStateBean

var state_id:int#状态类型id
var state_name:String#状态名称
var state_num:float#状态数值
var state_lv:int#状态等级
var state_type:String#状态属性类型
var state_mold = Utils.BuffModeEnum.BUFF#状态增益减益
var state_img:String#状态图片
var state_time :int#状态持续时间

func _create(dict:Dictionary):
	if dict.has("state_id"):
		state_id = dict["state_id"]
	if dict.has("state_name"):
		state_name = dict["state_name"]
	if dict.has("state_num"):
		state_num = dict["state_num"]
	if dict.has("state_lv"):
		state_lv = dict["state_lv"]
	if dict.has("state_type"):
		state_type = dict["state_type"]
	if dict.has("state_img"):
		state_img = dict["state_img"]
	if dict.has("state_time"):
		state_time = dict["state_time"]
	if dict.has("state_mold"):
		state_mold = dict["state_mold"]
