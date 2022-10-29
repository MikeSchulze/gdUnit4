@tool
class_name ClassWithVariables
extends Resource

enum{
	A,
	B,
	C
}

enum ETYPE 	{
	EA,
	EB
	}

# Declare member variables here. Examples:
var a = 2
var b = "text"

# Declare some const variables
const T1 = 1

const T2 = 2

signal source_changed( text )

@onready var name_label = "../HBoxContainer/Effect Name"

@export var path: NodePath = ".."

class ClassA:
	var x = 1
	# some comment
	func foo()->String:
		return ""

var _data:= Dictionary()
func foo( value :int = T1):
	var c = a + b
	pass
