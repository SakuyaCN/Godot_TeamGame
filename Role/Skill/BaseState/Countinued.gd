extends BaseState

#BUFF移除
func _destroy():
	role.call_deferred("removeState",state_bean.state_id)

#触发BUFF效果
func addBuff():
	role.call_deferred("_show_damage_label",state_bean.state_name,Utils.HurtType.OTHER)

func time_tick():
	match state_bean.state_other["type"]:
		"number":#直接数字掉血
			role.fight_script.do_number_hurt(state_bean.state_other["hurt_num"],state_bean.state_other["hurt_type"],who.hero_attr,true)
		"pt_max":#最大生命值百分比掉血
			var hurt_num = state_bean.state_other["hurt_num"] / 100.0 * hero_attr.max_hp
			role.fight_script.do_number_hurt(hurt_num,state_bean.state_other["hurt_type"],who.hero_attr,true)
		"pt_now":#当前生命值百分比掉血
			var hurt_num = state_bean.state_other["hurt_num"] / 100.0 * hero_attr.hp
			role.fight_script.do_number_hurt(hurt_num,state_bean.state_other["hurt_type"],who.hero_attr,true)
		"ys":#元素伤害掉血
			var hurt_num = hero_attr.toDict()[state_bean.state_other["hurt_type"]]
			role.fight_script.do_number_hurt(hurt_num,state_bean.state_other["hurt_type"],who.hero_attr,true)
