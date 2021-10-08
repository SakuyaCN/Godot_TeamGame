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
		"mdef": return "魔免"
		"def": return "物免"

func get_ys_color(ys):
	match ys:
		"fire": return Color("#ee7064")
		"ice": return Color("#4bdad0")
		"wind": return Color("#50cc52")
		"posion": return Color("#d14fb1")

func get_ys_string(attr):
	match attr:
		"fire": return "火属性"
		"ice": return "冰属性"
		"wind": return "风属性"
		"posion": return "毒属性"
