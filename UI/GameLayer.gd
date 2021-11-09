extends CanvasLayer

onready var fight_ui = $FightUI

onready var find_tv = $FindTv

func _ready():
	ConstantsValue.game_layer = self

func findTvShow(vis):
	find_tv.visible = vis
