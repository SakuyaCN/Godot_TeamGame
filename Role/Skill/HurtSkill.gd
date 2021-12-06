extends Node

class_name HurtSkill

var skillbean:SkillHurtBean
var role#技能接收者
var who#技能施加者

func _ready():
	set_process(false)
	set_physics_process(false)
	pass

func _create(_role,_who,_skillbean):
	skillbean = _skillbean
	role = _role
	who = _who
	_role.skill_script.add_child(self)
	_who.call_deferred("_show_damage_label",skillbean.hurt_name,Utils.HurtType.OTHER)
	match skillbean.hurt_mode as int:
		Utils.SkillHurtEnum.NUMBER:
			call_hurt(skillbean.hurt_num)
		Utils.SkillHurtEnum.PT_ATTR_ON:
			var hurt_num = who.hero_attr.toDict()[skillbean.hurt_attr] * (skillbean.hurt_num / 100.0)
			call_hurt(hurt_num)
		Utils.SkillHurtEnum.PT_ATTR_OT:
			var hurt_num = role.hero_attr.toDict()[skillbean.hurt_attr] * (skillbean.hurt_num / 100.0)
			call_hurt(hurt_num)
			

#设置伤害
func call_hurt(hurt):
	if skillbean.hurt_count <= 1:
		role.fight_script.do_number_hurt(hurt,skillbean.hurt_type,who.hero_attr,false)
	else:
		for count in range(skillbean.hurt_count):
			role.fight_script.do_number_hurt(hurt,skillbean.hurt_type,who.hero_attr,false)
			yield(get_tree().create_timer(skillbean.hurt_count_time),"timeout")
	queue_free()

func _destroy():
	pass
