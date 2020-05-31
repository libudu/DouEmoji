extends Node

var mouse_index:int

var emoji_edit_page:Control

# 缩略图引用
var thumb_file_dir := {}
# 表情文件的字典
var emoji_file_dir := {}


var picture_dir := {}
var type_dir := {}

# 资源的绝对目录
var res_path:String
# 缩略图的绝对目录
var thumb_path:String


func get_thumb_file(file_name:String):
	return thumb_file_dir.get(file_name.replace(".jpg", ".png"))


func get_emoji_file(file_name:String):
	return emoji_file_dir.get(file_name)


func _ready():
	init_res_path()


# 【初始化函数】初始化根目录
func init_res_path():
	var copy_directory := Directory.new()
	var error = copy_directory.open("emoji/")
	if error != OK:
		OS.alert("打开emoji目录失败！")
	res_path = copy_directory.get_current_dir() + "/"
	error = copy_directory.open("thumb/")
	if error != OK:
		OS.alert("打开thumb目录失败")
	thumb_path = copy_directory.get_current_dir() + "/"
