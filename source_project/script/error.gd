class_name ErrorLabel
extends ColorRect

const self_scene : PackedScene = preload("uid://biagmib2dnlhm")

static func throw_error(text : String) -> void:
	var _self : ErrorLabel = self_scene.instantiate()
	var stack : Array = get_stack()
	if !stack.is_empty(): #в релизной версии метод get_stack() может вернуть пустой массив
		stack.remove_at(0)
	var error_text : String = str(stack) + "\n" + text
	_self.get_node("text").set_text(error_text)
	ErrorCanvas.add_child(_self)
	push_error(error_text)

func _on_button_button_up() -> void:
	queue_free()
