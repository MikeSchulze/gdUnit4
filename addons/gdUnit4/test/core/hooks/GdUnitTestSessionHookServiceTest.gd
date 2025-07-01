# GdUnit generated TestSuite
extends GdUnitTestSuite


func test_load_hook_not_exists() -> void:
	var hook := GdUnitTestSessionHookService.new().load_hook("res://addons/gdUnit4/test/core/hooks/InvalidTestSessionHook.gd")

	assert_result(hook)\
		.is_error()\
		.contains_message("The hook 'res://addons/gdUnit4/test/core/hooks/InvalidTestSessionHook.gd' not exists.")


func test_load_hook_not_inherits_hook() -> void:
	var hook := GdUnitTestSessionHookService.new().load_hook("res://addons/gdUnit4/test/core/hooks/GdUnitTestSessionHookServiceTest.gd")

	assert_result(hook)\
		.is_error()\
		.contains_message("The hook 'res://addons/gdUnit4/test/core/hooks/GdUnitTestSessionHookServiceTest.gd' must inhertit from 'GdUnitTestSessionHook'.")


func test_load_hook_success() -> void:
	var hook := GdUnitTestSessionHookService.new().load_hook("res://addons/gdUnit4/test/core/hooks/ExampleTestSessionHook.gd")

	assert_result(hook).is_success()
	assert_object(hook.value())\
		.is_not_null()\
		.is_inheriting(GdUnitTestSessionHook)


func test_register_hook() -> void:
	var service := GdUnitTestSessionHookService.new()

	var hook := ExampleTestSessionHook.new()
	service.register(hook)

	# verify
	assert_array(service.enigne_hooks).contains_exactly([hook])

	# try to register at twice should fail
	var result := service.register(hook)
	assert_result(result)\
		.is_error()\
		.contains_message("A hook instance of 'res://addons/gdUnit4/test/core/hooks/ExampleTestSessionHook.gd' is already registered.")
	assert_array(service.enigne_hooks).contains_exactly([hook])


func test_register_hook_invalid_priority() -> void:
	var service := GdUnitTestSessionHookService.new()

	assert_result(service.register(PriorizedTestSessionHook.new(-10, "hook_a")))\
		.is_error()\
		.contains_message("The hook priority of 'res://addons/gdUnit4/test/core/hooks/PriorizedTestSessionHook.gd' must by higher than 0.")


func test_execute_startup() -> void:
	var service := GdUnitTestSessionHookService.new()

	var hook := ExampleTestSessionHook.new()
	service.register(hook)

	assert_array(hook._state).is_empty()

	service.execute_startup(GdUnitTestSession.new([]))
	assert_array(hook._state).contains_exactly(["startup"])


func test_execute_shutdown() -> void:
	var service := GdUnitTestSessionHookService.new()

	var hook := ExampleTestSessionHook.new()
	service.register(hook)

	assert_array(hook._state).is_empty()

	service.execute_shutdown(GdUnitTestSession.new([]))
	assert_array(hook._state).contains_exactly(["shutdown"])


func test_hook_priority_execution() -> void:
	var service := GdUnitTestSessionHookService.new()
	var hook_a := PriorizedTestSessionHook.new(10, "hook_a")
	var hook_b := PriorizedTestSessionHook.new(20, "hook_b")
	var hook_c := PriorizedTestSessionHook.new(30, "hook_c")

	var start_up_called := PackedStringArray()
	hook_a.start_up.connect(func(hook_name: String) -> void: start_up_called.push_back(hook_name))
	hook_b.start_up.connect(func(hook_name: String) -> void: start_up_called.push_back(hook_name))
	hook_c.start_up.connect(func(hook_name: String) -> void: start_up_called.push_back(hook_name))
	var shutdown_called := PackedStringArray()
	hook_a.shut_down.connect(func(hook_name: String) -> void: shutdown_called.push_back(hook_name))
	hook_b.shut_down.connect(func(hook_name: String) -> void: shutdown_called.push_back(hook_name))
	hook_c.shut_down.connect(func(hook_name: String) -> void: shutdown_called.push_back(hook_name))

	# register unorderd
	assert_result(service.register(hook_b)).is_success()
	assert_result(service.register(hook_c)).is_success()
	assert_result(service.register(hook_a)).is_success()

	# must be executed ordered by priority
	var test_session := GdUnitTestSession.new([])
	assert_result(await service.execute_startup(test_session)).is_success()
	assert_result(await service.execute_shutdown(test_session)).is_success()

	# verify is called in the correct order
	assert_array(start_up_called).contains_exactly(["hook_a", "hook_b", "hook_c"])
	assert_array(shutdown_called).contains_exactly(["hook_a", "hook_b", "hook_c"])
