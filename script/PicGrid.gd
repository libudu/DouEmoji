extends GridContainer

const EmojiScene := preload("res://Emoji.tscn")

# 资源的绝对路径
var res_path:String
# 表情目录的路径
const EMOJI_DIR_PATH := "emoji/"
# 表情文件的字典
var emoji_file_dir := {}
# 用于复制的目录对象
var copy_directory := Directory.new()
# 后缀名
var suffix_list := [".gif", ".png", ".jpg"]


func _ready():
	init_res_path()
	load_all_emojis()
	get_tree().connect("files_dropped", self, "drop_files")


# 【初始化函数】初始化根目录
func init_res_path():
	res_path = OS.get_executable_path()
	res_path = res_path.replace(res_path.get_file(), "")


# 【信号函数】把文件拖入后处理的函数
func drop_files(file_paths:PoolStringArray, screen:int):
	var all_num = file_paths.size()
	var success_num = 0
	for file_path in file_paths:
		var file_name := file_path.split("\\")[-1] as String
		# 检查后缀名
		var error := -1
		for suffix in suffix_list:
			if file_name.ends_with(suffix):
				error = OK
				break
		if error != OK:
			OS.alert(file_name+"未能成功导入！")
			continue
		# 复制到目标路径
		var destination = res_path + EMOJI_DIR_PATH + file_name
		error = copy_directory.copy(file_path, destination)
		if error != OK:
			OS.alert(file_name+"未能成功导入！")
		else:
			success_num += 1
			load_a_emoji(destination)
	OS.alert("本次共添加%s个文件！成功添加%s个！" % [all_num, success_num])


# 加载所有表情包
func load_all_emojis():
	var emoji_file_path := GlobalUtil.search_dir(res_path + EMOJI_DIR_PATH, suffix_list)
	for path in emoji_file_path:
		load_a_emoji(path)


# 加载一个表情包
func load_a_emoji(path:String):
	var emoji := EmojiScene.instance()
	emoji.init_emoji(path)
	add_child(emoji)

