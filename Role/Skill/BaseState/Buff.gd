extends BaseState

func addBuff():
	.addBuff()
	updateAttr(false)

func _destroy():
	._destroy()
	updateAttr(true)

func updateAttr(is_over):
	var num = state_bean.state_num
	if state_bean.state_mold == Utils.BuffModeEnum.DEBUFF:
		num = 0 - num
	if is_over:
		num = 0 - num
	hero_attr.updateNum(state_bean.state_type,num)
