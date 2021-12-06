extends KinematicBody2D

export (int) var speed = 200
export (int) var jump_speed = -450
export (int) var gravity = 750

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.15

var velocity = Vector2.ZERO

var role_data
var nick_name

var input_mode = InputMode.IDLE

enum InputMode{
	IDLE = -1
	UP = 0,
	LEFT = 1,
	RIGHT = 2
}

onready var animatedSprite = $AnimatedSprite

func setData(nick_name,_data):
	role_data = _data
	$RoleUI/name.text = nick_name
	role_data.job = "无畏勇者"
	load_asset()

func load_asset():
	animatedSprite.position.y = -48
	match role_data.job:
		"黑袍法师":
			animatedSprite.frames = load("res://Texture/Pre-made characters/BlackHero.tres").duplicate()
			animatedSprite.position.y = -60
			animatedSprite.position.x = -5
			$RoleUI/name.rect_position.y = -20
			animatedSprite.scale = Vector2(3.5,3.5)
		"无畏勇者":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Brave.tres").duplicate()
			animatedSprite.position.y = -64
			$RoleUI/name.rect_position.y = -15
			animatedSprite.scale = Vector2(4,4)
		"不屈骑士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Knight.tres").duplicate()
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
			$RoleUI/name.rect_position.y = -15
		"绝地武士":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Warrior.tres").duplicate()
			animatedSprite.position.y = -86
			animatedSprite.scale = Vector2(5,5)
			$RoleUI/name.rect_position.y = -15
		"致命拳手":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Boxer.tres").duplicate()
			animatedSprite.position.y = -70
			animatedSprite.scale = Vector2(3,3)
			$RoleUI/name.rect_position.y = -15
		"战地女神":
			animatedSprite.frames = load("res://Texture/Pre-made characters/Goddess.tres").duplicate()
			animatedSprite.position.y = -95
			animatedSprite.scale = Vector2(3,3)
			$RoleUI/name.rect_position.y = -15
		"moster":
			animatedSprite.frames = load(role_data["node"].frames).duplicate()
			animatedSprite.flip_h = role_data["node"].flip_h
			animatedSprite.position.y = role_data["node"].pos_y
			animatedSprite.scale = Vector2(role_data["node"].scale,role_data["node"].scale)
			$RoleUI/name.rect_position.y = role_data["node"].pos_y / 4
			$RoleUI/name.set("custom_colors/font_outline_modulate",Color.palevioletred)
	animatedSprite.animation = "Idle"

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
	if !is_on_floor():
		input_mode = InputMode.UP
	match input_mode:
		InputMode.IDLE:
			$AnimatedSprite.play("Idle")
		InputMode.LEFT:
			$AnimatedSprite.play("Run")
		InputMode.RIGHT:
			$AnimatedSprite.play("Run")
		InputMode.UP:
			$AnimatedSprite.play("Jump")
	

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		input_mode = InputMode.RIGHT
		dir += 1
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
		input_mode = InputMode.LEFT
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		input_mode = InputMode.IDLE
