extends Control

var local_equ = null

func _ready():
	for item in super_attr:
			$NinePatchRect2/Label.text += "\n%s + %s" %[EquUtils.get_attr_string(item),super_attr[item][1]]
	reLoad()
	
func reLoad():
	if local_equ != null && local_equ.has("super_attr"):
		$NinePatchRect/Label.text = ""
		for item in local_equ["super_attr"]:
			$NinePatchRect/Label.text += "%s + %s\n" %[EquUtils.get_attr_string(item.keys()[0]),item.values()[0]]

func _on_ColorRect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		StorageData._save_storage()
		get_tree().call_group("PartyUI","seal_choose")
		queue_free()

var super_attr = {
	"atk":[500,1500],
	"mtk":[500,1500],
	"hp":[10000,15000],
	"def":[1,3],
	"mdef":[1,3],
	"speed":[1000,2000],
	"crit":[1000,2000],
	"uncrit":[1000,2000],
	"hold":[1,3],
	"hole_pass":[1500,2500],
	"atk_pass":[2,5],
	"mtk_pass":[2,5],
	"atk_blood":[2,5],
	"mtk_blood":[2,5],
	"atk_buff":[1,3],
	"mtk_buff":[1,3],
	"hp_buff":[2,5],
	"hurt_buff":[3,6],
	"crit_buff":[3,6],
	"true_hurt":[200,500],
	"shield":[20000,35000],
	"exp_buff":[5,8],
	"reflex":[1,3],
	"skill_crit":[300,500],
	"atk_mtk":[2,5],
	"skill_buff":[2,5],
	"atk_hurt_buff":[2,5],
	"mtk_hurt_buff":[2,5],
	"hurt_pass":[1,3]
}

func _on_Button_pressed():
	if local_equ != null && StorageData.UseGoodsNum([["能量水晶",1]]):
		if local_equ.has("super_attr"):
			for item in local_equ.super_attr:
				var attr = super_attr[item.keys()[0]]
				var atr_num = stepify(rand_range(super_attr[item.keys()[0]][0],super_attr[item.keys()[0]][1]),0.01)
				if atr_num >= 100:
					atr_num = atr_num as int
				item[item.keys()[0]] = atr_num
		else:
			var sp_attr = []
			for index in range(2 + randi()%3):
				var attr = super_attr.keys()[randi()%super_attr.size()]
				var atr_num = stepify(rand_range(super_attr[attr][0],super_attr[attr][1]),0.01)
				if atr_num >= 100:
					atr_num = atr_num as int
				sp_attr.append({
					attr: atr_num
				})
				local_equ.super_attr = sp_attr
		reLoad()

var  press_count = 0
func _on_Button2_pressed():
	if StorageData.UseGoodsNum([["能量水晶",2]]):
		if local_equ.has("super_attr"):
			ConstantsValue.showMessage("当前装备已有特殊词条，双击后重置",2)
			press_count += 1
		if press_count == 2:
			var sp_attr = []
			for index in range(2 + randi()%3):
				var attr = super_attr.keys()[randi()%super_attr.size()]
				var atr_num = stepify(rand_range(super_attr[attr][0],super_attr[attr][1]),0.01)
				if atr_num >= 100:
					atr_num = atr_num as int
				sp_attr.append({
					attr: atr_num
				})
				local_equ.super_attr = sp_attr
			reLoad()
	yield(get_tree().create_timer(0.5),"timeout")
	press_count = 0
