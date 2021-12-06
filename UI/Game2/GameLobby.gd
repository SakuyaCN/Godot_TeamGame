extends Node2D

#var SERVER_IP = "http://150.158.34.28"
var SERVER_IP = "localhost"
var SERVER_PORT = 8866

var SPEED = 10

onready var base_role = preload("res://Role/BaseRole.tscn")
onready var online_role = preload("res://Role/OnlineRole.tscn")

var player_info = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	#rpc_id(1,"create_player",ConstantsValue.online_data,ConstantsValue.on)

func _player_connected(id):
	rpc_id(id, "register_player", StorageData.get_player_state()["nickname"],ConstantsValue.online_data,ConstantsValue.online_attr.toDict())

func _player_disconnected(id):
	player_info.erase(id)

func _connected_ok():
	print("connect ok")

func _connected_fail():
	pass # Could not even connect to server; abort.

func _process(delta):
	$PxBg/pb2.scroll_offset.x -= delta * (SPEED + 15)
	$PxBg/pb4.scroll_offset.x -= delta * (SPEED + 12)
	$PxBg/pb5.scroll_offset.x += delta * (SPEED + 8)
	$PxBg/pb6.scroll_offset.x -= delta * (SPEED + 5)
	$PxBg/pb7.scroll_offset.x += delta * (SPEED + 2)

remote func player_join(id,info):
	player_info[id] = info
	var role = online_role.instance()
	$Main.add_player(role)
	role.name = str(id)
	role.set_network_master(id)
	role.setData(info["nickname"],info["role_data"])
	#role.setOnlineData(info.role_data,info.hero_attr)

