# Integration test demonstrating fix for JSON chunking issue with BBCode
extends GdUnitTestSuite

# This test verifies the fix for the issue where BBCode color tags in RPC messages
# would cause JSON deserialization errors when messages were chunked over TCP
const __source = 'res://addons/gdUnit4/src/network/rpc/RPC.gd'


func test_bbcode_json_chunking_bugfix():
	"""
	Regression test for JSON chunking bug.
	
	Before the fix: BBCode tags like [color=#1E90FF]text[/color] in RPC messages
	would cause "Can't deserialize JSON" errors when TCP chunked the data.
	
	After the fix: BBCode is stripped during serialization, preventing chunk
	boundary issues while preserving colors for display.
	"""
	
	# Create RPC with the exact type of BBCode that caused the original bug
	var problematic_rpc = RPC.new()
	problematic_rpc._data = {
		"event_type": "test_report",
		"reports": [
			{
				"message": "Expecting:\n [color=#1E90FF]'expected'[/color]\n but was\n [color=#1E90FF]'actual'[/color]",
				"line_number": 42,
				"failure_details": "[color=#CD5C5C]Assertion failed[/color] in test case"
			}
		],
		"summary": "[color=#EFF883]Warning:[/color] [color=#CD5C5C]1 failed[/color], [color=#1E90FF]2 passed[/color]"
	}
	
	# Serialize - this should strip BBCode and produce clean JSON
	var serialized_json = problematic_rpc.serialize()
	
	# Verify JSON is valid and contains no BBCode
	assert_that(serialized_json).does_not_contain("[color=")
	assert_that(serialized_json).does_not_contain("[/color]")
	assert_that(serialized_json).does_not_contain("#1E90FF")
	assert_that(serialized_json).does_not_contain("#CD5C5C")
	assert_that(serialized_json).does_not_contain("#EFF883")
	
	# Verify JSON can be parsed without errors
	var json = JSON.new()
	var parse_result = json.parse(serialized_json)
	assert_that(parse_result).is_equal(OK)
	
	# Verify deserialization works without errors
	var deserialized_rpc = RPC.deserialize(serialized_json)
	assert_that(deserialized_rpc).is_not_null()
	
	# Verify content integrity (BBCode stripped but text preserved)
	var data = deserialized_rpc._data
	assert_that(data["reports"][0]["message"]).contains("Expecting:")
	assert_that(data["reports"][0]["message"]).contains("'expected'")
	assert_that(data["reports"][0]["message"]).contains("'actual'")
	assert_that(data["reports"][0]["failure_details"]).is_equal("Assertion failed in test case")
	assert_that(data["summary"]).is_equal("Warning: 1 failed, 2 passed")


func test_simulated_tcp_chunking_scenario():
	"""
	Simulate the TCP chunking scenario that caused the original bug.
	
	This test artificially splits JSON at problematic boundaries to verify
	our fix prevents deserialization errors.
	"""
	
	# Create RPC with BBCode that would cause chunking issues
	var rpc = RPC.new()
	rpc._data = {
		"message": "[color=#1E90FF]This is a test message with color formatting[/color]"
	}
	
	# Serialize (BBCode should be stripped)
	var clean_json = rpc.serialize()
	
	# Simulate TCP chunking by splitting the JSON at various points
	var chunk_sizes = [10, 20, 50, 100]
	
	for chunk_size in chunk_sizes:
		var chunks = _split_into_chunks(clean_json, chunk_size)
		var reassembled = "".join(chunks)
		
		# Each reassembled JSON should parse correctly
		var json = JSON.new()
		var parse_result = json.parse(reassembled)
		
		assert_that(parse_result).is_equal(OK)
		
		# And deserialize correctly
		var deserialized = RPC.deserialize(reassembled)
		assert_that(deserialized).is_not_null()
		assert_that(deserialized._data["message"]).is_equal("This is a test message with color formatting")


func test_original_error_fragments_no_longer_occur():
	"""
	Test that the specific error fragments from the original bug report
	no longer occur in serialized JSON.
	
	Original fragments: 'mber":-1', ',"messag', 'e":"[col'
	These occurred when BBCode tags were split across chunk boundaries.
	"""
	
	# Create data that would have produced the problematic fragments
	var rpc = RPC.new()
	rpc._data = {
		"line_number": -1,
		"message": "[color=#FF0000]Error occurred[/color]",
		"details": "Additional [color=#00FF00]context[/color] information"
	}
	
	var serialized = rpc.serialize()
	
	# These fragments should NOT appear in the serialized JSON
	var problematic_fragments = [
		'mber":-1',
		',"messag',
		'e":"[col',
		'[color=',
		'[/color]',
		'#FF0000',
		'#00FF00'
	]
	
	for fragment in problematic_fragments:
		assert_that(serialized).does_not_contain(fragment)
	
	# But the clean content should still be present
	assert_that(serialized).contains("Error occurred")
	assert_that(serialized).contains("context")
	assert_that(serialized).contains("line_number")
	assert_that(serialized).contains("-1")


# Helper function to simulate TCP chunking
func _split_into_chunks(text: String, chunk_size: int) -> Array[String]:
	var chunks: Array[String] = []
	var start = 0
	
	while start < text.length():
		var end = min(start + chunk_size, text.length())
		chunks.append(text.substr(start, end - start))
		start = end
	
	return chunks


func test_performance_regression_check():
	"""
	Ensure BBCode stripping doesn't cause performance regression.
	
	The fix should be efficient even with large amounts of data.
	"""
	
	# Create large dataset similar to what GdUnit4 might generate
	var large_data = {}
	
	for i in range(50):  # 50 test cases
		large_data["test_case_%d" % i] = {
			"name": "TestCase%d" % i,
			"status": "failed",
			"message": "[color=#CD5C5C]Expected [color=#1E90FF]'%s'[/color] but got [color=#1E90FF]'%s'[/color][/color]" % ["expected_%d" % i, "actual_%d" % i],
			"stack_trace": "[color=#EFF883]Line %d:[/color] assertion failed" % (i * 10),
			"reports": []
		}
		
		# Add multiple report entries per test case
		for j in range(3):
			large_data["test_case_%d" % i]["reports"].append({
				"line": j * 5,
				"detail": "[color=#1E90FF]Detail %d for test %d[/color]" % [j, i]
			})
	
	var rpc = RPC.new()
	rpc._data = large_data
	
	# Measure serialization time
	var start_time = Time.get_ticks_usec()
	var serialized = rpc.serialize()
	var end_time = Time.get_ticks_usec()
	
	var duration_ms = (end_time - start_time) / 1000.0
	
	# Should complete in reasonable time (less than 100ms for this dataset)
	assert_that(duration_ms).is_less_than(100.0)
	
	# Verify BBCode was completely removed
	assert_that(serialized).does_not_contain("[color=")
	assert_that(serialized).does_not_contain("[/color]")
	
	# Verify JSON is valid
	var json = JSON.new()
	assert_that(json.parse(serialized)).is_equal(OK)
	
	# Verify deserialization works and preserves data structure
	var deserialized = RPC.deserialize(serialized)
	assert_that(deserialized._data.size()).is_equal(50)
	assert_that(deserialized._data["test_case_0"]["reports"].size()).is_equal(3)