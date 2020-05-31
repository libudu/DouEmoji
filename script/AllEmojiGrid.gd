extends EmojiGrid

# 用于复制的目录对象
var copy_directory := Directory.new()
# 后缀名
var suffix_list := [".gif", ".png", ".jpg"]

# 图片路径映射到：使用频率、关键字、类型
var picture_index := 0


func _ready():
	get_tree().connect("files_dropped", self, "drop_files")


# 加载所有表情包
func load_all_emojis():
	# 搜索缩略图目录，加载缩略图图片
	var thumb_file_name := GlobalUtil.search_dir(thumb_path, suffix_list)
	for file_name in thumb_file_name:
		thumb_file_dir[file_name] = GlobalUtil.load_image_from_path(thumb_path + file_name.replace(".jpg",".png"))
	# 搜索文件目录，补全缩略图，界面中加载出缩略图
	var emoji_file_name := GlobalUtil.search_dir(res_path, suffix_list)
	for file_name in emoji_file_name:
		load_a_emoji(file_name)


# 加载一个表情包，如果没有缩略图则生成缩略图
func load_a_emoji(file_name:String):
	var thumb_file_name := file_name.replace(".jpg", ".png")
	if not thumb_file_dir.has(thumb_file_name):
		print("图片%s的缩略图不存在，正在生成……" % file_name)
		var texture := GlobalUtil.load_image_from_path(res_path + file_name)
		var thumb_texture := GlobalUtil.scale_texture(texture)
		thumb_texture.get_data().save_png(thumb_path + thumb_file_name)
		thumb_file_dir[thumb_file_name] = thumb_texture
	if not Global.picture_dir.has(file_name):
		print("图片%s的记录不存在，正在生成……" % file_name)
		Global.picture_dir[file_name] = {"keyword":"","type":""}
	add_emoji_child(file_name)


# 【信号函数】把文件拖入后处理的函数
func drop_files(file_paths:PoolStringArray, screen:int):
	var all_num = file_paths.size()
	var success_num = 0
	for file_path in file_paths:
		var file_name := file_path.split("\\")[-1] as String
		# 检查后缀名
		var error := -1
		var this_suffix:String
		for suffix in suffix_list:
			if file_name.ends_with(suffix):
				error = OK
				this_suffix = suffix
				break
		if error != OK:
			OS.alert(file_name+"并非jpg/png/gif文件，无法导入！")
			continue
		# 复制到目标路径
		picture_index += 1
		var destination = res_path + str(picture_index) + this_suffix
		error = copy_directory.copy(file_path, destination)
		if error != OK:
			OS.alert(file_name+"未能成功导入！错误码：" + str(error))
		else:
			success_num += 1
			load_a_emoji(str(picture_index) + this_suffix)
	OS.alert("本次共添加%s个文件！成功添加%s个！" % [all_num, success_num])

