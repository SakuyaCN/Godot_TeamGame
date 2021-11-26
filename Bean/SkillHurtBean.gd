class_name SkillHurtBean

var hurt_id:String#伤害类型id
var hurt_name:String#伤害名称
var hurt_num:float#伤害数值
var hurt_type#伤害类型
var hurt_count :int#伤害次数
var hurt_attr#百分比伤害时类型 atk def
var hurt_mode = Utils.SkillHurtEnum.NUMBER #伤害规则类型 0 直接 1自身 2 敌人 属性百分比
var hurt_count_time:float

func _create(dict:Dictionary):
	hurt_id = str(OS.get_system_time_msecs()+ randi()%10000)
	if dict.has("hurt_name"):
		hurt_name = dict["hurt_name"]
	if dict.has("hurt_num"):
		hurt_num = dict["hurt_num"]
	if dict.has("hurt_type"):
		hurt_type = dict["hurt_type"]
	if dict.has("hurt_count"):
		hurt_count = dict["hurt_count"]
	if dict.has("hurt_mode"):
		hurt_mode = dict["hurt_mode"]
	if dict.has("hurt_attr"):
		hurt_attr = dict["hurt_attr"]
	if dict.has("hurt_count_time"):
		hurt_count_time = dict["hurt_count_time"]
