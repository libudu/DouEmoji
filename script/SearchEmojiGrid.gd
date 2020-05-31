extends EmojiGrid


# 开始搜索关键词
func start_search(keyword:String, strict_match:bool):
	children_queue_free()
	for pic_name in Global.picture_dir:
		var pic_keyword_str:String = Global.picture_dir[pic_name]["keyword"]
		if keyword == "" and pic_keyword_str == "":
			add_emoji_child(pic_name)
		else: 
			for pic_keyword in pic_keyword_str.split(" ", false):
				if strict_match == false and unstrict_judge_keyword(keyword, pic_keyword) or strict_match == true and keyword == pic_keyword:
					add_emoji_child(pic_name)


# 模糊搜索时对关键词是否符合的判断逻辑
func unstrict_judge_keyword(keyword:String, pic_keyword:String) -> bool:
	if keyword.similarity(pic_keyword) > 0 or keyword.find(pic_keyword) != -1 or pic_keyword.find(keyword) != -1:
		#print(keyword.similarity(pic_keyword))
		#print(keyword.find(pic_keyword))
		#pic_keyword.find(keyword)
		return true
	return false


func children_queue_free():
	emoji_children_dir.clear()
	for child in get_children():
		child.queue_free()
