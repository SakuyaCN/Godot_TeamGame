# GodotHttp Class
class_name GodotHttp
extends Node

var http_url = "http://150.158.34.28:8856/api/"
var is_ssl = false
var header = ["Content-Type:application/json"]

var mode = "GET"
var query = {}
var req_url = ""
var req = HTTPRequest.new()
var is_connect = false

signal http_res(url,data)
signal http_download()

func _ready():
	add_child(req)
	req.use_threads = true
	req.connect("request_completed",self,"_on_request_completed")
	if mode == "GET":
		req.request(http_url+req_url)
	elif mode == "POST":
		req.request(http_url+req_url, header, false, HTTPClient.METHOD_POST, query)
	else:
		req.request(req_url)

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

func file_download(path,url):
	req_url = url
	mode = "FILE"
	req.download_file = path
	ConstantsValue.ui_layer.add_child(self)

func _on_request_completed(result, response_code, headers, body):
	if mode != "FILE":
		if body != null && response_code == 200:
			var json = JSON.parse(body.get_string_from_utf8())
			emit_signal("http_res",req_url,json.result)
			queue_free()
	else:
		emit_signal("http_download")
