extends Object

var _message

func _init(message:String, path:String="", load_on_init:bool=false, 
	set_auto_save:bool=false, set_network_sync:bool=false
) -> void:
	_message = message

func a1(set_name:String, path:String="", load_on_init:bool=false, 
	set_auto_save:bool=false, set_network_sync:bool=false
) -> void:
	pass

func a2(set_name:String, path:String="", load_on_init:bool=false, 
	set_auto_save:bool=false, set_network_sync:bool=false
) -> 	void:
	pass

func a3(set_name:String, path:String="", load_on_init:bool=false, 
	set_auto_save:bool=false, set_network_sync:bool=false
) :
	pass

func a4(set_name:String,
	path:String="",
	load_on_init:bool=false,
	set_auto_save:bool=false,
	set_network_sync:bool=false
):
	pass

func a5(
	value : Array,
	expected : String,
	test_parameters : Array = [
		[ ["a"], "a" ],
		[ ["a", "very", "long", "argument"], "a very long argument" ],
	]
):
	pass
