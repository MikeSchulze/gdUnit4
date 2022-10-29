extends Object

enum { FOO, BAR, BAZ }

static func to_str(type:int):
	match type:
		FOO: return "FOO"
		BAR: return "BAR"
		BAZ: return "BAZ"
