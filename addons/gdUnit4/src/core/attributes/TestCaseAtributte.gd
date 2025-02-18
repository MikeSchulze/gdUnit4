class_name TestCaseAttribute
extends Resource


# default timeout 5min
const DEFAULT_TIMEOUT := -1


## The test timeout if set or default
var timeout: int = DEFAULT_TIMEOUT:
	set(value):
		timeout = value
	get:
		if timeout == DEFAULT_TIMEOUT:
			timeout = GdUnitSettings.test_timeout()
		return timeout


## The test seed
var test_seed: int = -1


## Marks a test as skipped
var is_skipped := false


## Optional skip reason to descripe
var skip_reason := "Unknown"


## Defines how many fuzzer iterations to run
var fuzzer_iterations: int = Fuzzer.ITERATION_DEFAULT_COUNT


## A set of fuzzers to use for the test
var fuzzers: Array[GdFunctionArgument] = []
