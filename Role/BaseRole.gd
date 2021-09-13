extends Node2D

var role_data:Dictionary
var index = 0
var is_position = false
var is_moster = false
var run_position = Vector2.ZERO

onready var ui = $RoleUI

onready var am_player = $AnimationPlayer
onready var fight_script = $FightScript
onready var animatedSprite = $AnimatedSprite
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_role(_role_data):
	role_data = _role_data
	ui.initRole()
	load_asset()

func setIndex(_index):
	self.index = _index
	
func changeAnim(anim):
	animatedSprite.animation = anim

func load_asset():
	animatedSprite.position.y = -48
	match role_data.job:
		"黑袍法师":animatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres")
		"无畏勇者":animatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres")
		"不屈骑士":animatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres")
		"战地牧师":animatedSprite.frames = load("res://Texture/Pre-made characters/Minister.tres")
		"moster":
			is_moster = true
			animatedSprite.frames = load(role_data["node"].frames)
			animatedSprite.flip_h = role_data["node"].flip_h
			animatedSprite.position.y = role_data["node"].pos_y
			animatedSprite.scale = Vector2(role_data["node"].scale,role_data["node"].scale)
			$RoleUI/name.rect_position.y = role_data["node"].pos_y / 4
			$RoleUI/attr.position.y += role_data["node"].pos_y
			$RoleUI/name.set("custom_colors/font_outline_modulate",Color.palevioletred)
	animatedSprite.animation = "Idle"
	if is_moster:
		add_to_group("moster_role")
	else:
		add_to_group("player_role")

func run2position(_position):
	animatedSprite.animation = "Run"
	if not is_moster:
		global_position = Vector2(-100,_position.position.y)
	else:
		global_position = Vector2(1337,_position.position.y)
	animatedSprite.speed_scale = 5.0
	run_position = _position
	is_position = true

func _process(delta):
	if is_position:
		if not is_moster:
			global_position.x += delta * 250
			if global_position.x >= run_position.position.x:
				animatedSprite.speed_scale = 1.0
				is_position = false
				set_process(false)
				get_tree().call_group("game_main","plus_size")
		else:
			global_position.x -= delta * 250
			if global_position.x <= run_position.position.x:
				animatedSprite.speed_scale = 1.0
				is_position = false
				set_process(false)
				animatedSprite.animation = "Idle"
				get_tree().call_group("game_main","moster_plus_size")

func start_fight():
	if am_player.is_playing():
		yield(am_player,"animation_finished")
	am_player.play("show_bar")
