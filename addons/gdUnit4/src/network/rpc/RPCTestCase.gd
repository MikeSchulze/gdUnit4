class_name RPCTestCase
extends RPC


static func of(test_case: GdUnitTestCase) -> RPCTestCase:
	return RPCTestCase.new(test_case)
