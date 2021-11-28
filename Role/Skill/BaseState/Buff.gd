extends BaseState

func _destroy():
	updateAttr(true)
	get_tree().call_group("RoleUI","load_attr")
	role.call_deferred("removeState",state_bean.state_id)

#触发BUFF效果
func addBuff():
	updateAttr()
	get_tree().call_group("RoleUI","load_attr")
	role.call_deferred("_show_damage_label",state_bean.state_name,Utils.HurtType.OTHER)

func updateAttr(_is_over = false):
	var num = state_bean.state_num
	if state_bean.state_type == "all":
		for item in hero_attr.toDict():
			var item_num = hero_attr.toDict()[item] * (num / 100.0)
			if _is_over:
				item_num = 0 - item_num
			hero_attr.updateNum(item,item_num,true,true)
	else:
		if state_bean.state_is_odd:
			num = hero_attr.toDict()[state_bean.state_type] * (num / 100.0)
		if _is_over:
			num = 0 - num
		hero_attr.updateNum(state_bean.state_type,num,true,true)
