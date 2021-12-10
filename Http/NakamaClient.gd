extends Reference

class_name GodotNakamaClient

var client : NakamaClient
var ip = "150.158.34.28"

var COLLECTION = "Storage"
var COLLECTION_KEY = "Storage_key"
var KEY = "nakama_godot_demo"

func _init():
	client = Nakama.create_client(KEY,ip, 7350, "http")

func registerOrLogin(email,password):
	var session = yield(client.authenticate_email_async(email, password), "completed")
	return session

func logOut():
	var session = isExpired()
	return session

func isExpired():
	var invalid_authtoken = ConstantsValue.user_info.token
	if invalid_authtoken:
		var restored_session = ConstantsValue.GodotNakama.client.restore_session(invalid_authtoken)
		if !restored_session.expired:
			return restored_session
	return null

#查看存档列表
func listStorageKeys():
	var session = isExpired()
	if session != null:
		var objs = yield(client.list_users_storage_objects_async(session,COLLECTION_KEY,session.user_id,1,""), "completed")
		if objs.objects.size() > 0:
			return objs.objects[0]
	return null

func getStorage(_key):
	var session = isExpired()
	if session != null:
		var obj_arry = [NakamaStorageObjectId.new(COLLECTION,_key,session.user_id)]
		var objs :NakamaAPI.ApiStorageObjects= yield(client.read_storage_objects_async(session,obj_arry), "completed")
		if(objs.is_exception()):
			return null
		if objs.objects.size() > 0:
			return objs.objects[0].value
	return null

#上传当前存档
func postStorage():
	var session = isExpired()
	if session != null:
		var keys = [NakamaWriteStorageObject.new(COLLECTION_KEY, "array", 1, 1,to_json({
			"key_1":str(StorageData.get_player_state().save_id)
		}), "")]
		var write_key : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, keys), "completed")
		if !write_key.is_exception():
			var objs = [NakamaWriteStorageObject.new(COLLECTION, str(StorageData.get_player_state().save_id), 1, 1,to_json(StorageData.storage_data), "")]
			var write : NakamaAPI.ApiStorageObjectAcks = yield(client.write_storage_objects_async(session, objs), "completed")
			if !write.is_exception():
				ConstantsValue.showMessage("存档上传成功！",2)
			else:
				ConstantsValue.showMessage("存档上传失败！",2)
