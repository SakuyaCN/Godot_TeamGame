extends Node

func get_attr_string(attr):
	match attr:
		"atk": return "攻击"
		"hp": return "血量"
		"mtk": return "魔力"
		"mp": return "法力"
		"speed": return "速度"
		"crit": return "暴击"
		"uncrit": return "抗暴"
		"mdef": return "魔免率"
		"def": return "物免率"
		"mp": return "法力"
		"hold": return "格挡率"
		"hole_num": return "格挡伤害"
		"dodge": return "闪避率"
		"hole_pass": return "格挡穿透"
		"mtk_pass": return "魔免穿透"
		"atk_pass": return "物免穿透"
		"atk_blood": return "物理吸血"
		"mtk_blood": return "魔力吸血"
		"atk_buff": return "攻击提升百分比"
		"mtk_buff": return "魔力提升百分比"
		"hp_buff": return "生命提升百分比"
		"true_hurt": return "真实伤害"
		"uncrit": return "抗暴击"
		"hurt_buff":return "普攻加成率"
		"crit_buff":return "暴伤加成率"

func get_ys_color(ys):
	match ys:
		"fire": return Color("#ee7064")
		"ice": return Color("#4bdad0")
		"wind": return Color("#50cc52")
		"posion": return Color("#d14fb1")

func get_ys_color_string(ys):
	match ys:
		"fire": return "#ee7064"
		"ice": return "#4bdad0"
		"wind": return "#50cc52"
		"posion": return "#d14fb1"

func get_quality_color(ys):
	match ys:
		"S++": return Color("#e19c5f")
		"S级": return Color("#b06ee1")
		"A级": return Color("#7ac6ce")
		"B级": return Color("#7fc995")
		"C级": return Color("#706050")

func get_ys_string(attr):
	match attr:
		"fire": return "火属性"
		"ice": return "冰属性"
		"wind": return "风属性"
		"posion": return "毒属性"

#生成一件新装备
func createNewEqu(data,type):
	var id = str(OS.get_system_time_msecs() + randi()%1000+1)
	var base_attr = []
	var ys_attr = []
	if data.keys().has("attr"):
		for base in data.attr:
			base_attr.append({
				base:rand_range(data.attr[base][0],data.attr[base][1]) as int
			})
	if data.keys().has("ys_attr"):
		for base in data.ys_attr:
			ys_attr.append({
				base:rand_range(data.ys_attr[base][0],data.ys_attr[base][1]) as int
			})
	var equData = {
		"id":id,
		"name":data.name,
		"lv":data.lv,
		"image":data.img,
		"quality":"A级",
		"type":type,
		"is_on":false,
		"base_attr":base_attr,
		"ys_attr":ys_attr
	}
	StorageData.addEqutoBag(equData)
	return equData
