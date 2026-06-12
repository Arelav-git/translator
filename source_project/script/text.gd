extends TextEdit
class_name TranslateText

@onready var lang : String = %language.get_text()
@export var translate_to : TextEdit

static var last_focus : TranslateText = null

func _init() -> void:
	last_focus = self

func translate() -> void:
	if !translate_to:
		ErrorLabel.throw_error("нет валидного указателя на translate_to")
		return
	var request_url : String = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=" + lang + "&tl=" + translate_to.lang + "&dt=t&q=" + get_text().uri_encode()
	TranslateReqwest.add_request(translate_to,request_url)

func _on_clean_button_up() -> void:
	set_text("")
	last_focus.grab_focus()

func _on_paste_button_up() -> void:
	set_text(DisplayServer.clipboard_get())
	_on_focus_entered()

func _on_focus_entered() -> void:
	last_focus = self

func _on_text_changed() -> void:
	translate()

func _on_copy_button_up() -> void:
	DisplayServer.clipboard_set(get_text())
