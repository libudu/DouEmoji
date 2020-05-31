extends GridContainer
class_name EmojiGrid

const EmojiScene := preload("res://scene/Emoji.tscn")

# 资源的绝对目录
onready var res_path := Global.res_path
# 缩略图的绝对目录
onready var thumb_path := Global.thumb_path

# 缩略图引用
onready var thumb_file_dir := Global.thumb_file_dir
# 表情文件的字典
onready var emoji_file_dir := Global.emoji_file_dir

var emoji_children_dir := {}

func add_emoji_child(file_name:String):
	var emoji := EmojiScene.instance()
	add_child(emoji)
	emoji_children_dir[file_name] = emoji
	emoji.init_emoji(file_name, Global.get_thumb_file(file_name), Global.picture_dir[file_name]["keyword"])
	emoji.connect("emoji_edited", Global.emoji_edit_page, "show_edit", [file_name, emoji])
