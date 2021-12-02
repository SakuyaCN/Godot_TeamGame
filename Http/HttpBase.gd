# GodotHttp Class
class_name GodotHttp
extends Node

var http_url = "http://150.158.34.28:8855/api/"
var is_ssl = false
var header = ["Content-Type:application/json"]

var mode = "GET"
var query = {}
var req_url = ""
var req = HTTPRequest.new()
var is_connect = false

signal http_res(url,data)

func _ready():
	add_child(req)
	req.use_threads = true
	req.connect("request_completed",self,"_on_request_completed")
	if mode == "GET":
		req.request(http_url+req_url)
	else:
		req.request(http_url+req_url, header, false, HTTPClient.METHOD_POST, query)

func http_get(url):
	if is_connect:
		return
	is_connect = true
	mode = "GET"
	req_url = url
	ConstantsValue.ui_layer.add_child(self)

func http_post(url,_query):
	if is_connect:
		return
	is_connect = true
	mode = "POST"
	req_url = url
	query = _query
	ConstantsValue.ui_layer.add_child(self)

func file_update(file_path):
	var file_name = StorageData.get_player_state().id
	var file = File.new()
	file.open('res://icon.png', File.READ)
	var file_content = file.get_buffer(file.get_len())

	var body = PoolByteArray()
	body.append_array("\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L\r\n".to_utf8())
	body.append_array("Content-Disposition: form-data; name=\"file\"; filename=\"%s.json\"\r\n".to_utf8() %file_name)
	body.append_array("Content-Type: text/plain\r\n\r\n".to_utf8())
	body.append_array(file_content)
	body.append_array("\r\n--WebKitFormBoundaryePkpFF7tjBAqx29L--\r\n".to_utf8())

	var headers = ["Content-Type: multipart/form-data;boundary=\"WebKitFormBoundaryePkpFF7tjBAqx29L\""]
	req.connect_to_host(http_url+"file_update", 3000, false)

	while req.get_status() == HTTPClient.STATUS_CONNECTING or req.get_status() == HTTPClient.STATUS_RESOLVING:
		req.poll()
		OS.delay_msec(500)

	assert(req.get_status() == HTTPClient.STATUS_CONNECTED) # Could not connect

	var err = req.request_raw(HTTPClient.METHOD_POST, "/images" , headers, body)

	assert(err == OK)

	while req.get_status() == HTTPClient.STATUS_REQUESTING:
		req.poll()
		if not OS.has_feature("web"):
			OS.delay_msec(500)
		else:
			yield(Engine.get_main_loop(), "idle_frame")

func _on_request_completed(result, response_code, headers, body):
	if body != null && response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		emit_signal("http_res",req_url,json.result)
		queue_free()
