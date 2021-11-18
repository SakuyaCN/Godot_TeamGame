extends BaseState

#BUFF移除
func _destroy():
	role.call_deferred("removeState",state_bean.state_id)

#触发BUFF效果
func addBuff():
	role.call_deferred("_show_damage_label",state_bean.state_name,Utils.HurtType.OTHER)
