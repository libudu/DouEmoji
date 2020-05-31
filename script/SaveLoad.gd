extends Node

var emoji_grid:Control

var file := File.new()
var pic_data_file_path := "data/pic_data.json"


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_index = event.button_index


# 保存必要的信息
func save_info():
	file.open(pic_data_file_path, File.WRITE)
	var save_data_dir := {}
	save_data_dir["picture_index"] = emoji_grid.picture_index
	save_data_dir["picture_dir"] = Global.picture_dir
	save_data_dir["type_dir"] = Global.type_dir
	file.store_string(to_json(save_data_dir))
	file.close()


# 加载必要的信息
func load_info():
	if file.file_exists(pic_data_file_path):
		var load_data_dir:Dictionary = GlobalUtil.read_json(pic_data_file_path)
		if load_data_dir.has("picture_index"):
			emoji_grid.picture_index = load_data_dir["picture_index"]
		if load_data_dir.has("picture_dir"):
			Global.picture_dir = load_data_dir["picture_dir"]
		if load_data_dir.has("type_dir"):
			Global.type_dir = load_data_dir["type_dir"]
	else:
		print("第一次加载应用，没有数据文件。")


# 退出时保存
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_info()
		get_tree().quit()
