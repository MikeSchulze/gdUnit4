# GdUnit generated TestSuite
class_name GdUnitTcpServerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/gdUnit4/src/network/GdUnitTcpServer.gd'

const DLM := GdUnitServerConstants.JSON_RESPONSE_DELIMITER


func test_read_next_data_packages() -> void:
	var server = mock(TCPServer)
	var stream = mock(StreamPeerTCP)

	do_return(stream).on(server).take_connection()

	var connection :GdUnitTcpServer.TcpConnection = auto_free(GdUnitTcpServer.TcpConnection.new(server))

	# single package
	var data = DLM + "aaaa" + DLM
	var data_packages := connection._read_next_data_packages(data.to_utf8_buffer())
	assert_array(data_packages).contains_exactly(["aaaa"])

	# many package
	data = DLM + "aaaa" + DLM + "bbbb" + DLM + "cccc" + DLM + "dddd" + DLM + "eeee" + DLM
	data_packages = connection._read_next_data_packages(data.to_utf8_buffer())
	assert_array(data_packages).contains_exactly(["aaaa", "bbbb", "cccc", "dddd", "eeee"])

	# with splitted package
	data_packages.clear()
	var data1 := DLM + "aaaa" + DLM + "bbbb" + DLM + "cc"
	var data2 := "cc" + DLM + "dd"
	var data3 := "dd" + DLM + "eeee" + DLM
	data_packages.append_array(connection._read_next_data_packages(data1.to_utf8_buffer()))
	data_packages.append_array(connection._read_next_data_packages(data2.to_utf8_buffer()))
	data_packages.append_array(connection._read_next_data_packages(data3.to_utf8_buffer()))
	assert_array(data_packages).contains_exactly(["aaaa", "bbbb", "cccc", "dddd", "eeee"])


func test_receive_packages() -> void:
	var server = mock(TCPServer)
	var stream = mock(StreamPeerTCP)

	do_return(stream).on(server).take_connection()

	var connection :GdUnitTcpServer.TcpConnection = auto_free(GdUnitTcpServer.TcpConnection.new(server))
	var test_server :GdUnitTcpServer = auto_free(GdUnitTcpServer.new())
	test_server.add_child(connection)
	# create a signal collector to catch all signals emitted on the test server during `receive_packages()`
	var signal_collector_ := signal_collector(test_server)

	# mock send RPCMessage
	var data := DLM + RPCMessage.of("Test Message").serialize() + DLM
	var package_data = [0, data.to_ascii_buffer()]
	do_return(data.length()).on(stream).get_available_bytes()
	do_return(package_data).on(stream).get_partial_data(data.length())

	# do receive next packages
	connection.receive_packages()

	# expect the RPCMessage is received and emitted
	assert_that(signal_collector_.is_emitted("rpc_data", [RPCMessage.of("Test Message")])).is_true()


# TODO refactor out and provide as public interface to can be reuse on other tests
class TestGdUnitSignalCollector:
	var _signalCollector :GdUnitSignalCollector
	var _emitter :Variant


	func _init(emitter :Variant):
		_emitter = emitter
		_signalCollector = GdUnitSignalCollector.new()
		_signalCollector.register_emitter(emitter)


	func is_emitted(signal_name :String, expected_args :Array) -> bool:
		return _signalCollector.match(_emitter, signal_name, expected_args)


	func _notification(what):
		if what == NOTIFICATION_PREDELETE:
			_signalCollector.unregister_emitter(_emitter)


func signal_collector(instance :Variant) -> TestGdUnitSignalCollector:
	return TestGdUnitSignalCollector.new(instance)
