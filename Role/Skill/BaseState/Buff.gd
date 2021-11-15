extends BaseState

func addBuff():
	.addBuff()
	hero_attr.atk += state_bean.state_num

func _destroy():
	._destroy()
	hero_attr.atk -= state_bean.state_num
