class_name RPCTestCase
extends RPC


static func of(test_case: GdUnitTestCase) -> RPCTestCase:
	var rpc := RPCTestCase.new()
	rpc.set_data(test_case)
	return rpc
