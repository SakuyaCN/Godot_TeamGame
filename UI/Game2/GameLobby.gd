extends Node2D

#var SERVER_IP = "http://150.158.34.28"
var client : NakamaClient
var SERVER_IP = "localhost"
var SERVER_PORT = 8866

var SPEED = 10

onready var base_role = preload("res://Role/BaseRole.tscn")
onready var online_role = preload("res://Role/OnlineRole.tscn")

var player_info = {}

func _ready():
	pass

func _process(delta):
	$PxBg/pb2.scroll_offset.x -= delta * (SPEED + 15)
	$PxBg/pb4.scroll_offset.x -= delta * (SPEED + 12)
	$PxBg/pb5.scroll_offset.x += delta * (SPEED + 8)
	$PxBg/pb6.scroll_offset.x -= delta * (SPEED + 5)
	$PxBg/pb7.scroll_offset.x += delta * (SPEED + 2)

remote func player_array_create(_player_info):
	player_info = _player_info
	for info in player_info:
		add_player(info,player_info[info])

remote func player_join(id,info):
	player_info[id] = info
	add_player(id,info)
	#role.setOnlineData(info.role_data,info.hero_attr)

func add_player(id,info):
	var role = online_role.instance()
	$Main.add_player(role)
	role.name = str(id)
	role.set_network_master(id)
	role.setData(info["nickname"],info["role_data"])
