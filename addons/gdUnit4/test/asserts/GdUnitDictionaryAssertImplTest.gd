# GdUnit generated TestSuite
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/asserts/GdUnitDictionaryAssertImpl.gd'


func test_must_fail_has_invlalid_type() -> void:
	assert_failure(func(): assert_dict(1)) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <int>")
	assert_failure(func(): assert_dict(1.3)) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <float>")
	assert_failure(func(): assert_dict(true)) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <bool>")
	assert_failure(func(): assert_dict("abc")) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <String>")
	assert_failure(func(): assert_dict([])) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <Array>")
	assert_failure(func(): assert_dict(Resource.new())) \
		.is_failed() \
		.has_message("GdUnitDictionaryAssert inital error, unexpected type <Object>")


func test_is_null() -> void:
	assert_dict(null).is_null()
	
	assert_failure(func(): assert_dict({}).is_null()) \
		.is_failed() \
		.has_message("Expecting: '<null>' but was '{ }'")


func test_is_not_null() -> void:
	assert_dict({}).is_not_null()
	
	assert_failure(func(): assert_dict(null).is_not_null()) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_is_equal() -> void:
	assert_dict({}).is_equal({})
	assert_dict({1:1}).is_equal({1:1})
	assert_dict({1:1, "key_a": "value_a"}).is_equal({1:1, "key_a": "value_a" })
	# different order is also equals
	assert_dict({"key_a": "value_a", 1:1}).is_equal({1:1, "key_a": "value_a" })
	
	# should fail
	assert_failure(func(): assert_dict(null).is_equal({1:1})) \
		.is_failed() \
		.has_message("""
			Expecting:
			 '{
				1: 1
			  }'
			 but was
			 '<null>'"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict({}).is_equal({1:1})).is_failed()
	assert_failure(func(): assert_dict({1:1}).is_equal({})).is_failed()
	assert_failure(func(): assert_dict({1:1}).is_equal({1:2})).is_failed()
	assert_failure(func(): assert_dict({1:2}).is_equal({1:1})).is_failed()
	assert_failure(func(): assert_dict({1:1}).is_equal({1:1, "key_a": "value_a"})).is_failed()
	assert_failure(func(): assert_dict({1:1, "key_a": "value_a"}).is_equal({1:1})).is_failed()
	assert_failure(func(): assert_dict({1:1, "key_a": "value_a"}).is_equal({1:1, "key_b": "value_b"})).is_failed()
	assert_failure(func(): assert_dict({1:1, "key_b": "value_b"}).is_equal({1:1, "key_a": "value_a"})).is_failed()
	assert_failure(func(): assert_dict({"key_a": "value_a", 1:1}).is_equal({1:1, "key_b": "value_b"})).is_failed()
	assert_failure(func(): assert_dict({1:1, "key_b": "value_b"}).is_equal({"key_a": "value_a", 1:1})) \
		.is_failed() \
		.has_message("""
			Expecting:
			 '{
				1: 1,
				"key_a": "value_a"
			  }'
			 but was
			 '{
				1: 1,
				"key_ab": "value_ab"
			  }'"""
			.dedent()
			.trim_prefix("\n")
		)


func test_is_not_equal() -> void:
	assert_dict(null).is_not_equal({})
	assert_dict({}).is_not_equal(null)
	assert_dict({}).is_not_equal({1:1})
	assert_dict({1:1}).is_not_equal({})
	assert_dict({1:1}).is_not_equal({1:2})
	assert_dict({2:1}).is_not_equal({1:1})
	assert_dict({1:1}).is_not_equal({1:1, "key_a": "value_a"})
	assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1})
	assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1,  "key_b": "value_b"})
	
	# should fail
	assert_failure(func(): assert_dict({}).is_not_equal({})).is_failed()
	assert_failure(func(): assert_dict({1:1}).is_not_equal({1:1})).is_failed()
	assert_failure(func(): assert_dict({1:1, "key_a": "value_a"}).is_not_equal({1:1, "key_a": "value_a"})).is_failed()
	assert_failure(func(): assert_dict({"key_a": "value_a", 1:1}).is_not_equal({1:1, "key_a": "value_a"})) \
		.is_failed() \
		.has_message("""
			Expecting:
			 '{
				1: 1,
				"key_a": "value_a"
			  }'
			 not equal to
			 '{
				1: 1,
				"key_a": "value_a"
			  }'"""
			.dedent()
			.trim_prefix("\n")
		)


func test_is_empty() -> void:
	assert_dict({}).is_empty()
	
	assert_failure(func(): assert_dict(null).is_empty()) \
		.is_failed() \
		.has_message("Expecting:\n"
			+ " must be empty but was\n"
			+ " '<null>'")
	assert_failure(func(): assert_dict({1:1}).is_empty()) \
		.is_failed() \
		.has_message("""
			Expecting:
			 must be empty but was
			 '{
				1: 1
			  }'"""
			.dedent()
			.trim_prefix("\n")
		)


func test_is_not_empty() -> void:
	assert_dict({1:1}).is_not_empty()
	assert_dict({1:1, "key_a": "value_a"}).is_not_empty()
	
	assert_failure(func(): assert_dict(null).is_not_empty()) \
		.is_failed() \
		.has_message("Expecting:\n"
			+ " must not be empty")
	assert_failure(func(): assert_dict({}).is_not_empty()).is_failed()


func test_has_size() -> void:
	assert_dict({}).has_size(0)
	assert_dict({1:1}).has_size(1)
	assert_dict({1:1, 2:1}).has_size(2)
	assert_dict({1:1, 2:1, 3:1}).has_size(3)
	
	assert_failure(func(): assert_dict(null).has_size(0))\
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")
	assert_failure(func(): assert_dict(null).has_size(1)).is_failed()
	assert_failure(func(): assert_dict({}).has_size(1)).is_failed()
	assert_failure(func(): assert_dict({1:1}).has_size(0)).is_failed()
	assert_failure(func(): assert_dict({1:1}).has_size(2)) \
		.is_failed() \
		.has_message("""
			Expecting size:
			 '2'
			 but was
			 '1'"""
			.dedent()
			.trim_prefix("\n")
		)


func test_contains_keys() -> void:
	assert_dict({1:1, 2:2, 3:3}).contains_keys([2])
	assert_dict({1:1, 2:2, "key_a": "value_a"}).contains_keys([2, "key_a"])
	
	assert_failure(func(): assert_dict({1:1, 3:3}).contains_keys([2])) \
		.is_failed() \
		.has_message("""
			Expecting keys:
			 1, 3
			 to contains:
			 2
			 but can't find key's:
			 2"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict({1:1, 3:3}).contains_keys([1, 4])) \
		.is_failed() \
		.has_message("""
			Expecting keys:
			 1, 3
			 to contains:
			 1, 4
			 but can't find key's:
			 4"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict(null).contains_keys([1, 4])) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_contains_not_keys() -> void:
	assert_dict({}).contains_not_keys([2])
	assert_dict({1:1, 3:3}).contains_not_keys([2])
	assert_dict({1:1, 3:3}).contains_not_keys([2, 4])
	
	assert_failure(func(): assert_dict({1:1, 2:2, 3:3}).contains_not_keys([2, 4])) \
		.is_failed() \
		.has_message("""
			Expecting keys:
			 1, 2, 3
			 do not contains:
			 2, 4
			 but contains key's:
			 2"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict({1:1, 2:2, 3:3}).contains_not_keys([1, 2, 3, 4])) \
		.is_failed() \
		.has_message("""
			Expecting keys:
			 1, 2, 3
			 do not contains:
			 1, 2, 3, 4
			 but contains key's:
			 1, 2, 3"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict(null).contains_not_keys([1, 4])) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_contains_key_value() -> void:
	assert_dict({1:1}).contains_key_value(1, 1)
	assert_dict({1:1, 2:2, 3:3}).contains_key_value(3, 3).contains_key_value(1, 1)
	
	assert_failure(func(): assert_dict({1:1}).contains_key_value(1, 2)) \
		.is_failed() \
		.has_message("""
			Expecting key and value:
			 '1' : '2'
			 but contains
			 '1' : '1'"""
			.dedent()
			.trim_prefix("\n")
		)
	assert_failure(func(): assert_dict(null).contains_key_value(1, 2)) \
		.is_failed() \
		.has_message("Expecting: not to be '<null>'")


func test_override_failure_message() -> void:
	assert_failure(func(): assert_dict({1:1}) \
			.override_failure_message("Custom failure message") \
			.is_null()) \
		.is_failed() \
		.has_message("Custom failure message")


var _value = 0
func next_value() -> Dictionary:
	_value += 1
	return { "key_%d" % _value : _value}


func test_with_value_provider() -> void:
	assert_dict(CallBackValueProvider.new(self, "next_value"))\
		.is_equal({"key_1" : 1}).is_equal({"key_2" : 2}).is_equal({"key_3" : 3})


# tests if an assert fails the 'is_failure' reflects the failure status
func test_is_failure() -> void:
	# initial is false
	assert_bool(is_failure()).is_false()

	# checked success assert
	assert_dict({}).is_empty()
	assert_bool(is_failure()).is_false()

	# checked faild assert
	assert_failure(func(): assert_dict({}).is_not_empty()).is_failed()
	assert_bool(is_failure()).is_true()

	# checked next success assert
	assert_dict({}).is_empty()
	# is true because we have an already failed assert
	assert_bool(is_failure()).is_true()

	# should abort here because we had an failing assert
	if is_failure():
		return
	assert_bool(true).override_failure_message("This line shold never be called").is_false()
