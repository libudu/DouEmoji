extends Control

onready var save_load := $SaveLoad

onready var all_emoji_panel := $AllEmojiPanel
onready var type_emoji_panel := $TypeEmojiPanel
onready var search_emoji_panel := $SearchEmojiPanel

var all_panel:Array


func _ready():
	Global.emoji_edit_page = $EmojiEditPage
	
	Global.all_emoji_grid = $AllEmojiPanel/EmojiArea/AllEmojiGrid
	Global.search_emoji_grid = $SearchEmojiPanel/SearchArea/SearchEmojiGrid
	
	save_load.emoji_grid = Global.all_emoji_grid
	# 必须先加载信息再加载表情包，否则加载表情包生成的信息可能被后加载的信息覆盖
	save_load.load_info()
	Global.all_emoji_grid.load_all_emojis()
	print(Global.picture_dir)
	
	all_panel = [all_emoji_panel, type_emoji_panel, search_emoji_panel]
	show_panel(1)


func show_panel(panel_index:int):
	for panel in all_panel:
		panel.hide()
	match panel_index:
		1:
			all_emoji_panel.show()
		2:
			type_emoji_panel.show()
		3:
			search_emoji_panel.show()
