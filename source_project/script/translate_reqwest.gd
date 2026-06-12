extends HTTPRequest

var busy : bool = false
var last_receiver : TranslateText = null
var last_url : String = ""

func add_request(receiver : TranslateText,url : String) -> void:
	last_receiver = receiver
	last_url = url
	if busy : return
	request_completed.connect(_on_request_completed.bind(receiver,url),CONNECT_ONE_SHOT)
	var error : Error = request(url)
	if error != Error.OK:
		ErrorLabel.throw_error("Ошибка при создании HTTP-запроса Error: %s." % [error])
		return
	busy = true

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray,receiver : TranslateText,url : String) -> void:
	busy = false
	if url != last_url:
		add_request(last_receiver,last_url)
	if result != HTTPRequest.RESULT_SUCCESS:
		ErrorLabel.throw_error("Не удалось связаться с сервером перевода.")
		return
	if response_code != 200:
		ErrorLabel.throw_error("Ошибка сервера: " + str(response_code))
		return
	var json_string: String = body.get_string_from_utf8()
	var json : JSON = JSON.new()
	var parse_err : Error = json.parse(json_string)
	
	if parse_err != Error.OK:
		ErrorLabel.throw_error("Ошибка парсинга JSON.")
		return
	var response_data : Variant = json.get_data()
	if response_data is Array && response_data.size() > 0 && response_data[0] is Array && response_data[0].size() > 0:
		var translated_text: String = response_data[0][0][0]
		receiver.set_text(translated_text)
	else:
		ErrorLabel.throw_error("Не удалось разобрать структуру ответа.")
		
