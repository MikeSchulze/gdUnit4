# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name GdUnitSignalAssertImplTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitSignalAssertImpl.gd'
const GdUnitTools = preload("res://addons/gdUnit4/src/core/GdUnitTools.gd")


class TestEmitter extends Node:
	signal test_signal_counted(value)
	signal test_signal(value :int)
	signal test_signal_unused()
	
	var _trigger_count :int
	var _count := 0
	
	func _init(trigger_count := 10):
		_trigger_count = trigger_count
	
	func _process(_delta):
		if _count >= _trigger_count:
			test_signal_counted.emit(_count)
		
		if _count == 20:
			test_signal.emit(10)
			test_signal.emit(20)
		_count += 1


var signal_emitter :TestEmitter


func before_test():
	signal_emitter = auto_free(TestEmitter.new())
	add_child(signal_emitter)


# we need to skip await fail test because of an bug in Godot 4.0 stable
func is_skip_fail_await() -> bool:
	return Engine.get_version_info().hex < 0x40002


# using this helper to await for the given callable and assert the failure
func verify_failed(cb :Callable) -> GdUnitStringAssert:
	GdAssertReports.expect_fail(true)
	await cb.call()
	GdAssertReports.expect_fail(false)
	
	var a :GdUnitSignalAssert = GdUnitThreadManager.get_current_context().get_assert()
	return assert_str(GdUnitTools.richtext_normalize(a._failure_message()))


func test_invalid_arg() -> void:
	(await verify_failed(func(): assert_signal(null).wait_until(50).is_emitted("test_signal_counted")))\
		.is_equal("Can't wait for signal checked a NULL object.")
	(await verify_failed(func(): await assert_signal(null).wait_until(50).is_not_emitted("test_signal_counted")))\
		.is_equal("Can't wait for signal checked a NULL object.")


func test_unknown_signal() -> void:
	(await verify_failed(func(): await assert_signal(signal_emitter).wait_until(50).is_emitted("unknown"))) \
		.is_equal("Can't wait for non-existion signal 'unknown' checked object 'Node'.")


func test_signal_is_emitted_without_args() -> void:
	# wait until signal 'test_signal_counted' without args
	await assert_signal(signal_emitter).is_emitted("test_signal", [10])
	await assert_signal(signal_emitter).is_emitted("test_signal", [20])
	# wait until signal 'test_signal_unused' where is never emitted
	
	if is_skip_fail_await():
		return
	
	(await verify_failed(func(): await assert_signal(signal_emitter).wait_until(500).is_emitted("test_signal_unused")))\
		.is_equal("Expecting emit signal: 'test_signal_unused()' but timed out after 500ms")


func test_signal_is_emitted_with_args() -> void:
	# wait until signal 'test_signal' is emitted with value 30
	await assert_signal(signal_emitter).is_emitted("test_signal_counted", [20])
	
	if is_skip_fail_await():
		return
	(await verify_failed(func(): await assert_signal(signal_emitter).wait_until(50).is_emitted("test_signal_counted", [500]))) \
		.is_equal("Expecting emit signal: 'test_signal_counted([500])' but timed out after 50ms")


func test_signal_is_not_emitted() -> void:
	# wait to verify signal 'test_signal_counted()' is not emitted until the first 50ms
	await assert_signal(signal_emitter).wait_until(50).is_not_emitted("test_signal_counted")
	# wait to verify signal 'test_signal_counted(50)' is not emitted until the NEXT first 80ms
	await assert_signal(signal_emitter).wait_until(30).is_not_emitted("test_signal_counted", [50])
	
	if is_skip_fail_await():
		return
	# until the next 500ms the signal is emitted and ends in a failure
	(await verify_failed(func(): await assert_signal(signal_emitter).wait_until(1000).is_not_emitted("test_signal_counted", [50]))) \
		.starts_with("Expecting do not emit signal: 'test_signal_counted([50])' but is emitted after")


func test_override_failure_message() -> void:
	if is_skip_fail_await():
		return
	
	(await verify_failed(func(): await assert_signal(signal_emitter) \
		.override_failure_message("Custom failure message")\
		.wait_until(100)\
		.is_emitted("test_signal_unused"))) \
		.is_equal("Custom failure message")


func test_node_changed_emitting_signals():
	var node :Node2D = auto_free(Node2D.new())
	add_child(node)
	
	await assert_signal(node).wait_until(200).is_emitted("draw")
	
	node.visible = false;
	await assert_signal(node).wait_until(200).is_emitted("visibility_changed")
	
	# expecting to fail, we not changed the visibility
	#node.visible = true;
	if not is_skip_fail_await():
		(await verify_failed(func(): await assert_signal(node).wait_until(200).is_emitted("visibility_changed")))\
			.is_equal("Expecting emit signal: 'visibility_changed()' but timed out after 200ms")
	
	node.show()
	await assert_signal(node).wait_until(200).is_emitted("draw")


func test_is_signal_exists() -> void:
	var node :Node2D = auto_free(Node2D.new())
	
	assert_signal(node).is_signal_exists("visibility_changed")\
		.is_signal_exists("draw")\
		.is_signal_exists("visibility_changed")\
		.is_signal_exists("tree_entered")\
		.is_signal_exists("tree_exiting")\
		.is_signal_exists("tree_exited")
	
	if is_skip_fail_await():
		return
	
	(await verify_failed(func(): assert_signal(node).is_signal_exists("not_existing_signal"))) \
		.is_equal("The signal 'not_existing_signal' not exists checked object 'Node2D'.")


class MyEmitter extends Node:
	
	signal my_signal_a
	signal my_signal_b(value :String)
	
	
	func do_emit_a() -> void:
		my_signal_a.emit()
	
	
	func do_emit_b() -> void:
		my_signal_b.emit("foo")


func test_monitor_signals() -> void:
	# start to watch on the emitter to collect all emitted signals
	var emitter_a := monitor_signals(MyEmitter.new())
	var emitter_b := monitor_signals(MyEmitter.new())
	
	# verify the signals are not emitted initial
	await assert_signal(emitter_a).wait_until(50).is_not_emitted('my_signal_a')
	await assert_signal(emitter_a).wait_until(50).is_not_emitted('my_signal_b')
	await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_a')
	await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_b')
	
	# emit signal `my_signal_a` on emitter_a
	emitter_a.do_emit_a()
	await assert_signal(emitter_a).is_emitted('my_signal_a')
	
	# emit signal `my_signal_b` on emitter_a
	emitter_a.do_emit_b()
	await assert_signal(emitter_a).is_emitted('my_signal_b', ["foo"])
	# verify emitter_b still has nothing emitted
	await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_a')
	await assert_signal(emitter_b).wait_until(50).is_not_emitted('my_signal_b')
	
	# now verify emitter b
	emitter_b.do_emit_a()
	await assert_signal(emitter_b).wait_until(50).is_emitted('my_signal_a')


class ExampleResource extends Resource:
	@export var title := "Title":
		set(new_value):
			title = new_value
			changed.emit()
	
	
	func change_title(p_title: String) -> void:
		title = p_title


func test_monitor_signals_on_resource_set() -> void:
	var sut = ExampleResource.new()
	var emitter := monitor_signals(sut)
	
	sut.change_title("Some title")
	
	# title change should emit "changed" signal
	await assert_signal(emitter).is_emitted("changed")
	assert_str(sut.title).is_equal("Some title")

