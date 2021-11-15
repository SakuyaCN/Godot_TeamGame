class_name SkillStateBean

var state_name:String
var state_num:float
var state_lv:int
var state_type = Utils.BuffEnum.NOR
var state_img:String
var state_time :int

func _create(dict:Dictionary):
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
