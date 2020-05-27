extends Panel


func show_panel(panel_name:String):
	for i in get_children():
		i.hide()
	match panel_name:
		"all_emoji":
			pass
		"type_emoji":
			pass
		"search_emoji":
			pass
