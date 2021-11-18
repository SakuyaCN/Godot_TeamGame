extends BaseState

func _destroy():
	updateAttr(true)
	get_tree().call_group("RoleUI","load_attr")
	role.call_deferred("removeState",state_bean.state_id)

#触发BUFF效果
func addBuff():
	updateAttr(false)
	get_tree().call_group("RoleUI","load_attr")
	role.call_deferred("_show_damage_label",state_bean.state_name,Utils.HurtType.OTHER)

func updateAttr(is_over):
	var num = state_bean.state_num
	if state_bean.state_mold == Utils.BuffModeEnum.DEBUFF:
		num = 0 - num
	if is_over:
		num = 0 - num
	hero_attr.updateNum(state_bean.state_type,num)
