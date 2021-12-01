extends Node

var websocket_url = "ws://150.158.34.28:8001"
onready var _client :WebSocketClient = WebSocketClient.new()

var is_chat_ok = true

var is_connect = false
var count = 0

func _ready():
	set_process(false)
	add_to_group("chat")
	_client.verify_ssl = false
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_error")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

func _closed(was_clean = false):
	is_connect = false
	connet_server()
	
func _error(was_clean = false):
	is_connect = false
	connet_server()

func _connected(proto = ""):
	print("_connected")
	on_connect_login()
	is_connect = true

func _on_seedData(msg):
	if !is_chat_ok:
		ConstantsValue.showMessage("聊天间隔时间10秒！",1)
		return
	var entity = {
		"type":"chat",
		"nickname":StorageData.get_player_state()["nickname"],
		"uuid":OS.get_unique_id(),
		"msg":msg,
		"save_id":StorageData.get_player_state()["save_id"]
	}
	var err = _client.get_peer(1).put_packet(to_json(entity).to_utf8())
	is_chat_ok = false
	$Timer.start()

func _on_data():
	var pkt = _client.get_peer(1).get_packet().get_string_from_utf8()
	var json = parse_json(pkt)
	ConstantsValue.chat_array.append(json)
	if ConstantsValue.chat_array.size() > 20:
		ConstantsValue.chat_array.remove(0)
	ConstantsValue.emit_signal("on_chat_message",json)

func connet_server():
	var err = _client.connect_to_url(websocket_url)
	if err == OK:
		_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
		set_process(true)
	else:
		if count == 10:
			return
		yield(get_tree().create_timer(5),"timeout")
		connet_server()
		count+=1

func _process(delta):
	_client.poll()

func _on_Timer_timeout():
	is_chat_ok = true

func on_connect_login():
	var entity = {
		"type":"login",
		"nickname":"无名玩家",
		"uuid":OS.get_unique_id(),
		"save_id":StorageData.get_player_state()["save_id"]
	}
	var err = _client.get_peer(1).put_packet(to_json(entity).to_utf8())
