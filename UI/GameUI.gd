extends Control

onready var login_ui = $LoginUI
onready var create_ui = $CreateUI
onready var main_ui = $MainUi
onready var map_ui = $MapUi
onready var bag_ui = $BagUI
onready var party_ui = $PartyUI
onready var build_ui = $BuildUI

onready var tempSKillIcon = $temp_skill_icon

onready var uiLayer = get_parent()

func _ready():
	tempSKillIcon.visible = false
	
