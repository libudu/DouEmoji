extends Panel

onready var search_emoji_grid := $SearchArea/SearchEmojiGrid

onready var search_edit:LineEdit = $SearchEdit

# 是否严格匹配
var strict_match := false


func start_search():
	search_emoji_grid.start_search(search_edit.text, strict_match)


func _on_StrickSearchBox_toggled(button_pressed:bool):
	strict_match = !button_pressed
