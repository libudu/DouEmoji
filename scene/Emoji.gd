extends Control
class_name Emoji

signal emoji_clicked
signal emoji_edited

onready var keyword_label := $KeywordLabel
onready var emoji_texture := $EmojiTexture

var file_name:String
var emoji_file_path:String
var clicked := false


# 【初始化函数】初始化一个表情包
func init_emoji(file_name:String, thumb_pic:Texture, keyword:String):
	self.file_name = file_name
	emoji_file_path = Global.res_path + file_name
	emoji_texture.texture = thumb_pic
	set_keyword(keyword)


func set_keyword(keyword:String):
	if keyword.length() > 30:
		keyword_label.text = keyword.left(30) + "..."
	else:
		keyword_label.text = keyword


# 【信号函数】左键按下打开图片，右键打开查看信息
func button_clicked():
	if Global.picture_dir.has(file_name):
		if Global.mouse_index == 2:
			OS.shell_open(emoji_file_path)
		if Global.mouse_index == 1:
			emit_signal("emoji_edited")
	else:
		OS.alert("该表情包不存在或已被删除！")


func delete_emoji():
	# 删除数据
	Global.picture_dir.erase(file_name)
	# 删除可能存在的引用及Emoji
	var emoji:Emoji = Global.search_emoji_grid.emoji_children_dir.get(file_name)
	if emoji != null:
		Global.search_emoji_grid.emoji_children_dir.erase(file_name)
		emoji.queue_free()
	emoji = Global.all_emoji_grid.emoji_children_dir.get(file_name)
	if emoji != null:
		Global.all_emoji_grid.emoji_children_dir.erase(file_name)
		emoji.queue_free()
	# 删除文件
	var dir := Directory.new()
	dir.remove(Global.res_path + file_name)
	dir.remove(Global.thumb_path + file_name.replace(".jpg", ".png"))
