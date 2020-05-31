extends Control
class_name Emoji

signal emoji_clicked
signal emoji_edited

onready var keyword_label := $KeywordLabel
onready var emoji_texture := $EmojiTexture

var emoji_file_path:String
var clicked := false


# 【初始化函数】初始化一个表情包
func init_emoji(res_path:String, thumb_pic:Texture, keyword:String):
	emoji_file_path = res_path
	emoji_texture.texture = thumb_pic
	set_keyword(keyword)


func set_keyword(keyword:String):
	if keyword.length() > 30:
		keyword_label.text = keyword.left(30) + "..."
	else:
		keyword_label.text = keyword


# 【信号函数】左键按下打开图片，右键打开查看信息
func button_clicked():
	if Global.mouse_index == 2:
		OS.shell_open(emoji_file_path)
	if Global.mouse_index == 1:
		emit_signal("emoji_edited")
