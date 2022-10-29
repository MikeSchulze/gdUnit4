# GdUnit generated TestSuite
class_name NetworkServerTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit4/test/scenes/resources/gd-64/Server.gd'

func _test_StartServer() -> void:
	var scene_instance = load("res://addons/gdUnit4/test/scenes/resources/gd-64/Server.tscn").instantiate()
	# create a spy checked the server instance
	var spy_server = spy(scene_instance)
	
	scene_runner(spy_server)
	assert_signal(spy_server).is_emitted("hello")
	
	prints("scene runns")
	
	var client = spy(auto_free(Client.new()))
	add_child(client)
	client.StartClient()
	assert_signal(client).is_emitted("done")
	# give client time to connect
	await get_tree().create_timer(1.3).timeout
	
	verify(client)._OnConnectionSucceeded()
	verify(spy_server)._Peer_Connected(any_int())
	remove_child(client)
