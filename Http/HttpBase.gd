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

func _on_request_completed(result, response_code, headers, body):
	if body != null && response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		emit_signal("http_res",req_url,json.result)
		queue_free()
