extends BaseState

func addBuff():
	.addBuff()
	hero_attr.atk += num

func _destroy():
	._destroy()
	hero_attr.atk -= num
