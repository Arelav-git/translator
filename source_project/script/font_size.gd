extends SpinBox

func _ready() -> void:
	var _val : int = Ui.get_data().font_size
	set_value(_val)
	_on_value_changed(_val)

func _on_value_changed(_value: float) -> void:
	ThemeDB.get_project_theme().set_default_font_size(int(_value))
