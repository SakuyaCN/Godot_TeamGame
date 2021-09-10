extends Control

onready var top_info = {
	"position3":{
		"label":$top/title/label_job,
		"exp_bar":$top/progress_exp,
		"exp_label":$top/label_exp,
		"hp_bar":$top/progress_hp,
		"hp_label":$top/label_hp,
		"lv_label":$top/label_lv
	},
	"position2":{
		"label":$top2/title/label_job,
		"exp_bar":$top2/progress_exp,
		"exp_label":$top2/label_exp,
		"hp_bar":$top2/progress_hp,
		"hp_label":$top2/label_hp,
		"lv_label":$top2/label_lv
	},
	"position1":{
		"label":$top3/title/label_job,
		"exp_bar":$top3/progress_exp,
		"exp_label":$top3/label_exp,
		"hp_bar":$top3/progress_hp,
		"hp_label":$top3/label_hp,
		"lv_label":$top3/label_lv
	}
}

func _ready():
	visible = false

func showui():
	visible = true
	$AnimationPlayer.play("show")
	load_player_data()
	
func load_player_data():
	for pos in StorageData.storage_data["player_team"]:
		var data = StorageData.storage_data["player_team"][pos]
		if data != null:
			top_info[pos].label.text = data.job
			top_info[pos].lv_label.text = str(data.lv)
			top_info[pos].exp_bar.max_value = Utils.get_up_lv_exp(data.lv)
			top_info[pos].exp_bar.value = data.exp
			top_info[pos].exp_label.text = "{}%".format([(top_info[pos].exp_bar.value / top_info[pos].exp_bar.max_value) as int] ,"{}")
			top_info[pos].hp_bar.max_value = data.attr.hp
			top_info[pos].hp_bar.value = data.attr.hp
			top_info[pos].hp_label.text = "{}%".format([((top_info[pos].hp_bar.value / top_info[pos].hp_bar.max_value) * 100) as int] ,"{}")
		else:
			top_info[pos].label.text = "暂无角色"
			top_info[pos].lv_label.text = "0"
			top_info[pos].exp_bar.max_value = 0
			top_info[pos].exp_bar.value = 0
			top_info[pos].exp_label.text = "0%"
			top_info[pos].hp_bar.max_value = 0
			top_info[pos].hp_bar.value = 0
			top_info[pos].hp_label.text = "0%"

func _on_map_pressed():
	if !get_parent().map_ui.visible:
		get_parent().map_ui.show_map()
