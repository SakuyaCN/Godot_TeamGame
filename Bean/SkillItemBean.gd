extends Node

class_name SkillItemBean

var item_script:String #触发脚本
var item_odds_type:int#触发类型
var item_odds:int #触发概率
var item_odds_attr #触发阈值的属性 
var item_odds_num:int #触发阈值百分比
var item_count = 1 #触发次数 -1为无限循环
var item_itme:int #是否延迟触发
var item_role = []#触发脚本的角色

var scrpit_info#脚本内容

func _create(dict:Dictionary):
	if dict.has("item_script"):
		item_script = dict["item_script"]
	if dict.has("item_odds"):
		item_odds = dict["item_odds"]
	if dict.has("item_odds_type"):
		item_odds_type = dict["item_odds_type"]
	if dict.has("item_odds_attr"):
		item_odds_attr = dict["item_odds_attr"]
	if dict.has("item_odds_num"):
		item_odds_num = dict["item_odds_num"]
	if dict.has("item_count"):
		item_count = dict["item_count"]
	if dict.has("item_itme"):
		item_itme = dict["item_itme"]
	if dict.has("item_role"):
		item_role = dict["item_role"]
	if dict.has("scrpit_info"):
		var info = SkillStateBean.new()
		info._create(dict["scrpit_info"])
		scrpit_info = info
