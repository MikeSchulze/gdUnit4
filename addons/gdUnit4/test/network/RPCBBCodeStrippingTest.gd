# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite for BBCode stripping functionality in RPC serialization
const __source = 'res://addons/gdUnit4/src/network/rpc/RPC.gd'


func test_strip_bbcode_removes_color_tags():
	# Test basic color tag removal
	var text_with_color = "[color=#FF0000]Error message[/color]"
	var expected = "Error message"
	var actual = RPC._strip_bbcode(text_with_color)
	
	assert_that(actual).is_equal(expected)


func test_strip_bbcode_removes_multiple_color_tags():
	# Test multiple color tags in same string
	var text_with_colors = "[color=#FF0000]Error[/color] and [color=#00FF00]Success[/color]"
	var expected = "Error and Success"
	var actual = RPC._strip_bbcode(text_with_colors)
	
	assert_that(actual).is_equal(expected)


func test_strip_bbcode_removes_nested_tags():
	# Test nested BBCode tags
	var text_with_nested = "[color=#FF0000][b]Bold Error[/b][/color]"
	var expected = "Bold Error"
	var actual = RPC._strip_bbcode(text_with_nested)
	
	assert_that(actual).is_equal(expected)


func test_strip_bbcode_removes_bgcolor_tags():
	# Test background color tags (used in GdUnit4)
	var text_with_bgcolor = "[bgcolor=#FF0000][color=white]Message[/color][/bgcolor]"
	var expected = "Message"
	var actual = RPC._strip_bbcode(text_with_bgcolor)
	
	assert_that(actual).is_equal(expected)


func test_strip_bbcode_preserves_text_without_tags():
	# Test that plain text is unchanged
	var plain_text = "This is plain text with no BBCode tags"
	var actual = RPC._strip_bbcode(plain_text)
	
	assert_that(actual).is_equal(plain_text)


func test_strip_bbcode_handles_empty_string():
	# Test empty string handling
	var empty_text = ""
	var actual = RPC._strip_bbcode(empty_text)
	
	assert_that(actual).is_equal(empty_text)


func test_strip_bbcode_handles_malformed_tags():
	# Test incomplete or malformed tags
	var malformed_text = "[color=#FF0000 incomplete tag and [/color] valid end"
	var expected = " incomplete tag and  valid end"
	var actual = RPC._strip_bbcode(malformed_text)
	
	assert_that(actual).is_equal(expected)


func test_strip_bbcode_from_dict_simple():
	# Test BBCode stripping from dictionary values
	var test_dict = {
		"message": "[color=#FF0000]Error occurred[/color]",
		"plain_key": "No BBCode here",
		"number": 42
	}
	
	RPC._strip_bbcode_from_dict(test_dict)
	
	assert_that(test_dict["message"]).is_equal("Error occurred")
	assert_that(test_dict["plain_key"]).is_equal("No BBCode here")
	assert_that(test_dict["number"]).is_equal(42)


func test_strip_bbcode_from_dict_nested():
	# Test BBCode stripping from nested dictionaries
	var nested_dict = {
		"outer_message": "[color=#00FF00]Outer[/color]",
		"nested": {
			"inner_message": "[color=#FF0000]Inner error[/color]",
			"value": 123
		}
	}
	
	RPC._strip_bbcode_from_dict(nested_dict)
	
	assert_that(nested_dict["outer_message"]).is_equal("Outer")
	assert_that(nested_dict["nested"]["inner_message"]).is_equal("Inner error")
	assert_that(nested_dict["nested"]["value"]).is_equal(123)


func test_strip_bbcode_from_array_simple():
	# Test BBCode stripping from array elements
	var test_array = [
		"[color=#FF0000]Error 1[/color]",
		"Plain text",
		42,
		"[color=#00FF00]Success[/color]"
	]
	
	RPC._strip_bbcode_from_array(test_array)
	
	assert_that(test_array[0]).is_equal("Error 1")
	assert_that(test_array[1]).is_equal("Plain text")
	assert_that(test_array[2]).is_equal(42)
	assert_that(test_array[3]).is_equal("Success")


func test_strip_bbcode_from_array_with_nested_dict():
	# Test BBCode stripping from arrays containing dictionaries
	var complex_array = [
		{"message": "[color=#FF0000]Dict in array[/color]"},
		"[color=#00FF00]String in array[/color]",
		["[color=#0000FF]Nested array string[/color]"]
	]
	
	RPC._strip_bbcode_from_array(complex_array)
	
	assert_that(complex_array[0]["message"]).is_equal("Dict in array")
	assert_that(complex_array[1]).is_equal("String in array")
	assert_that(complex_array[2][0]).is_equal("Nested array string")


func test_serialize_strips_bbcode_from_rpc_data():
	# Test that serialize() method properly strips BBCode
	var rpc = RPC.new()
	rpc._data = {
		"test_result": "[color=#FF0000]Test failed with error[/color]",
		"report": {
			"summary": "[color=#00FF00]2 passed[/color], [color=#FF0000]1 failed[/color]"
		}
	}
	
	var serialized_json = rpc.serialize()
	
	# Parse the JSON to verify BBCode was stripped
	var json = JSON.new()
	var parse_result = json.parse(serialized_json)
	
	assert_that(parse_result).is_equal(OK)
	
	var parsed_data = json.get_data()._data
	assert_that(parsed_data["test_result"]).is_equal("Test failed with error")
	assert_that(parsed_data["report"]["summary"]).is_equal("2 passed, 1 failed")


func test_serialize_deserialize_roundtrip():
	# Test complete serialization -> deserialization roundtrip
	var original_rpc = RPC.new()
	original_rpc._data = {
		"event_type": "test_failed",
		"message": "[color=#FF0000]Assertion failed[/color]",
		"details": {
			"expected": "[color=#00FF00]true[/color]",
			"actual": "[color=#FF0000]false[/color]"
		}
	}
	
	# Serialize (should strip BBCode)
	var serialized = original_rpc.serialize()
	
	# Deserialize
	var deserialized_rpc = RPC.deserialize(serialized)
	
	# Verify data integrity (BBCode should be stripped)
	var data = deserialized_rpc._data
	assert_that(data["event_type"]).is_equal("test_failed")
	assert_that(data["message"]).is_equal("Assertion failed")
	assert_that(data["details"]["expected"]).is_equal("true")
	assert_that(data["details"]["actual"]).is_equal("false")


func test_real_world_gdunit_assert_message():
	# Test with actual GdUnit4 assert message format
	var rpc = RPC.new()
	rpc._data = {
		"reports": [
			{
				"line_number": 42,
				"failure_message": "Expecting:\n [color=#1E90FF]'expected_value'[/color]\n but was\n [color=#1E90FF]'actual_value'[/color]"
			}
		]
	}
	
	var serialized = rpc.serialize()
	var deserialized = RPC.deserialize(serialized)
	
	var report = deserialized._data["reports"][0]
	var expected_clean_message = "Expecting:\n 'expected_value'\n but was\n 'actual_value'"
	
	assert_that(report["failure_message"]).is_equal(expected_clean_message)


func test_performance_with_large_data():
	# Test performance doesn't degrade with large amounts of data
	var large_dict = {}
	
	# Create a large dataset with many BBCode strings
	for i in range(100):
		large_dict["message_%d" % i] = "[color=#FF0000]Error message %d[/color]" % i
		large_dict["nested_%d" % i] = {
			"detail": "[color=#00FF00]Detail %d[/color]" % i,
			"values": [
				"[color=#0000FF]Value 1[/color]",
				"[color=#FFFF00]Value 2[/color]"
			]
		}
	
	var rpc = RPC.new()
	rpc._data = large_dict
	
	# This should complete without hanging or excessive delay
	var start_time = Time.get_ticks_msec()
	var serialized = rpc.serialize()
	var end_time = Time.get_ticks_msec()
	
	# Verify it completed reasonably quickly (less than 1 second)
	var duration = end_time - start_time
	assert_that(duration).is_less_than(1000)
	
	# Verify BBCode was actually stripped
	assert_that(serialized).does_not_contain("[color=")
	assert_that(serialized).does_not_contain("[/color]")


func test_regex_doesnt_break_json_structure():
	# Test that our regex doesn't accidentally remove valid JSON syntax
	var json_like_text = '{"key": "value", "array": [1, 2, 3]}'
	var result = RPC._strip_bbcode(json_like_text)
	
	# Should be unchanged since it contains no BBCode
	assert_that(result).is_equal(json_like_text)


func test_bbcode_with_json_special_chars():
	# Test BBCode that contains JSON special characters
	var complex_text = '[color=#FF0000]Error: {"invalid": "json"}[/color]'
	var expected = 'Error: {"invalid": "json"}'
	var result = RPC._strip_bbcode(complex_text)
	
	assert_that(result).is_equal(expected)