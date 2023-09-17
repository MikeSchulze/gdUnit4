extends Control


var _stage := 0


func _ready():
	var test_suite :GdUnitTestSuite = GdUnitTestResourceLoader.load_test_suite("res://addons/gdUnit4/test/asserts/GdUnitBoolAssertImplTest.gd")
	await GdUnitTestSuiteExecutor.new().execute(test_suite)
	# exit
	_stage = 100



func _process(_delta):
	if _stage == 100:
		_stage = 0
		await get_tree().process_frame
		prints("finallize ...")
		Engine.get_main_loop().root.print_tree()
		await get_tree().process_frame
		get_tree().quit()

