extends GdUnitTestSuite

const MIN_VALUE := -10
const MAX_VALUE := 22

class NestedFuzzer extends Fuzzer:
	
	func _init():
		pass
	
	func next_value()->Dictionary: 
		return {}

	static func _s_max_value() -> int:
		return MAX_VALUE

func min_value() -> int:
	return MIN_VALUE

func get_fuzzer() -> Fuzzer:
	return Fuzzers.rangei(min_value(), NestedFuzzer._s_max_value())

func non_fuzzer() -> Resource:
	return Image.new()

func test_create_fuzzer_argument_default():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "Fuzzers.rangei(-10, 22)")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_not_null()
	assert_that(fuzzer).is_instanceof(Fuzzer)
	assert_int(fuzzer.next_value()).is_between(-10, 22)

func test_create_fuzzer_argument_with_constants():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "Fuzzers.rangei(-10, MAX_VALUE)")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_not_null()
	assert_that(fuzzer).is_instanceof(Fuzzer)
	assert_int(fuzzer.next_value()).is_between(-10, 22)

func test_create_fuzzer_argument_with_custom_function():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "get_fuzzer()")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_not_null()
	assert_that(fuzzer).is_instanceof(Fuzzer)
	assert_int(fuzzer.next_value()).is_between(MIN_VALUE, MAX_VALUE)

func test_create_fuzzer_do_fail():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "non_fuzzer()")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_null()

func test_create_nested_fuzzer_do_fail():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "NestedFuzzer.new()")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_not_null()
	assert_that(fuzzer is Fuzzer).is_true()
	# the fuzzer is not typed as NestedFuzzer seams be a Godot bug
	assert_bool(fuzzer is NestedFuzzer).is_false()

func test_create_external_fuzzer():
	var fuzzer_arg := GdFunctionArgument.new("fuzzer", GdObjects.TYPE_FUZZER, "TestExternalFuzzer.new()")
	var fuzzer := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_arg)
	assert_that(fuzzer).is_not_null()
	assert_that(fuzzer is Fuzzer).is_true()
	assert_bool(fuzzer is TestExternalFuzzer).is_true()

func test_create_multipe_fuzzers():
	var fuzzer_a_arg := GdFunctionArgument.new("fuzzer_a", GdObjects.TYPE_FUZZER, "Fuzzers.rangei(-10, MAX_VALUE)")
	var fuzzer_a := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_a_arg)
	var fuzzer_b_arg := GdFunctionArgument.new("fuzzer_b", GdObjects.TYPE_FUZZER, "Fuzzers.rangei(10, 20)")
	var fuzzer_b := FuzzerTool.create_fuzzer(self.get_script(), fuzzer_b_arg)
	assert_that(fuzzer_a).is_not_null()
	assert_that(fuzzer_a).is_instanceof(IntFuzzer)
	var a :IntFuzzer = fuzzer_a
	assert_int(a._from).is_equal(-10)
	assert_int(a._to).is_equal(MAX_VALUE)
	
	assert_that(fuzzer_b).is_not_null()
	assert_that(fuzzer_b).is_instanceof(IntFuzzer)
	var b :IntFuzzer = fuzzer_b
	assert_int(b._from).is_equal(10)
	assert_int(b._to).is_equal(20)
