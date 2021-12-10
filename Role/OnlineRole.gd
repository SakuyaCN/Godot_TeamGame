extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_LENGTH := 32.0
const SLOPE_LIMIT := deg2rad(45.0)

export(float) var speed := 300.0
export(float) var gravity := 2000.0
export(float) var jump_strength := 800.0

var direction := Vector2.ZERO
var velocity := Vector2.ZERO
var snap_vector := SNAP_DIRECTION * SNAP_LENGTH


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

func _physics_process(delta:float) -> void:
	_move(delta)
	_animate()


func _unhandled_input(event: InputEvent) -> void:
	if is_network_master():
		_handle_input(event)

func _animate() -> void:
	var animation := "Idle"
	if not is_on_floor():
		if velocity.y >= 0.0:
			animation = "Idle"
		elif velocity.y < 0.0:
			animation = "Jump"
	else:
		if velocity.x != 0.0:
			animation = "Run"
		else:
			animation = "Idle"
	animatedSprite.play(animation)

func _handle_input(event: InputEvent) -> void:
	if event.is_action("left") or event.is_action("right"):
		rpc_id(1,"_update_player_direction",Input.get_action_strength("right") - Input.get_action_strength("left") )
	if event.is_action_pressed("jump"):
		_jump()
	elif event.is_action_released("jump"):
		_cancel_jump()

func _move(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL).y
	if is_on_floor():
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH
		#sprite.is_emitting = false

func _jump() -> void:
	if is_on_floor():
		snap_vector = Vector2.ZERO
		velocity.y = -jump_strength
		#sprite.is_emitting = true

func _cancel_jump() -> void:
	if not is_on_floor() and velocity.y < 0.0:
		velocity.y = 0.0

func _update_direction(_strength = null) -> void:
	if _strength == null:
		direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	else:
		direction.x = _strength
	velocity.x = direction.x * speed
	if not velocity.x == 0:
		animatedSprite.flip_h = velocity.x < 0

remote func _update_player_direction(strength):
	print("rpc %s"%strength)
	var who = get_tree().get_rpc_sender_id()
	if who == get_tree().get_network_unique_id():
		_update_direction(strength)
