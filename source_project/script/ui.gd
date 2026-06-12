extends CanvasLayer

var data : SaveData = load("res://singleton/save_data.tres")

func _init() -> void:
	setup_data()
	DisplayServer.window_set_position(data.window_rect2i.position)
	DisplayServer.window_set_size(data.window_rect2i.size)

func setup_data() -> void:
	if ResourceLoader.exists("user://data.tres"):
		var check_data : SaveData = ResourceLoader.load("user://data.tres")
		if check_data && check_data.version == data.version:
			data = ResourceLoader.load("user://data.tres")

func get_data() -> SaveData:
	return data

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		data.font_size = %font_size.get_value()
		data.always_on_top = %always_on_top.is_pressed()
		data.window_rect2i.position = DisplayServer.window_get_position()
		data.window_rect2i.size = DisplayServer.window_get_size()
		ResourceSaver.save(data,"user://data.tres")
