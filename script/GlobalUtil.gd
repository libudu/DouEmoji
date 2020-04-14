extends Node


# 读取目录中所有的指定后缀文件
func search_dir(path:String, suffix_list := []) -> Array:
	var file_list := []
	var file_name := ""
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		file_name = dir.get_next()
		while file_name != "":
			if suffix_list == []:
				file_list.append(path + file_name)
			else:
				for suffix in suffix_list:
					if file_name.ends_with(suffix):
						file_list.append(path + file_name)
						break
			file_name = dir.get_next()
		dir.list_dir_end()
	return file_list


# 解析json文件
func read_json(file_name:String) -> Dictionary:
	var file = File.new()
	file.open(file_name, File.READ)
	var content = file.get_as_text()
	file.close()
	var pr := JSON.parse(content)
	if pr.error != OK:
		OS.alert("文件%s解析错误。\n错误行数：%s\n错误原因：%s" % [file_name, pr.error_line, pr.error_string])
	return pr.result


# 读取路径转为图像
func load_image_from_path(path:String) -> ImageTexture:
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
