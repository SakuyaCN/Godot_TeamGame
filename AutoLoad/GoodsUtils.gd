extends Node

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
