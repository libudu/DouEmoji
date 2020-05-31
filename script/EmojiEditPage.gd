extends Control

# 当前正在编辑的表情信息的字典
var emoji_info_dir:Dictionary

var now_emoji:Emoji

onready var keyword_edit := $Panel/KeywordEdit
onready var pre_texture := $Panel/PreTexture


func _ready():
	hide()


func show_edit(file_name:String, emoji:Emoji):
	now_emoji = emoji
	emoji_info_dir = Global.picture_dir[file_name]
	keyword_edit.text = emoji_info_dir["keyword"]
	pre_texture.texture = Global.get_thumb_file(file_name)
	show()


func confirm_edit():
	emoji_info_dir["keyword"] = keyword_edit.text
	now_emoji.set_keyword(keyword_edit.text)
	hide()
