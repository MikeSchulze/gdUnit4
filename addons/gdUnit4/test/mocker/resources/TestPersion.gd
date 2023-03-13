extends Object

var _name
var _value
var _address :Address

class Address:
	var _street :String
	var _code :int
	
	func _init(street :String, code :int):
		_street = street
		_code = code


func _init(name_ :String, street :String, code :int):
	_name = name_
	_value = 1024
	_address = Address.new(street, code)

func name() -> String:
	return _name
