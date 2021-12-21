extends Node2D

var role = preload("res://Role/BaseRole.tscn")

var player_array = []

onready var role_position = [
	$GameMain/Position/PositionP1,
	$GameMain/Position/PositionP2,
	$GameMain/Position/PositionP3
]

func _ready():
	setHero()

func _process(delta):
	$ParallaxBackground/ParallaxLayer2.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer3.motion_offset.x -= delta * 10
	$ParallaxBackground/ParallaxLayer4.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer5.motion_offset.x -= delta * 10
	$ParallaxBackground/ParallaxLayer6.motion_offset.x += delta * 10
	$ParallaxBackground/ParallaxLayer7.motion_offset.x -= delta * 10

func setHero():
	for pos in range(3):
		if StorageData.player_state["team_position"][pos] != null:
			if role_position[pos].get_child_count() == 0:
				var new_hero = role.instance()
				player_array.append(new_hero)
				new_hero.setIndex(pos)
				role_position[pos].add_child(new_hero)
				new_hero.set_role(StorageData.team_data.get(StorageData.player_state["team_position"][pos]))
		else:
			player_array.append(null)

#退出副本
func _on_attrs3_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		ConstantsValue.game_mode_change = true
		$UILayer.change_scene("res://UI/Game.tscn")

#开始战斗
func _on_attrs4_gui_input(event):
	pass # Replace with function body.
