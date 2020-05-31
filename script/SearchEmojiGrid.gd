extends EmojiGrid


func start_search(keyword:String, strict_match:bool):
	for child in get_children():
		child.queue_free()
	for pic_name in Global.picture_dir:
		var pic_keyword_str:String = Global.picture_dir[pic_name]["keyword"]
		for pic_keyword in pic_keyword_str.split(" ", true):
			if strict_match == false and unstrict_judge_keyword(keyword, pic_keyword) or strict_match == true and keyword == pic_keyword:
				add_emoji_child(pic_name)


func unstrict_judge_keyword(keyword:String, pic_keyword:String) -> bool:
	if keyword.similarity(pic_keyword) > 0 or keyword.find(pic_keyword) != -1 or pic_keyword.find(keyword) != -1:
		#print(keyword.similarity(pic_keyword))
		#print(keyword.find(pic_keyword))
		#pic_keyword.find(keyword)
		return true
	return false
