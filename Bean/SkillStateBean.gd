class_name SkillStateBean

var state_id:String#状态类型id
var state_name:String#状态名称
var state_num:float#状态数值
var state_lv:int#状态等级
var state_type#状态属性类型
var state_is_odd = false#是否为百分比
var state_mold = 0#Utils.BuffModeEnum.BUFF#状态增益减益
var state_img:String#状态图片
var state_time :int#状态持续时间
var state_over :bool#状态持续时间是否叠加
var state_other = {}#状态其他信息

func _create(dict:Dictionary):
	state_id = str(OS.get_system_time_msecs()+ randi()%10000)
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
	if dict.has("state_over"):
		state_over = dict["state_over"]
	if dict.has("state_other"):
		state_other = dict["state_other"]
	if dict.has("state_is_odd"):
		state_is_odd = dict["state_is_odd"]
