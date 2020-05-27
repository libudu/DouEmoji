extends Control
class_name Emoji
signal emoji_clicked

var emoji_file_path:String
var clicked := false

# 【初始化函数】初始化一个表情包
func init_emoji(res_path:String, thumb_pic:Texture):
	emoji_file_path = res_path
	$EmojiTexture.texture = thumb_pic


# 【信号函数】按钮被按下了
func button_clicked():
	OS.shell_open(emoji_file_path)
