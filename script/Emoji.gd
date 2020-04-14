extends Control
class_name Emoji
signal emoji_clicked

var emoji_file_path:String


# 【初始化函数】初始化一个表情包
func init_emoji(texture_path:String):
	emoji_file_path = texture_path
	$EmojiTexture.texture = GlobalUtil.load_image_from_path(texture_path)


# 【信号函数】按钮被按下了
func button_clicked():
	OS.shell_open(emoji_file_path)
