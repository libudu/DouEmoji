extends GridContainer

const EmojiScene := preload("res://Emoji.tscn")

# 资源的绝对目录
var res_path:String
# 缩略图的绝对目录
var thumb_path:String
# 缩略图引用
var thumb_file_dir := {}

# 表情文件的字典
var emoji_file_dir := {}
# 用于复制的目录对象
var copy_directory := Directory.new()
# 后缀名
var suffix_list := [".gif", ".png", ".jpg"]


# 图片路径映射到：使用频率、关键字、类型
var picture_index := 0
var picture_dir := {}
var type_dir := {}

var file := File.new()
var pic_data_file_path := "data/pic_data.json"

# 保存必要的信息
func save_info():
	file.open(pic_data_file_path, File.WRITE)
	var save_data_dir := {}
	save_data_dir["picture_index"] = picture_index
	save_data_dir["picture_dir"] = picture_dir
	save_data_dir["type_dir"] = type_dir
	file.store_string(to_json(save_data_dir))
	file.close()

# 加载必要的信息
func load_info():
	if file.file_exists(pic_data_file_path):
		var load_data_dir:Dictionary = GlobalUtil.read_json(pic_data_file_path)
		if load_data_dir.has("picture_index"):
			picture_index = load_data_dir["picture_index"]
		if load_data_dir.has("picture_dir"):
			picture_dir = load_data_dir["picture_dir"]
		if load_data_dir.has("type_dir"):
			type_dir = load_data_dir["type_dir"]
	else:
		print("第一次加载应用，没有数据文件。")

# 退出时保存
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_info()
		get_tree().quit()


func _ready():
	load_info()
	init_res_path()
	load_all_emojis()
	get_tree().connect("files_dropped", self, "drop_files")


# 【初始化函数】初始化根目录
func init_res_path():
	var error = copy_directory.open("emoji/")
	if error != OK:
		OS.alert("打开emoji目录失败！")
	res_path = copy_directory.get_current_dir() + "/"
	error = copy_directory.open("thumb/")
	if error != OK:
		OS.alert("打开thumb目录失败")
	thumb_path = copy_directory.get_current_dir() + "/"


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
	var emoji := EmojiScene.instance()
	emoji.init_emoji(res_path+file_name, thumb_file_dir[thumb_file_name] )
	add_child(emoji)


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

