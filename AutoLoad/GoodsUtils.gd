extends Node

var box = preload("res://UI/ControlUI/BoxGoods.tscn")

func useGoods(_node:Node,_name,_num):
	match _name:
		"小队招募令":
			_node.bagChange(false)
			ConstantsValue.ui_layer.ui.create_ui.showCreate(true)
		"刻印收纳箱":
			ConstantsValue.showSealBox(null)
		"半小时挂机卡":
			if StorageData.UseGoodsNum([["半小时挂机卡",1]]):
				ConstantsValue.showHangUp(ConstantsValue.game_main.player_array,1800)
		"助战宝箱":
			if StorageData.UseGoodsNum([["助战宝箱钥匙",1]]):
				var arr = box_array.duplicate()
				var arr_g = []
				arr.shuffle()
				for index in range(3):
					arr_g.append([arr[index][0],rand_range(arr[index][1],arr[index][2]) as int ])
				var ins = box.instance()
				ConstantsValue.ui_layer.add_child(ins)
				ins.setGoods(arr_g)
				if randi()%100 < 10:
					var key = spirit_array[randi()%spirit_array.size()]
					ins.add_spirit(LocalData.spirit_data[key])
					StorageData.addSpirit(key)


var box_array = [
	["初级助战进阶石",10,20],
	["初级助战进阶石",10,20],
	["初级助战进阶石",10,20],
	["初级助战进阶石",10,20],
	["中级助战进阶石",5,10],
	["中级助战进阶石",5,10],
	["高级助战进阶石",1,5],
	["绿色陨铁",55,100],
	["红色陨铁",55,100],
	["绿色陨铁",55,100],
	["红色陨铁",55,100],
	["绿色陨铁",55,100],
	["红色陨铁",55,100],
	["秘银矿石",30,50],
	["秘银矿石",30,50],
	["青岚铁矿",10,15],
	["暗蓝星矿",10,15],
	["神秘之石",1,5],
	["火焰之石",10,20],
	["刻印碎片",10,20],
	["刻印碎片",10,20],
	["刻印碎片",10,20],
	["技能手册",10,20],
	["技能手册",10,20],
	["技能手册",10,20],
	["荒漠铜币串",10,30],
	["荒漠铜币串",10,30]
]

var spirit_array = ["0","1","2","3","4","5","6","7","8","9"]
