extends Control
var config = ConfigFile.new()

func _ready():
	pass

#加密操作
func _on_Button_pressed():
	var list = list_files_in_directory("res://Storage/")
	for path in list:
		var p = "res://Storage/"+path
		var data = LoadData(p)
		save_encrypted(p,data)

func LoadData(file_path):
	var jsondata
	var filedata = File.new()
	filedata.open(file_path,File.READ)
	jsondata = JSON.parse(filedata.get_as_text())
	filedata.close()
	return jsondata.result

func save(file,data):
	var saver = File.new()
	saver.open(file, File.WRITE)
	saver.store_line(to_json(data))
	saver.close()

#加密存储
func save_encrypted(path,data):
	var file = File.new()
	file.open_encrypted_with_pass(path,File.WRITE,"sakuya")
	file.store_string(to_json(data))
	file.close()

#加密读取
func read_encrypted(file_path):
	var jsondata
	var filedata = File.new()
	filedata.open_encrypted_with_pass(file_path,File.READ,"sakuya")
	jsondata = JSON.parse(filedata.get_as_text())
	filedata.close()
	return jsondata.result

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file.ends_with(".json"):
				files.append(file)
			if file == "":
				break
		dir.list_dir_end()
	return files

func _on_Button2_pressed():
	var list = list_files_in_directory("res://Storage/")
	for path in list:
		var p = "res://Storage/"+path
		var data = read_encrypted(p)
		save(p,data)
