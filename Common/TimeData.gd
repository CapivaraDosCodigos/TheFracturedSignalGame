extends RefCounted
class_name TimeData

static func get_time() -> String:
	var data: String = Time.get_date_string_from_system()
	var hora: String = Time.get_time_string_from_system().substr(0, 5)
	var data_hora: String = "%s %sh%s" % [data.replace("-", "/"), hora.substr(0, 2), hora.substr(3, 2)]
	return data_hora
