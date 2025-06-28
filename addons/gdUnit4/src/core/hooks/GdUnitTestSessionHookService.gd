class_name GdUnitTestSessionHookService
extends RefCounted


var enigne_hooks: Array[GdUnitTestSessionHook] = []:
	get:
		return enigne_hooks
	set(value):
		enigne_hooks.append(value)


static func sort_by_priority(left: GdUnitTestSessionHook, right: GdUnitTestSessionHook) -> int:
	return left.priority < right.priority


func register(hook: GdUnitTestSessionHook, is_system_hook := false) -> GdUnitResult:
	if !is_system_hook and hook.priority < 0:
		return GdUnitResult.error("The hook priority of '%s' must by higher than 0." % hook.get_script().resource_path)
	if enigne_hooks.has(hook):
		return GdUnitResult.error("A hook instance of '%s' is already registered." % hook.get_script().resource_path)

	enigne_hooks.append(hook)
	enigne_hooks.sort_custom(sort_by_priority)

	return GdUnitResult.success("")


func load_hook(hook_resourc_path: String) -> GdUnitResult:
	if !FileAccess.file_exists(hook_resourc_path):
		return GdUnitResult.error("The hook '%s' not exists." % hook_resourc_path)
	var script: GDScript = load(hook_resourc_path)
	if script.get_base_script() != GdUnitTestSessionHook:
		return GdUnitResult.error("The hook '%s' must inhertit from 'GdUnitTestSessionHook'." % hook_resourc_path)

	return GdUnitResult.success(script.new())


func execute_startup(session: GdUnitTestSession) -> GdUnitResult:
	return await execute("startup", session)


func execute_shutdown(session: GdUnitTestSession) -> GdUnitResult:
	return await execute("shutdown", session)


func execute(hook_func: String, session: GdUnitTestSession) -> GdUnitResult:
	var failed_hook_calls: Array[GdUnitResult] = []
	for hook in enigne_hooks:
		var result: GdUnitResult = await hook.call(hook_func, session)
		if result == null:
			failed_hook_calls.push_back(GdUnitResult.error("Result is null! Check '%s'" % hook.get_script().resource_path))
		elif result.is_error():
			failed_hook_calls.push_back(result)

	if failed_hook_calls.is_empty():
		return GdUnitResult.success()

	var errors := failed_hook_calls.map(func(result: GdUnitResult) -> String:
		return "Hook call '%s' failed with error: '%s'" % [hook_func, result.error_message()]
	)
	return GdUnitResult.error( "\n".join(errors))
